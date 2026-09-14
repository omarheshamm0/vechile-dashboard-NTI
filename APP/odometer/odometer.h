#ifndef ODOMETER_H_
#define ODOMETER_H_

#include "STD_TYPES.h"
#include "dashboard_types.h"

/* --- Public Function Prototypes --- */

/* Initialize odometer counters and trip metrics */
void Odometer_Init(void);

/* Periodically update distance, max speed, and average speed */
void Odometer_Update(CarData_t *pCarData, uint16 deltaMs);

/* Reset trip distance and trip average speed */
void Odometer_ResetTrip(CarData_t *pCarData);

#endif /* ODOMETER_H_ */