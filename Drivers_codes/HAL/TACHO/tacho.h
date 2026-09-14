#ifndef TACHO_H
#define TACHO_H

#include "../../LIB/STD_TYPES.h"
#include "../../LIB/dashboard_types.h"

void TAC_Init(void);
void TAC_Task250ms(CarData_t *pCarData, const DashCfg_t *pCfg);
void TAC_OnPulse(void);

#endif /* TACHO_H */