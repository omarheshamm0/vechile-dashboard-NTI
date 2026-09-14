#ifndef SPEEDO_H
#define SPEEDO_H

#include "STD_TYPES.h"
#include "dashboard_types.h"

/* Initialize Timer1 Input Capture and Overflow interrupts */
void SPD_Init(void);

/* Called every 100 ms from the scheduler to update speed and odometer */
void SPD_Task100ms(CarData_t *pCarData, const DashCfg_t *pCfg);

/* Interrupt Handlers for Input Capture and Timer1 Overflow */
void SPD_OnCaptureISR(void);
void SPD_OnOverflowISR(void);

#endif /* SPEEDO_H */