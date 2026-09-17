#ifndef DASHBOARD_TYPES_H
#define DASHBOARD_TYPES_H

#include "STD_TYPES.h"

typedef struct {
    uint16 speedKmh;         /* 0..250                                 */
    uint16 rpm;              /* 0..8000                                */
    uint8  fuelPct;          /* 0..100                                 */
    sint16 coolantC;         /* -40..130                               */
    uint16 battmV;           /* 0..16000                               */
    uint8  oilBarX10;        /* 0..100  (0.0..10.0 bar)                */
    uint32 odoMetres;        /* lifetime, metres                       */
    uint32 tripMetres;       /* since last reset                       */
    uint16 maxSpeedKmh;      /* session record                         */
    uint16 avgSpeedKmh;      /* trip average                           */
    uint16 warnMask;         /* bit per Warn_t, 1 = active             */
    uint8  lampByte;         /* what was last shifted to the 595       */
    uint8  turnLeft   : 1;
    uint8  turnRight  : 1;
    uint8  highBeam   : 1;
    uint8  handbrake  : 1;
    uint8  seatbelt   : 1;   /* 1 = unbuckled                          */
    uint8  doorOpen   : 1;
    uint8  engineRun  : 1;
    uint8  limpHome   : 1;
    uint8  state;            /* ClusterState_t                         */
    uint8  page;             /* DisplayPage_t                          */
    uint32 ignitionSec;      /* seconds since key on                   */
} CarData_t;

#define DSH_MAGIC   0x4443u      /* 'D','C'                              */
#define DSH_VERSION 0x01u

typedef struct {
    uint16 magic;
    uint8  version;
    uint32 odoMetres;          /* lifetime odometer                    */
    uint32 tripMetres;         /* trip meter                           */
    uint16 maxSpeedRecord;     /* all-time                             */
    uint16 speedLimitKmh;      /* over-speed warning  (default 120)    */
    uint8  fuelWarnPct;        /* (default 10)                         */
    uint8  coolantWarnC;       /* (default 110)                        */
    uint8  oilWarnBarX10;      /* (default 10 = 1.0 bar)               */
    uint16 battLowmV;          /* (default 12000)                      */
    uint16 battHighmV;         /* (default 15000)                      */
    uint8  pulsesPerRev;       /* wheel sensor      (default 4)        */
    uint16 wheelCircMm;        /* (default 2000)                       */
    uint8  tachPulsesPerRev;   /* (default 2)                          */
    uint16 ignitionCycles;
    uint8  writeSlot;          /* wear-levelling slot 0..7             */
    uint8  checksum;
} DashCfg_t;                     /* 33 bytes                             */

typedef enum { CS_OFF = 0, CS_ACC, CS_IGNITION, CS_BULBCHECK,
               CS_CRANKING, CS_RUNNING, CS_LIMP_HOME,
               CS_STALLED }                                ClusterState_t;

typedef enum { WARN_NONE = 0, WARN_OIL, WARN_BATT, WARN_COOLANT,
               WARN_CHECK, WARN_FUEL, WARN_OVERSPEED,
               WARN_SEATBELT, WARN_DOOR, WARN_HANDBRAKE }  Warn_t;

typedef enum { PG_MAIN = 0, PG_TRIP, PG_ENGINE, PG_ELECTRICAL,
               PG_DIAG }                                   DisplayPage_t;

typedef enum { SPI_SLAVE_SWITCHES = 0, SPI_SLAVE_LAMPS }   SpiSlave_t;

typedef struct {
    volatile uint16 lastIcr;      /* previous ICR1                     */
    volatile uint16 ovfCount;     /* Timer1 overflows since last edge  */
    volatile uint32 deltaTicks;   /* 32-bit period, ready for maths    */
    volatile uint8  fresh;        /* set by ISR, cleared by the task   */
    uint16          stallTicks;   /* 10 ms units since last edge       */
} Capture_t;

#endif /* DASHBOARD_TYPES_H */
