#include <avr/io.h>
#include <avr/interrupt.h>
#include <stddef.h>
#include <stdint.h>

#include "LIB/STD_TYPES.h"
#include "LIB/dashboard_types.h"
#include "HAL/SPEEDO/speedo.h"
#include "odometer.h"

#define SPD_TICK_US        8u
#define SPD_SPEED_NUM      1800000UL
#define SPD_STALL_TICKS    10u
#define SPD_MAX_KMH        250u

static volatile uint16_t s_lastCnt;
static volatile uint16_t s_ovfCount;
static volatile uint32_t s_deltaTicks;
static volatile uint8_t  s_fresh;
static uint16_t          s_stallTicks;
static uint8_t           s_firstEdge;
static volatile uint16_t s_pulseAccum;      /* pulses since last task */

void SPD_Init(void)
{
    /* PB2 / INT2 as input */
    DDRB  &= (uint8_t)~(1u << PB2);
    PORTB &= (uint8_t)~(1u << PB2);

    s_lastCnt    = 0u;
    s_ovfCount   = 0u;
    s_deltaTicks = 0UL;
    s_fresh      = 0u;
    s_stallTicks = 0u;
    s_firstEdge  = 1u;
    s_pulseAccum = 0u;

    /* Timer1: normal mode, prescaler 64 (8 us/tick), overflow int on */
    TCCR1A = 0x00u;
    TCCR1B = (uint8_t)((1u << CS11) | (1u << CS10));
    TIFR   = (uint8_t)(1u << TOV1);
    TIMSK |= (uint8_t)(1u << TOIE1);
    TCNT1  = 0u;

    /* INT2 on rising edge */
    MCUCSR |= (uint8_t)(1u << ISC2);
    GIFR   |= (uint8_t)(1u << INTF2);
    GICR   |= (uint8_t)(1u << INT2);
}

void SPD_OnOverflowISR(void)
{
    s_ovfCount++;
}

ISR(TIMER1_OVF_vect)
{
    SPD_OnOverflowISR();
}

ISR(INT2_vect)
{
    uint16_t now  = TCNT1;
    uint32_t delta;

    if (s_firstEdge)
    {
        s_firstEdge = 0u;
        s_lastCnt   = now;
        s_ovfCount  = 0u;
        return;
    }

    delta = ((uint32_t)s_ovfCount << 16) + (uint32_t)now - (uint32_t)s_lastCnt;

    s_lastCnt    = now;
    s_ovfCount   = 0u;
    s_deltaTicks = delta;
    s_fresh      = 1u;
    s_stallTicks = 0u;
    s_pulseAccum++;
}

void SPD_Task100ms(CarData_t *pCarData, const DashCfg_t *pCfg)
{
    uint32_t deltaTicks;
    uint8_t  isFresh;
    uint32_t periodUs;
    uint32_t speed;
    uint16_t pulses;

    if ((pCarData == NULL) || (pCfg == NULL) || (pCfg->pulsesPerRev == 0u))
    {
        return;
    }

    /* Atomic snapshot of ISR-shared state */
    {
        uint8_t sreg = SREG;
        cli();
        deltaTicks  = s_deltaTicks;
        isFresh     = s_fresh;
        s_fresh     = 0u;
        pulses      = s_pulseAccum;
        s_pulseAccum = 0u;
        SREG = sreg;
    }

    /* ---- Speed calculation ---- */
    if (isFresh && deltaTicks > 0u)
    {
        periodUs = deltaTicks * SPD_TICK_US;
        speed    = SPD_SPEED_NUM / periodUs;

        if (speed <= SPD_MAX_KMH)
        {
            pCarData->speedKmh = (uint16_t)speed;
            if (pCarData->speedKmh > pCarData->maxSpeedKmh)
            {
                pCarData->maxSpeedKmh = pCarData->speedKmh;
            }
        }
        else
        {
            pCarData->speedKmh = 0u;
        }

        s_stallTicks = 0u;
    }
    else
    {
        if (s_stallTicks < 0xFFFFu) s_stallTicks++;
        if (s_stallTicks >= SPD_STALL_TICKS)
        {
            pCarData->speedKmh = 0u;
        }
    }

    /* ---- Odometer: every pulse counts, not just one per window ---- */
    if (pulses > 0u)
    {
        if (pulses > 100u) pulses = 100u;   /* clamp: 100 x 500 mm = 50 m */
        {
            uint16_t mmPerPulse =
                (uint16_t)(pCfg->wheelCircMm / pCfg->pulsesPerRev);
            ODO_AddDistance((uint16_t)(mmPerPulse * pulses));
        }
    }
}