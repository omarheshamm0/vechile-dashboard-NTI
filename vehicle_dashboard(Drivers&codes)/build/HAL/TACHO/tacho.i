# 0 "HAL/TACHO/tacho.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/TACHO/tacho.c"
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
# 2 "HAL/TACHO/tacho.c" 2
# 1 "C:/avr-gcc/avr/include/avr/interrupt.h" 1 3
# 3 "HAL/TACHO/tacho.c" 2
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 1 3 4
# 160 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef int ptrdiff_t;
# 229 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef unsigned int size_t;
# 344 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef int wchar_t;
# 4 "HAL/TACHO/tacho.c" 2

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
# 6 "HAL/TACHO/tacho.c" 2
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
# 7 "HAL/TACHO/tacho.c" 2
# 1 "./HAL/TACHO/tacho.h" 1




# 1 "./HAL/TACHO/../../LIB/STD_TYPES.h" 1
# 6 "./HAL/TACHO/tacho.h" 2

# 1 "./HAL/TACHO/../../LIB/dashboard_types.h" 1
# 8 "./HAL/TACHO/tacho.h" 2


void TAC_Init(void);


void TAC_Task250ms(CarData_t *pCarData, const DashCfg_t *pCfg);


void TAC_OnPulse(void);
# 8 "HAL/TACHO/tacho.c" 2

static volatile uint16_t s_tachoPulseCount = 0;



# 12 "HAL/TACHO/tacho.c" 3
void __vector_1 (void) __attribute__ ((__signal__,__used__, __externally_visible__)) ; void __vector_1 (void)

# 13 "HAL/TACHO/tacho.c"
{
    s_tachoPulseCount++;
}

void TAC_Init(void)
{

    
# 20 "HAL/TACHO/tacho.c" 3
   (*(volatile uint8_t *)((0x11) + 0x20)) 
# 20 "HAL/TACHO/tacho.c"
        &= ~(1 << 
# 20 "HAL/TACHO/tacho.c" 3
                  2
# 20 "HAL/TACHO/tacho.c"
                     );
    
# 21 "HAL/TACHO/tacho.c" 3
   (*(volatile uint8_t *)((0x12) + 0x20)) 
# 21 "HAL/TACHO/tacho.c"
         |= (1 << 
# 21 "HAL/TACHO/tacho.c" 3
                  2
# 21 "HAL/TACHO/tacho.c"
                     );


    
# 24 "HAL/TACHO/tacho.c" 3
   (*(volatile uint8_t *)((0x35) + 0x20)) 
# 24 "HAL/TACHO/tacho.c"
         &= ~((1 << 
# 24 "HAL/TACHO/tacho.c" 3
                    1
# 24 "HAL/TACHO/tacho.c"
                         ) | (1 << 
# 24 "HAL/TACHO/tacho.c" 3
                                   0
# 24 "HAL/TACHO/tacho.c"
                                        ));
    
# 25 "HAL/TACHO/tacho.c" 3
   (*(volatile uint8_t *)((0x35) + 0x20)) 
# 25 "HAL/TACHO/tacho.c"
         |= (1 << 
# 25 "HAL/TACHO/tacho.c" 3
                  1
# 25 "HAL/TACHO/tacho.c"
                       ) | (1 << 
# 25 "HAL/TACHO/tacho.c" 3
                                 0
# 25 "HAL/TACHO/tacho.c"
                                      );
    
# 26 "HAL/TACHO/tacho.c" 3
   (*(volatile uint8_t *)((0x3B) + 0x20)) 
# 26 "HAL/TACHO/tacho.c"
         |= (1 << 
# 26 "HAL/TACHO/tacho.c" 3
                  6
# 26 "HAL/TACHO/tacho.c"
                      );
}

void TAC_Task250ms(CarData_t *pData, const DashCfg_t *pCfg)
{
    if ((pData == ((void *)0)) || (pCfg == ((void *)0)) || (pCfg->tachPulsesPerRev == 0))
    {
        return;
    }


    uint8_t sreg = 
# 37 "HAL/TACHO/tacho.c" 3
                  (*(volatile uint8_t *)((0x3F) + 0x20))
# 37 "HAL/TACHO/tacho.c"
                      ;
    
# 38 "HAL/TACHO/tacho.c" 3
   __asm__ __volatile__ ("cli" ::: "memory")
# 38 "HAL/TACHO/tacho.c"
        ;
    uint16_t pulses = s_tachoPulseCount;
    s_tachoPulseCount = 0;
    
# 41 "HAL/TACHO/tacho.c" 3
   (*(volatile uint8_t *)((0x3F) + 0x20)) 
# 41 "HAL/TACHO/tacho.c"
        = sreg;


    pData->rpm = (uint16_t)(((uint32_t)pulses * 240UL) / pCfg->tachPulsesPerRev);
}
