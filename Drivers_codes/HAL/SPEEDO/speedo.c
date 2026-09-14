#include "speedo.h"
#include "BIT_MATH.h"
#include <avr/io.h>
#include <avr/interrupt.h>

static volatile Capture_t g_captureData = {0};

void SPD_Init(void)
{
    /* Timer1 Normal Mode, Prescaler = 64 (1 tick = 8 us at 8 MHz) */
    TCCR1A = 0x00;
    TCCR1B = (1 << ICNC1) | (1 << ICES1) | (1 << CS11) | (1 << CS10);

    /* Enable Input Capture Interrupt and Overflow Interrupt */
    TIMSK |= (1 << TICIE1) | (1 << TOIE1);
}

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

void SPD_OnOverflowISR(void)
{
    g_captureData.ovfCount++;
}

/* Timer1 Input Capture ISR */
ISR(TIMER1_CAPT_vect)
{
    SPD_OnCaptureISR();
}

/* Timer1 Overflow ISR */
ISR(TIMER1_OVF_vect)
{
    SPD_OnOverflowISR();
}

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