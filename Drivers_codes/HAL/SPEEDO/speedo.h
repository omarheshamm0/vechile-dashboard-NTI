#ifndef SPEEDO_H
#define SPEEDO_H

/* Include basic data types (uint8, uint16, etc.) */
#include "../../LIB/STD_TYPES.h"
/* Include dashboard data structures (CarData_t, DashCfg_t) */
#include "../../LIB/dashboard_types.h"

/* Initialize Timer1 Input Capture and Overflow interrupts */
void SPD_Init(void);

/* Periodic task called every 100 ms to calculate speed and distance */
void SPD_Task100ms(CarData_t *pCarData, const DashCfg_t *pCfg);

/* Function executed when a new pulse arrives from the wheel sensor */
void SPD_OnCaptureISR(void);

/* Function executed when Timer1 overflows (reaches max count) */
void SPD_OnOverflowISR(void);

#endif /* SPEEDO_H */