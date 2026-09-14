#ifndef SPEEDO_H
#define SPEEDO_H

#include "../../LIB/STD_TYPES.h"
#include "../../LIB/dashboard_types.h"

void SPD_Init(void);
void SPD_Task100ms(CarData_t *pCarData, const DashCfg_t *pCfg);
void SPD_OnCaptureISR(void);
void SPD_OnOverflowISR(void);

#endif /* SPEEDO_H */