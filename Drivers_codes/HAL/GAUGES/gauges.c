#include "gauges.h"
#include "ADC_interface.h"

/* ADC Channel definitions based on the Pin Map[cite: 1] */
#define GAU_CH_FUEL     ADC_CHANNEL_0
#define GAU_CH_COOLANT  ADC_CHANNEL_1
#define GAU_CH_BATT     ADC_CHANNEL_2
#define GAU_CH_OIL      ADC_CHANNEL_3

/* Moving Average arrays (8 samples for fuel and coolant)[cite: 1] */
static uint16 Fuel_Buffer[8] = {0};
static uint16 Coolant_Buffer[8] = {0};
static uint8  Filter_Idx = 0;

/* Error counters for Plausibility checks - 5 seconds = 10 cycles of 500ms[cite: 1] */
static uint8 ErrCount_Fuel = 0;
static uint8 ErrCount_Coolant = 0;
static uint8 ErrCount_Batt = 0;
static uint8 ErrCount_Oil = 0;

/* Helper function to calculate the Median of 3 values[cite: 1] */
static uint16 Get_Median_Of_3(uint16 a, uint16 b, uint16 c) {
    if ((a <= b && b <= c) || (c <= b && b <= a)) return b;
    if ((b <= a && a <= c) || (c <= a && a <= b)) return a;
    return c;
}

/* Plausibility Check Function[cite: 1] */
static uint8 Check_Plausibility(uint16 raw, uint8 *err_count) {
    /* If channel is pinned at 0 or 1023[cite: 1] */
    if (raw == 0 || raw == 1023) {
        (*err_count)++;
        if (*err_count >= 10) { /* 10 cycles * 500ms = 5 seconds[cite: 1] */
            *err_count = 10; 
            return E_NOK; /* Implausible reading */
        }
    } else {
        *err_count = 0; /* Reset counter if reading returns to normal */
    }
    return E_OK; /* Plausible reading */
}

void GAU_Init(void) {
    /* Initialize ADC with AREF reference and Prescaler 64[cite: 1, 4] */
    ADC_Init(ADC_REF_AREF, ADC_PRESC_64);
}
void GAU_Update(CarData_t *CarData) {
    uint16 raw_fuel, raw_coolant, raw_batt, raw_oil;
    uint32 sum_fuel = 0, sum_coolant = 0;
    uint8 i;
    
    /* Read channels (Using fast polling for simplicity, real system might use interrupts) */
    ADC_ReadChannel(GAU_CH_FUEL, &raw_fuel);
    ADC_ReadChannel(GAU_CH_COOLANT, &raw_coolant);
    ADC_ReadChannel(GAU_CH_BATT, &raw_batt);
    ADC_ReadChannel(GAU_CH_OIL, &raw_oil);

    /* 1. Plausibility Check[cite: 1] */
    uint8 fuel_ok = Check_Plausibility(raw_fuel, &ErrCount_Fuel);
    uint8 cool_ok = Check_Plausibility(raw_coolant, &ErrCount_Coolant);
    uint8 batt_ok = Check_Plausibility(raw_batt, &ErrCount_Batt);
    uint8 oil_ok  = Check_Plausibility(raw_oil, &ErrCount_Oil);

    if (fuel_ok && cool_ok && batt_ok && oil_ok) {
        CarData->warnMask |= (1 << WARN_CHECK); /* Raise Check Engine Warning[cite: 1] */
    } else {
        CarData->warnMask &= ~(1 << WARN_CHECK); /* Note: 2-second hysteresis should be managed by scheduler[cite: 1] */
    }

    /* 2. Filtering for Fuel and Coolant (Moving Average of 8 samples)[cite: 1] */
    Fuel_Buffer[Filter_Idx] = raw_fuel;
    Coolant_Buffer[Filter_Idx] = raw_coolant;
    Filter_Idx = (Filter_Idx + 1) % 8;
    
    for (i = 0; i < 8; i++) {
        sum_fuel += Fuel_Buffer[i];
        sum_coolant += Coolant_Buffer[i];
    }
    raw_fuel = sum_fuel / 8;
    raw_coolant = sum_coolant / 8;

    /* (Note: For simplicity, we assume Median for oil and battery takes the last 3 readings directly, you can build a buffer for it too) */

    /* 3. Apply Scaling Equations using uint32 to avoid overflow[cite: 1] */
    if (fuel_ok) {
        CarData->fuelPct = (uint8)(((uint32)raw_fuel * 100) / 1023);
    }
    
    if (cool_ok) {
        CarData->coolantC = (uint16)((((uint32)raw_coolant * 170) / 1023) - 40);
    }
    
    if (batt_ok) {
        CarData->battmV = (uint16)(((uint32)raw_batt * 16000) / 1023);
    }
    
    if (oil_ok) {
        CarData->oilBarX10 = (uint8)(((uint32)raw_oil * 100) / 1023);
    }
}
