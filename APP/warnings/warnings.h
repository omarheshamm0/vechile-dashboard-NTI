#ifndef WARNINGS_H
#define WARNINGS_H

#include "STD_TYPES.h"
#include "dashboard_types.h"

/* Legacy API kept for compatibility */
void WRN_Update(CarData_t *CarData);
Warn_t WRN_Highest(const CarData_t *CarData);

/* Current application API */
void Warnings_Init(void);
void Warnings_Update(CarData_t *pCarData, uint16 deltaMs);

#endif /* WARNINGS_H */
