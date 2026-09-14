#include "warnings.h"

/* Variables to store latched warnings (cleared only on key cycle)[cite: 1] */
static uint8 Latched_Oil = 0;
static uint8 Latched_Coolant = 0;

void WRN_Update(CarData_t *CarData) {
    /* 1. Evaluate Oil Pressure (< 1.0 bar while engine is running for 2s)[cite: 1] */
    /* Note: The 2-second timing is managed by the scheduler; here we check the value */
    if (CarData->engineRun && CarData->oilBarX10 < 10) {
        Latched_Oil = 1; /* Latching activated[cite: 1] */
    }

    /* 2. Evaluate Coolant Temperature (> 110 °C for 3s)[cite: 1] */
    if (CarData->coolantC > 110) {
        Latched_Coolant = 1; /* Latching activated[cite: 1] */
    }

    /* 3. Evaluate Battery (< 12V while engine running, or > 15V) - Non-latching[cite: 1] */
    uint8 batt_warn = 0;
    if ((CarData->engineRun && CarData->battmV < 12000) || (CarData->battmV > 15000)) {
        batt_warn = 1;
    }

    /* 4. Evaluate Fuel (< 10%) - Non-latching, clears at > 13% (Hysteresis)[cite: 1] */
    static uint8 fuel_warn_active = 0;
    if (CarData->fuelPct < 10) {
        fuel_warn_active = 1;
    } else if (CarData->fuelPct > 13) {
        fuel_warn_active = 0;
    }

    /* Update warnMask in CarData */
    if (Latched_Oil)      CarData->warnMask |= (1 << WARN_OIL);
    else                  CarData->warnMask &= ~(1 << WARN_OIL);

    if (Latched_Coolant)  CarData->warnMask |= (1 << WARN_COOLANT);
    else                  CarData->warnMask &= ~(1 << WARN_COOLANT);

    if (batt_warn)        CarData->warnMask |= (1 << WARN_BATT);
    else                  CarData->warnMask &= ~(1 << WARN_BATT);

    if (fuel_warn_active) CarData->warnMask |= (1 << WARN_FUEL);
    else                  CarData->warnMask &= ~(1 << WARN_FUEL);
    
    /* Other warnings (Overspeed, Seatbelt, Door, Handbrake) are updated by their respective modules */
}

Warn_t WRN_Highest(const CarData_t *CarData) {
    /* Strict Priority Resolution from 1 (Highest) to 9 (Lowest)[cite: 1] */
    if (CarData->warnMask & (1 << WARN_OIL))       return WARN_OIL;       /* Priority 1 */
    if (CarData->warnMask & (1 << WARN_BATT))      return WARN_BATT;      /* Priority 2 */
    if (CarData->warnMask & (1 << WARN_COOLANT))   return WARN_COOLANT;   /* Priority 3 */
    if (CarData->warnMask & (1 << WARN_CHECK))     return WARN_CHECK;     /* Priority 4 */
    if (CarData->warnMask & (1 << WARN_FUEL))      return WARN_FUEL;      /* Priority 5 */
    if (CarData->warnMask & (1 << WARN_OVERSPEED)) return WARN_OVERSPEED; /* Priority 6 */
    if (CarData->warnMask & (1 << WARN_SEATBELT))  return WARN_SEATBELT;  /* Priority 7 */
    if (CarData->warnMask & (1 << WARN_DOOR))      return WARN_DOOR;      /* Priority 8 */
    if (CarData->warnMask & (1 << WARN_HANDBRAKE)) return WARN_HANDBRAKE; /* Priority 9 */
    
    return WARN_NONE;
}