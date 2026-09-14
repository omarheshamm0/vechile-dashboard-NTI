/*
 * File: warnings.c
 * Author: Ahmed Ellamie / ahmed.ellamieee@gmail.com
 * Description: Vehicle alert evaluation and bitmask updates.
 */

#include "warnings.h"
#include <stddef.h>

/* Default Threshold Definitions */
#define OIL_WARN_BAR_X10    10    /* 1.0 bar */
#define BATT_LOW_MV         12000 /* 12.0 V */
#define BATT_HIGH_MV        15000 /* 15.0 V */
#define COOLANT_WARN_C      110   /* 110 °C */
#define FUEL_WARN_PCT       10    /* 10 % */
#define SPEED_LIMIT_KMH     120   /* 120 km/h */

void Warnings_Init(void) {
    /* Ready for optional status setup */
}

void Warnings_Update(CarData_t *pCarData, uint16 deltaMs) {
    (void)deltaMs; /* Reserved for timing/blinking logic if needed */

    if (pCarData == NULL) {
        return;
    }

    uint16 mask = 0;

    /* Check Low Engine Oil Pressure */
    if (pCarData->oilBarX10 < OIL_WARN_BAR_X10) {
        mask |= (1U << WARN_OIL);
    }

    /* Check Battery Voltage Out-of-Bounds */
    if ((pCarData->battmV < BATT_LOW_MV) || (pCarData->battmV > BATT_HIGH_MV)) {
        mask |= (1U << WARN_BATT);
    }

    /* Check Engine Overheating */
    if (pCarData->coolantC >= COOLANT_WARN_C) {
        mask |= (1U << WARN_COOLANT);
    }

    /* Check Low Fuel Level */
    if (pCarData->fuelPct <= FUEL_WARN_PCT) {
        mask |= (1U << WARN_FUEL);
    }

    /* Check Speed Limit Threshold */
    if (pCarData->speedKmh > SPEED_LIMIT_KMH) {
        mask |= (1U << WARN_OVERSPEED);
    }

    /* Check Discrete Safety Warnings */
    if (pCarData->seatbelt) {
        mask |= (1U << WARN_SEATBELT);
    }

    if (pCarData->doorOpen) {
        mask |= (1U << WARN_DOOR);
    }

    if (pCarData->handbrake) {
        mask |= (1U << WARN_HANDBRAKE);
    }

    /* Update active warning bitmask */
    pCarData->warnMask = mask;
}