#ifndef TACHO_H
#define TACHO_H

#include "STD_TYPES.h"
#include "dashboard_types.h"

/* Initialize EXTI0 for pulse counting */
void TAC_Init(void);

/* Called every 250 ms to compute engine RPM */
void TAC_Task250ms(CarData_t *pCarData, const DashCfg_t *pCfg);

/* EXTI0 ISR Callback */
void TAC_OnPulse(void);

#endif /* TACHO_H */