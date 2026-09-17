#include <avr/io.h>
#include <avr/interrupt.h>
#include <stddef.h>

#include "LIB/STD_TYPES.h"
#include "LIB/dashboard_types.h"
#include "HAL/TACHO/tacho.h"

static volatile uint16_t s_tachoPulseCount = 0;

/* External Interrupt 0 ISR (PD2 / Pin 15) */
ISR(INT0_vect)
{
    s_tachoPulseCount++;
}

void TAC_Init(void)
{
    /* Set PD2 (INT0) as Input with Internal Pull-Up */
    DDRD &= ~(1 << PD2);
    PORTD |= (1 << PD2);

    /* Configure INT0 for Rising Edge Trigger */
    MCUCR &= ~((1 << ISC01) | (1 << ISC00));
    MCUCR |= (1 << ISC01) | (1 << ISC00);
    GICR  |= (1 << INT0);
}

void TAC_Task250ms(CarData_t *pData, const DashCfg_t *pCfg)
{
    if ((pData == NULL) || (pCfg == NULL) || (pCfg->tachPulsesPerRev == 0))
    {
        return;
    }

    /* Atomic Read and Reset */
    uint8_t sreg = SREG;
    cli();
    uint16_t pulses = s_tachoPulseCount;
    s_tachoPulseCount = 0;
    SREG = sreg;

    /* RPM = (pulses * 4 * 60) / tachPulsesPerRev */
    pData->rpm = (uint16_t)(((uint32_t)pulses * 240UL) / pCfg->tachPulsesPerRev);
}