#include "speedo.h"
#include "BIT_MATH.h"

#if defined(__has_include)
    #if __has_include(<avr/io.h>)
        #include <avr/io.h>
    #else
        #include <stdint.h>
    #endif
    #if __has_include(<avr/interrupt.h>)
        #include <avr/interrupt.h>
    #endif
#else
    #include <avr/io.h>
    #include <avr/interrupt.h>
#endif

static volatile Capture_t g_captureData = {0};

#if defined(TCCR1A) && defined(TCCR1B) && defined(TIMSK) && defined(ICR1) && defined(TIFR)
void SPD_Init(void)
{
    /* Timer1 Normal Mode, Prescaler = 64 (1 tick = 8 us at 8 MHz) */
    TCCR1A = 0x00;
    TCCR1B = (1 << ICNC1) | (1 << ICES1) | (1 << CS11) | (1 << CS10);

    /* Enable Input Capture Interrupt and Overflow Interrupt */
    TIMSK |= (1 << TICIE1) | (1 << TOIE1);
}
#else
void SPD_Init(void)
{
    /* Timer1 not available on this AVR target. */
}
#endif

#if defined(ICR1) && defined(TIFR)
void SPD_OnCaptureISR(void)
{
    uint16 currentIcr = ICR1;
    uint32 delta = 0;

    /* Handle overflow race condition if overflow occurred before capture */
    if ((TIFR & (1 << TOV1)) && (currentIcr < 0x8000))
    {
        g_captureData.ovfCount++;
        TIFR |= (1 << TOV1); /* Clear pending overflow flag */
    }

    delta = ((uint32)g_captureData.ovfCount * 65536UL) + currentIcr - g_captureData.lastIcr;

    g_captureData.lastIcr = currentIcr;
    g_captureData.ovfCount = 0;
    g_captureData.deltaTicks = delta;
    g_captureData.fresh = 1;
    g_captureData.stallTicks = 0;
}
#else
void SPD_OnCaptureISR(void)
{
    /* Timer1 capture hardware unavailable on this target. */
}
#endif

void SPD_OnOverflowISR(void)
{
    g_captureData.ovfCount++;
}

#if defined(TIMER1_CAPT_vect)
/* Timer1 Input Capture ISR */
ISR(TIMER1_CAPT_vect)
{
    SPD_OnCaptureISR();
}
#endif

#if defined(TIMER1_OVF_vect)
/* Timer1 Overflow ISR */
ISR(TIMER1_OVF_vect)
{
    SPD_OnOverflowISR();
}
#endif

void SPD_Task100ms(CarData_t *pCarData, const DashCfg_t *pCfg)
{
    uint32 periodUs = 0;
    uint32 calculatedSpeed = 0;
    uint32 deltaTicks = 0;
    uint8 isFresh = 0;

    /* Atomic read of capture values */
    cli();
    deltaTicks = g_captureData.deltaTicks;
    isFresh = g_captureData.fresh;
    g_captureData.fresh = 0;
    sei();

    if (isFresh && deltaTicks > 0)
    {
        /* periodUs = deltaTicks * 8 (Prescaler 64 at 8MHz) */
        periodUs = deltaTicks * 8UL;

        /* speed_kmh = 1,800,000 / periodUs */
        calculatedSpeed = 1800000UL / periodUs;

        if (calculatedSpeed > 250)
        {
            calculatedSpeed = 0; /* Reject noise spikes */
        }

        pCarData->speedKmh = (uint16)calculatedSpeed;

        if (pCarData->speedKmh > pCarData->maxSpeedKmh)
        {
            pCarData->maxSpeedKmh = pCarData->speedKmh;
        }

        /* Odometer Distance accumulation (metres) */
        if (pCfg->pulsesPerRev > 0)
        {
            uint32 mmPerPulse = (uint32)pCfg->wheelCircMm / pCfg->pulsesPerRev;
            pCarData->odoMetres += (mmPerPulse / 1000UL);
            pCarData->tripMetres += (mmPerPulse / 1000UL);
        }
    }

    /* Stall Detection Timeout (1 Second = 10 calls of 100ms task) */
    g_captureData.stallTicks++;
    if (g_captureData.stallTicks >= 10)
    {
        pCarData->speedKmh = 0;
    }
}