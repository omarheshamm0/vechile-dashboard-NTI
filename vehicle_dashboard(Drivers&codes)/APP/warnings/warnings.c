#include "warnings.h"

/* تحديد زمن استدعاء الدالة (50 مللي ثانية بناءً على الـ Scheduler بتاعك) */
#define WRN_PERIOD_MS 50 

/* حساب عدد اللفات المطلوبة لكل تحذير */
#define OIL_TIME_LIMIT      (2000 / WRN_PERIOD_MS) /* 40 counts */
#define COOLANT_TIME_LIMIT  (3000 / WRN_PERIOD_MS) /* 60 counts */
#define BATT_TIME_LIMIT     (5000 / WRN_PERIOD_MS) /* 100 counts */

/* Variables to store latched warnings (cleared only on key cycle) */
static uint8 Latched_Oil = 0;
static uint8 Latched_Coolant = 0;

void WRN_Update(CarData_t *CarData) {
    /* عدادات الثواني (Static عشان تحتفظ بقيمتها بين كل استدعاء والتاني) */
    static uint16 oil_counter = 0;
    static uint16 coolant_counter = 0;
    static uint16 batt_low_counter = 0;
    static uint16 batt_high_counter = 0;

    /* ==============================================================
     * 1. Evaluate Oil Pressure (< 1.0 bar, engine running, 2 s)
     * ============================================================== */
    if (CarData->engineRun && (CarData->oilBarX10 < 10)) {
        oil_counter++;
        if (oil_counter >= OIL_TIME_LIMIT) {
            Latched_Oil = 1; /* Latching Yes */
        }
    } else {
        oil_counter = 0; /* تصفير العداد لو الضغط رجع طبيعي قبل الثانيتين */
    }

    /* ==============================================================
     * 2. Evaluate Coolant Temperature (> 110 °C, 3 s)
     * ============================================================== */
    if (CarData->coolantC > 110) {
        coolant_counter++;
        if (coolant_counter >= COOLANT_TIME_LIMIT) {
            Latched_Coolant = 1; /* Latching Yes */
        }
    } else {
        coolant_counter = 0;
    }

    /* ==============================================================
     * 3. Evaluate Battery Low (< 12.0 V, engine running, 5 s)
     * ============================================================== */
    static uint8 batt_low_warn = 0;
    
    if (CarData->engineRun == 0) {
        /* لو المحرك مطفي، مفيش تحذير هبوط بطارية لأن الدينامو أصلا مش شغال */
        batt_low_counter = 0;
        batt_low_warn = 0; 
    } else {
        /* لو المحرك شغال، نبدأ نقيم الفولت */
        if (CarData->battmV < 12000) {
            batt_low_counter++;
            if (batt_low_counter >= BATT_TIME_LIMIT) batt_low_warn = 1;
        } else if (CarData->battmV > 12500) { /* يطفي لو عدى 12.5V */
            batt_low_counter = 0;
            batt_low_warn = 0; 
        } else {
            batt_low_counter = 0;
        }
    }

    /* ==============================================================
     * 4. Evaluate Battery High (> 15.0 V, 5 s)
     * ============================================================== */
    static uint8 batt_high_warn = 0;
    if (CarData->battmV > 15000) {
        batt_high_counter++;
        if (batt_high_counter >= BATT_TIME_LIMIT) batt_high_warn = 1;
    } else if (CarData->battmV < 14500) { /* يطفي لو نزل تحت 14.5V */
        batt_high_counter = 0;
        batt_high_warn = 0;
    } else {
        batt_high_counter = 0;
    }

    /* ==============================================================
     * 5. Evaluate Fuel (< 10%) - (No time delay as per table)
     * ============================================================== */
    static uint8 fuel_warn_active = 0;
    if (CarData->fuelPct < 10) {
        fuel_warn_active = 1;
    } else if (CarData->fuelPct > 13) {
        fuel_warn_active = 0;
    }

    /* ==============================================================
     * Update warnMask in CarData
     * ============================================================== */
    if (Latched_Oil)      CarData->warnMask |= (1 << WARN_OIL);
    else                  CarData->warnMask &= ~(1 << WARN_OIL);

    if (Latched_Coolant)  CarData->warnMask |= (1 << WARN_COOLANT);
    else                  CarData->warnMask &= ~(1 << WARN_COOLANT);

    if (batt_low_warn || batt_high_warn) CarData->warnMask |= (1 << WARN_BATT);
    else                                 CarData->warnMask &= ~(1 << WARN_BATT);

    if (fuel_warn_active) CarData->warnMask |= (1 << WARN_FUEL);
    else                  CarData->warnMask &= ~(1 << WARN_FUEL);
}

Warn_t WRN_Highest(const CarData_t *CarData) {
    /* نفس دوال الأولوية بتاعتك زي ما هي */
    if (CarData->warnMask & (1 << WARN_OIL))       return WARN_OIL;
    if (CarData->warnMask & (1 << WARN_BATT))      return WARN_BATT;
    if (CarData->warnMask & (1 << WARN_COOLANT))   return WARN_COOLANT;
    if (CarData->warnMask & (1 << WARN_CHECK))     return WARN_CHECK;
    if (CarData->warnMask & (1 << WARN_FUEL))      return WARN_FUEL;
    if (CarData->warnMask & (1 << WARN_OVERSPEED)) return WARN_OVERSPEED;
    if (CarData->warnMask & (1 << WARN_SEATBELT))  return WARN_SEATBELT;
    if (CarData->warnMask & (1 << WARN_DOOR))      return WARN_DOOR;
    if (CarData->warnMask & (1 << WARN_HANDBRAKE)) return WARN_HANDBRAKE;
    
    return WARN_NONE;
}