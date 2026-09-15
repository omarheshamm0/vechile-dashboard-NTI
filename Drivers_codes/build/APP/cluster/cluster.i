# 0 "APP/cluster/cluster.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/cluster/cluster.c"
# 1 "APP/cluster/cluster.h" 1



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
# 5 "APP/cluster/cluster.h" 2
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
# 6 "APP/cluster/cluster.h" 2




void FSM_Init(CarData_t *CarData);

CarData_t *Cluster_GetCarData(void);
void Cluster_SetPage(DisplayPage_t page);
# 23 "APP/cluster/cluster.h"
void FSM_Run(CarData_t *CarData, uint8 keyPress, uint8 keyHeld, uint8 startBtn);
# 2 "APP/cluster/cluster.c" 2
# 1 "APP/warnings/warnings.h" 1






void WRN_Update(CarData_t *CarData);
Warn_t WRN_Highest(const CarData_t *CarData);
# 3 "APP/cluster/cluster.c" 2
# 11 "APP/cluster/cluster.c"
static uint16 State_Timer = 0;
static uint16 RPM_Timer = 0;
static CarData_t Cluster_Data;

CarData_t *Cluster_GetCarData(void) {
    return &Cluster_Data;
}

void Cluster_SetPage(DisplayPage_t page) {
    Cluster_Data.page = (uint8)page;
}

void FSM_Init(CarData_t *CarData) {
    CarData->state = CS_OFF;
    CarData->engineRun = 0;
    CarData->limpHome = 0;
    State_Timer = 0;
    RPM_Timer = 0;
}

void FSM_Run(CarData_t *CarData, uint8 keyPress, uint8 keyHeld, uint8 startBtn) {

    if (keyHeld && CarData->state != CS_OFF) {
        CarData->state = CS_OFF;

        return;
    }


    if (CarData->state == CS_RUNNING) {
        Warn_t highest_warn = WRN_Highest(CarData);
        if (highest_warn == WARN_OIL || highest_warn == WARN_BATT || highest_warn == WARN_COOLANT) {
            CarData->state = CS_LIMP_HOME;
            CarData->limpHome = 1;
        }
    }

    switch (CarData->state) {
        case CS_OFF:
            CarData->engineRun = 0;
            if (keyPress) {
                CarData->state = CS_ACC;
            }
            break;

        case CS_ACC:
            if (keyPress) {
                CarData->state = CS_IGNITION;

                CarData->state = CS_BULBCHECK;
                State_Timer = 0;
            }
            break;

        case CS_BULBCHECK:
            State_Timer++;
            if (State_Timer >= 300) {
                CarData->state = CS_IGNITION;
            }
            break;

        case CS_IGNITION:
            if (startBtn) {
                CarData->state = CS_CRANKING;
                State_Timer = 0;
                RPM_Timer = 0;
            }
            break;

        case CS_CRANKING:
            State_Timer++;


            if (CarData->rpm > 500) {
                RPM_Timer++;
                if (RPM_Timer >= 50) {
                    CarData->state = CS_RUNNING;
                    CarData->engineRun = 1;
                }
            } else {
                RPM_Timer = 0;
            }


            if (State_Timer >= 500 && CarData->state == CS_CRANKING) {
                CarData->state = CS_IGNITION;
            }
            break;

        case CS_RUNNING:

            if (CarData->rpm < 300) {
                RPM_Timer++;
                if (RPM_Timer >= 100) {
                    CarData->state = CS_STALLED;
                    CarData->engineRun = 0;
                }
            } else {
                RPM_Timer = 0;
            }
            break;

        case CS_STALLED:
            if (startBtn) {
                CarData->state = CS_CRANKING;
                State_Timer = 0;
                RPM_Timer = 0;
            }
            break;

        case CS_LIMP_HOME:

            break;

        default:
            CarData->state = CS_OFF;
            break;
    }
}
