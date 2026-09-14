#include "tacho.h"
#include "../../MCAL/INTERRUPT/INTERRUPT_interface.h"
#include <avr/interrupt.h>

/* Holds the total number of engine pulses recorded by INT0 */
static volatile uint16 g_pulseCount = 0;

/* Interrupt callback: increments count each time an engine pulse arrives */
void TAC_OnPulse(void)
{
    g_pulseCount++;
}

/* Configure INT0 to trigger on rising signal edges */
void TAC_Init(void)
{
    EXTI_SetSense(EXTI_INT0, EXTI_RISING_EDGE);
    EXTI_SetCallback(EXTI_INT0, TAC_OnPulse);
    EXTI_Enable(EXTI_INT0);
}

/* Task called every 250 ms to compute RPM and engine state */
void TAC_Task250ms(CarData_t *pCarData, const DashCfg_t *pCfg)
{
    uint16 count = 0;

    /* Safely fetch and reset pulse counter without interrupt interference */
    INTERRUPT_DisableGlobal();
    count = g_pulseCount;
    g_pulseCount = 0;
    INTERRUPT_EnableGlobal();

    /* Convert 250ms pulse count to Revolutions Per Minute (RPM) */
    if (pCfg->tachPulsesPerRev > 0)
    {
        pCarData->rpm = (uint16)(((uint32)count * 240UL) / pCfg->tachPulsesPerRev);
    }
    else
    {
        pCarData->rpm = count * 120U; /* Default fall-back calculation */
    }

    /* Update engine running state based on RPM threshold */
    if (pCarData->rpm > 500)
    {
        pCarData->engineRun = 1; /* Engine running */
    }
    else if (pCarData->rpm < 300)
    {
        pCarData->engineRun = 0; /* Engine stopped / stalled */
    }
}