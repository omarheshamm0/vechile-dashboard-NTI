#ifndef GAUGES_H
#define GAUGES_H

#include "STD_TYPES.h"
/* CarData_t will be defined in a general types header or within the FSM */
#include "dashboard_types.h" 

void GAU_Init(void);
void GAU_Update(CarData_t *CarData);

#endif /* GAUGES_H */