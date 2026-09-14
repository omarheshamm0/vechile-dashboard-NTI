#include "speedo.h"
#include "../../LIB/BIT_MATH.h"
#include <avr/io.h>
#include <avr/interrupt.h>

/* Holds the timer capture status; 'volatile' ensures ISR updates are visible to main tasks */
static volatile Capture_t g_captureData = {0};

/* Setup Timer1 registers for Input Capture Mode */
void SPD_Init(void)
{
    /* Normal timer mode (no PWM waveform generation) */
    TCCR1A = 0x00;

    /* Enable Noise Canceler (ICNC1), Rising Edge trigger (ICES1), Prescaler = 64 (CS11 | CS10) */
    TCCR1B = (1 << ICNC1) | (1 << ICES1) | (1 << CS11) | (1 << CS10);

    /* Turn on Input Capture Interrupt (TICIE1) and Overflow Interrupt (TOIE1) */
    TIMSK |= (1 << TICIE1) | (1 << TOIE1);
}

/* Process incoming wheel pulse inside the Input Capture interrupt */
void SPD_OnCaptureISR(void)
{
    uint16 currentIcr = ICR1; /* Read timer counter value at the exact moment of the edge */
    uint32 delta = 0;

    /* Handle race condition: check if timer overflowed right before reading ICR1 */
    if ((TIFR & (1 << TOV1)) && (currentIcr < 0x8000))
    {
        g_captureData.ovfCount++; /* Count the overflow */
        TIFR |= (1 << TOV1);      /* Clear pending overflow flag */
    }

    /* Calculate total 32-bit timer ticks between current and previous pulse */
    delta = ((uint32)g_captureData.ovfCount * 65536UL) + currentIcr - g_captureData.lastIcr;

    /* Save current values for the next pulse calculation */
    g_captureData.lastIcr = currentIcr;
    g_captureData.ovfCount = 0;
    g_captureData.deltaTicks = delta;
    g_captureData.fresh = 1;      /* Mark data as new for the 100ms task */
    g_captureData.stallTicks = 0; /* Reset car stopped/stall timer */
}

/* Track how many times 16-bit Timer1 has rolled over past 65535 */
void SPD_OnOverflowISR(void)
{
    g_captureData.ovfCount++;
}

/* Hardware Interrupt Vector for Timer1 Input Capture */
ISR(TIMER1_CAPT_vect)
{
    SPD_OnCaptureISR();
}

/* Hardware Interrupt Vector for Timer1 Overflow */
ISR(TIMER1_OVF_vect)
{
    SPD_OnOverflowISR();
}

/* Task called every 100 ms to update speed, trip meter, and total odometer */
void SPD_Task100ms(CarData_t *pCarData, const DashCfg_t *pCfg)
{
    uint32 periodUs = 0;
    uint32 calculatedSpeed = 0;
    uint32 deltaTicks = 0;
    uint8 isFresh = 0;

    /* Safely copy interrupt variables without data corruption */
    cli();
    deltaTicks = g_captureData.deltaTicks;
    isFresh = g_captureData.fresh;
    g_captureData.fresh = 0; /* Clear fresh flag */
    sei();

    /* If a new pulse arrived, perform calculations */
    if (isFresh && deltaTicks > 0)
    {
        /* Convert timer ticks to microseconds (1 tick = 8 us at 8 MHz with prescaler 64) */
        periodUs = deltaTicks * 8UL;

        /* Calculate speed in km/h based on pulse period */
        calculatedSpeed = 1800000UL / periodUs;

        /* Filter out false electrical noise spikes above 250 km/h */
        if (calculatedSpeed > 250)
        {
            calculatedSpeed = 0;
        }

        /* Update vehicle speed */
        pCarData->speedKmh = (uint16)calculatedSpeed;

        /* Store session maximum speed record */
        if (pCarData->speedKmh > pCarData->maxSpeedKmh)
        {
            pCarData->maxSpeedKmh = pCarData->speedKmh;
        }

        /* Accumulate driven distance into total and trip odometers */
        if (pCfg->pulsesPerRev > 0)
        {
            uint32 mmPerPulse = (uint32)pCfg->wheelCircMm / pCfg->pulsesPerRev;
            pCarData->odoMetres += (mmPerPulse / 1000UL);
            pCarData->tripMetres += (mmPerPulse / 1000UL);
        }
    }

    /* Timeout logic: if 1 second (10 x 100ms) passes with no pulses, set speed to 0 */
    g_captureData.stallTicks++;
    if (g_captureData.stallTicks >= 10)
    {
        pCarData->speedKmh = 0;
    }
}