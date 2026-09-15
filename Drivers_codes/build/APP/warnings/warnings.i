# 0 "APP/warnings/warnings.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/warnings/warnings.c"
# 1 "APP/warnings/warnings.h" 1



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
# 5 "APP/warnings/warnings.h" 2
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
# 6 "APP/warnings/warnings.h" 2

void WRN_Update(CarData_t *CarData);
Warn_t WRN_Highest(const CarData_t *CarData);
# 2 "APP/warnings/warnings.c" 2


static uint8 Latched_Oil = 0;
static uint8 Latched_Coolant = 0;

void WRN_Update(CarData_t *CarData) {


    if (CarData->engineRun && CarData->oilBarX10 < 10) {
        Latched_Oil = 1;
    }


    if (CarData->coolantC > 110) {
        Latched_Coolant = 1;
    }


    uint8 batt_warn = 0;
    if ((CarData->engineRun && CarData->battmV < 12000) || (CarData->battmV > 15000)) {
        batt_warn = 1;
    }


    static uint8 fuel_warn_active = 0;
    if (CarData->fuelPct < 10) {
        fuel_warn_active = 1;
    } else if (CarData->fuelPct > 13) {
        fuel_warn_active = 0;
    }


    if (Latched_Oil) CarData->warnMask |= (1 << WARN_OIL);
    else CarData->warnMask &= ~(1 << WARN_OIL);

    if (Latched_Coolant) CarData->warnMask |= (1 << WARN_COOLANT);
    else CarData->warnMask &= ~(1 << WARN_COOLANT);

    if (batt_warn) CarData->warnMask |= (1 << WARN_BATT);
    else CarData->warnMask &= ~(1 << WARN_BATT);

    if (fuel_warn_active) CarData->warnMask |= (1 << WARN_FUEL);
    else CarData->warnMask &= ~(1 << WARN_FUEL);


}

Warn_t WRN_Highest(const CarData_t *CarData) {

    if (CarData->warnMask & (1 << WARN_OIL)) return WARN_OIL;
    if (CarData->warnMask & (1 << WARN_BATT)) return WARN_BATT;
    if (CarData->warnMask & (1 << WARN_COOLANT)) return WARN_COOLANT;
    if (CarData->warnMask & (1 << WARN_CHECK)) return WARN_CHECK;
    if (CarData->warnMask & (1 << WARN_FUEL)) return WARN_FUEL;
    if (CarData->warnMask & (1 << WARN_OVERSPEED)) return WARN_OVERSPEED;
    if (CarData->warnMask & (1 << WARN_SEATBELT)) return WARN_SEATBELT;
    if (CarData->warnMask & (1 << WARN_DOOR)) return WARN_DOOR;
    if (CarData->warnMask & (1 << WARN_HANDBRAKE)) return WARN_HANDBRAKE;

    return WARN_NONE;
}
