#ifndef TACHO_H
#define TACHO_H

/* Include basic data types (uint8, uint16, etc.) */
#include "../../LIB/STD_TYPES.h"
/* Include dashboard data structures (CarData_t, DashCfg_t) */
#include "../../LIB/dashboard_types.h"

/* Initialize External Interrupt 0 (INT0) for counting ignition pulses */
void TAC_Init(void);

/* Periodic task called every 250 ms to compute engine RPM */
void TAC_Task250ms(CarData_t *pCarData, const DashCfg_t *pCfg);

/* Callback function executed on every external interrupt pulse */
void TAC_OnPulse(void);

#endif /* TACHO_H */