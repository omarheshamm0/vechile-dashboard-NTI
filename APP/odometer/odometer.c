/*
 * File: odometer.c
 * Author: Ahmed Ellamie / ahmed.ellamieee@gmail.com
 * Description: Odometer, trip distance, and speed statistics engine.
 */

#include "odometer.h"
#include <stddef.h>

static uint32 s_accumulatedDistanceMm = 0;
static uint32 s_tripTimeSec = 0;

void Odometer_Init(void) {
    s_accumulatedDistanceMm = 0;
    s_tripTimeSec = 0;
}

void Odometer_Update(CarData_t *pCarData, uint16 deltaMs) {
    if (pCarData == NULL) {
        return;
    }

    /* Convert speed from km/h to mm/s: (Speed * 1000000 mm) / 3600 s */
    uint32 speedMmPerSec = ((uint32)pCarData->speedKmh * 2500U) / 9U;
    uint32 addedMm = (speedMmPerSec * deltaMs) / 1000U;

    s_accumulatedDistanceMm += addedMm;

    /* Increment total and trip meters when accumulated millimeters reach 1 meter */
    if (s_accumulatedDistanceMm >= 1000U) {
        uint32 metresToAdd = s_accumulatedDistanceMm / 1000U;
        pCarData->odoMetres  += metresToAdd;
        pCarData->tripMetres += metresToAdd;
        s_accumulatedDistanceMm %= 1000U;
    }

    /* Track all-time session maximum speed */
    if (pCarData->speedKmh > pCarData->maxSpeedKmh) {
        pCarData->maxSpeedKmh = pCarData->speedKmh;
    }

    /* Update trip average speed calculation timer */
    static uint16 s_timeAccumulatorMs = 0;
    s_timeAccumulatorMs += deltaMs;

    if (s_timeAccumulatorMs >= 1000U) {
        s_tripTimeSec += (s_timeAccumulatorMs / 1000U);
        s_timeAccumulatorMs %= 1000U;

        /* Calculate average speed: (Trip Distance in Metres * 3600) / (1000 * Total Seconds) */
        if (s_tripTimeSec > 0U) {
            pCarData->avgSpeedKmh = (uint16)(((pCarData->tripMetres * 3600U) / 1000U) / s_tripTimeSec);
        }
    }
}

void Odometer_ResetTrip(CarData_t *pCarData) {
    if (pCarData == NULL) {
        return;
    }

    pCarData->tripMetres  = 0;
    pCarData->avgSpeedKmh = 0;
    s_tripTimeSec         = 0;
}