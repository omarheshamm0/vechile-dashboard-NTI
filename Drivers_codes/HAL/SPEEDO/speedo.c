#include "speedo.h"
#include "../../LIB/MATH.h"
#include <avr/io.h>
#include <avr/interrupt.h>

static volatile Capture_t g_captureData = {0};

void SPD_Init(void)
{
    TCCR1A = 0x00;
    TCCR1B = (1 << ICNC1) | (1 << ICES1) | (1 << CS11) | (1 << CS10);
    TIMSK |= (1 << TICIE1) | (1 << TOIE1);
}

void SPD_OnCaptureISR(void)
{
    uint16 currentIcr = ICR1;
    uint32 delta = 0;

    if ((TIFR & (1 << TOV1)) && (currentIcr < 0x8000))
    {
        g_captureData.ovfCount++;
        TIFR |= (1 << TOV1);
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

ISR(TIMER1_CAPT_vect)
{
    SPD_OnCaptureISR();
}

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

    cli();
    deltaTicks = g_captureData.deltaTicks;
    isFresh = g_captureData.fresh;
    g_captureData.fresh = 0;
    sei();

    if (isFresh && deltaTicks > 0)
    {
        periodUs = deltaTicks * 8UL;
        calculatedSpeed = 1800000UL / periodUs;

        if (calculatedSpeed > 250)
        {
            calculatedSpeed = 0;
        }

        pCarData->speedKmh = (uint16)calculatedSpeed;

        if (pCarData->speedKmh > pCarData->maxSpeedKmh)
        {
            pCarData->maxSpeedKmh = pCarData->speedKmh;
        }

        if (pCfg->pulsesPerRev > 0)
        {
            uint32 mmPerPulse = (uint32)pCfg->wheelCircMm / pCfg->pulsesPerRev;
            pCarData->odoMetres += (mmPerPulse / 1000UL);
            pCarData->tripMetres += (mmPerPulse / 1000UL);
        }
    }

    g_captureData.stallTicks++;
    if (g_captureData.stallTicks >= 10)
    {
        pCarData->speedKmh = 0;
    }
}