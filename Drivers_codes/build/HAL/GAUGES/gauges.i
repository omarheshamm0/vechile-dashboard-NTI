# 0 "HAL/GAUGES/gauges.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/GAUGES/gauges.c"
# 1 "HAL/GAUGES/gauges.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 11 "LIB/STD_TYPES.h"
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long uint32;
typedef signed char sint8;
typedef signed short sint16;
typedef signed long sint32;

typedef unsigned char uint8_h;

typedef enum
{
    E_OK = 0,
    E_NOK = 1
} STD_ReturnType;
# 5 "HAL/GAUGES/gauges.h" 2

# 1 "LIB/dashboard_types.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "LIB/dashboard_types.h" 2

typedef struct {
    uint16 speedKmh;
    uint16 rpm;
    uint8 fuelPct;
    sint16 coolantC;
    uint16 battmV;
    uint8 oilBarX10;
    uint32 odoMetres;
    uint32 tripMetres;
    uint16 maxSpeedKmh;
    uint16 avgSpeedKmh;
    uint16 warnMask;
    uint8 lampByte;
    uint8 turnLeft : 1;
    uint8 turnRight : 1;
    uint8 highBeam : 1;
    uint8 handbrake : 1;
    uint8 seatbelt : 1;
    uint8 doorOpen : 1;
    uint8 engineRun : 1;
    uint8 limpHome : 1;
    uint8 state;
    uint8 page;
    uint32 ignitionSec;
} CarData_t;




typedef struct {
    uint16 magic;
    uint8 version;
    uint32 odoMetres;
    uint32 tripMetres;
    uint16 maxSpeedRecord;
    uint16 speedLimitKmh;
    uint8 fuelWarnPct;
    uint8 coolantWarnC;
    uint8 oilWarnBarX10;
    uint16 battLowmV;
    uint16 battHighmV;
    uint8 pulsesPerRev;
    uint16 wheelCircMm;
    uint8 tachPulsesPerRev;
    uint16 ignitionCycles;
    uint8 writeSlot;
    uint8 checksum;
} DashCfg_t;

typedef enum { CS_OFF = 0, CS_ACC, CS_IGNITION, CS_BULBCHECK,
               CS_CRANKING, CS_RUNNING, CS_LIMP_HOME,
               CS_STALLED } ClusterState_t;

typedef enum { WARN_NONE = 0, WARN_OIL, WARN_BATT, WARN_COOLANT,
               WARN_CHECK, WARN_FUEL, WARN_OVERSPEED,
               WARN_SEATBELT, WARN_DOOR, WARN_HANDBRAKE } Warn_t;

typedef enum { PG_MAIN = 0, PG_TRIP, PG_ENGINE, PG_ELECTRICAL,
               PG_DIAG } DisplayPage_t;

typedef enum { SPI_SLAVE_SWITCHES = 0, SPI_SLAVE_LAMPS } SpiSlave_t;

typedef struct {
    volatile uint16 lastIcr;
    volatile uint16 ovfCount;
    volatile uint32 deltaTicks;
    volatile uint8 fresh;
    uint16 stallTicks;
} Capture_t;
# 7 "HAL/GAUGES/gauges.h" 2

void GAU_Init(void);
void GAU_Update(CarData_t *CarData);
# 2 "HAL/GAUGES/gauges.c" 2
# 1 "MCAL/ADC/ADC_interface.h" 1
# 46 "MCAL/ADC/ADC_interface.h"
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler);





STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading);




STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel);





STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading);





STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State);
# 3 "HAL/GAUGES/gauges.c" 2
# 11 "HAL/GAUGES/gauges.c"
static uint16 Fuel_Buffer[8] = {0};
static uint16 Coolant_Buffer[8] = {0};
static uint8 Filter_Idx = 0;


static uint8 ErrCount_Fuel = 0;
static uint8 ErrCount_Coolant = 0;
static uint8 ErrCount_Batt = 0;
static uint8 ErrCount_Oil = 0;


static uint8 Check_Plausibility(uint16 raw, uint8 *err_count) {
    if (raw == 0 || raw == 1023) {
        (*err_count)++;
        if (*err_count >= 10) {
            *err_count = 10;
            return E_NOK;
        }
    } else {
        *err_count = 0;
    }
    return E_OK;
}

void GAU_Init(void) {

    ADC_Init(1u, 6u);
}

void GAU_Update(CarData_t *CarData) {
    uint16 raw_fuel = 0, raw_coolant = 0, raw_batt = 0, raw_oil = 0;
    uint32 sum_fuel = 0, sum_coolant = 0;
    uint8 i;


    ADC_ReadChannel(0u, &raw_fuel);
    ADC_ReadChannel(1u, &raw_coolant);
    ADC_ReadChannel(2u, &raw_batt);
    ADC_ReadChannel(3u, &raw_oil);


    uint8 fuel_ok = Check_Plausibility(raw_fuel, &ErrCount_Fuel);
    uint8 cool_ok = Check_Plausibility(raw_coolant, &ErrCount_Coolant);
    uint8 batt_ok = Check_Plausibility(raw_batt, &ErrCount_Batt);
    uint8 oil_ok = Check_Plausibility(raw_oil, &ErrCount_Oil);


    if ((fuel_ok == E_NOK) || (cool_ok == E_NOK) || (batt_ok == E_NOK) || (oil_ok == E_NOK)) {
        CarData->warnMask |= (1 << WARN_CHECK);
    } else {
        CarData->warnMask &= ~(1 << WARN_CHECK);
    }


    Fuel_Buffer[Filter_Idx] = raw_fuel;
    Coolant_Buffer[Filter_Idx] = raw_coolant;
    Filter_Idx = (Filter_Idx + 1) % 8;

    for (i = 0; i < 8; i++) {
        sum_fuel += Fuel_Buffer[i];
        sum_coolant += Coolant_Buffer[i];
    }
    raw_fuel = sum_fuel / 8;
    raw_coolant = sum_coolant / 8;


    if (fuel_ok == E_OK) {
        CarData->fuelPct = (uint8)(((uint32)raw_fuel * 100) / 1023);
    }

    if (cool_ok == E_OK) {
        CarData->coolantC = (uint16)((((uint32)raw_coolant * 170) / 1023) - 40);
    }

    if (batt_ok == E_OK) {
       CarData->battmV = (uint16)(((uint32)raw_batt * 16) / 1023);
    }

    if (oil_ok == E_OK) {
        CarData->oilBarX10 = (uint8)(((uint32)raw_oil * 100) / 1023);
    }
}
