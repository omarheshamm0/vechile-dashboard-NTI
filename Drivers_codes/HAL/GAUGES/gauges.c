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

