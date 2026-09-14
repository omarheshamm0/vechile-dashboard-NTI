#include "tacho.h"
#include "INTERRUPT_interface.h"
#include <avr/interrupt.h>

static volatile uint16 g_pulseCount = 0;

void TAC_OnPulse(void)
{
    g_pulseCount++;
}

void TAC_Init(void)
{
    EXTI_SetSense(EXTI_INT0, EXTI_RISING_EDGE);
    EXTI_SetCallback(EXTI_INT0, TAC_OnPulse);
    EXTI_Enable(EXTI_INT0);
}

void TAC_Task250ms(CarData_t *pCarData, const DashCfg_t *pCfg)
{
    uint16 count = 0;

    /* Atomic read and reset of pulse counter */
    INTERRUPT_DisableGlobal();
    count = g_pulseCount;
    g_pulseCount = 0;
    INTERRUPT_EnableGlobal();

    /* RPM = count * (1000ms / 250ms) * 60s / pulsesPerRev */
    if (pCfg->tachPulsesPerRev > 0)
    {
        pCarData->rpm = (uint16)(((uint32)count * 240UL) / pCfg->tachPulsesPerRev);
    }
    else
    {
        pCarData->rpm = count * 120U; /* Default for 2 pulses/rev */
    }

    /* Update engine running state */
    if (pCarData->rpm > 500)
    {
        pCarData->engineRun = 1;
    }
    else if (pCarData->rpm < 300)
    {
        pCarData->engineRun = 0;
    }
}