# 0 "HAL/SPEEDO/speedo.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/SPEEDO/speedo.c"
# 1 "C:/avr-gcc/avr/include/avr/io.h" 1 3
# 99 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 1 3
# 126 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 3
# 1 "C:/avr-gcc/avr/include/inttypes.h" 1 3
# 37 "C:/avr-gcc/avr/include/inttypes.h" 3
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 1 3 4
# 9 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 3 4
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
# 1 "C:/avr-gcc/avr/include/stdint.h" 1 3 4
# 125 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef signed int int8_t __attribute__((__mode__(__QI__)));
typedef unsigned int uint8_t __attribute__((__mode__(__QI__)));
typedef signed int int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int uint16_t __attribute__ ((__mode__ (__HI__)));
typedef signed int int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int uint32_t __attribute__ ((__mode__ (__SI__)));

typedef signed int int64_t __attribute__((__mode__(__DI__)));
typedef unsigned int uint64_t __attribute__((__mode__(__DI__)));
# 146 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 163 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_least8_t;




typedef uint8_t uint_least8_t;




typedef int16_t int_least16_t;




typedef uint16_t uint_least16_t;




typedef int32_t int_least32_t;




typedef uint32_t uint_least32_t;







typedef int64_t int_least64_t;






typedef uint64_t uint_least64_t;
# 217 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_fast8_t;




typedef uint8_t uint_fast8_t;




typedef int16_t int_fast16_t;




typedef uint16_t uint_fast16_t;




typedef int32_t int_fast32_t;




typedef uint32_t uint_fast32_t;







typedef int64_t int_fast64_t;






typedef uint64_t uint_fast64_t;
# 277 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int64_t intmax_t;




typedef uint64_t uintmax_t;
# 12 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 2 3 4
#pragma GCC diagnostic pop
# 38 "C:/avr-gcc/avr/include/inttypes.h" 2 3
# 77 "C:/avr-gcc/avr/include/inttypes.h" 3
typedef int32_t int_farptr_t;





typedef uint32_t uint_farptr_t;
# 127 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 2 3
# 100 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 230 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/iom32.h" 1 3
# 720 "C:/avr-gcc/avr/include/avr/iom32.h" 3
       
# 721 "C:/avr-gcc/avr/include/avr/iom32.h" 3

       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
# 231 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 785 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/portpins.h" 1 3
# 786 "C:/avr-gcc/avr/include/avr/io.h" 2 3

# 1 "C:/avr-gcc/avr/include/avr/common.h" 1 3
# 788 "C:/avr-gcc/avr/include/avr/io.h" 2 3

# 1 "C:/avr-gcc/avr/include/avr/version.h" 1 3
# 790 "C:/avr-gcc/avr/include/avr/io.h" 2 3






# 1 "C:/avr-gcc/avr/include/avr/fuse.h" 1 3
# 248 "C:/avr-gcc/avr/include/avr/fuse.h" 3
typedef struct
{
    unsigned char low;
    unsigned char high;
} __fuse_t;
# 797 "C:/avr-gcc/avr/include/avr/io.h" 2 3


# 1 "C:/avr-gcc/avr/include/avr/lock.h" 1 3
# 800 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 2 "HAL/SPEEDO/speedo.c" 2
# 1 "C:/avr-gcc/avr/include/avr/interrupt.h" 1 3
# 3 "HAL/SPEEDO/speedo.c" 2
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 1 3 4
# 160 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef int ptrdiff_t;
# 229 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef unsigned int size_t;
# 344 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef int wchar_t;
# 4 "HAL/SPEEDO/speedo.c" 2


# 1 "./LIB/STD_TYPES.h" 1
# 11 "./LIB/STD_TYPES.h"

# 11 "./LIB/STD_TYPES.h"
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
# 7 "HAL/SPEEDO/speedo.c" 2
# 1 "./LIB/dashboard_types.h" 1



# 1 "./LIB/STD_TYPES.h" 1
# 5 "./LIB/dashboard_types.h" 2

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
# 8 "HAL/SPEEDO/speedo.c" 2
# 1 "./HAL/SPEEDO/speedo.h" 1



# 1 "./HAL/SPEEDO/../../LIB/STD_TYPES.h" 1
# 5 "./HAL/SPEEDO/speedo.h" 2
# 1 "./HAL/SPEEDO/../../LIB/dashboard_types.h" 1
# 6 "./HAL/SPEEDO/speedo.h" 2

void SPD_Init(void);
void SPD_Task100ms(CarData_t *pCarData, const DashCfg_t *pCfg);
void SPD_OnOverflowISR(void);
# 9 "HAL/SPEEDO/speedo.c" 2
# 1 "APP/odometer/odometer.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "APP/odometer/odometer.h" 2





void ODO_AddDistance(uint16 mm_to_add);





void ODO_GetTotal(uint32 *total);





void ODO_GetTrip(uint32 *trip);




void ODO_ResetTrip(void);
# 10 "HAL/SPEEDO/speedo.c" 2






static volatile uint16_t s_lastCnt;
static volatile uint16_t s_ovfCount;
static volatile uint32_t s_deltaTicks;
static volatile uint8_t s_fresh;
static uint16_t s_stallTicks;
static uint8_t s_firstEdge;
static volatile uint16_t s_pulseAccum;

void SPD_Init(void)
{

    
# 27 "HAL/SPEEDO/speedo.c" 3
   (*(volatile uint8_t *)((0x17) + 0x20)) 
# 27 "HAL/SPEEDO/speedo.c"
         &= (uint8_t)~(1u << 
# 27 "HAL/SPEEDO/speedo.c" 3
                             2
# 27 "HAL/SPEEDO/speedo.c"
                                );
    
# 28 "HAL/SPEEDO/speedo.c" 3
   (*(volatile uint8_t *)((0x18) + 0x20)) 
# 28 "HAL/SPEEDO/speedo.c"
         &= (uint8_t)~(1u << 
# 28 "HAL/SPEEDO/speedo.c" 3
                             2
# 28 "HAL/SPEEDO/speedo.c"
                                );

    s_lastCnt = 0u;
    s_ovfCount = 0u;
    s_deltaTicks = 0UL;
    s_fresh = 0u;
    s_stallTicks = 0u;
    s_firstEdge = 1u;
    s_pulseAccum = 0u;


    
# 39 "HAL/SPEEDO/speedo.c" 3
   (*(volatile uint8_t *)((0x2F) + 0x20)) 
# 39 "HAL/SPEEDO/speedo.c"
          = 0x00u;
    
# 40 "HAL/SPEEDO/speedo.c" 3
   (*(volatile uint8_t *)((0x2E) + 0x20)) 
# 40 "HAL/SPEEDO/speedo.c"
          = (uint8_t)((1u << 
# 40 "HAL/SPEEDO/speedo.c" 3
                             1
# 40 "HAL/SPEEDO/speedo.c"
                                 ) | (1u << 
# 40 "HAL/SPEEDO/speedo.c" 3
                                            0
# 40 "HAL/SPEEDO/speedo.c"
                                                ));
    
# 41 "HAL/SPEEDO/speedo.c" 3
   (*(volatile uint8_t *)((0x38) + 0x20)) 
# 41 "HAL/SPEEDO/speedo.c"
          = (uint8_t)(1u << 
# 41 "HAL/SPEEDO/speedo.c" 3
                            2
# 41 "HAL/SPEEDO/speedo.c"
                                );
    
# 42 "HAL/SPEEDO/speedo.c" 3
   (*(volatile uint8_t *)((0x39) + 0x20)) 
# 42 "HAL/SPEEDO/speedo.c"
         |= (uint8_t)(1u << 
# 42 "HAL/SPEEDO/speedo.c" 3
                            2
# 42 "HAL/SPEEDO/speedo.c"
                                 );
    
# 43 "HAL/SPEEDO/speedo.c" 3
   (*(volatile uint16_t *)((0x2C) + 0x20)) 
# 43 "HAL/SPEEDO/speedo.c"
          = 0u;


    
# 46 "HAL/SPEEDO/speedo.c" 3
   (*(volatile uint8_t *)((0x34) + 0x20)) 
# 46 "HAL/SPEEDO/speedo.c"
          |= (uint8_t)(1u << 
# 46 "HAL/SPEEDO/speedo.c" 3
                             6
# 46 "HAL/SPEEDO/speedo.c"
                                 );
    
# 47 "HAL/SPEEDO/speedo.c" 3
   (*(volatile uint8_t *)((0x3A) + 0x20)) 
# 47 "HAL/SPEEDO/speedo.c"
          |= (uint8_t)(1u << 
# 47 "HAL/SPEEDO/speedo.c" 3
                             5
# 47 "HAL/SPEEDO/speedo.c"
                                  );
    
# 48 "HAL/SPEEDO/speedo.c" 3
   (*(volatile uint8_t *)((0x3B) + 0x20)) 
# 48 "HAL/SPEEDO/speedo.c"
          |= (uint8_t)(1u << 
# 48 "HAL/SPEEDO/speedo.c" 3
                             5
# 48 "HAL/SPEEDO/speedo.c"
                                 );
}

void SPD_OnOverflowISR(void)
{
    s_ovfCount++;
}


# 56 "HAL/SPEEDO/speedo.c" 3
void __vector_9 (void) __attribute__ ((__signal__,__used__, __externally_visible__)) ; void __vector_9 (void)

# 57 "HAL/SPEEDO/speedo.c"
{
    SPD_OnOverflowISR();
}


# 61 "HAL/SPEEDO/speedo.c" 3
void __vector_3 (void) __attribute__ ((__signal__,__used__, __externally_visible__)) ; void __vector_3 (void)

# 62 "HAL/SPEEDO/speedo.c"
{
    uint16_t now = 
# 63 "HAL/SPEEDO/speedo.c" 3
                   (*(volatile uint16_t *)((0x2C) + 0x20))
# 63 "HAL/SPEEDO/speedo.c"
                        ;
    uint32_t delta;

    if (s_firstEdge)
    {
        s_firstEdge = 0u;
        s_lastCnt = now;
        s_ovfCount = 0u;
        return;
    }

    delta = ((uint32_t)s_ovfCount << 16) + (uint32_t)now - (uint32_t)s_lastCnt;

    s_lastCnt = now;
    s_ovfCount = 0u;
    s_deltaTicks = delta;
    s_fresh = 1u;
    s_stallTicks = 0u;
    s_pulseAccum++;
}

void SPD_Task100ms(CarData_t *pCarData, const DashCfg_t *pCfg)
{
    uint32_t deltaTicks;
    uint8_t isFresh;
    uint32_t periodUs;
    uint32_t speed;
    uint16_t pulses;

    if ((pCarData == ((void *)0)) || (pCfg == ((void *)0)) || (pCfg->pulsesPerRev == 0u))
    {
        return;
    }


    {
        uint8_t sreg = 
# 99 "HAL/SPEEDO/speedo.c" 3
                      (*(volatile uint8_t *)((0x3F) + 0x20))
# 99 "HAL/SPEEDO/speedo.c"
                          ;
        
# 100 "HAL/SPEEDO/speedo.c" 3
       __asm__ __volatile__ ("cli" ::: "memory")
# 100 "HAL/SPEEDO/speedo.c"
            ;
        deltaTicks = s_deltaTicks;
        isFresh = s_fresh;
        s_fresh = 0u;
        pulses = s_pulseAccum;
        s_pulseAccum = 0u;
        
# 106 "HAL/SPEEDO/speedo.c" 3
       (*(volatile uint8_t *)((0x3F) + 0x20)) 
# 106 "HAL/SPEEDO/speedo.c"
            = sreg;
    }


    if (isFresh && deltaTicks > 0u)
    {
        periodUs = deltaTicks * 8u;
        speed = 1800000UL / periodUs;

        if (speed <= 250u)
        {
            pCarData->speedKmh = (uint16_t)speed;
            if (pCarData->speedKmh > pCarData->maxSpeedKmh)
            {
                pCarData->maxSpeedKmh = pCarData->speedKmh;
            }
        }
        else
        {
            pCarData->speedKmh = 0u;
        }

        s_stallTicks = 0u;
    }
    else
    {
        if (s_stallTicks < 0xFFFFu) s_stallTicks++;
        if (s_stallTicks >= 10u)
        {
            pCarData->speedKmh = 0u;
        }
    }


    if (pulses > 0u)
    {
        if (pulses > 100u) pulses = 100u;
        {
            uint16_t mmPerPulse =
                (uint16_t)(pCfg->wheelCircMm / pCfg->pulsesPerRev);
            ODO_AddDistance((uint16_t)(mmPerPulse * pulses));
        }
    }
}
