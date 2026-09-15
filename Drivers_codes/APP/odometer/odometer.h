#ifndef ODOMETER_H
#define ODOMETER_H

#include "STD_TYPES.h"

/* 
 * Description: Adds distance to the accumulators. Called when pulses are counted.
 * Parameters:  mm_to_add - distance in millimeters (e.g., MM_PER_PULSE = 500)[cite: 1].
 */
void ODO_AddDistance(uint16 mm_to_add);

/* 
 * Description: Safely reads the lifetime odometer value using atomic block.
 * Parameters:  total - pointer to store the 32-bit total distance in meters.
 */
void ODO_GetTotal(uint32 *total);

/* 
 * Description: Safely reads the trip meter value using atomic block.
 * Parameters:  trip - pointer to store the 32-bit trip distance in meters.
 */
void ODO_GetTrip(uint32 *trip);

/* 
 * Description: Resets the trip meter securely.
 */
void ODO_ResetTrip(void);

#endif /* ODOMETER_H */