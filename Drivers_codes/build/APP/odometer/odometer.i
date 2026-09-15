# 0 "APP/odometer/odometer.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "APP/odometer/odometer.c"
# 1 "APP/odometer/odometer.h" 1



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
# 5 "APP/odometer/odometer.h" 2





void ODO_AddDistance(uint16 mm_to_add);





void ODO_GetTotal(uint32 *total);





void ODO_GetTrip(uint32 *trip);




void ODO_ResetTrip(void);
# 2 "APP/odometer/odometer.c" 2
# 1 "C:/avr-gcc/avr/include/avr/interrupt.h" 1 3
# 38 "C:/avr-gcc/avr/include/avr/interrupt.h" 3
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
# 39 "C:/avr-gcc/avr/include/avr/interrupt.h" 2 3
# 3 "APP/odometer/odometer.c" 2




# 6 "APP/odometer/odometer.c"
static volatile uint32 Odo_LifetimeMetres = 0;
static volatile uint32 Odo_TripMetres = 0;
static volatile uint16 Accumulator_mm = 0;

void ODO_AddDistance(uint16 mm_to_add) {




    {
        uint8 sreg = 
# 16 "APP/odometer/odometer.c" 3
                    (*(volatile uint8_t *)((0x3F) + 0x20))
# 16 "APP/odometer/odometer.c"
                        ;
        
# 17 "APP/odometer/odometer.c" 3
       __asm__ __volatile__ ("cli" ::: "memory")
# 17 "APP/odometer/odometer.c"
            ;

        Accumulator_mm += mm_to_add;


        while (Accumulator_mm >= 1000) {
            Accumulator_mm -= 1000;


            if (Odo_LifetimeMetres < 0xFFFFFFFF) {
                Odo_LifetimeMetres++;
            }

            if (Odo_TripMetres < 0xFFFFFFFF) {
                Odo_TripMetres++;
            }
        }

        
# 35 "APP/odometer/odometer.c" 3
       (*(volatile uint8_t *)((0x3F) + 0x20)) 
# 35 "APP/odometer/odometer.c"
            = sreg;
    }
}

void ODO_GetTotal(uint32 *total) {
    if (total == ((void *)0)) return;





    {
        uint8 sreg = 
# 47 "APP/odometer/odometer.c" 3
                    (*(volatile uint8_t *)((0x3F) + 0x20))
# 47 "APP/odometer/odometer.c"
                        ;
        
# 48 "APP/odometer/odometer.c" 3
       __asm__ __volatile__ ("cli" ::: "memory")
# 48 "APP/odometer/odometer.c"
            ;

        *total = Odo_LifetimeMetres;

        
# 52 "APP/odometer/odometer.c" 3
       (*(volatile uint8_t *)((0x3F) + 0x20)) 
# 52 "APP/odometer/odometer.c"
            = sreg;
    }
}

void ODO_GetTrip(uint32 *trip) {
    if (trip == ((void *)0)) return;

    {
        uint8 sreg = 
# 60 "APP/odometer/odometer.c" 3
                    (*(volatile uint8_t *)((0x3F) + 0x20))
# 60 "APP/odometer/odometer.c"
                        ;
        
# 61 "APP/odometer/odometer.c" 3
       __asm__ __volatile__ ("cli" ::: "memory")
# 61 "APP/odometer/odometer.c"
            ;

        *trip = Odo_TripMetres;

        
# 65 "APP/odometer/odometer.c" 3
       (*(volatile uint8_t *)((0x3F) + 0x20)) 
# 65 "APP/odometer/odometer.c"
            = sreg;
    }
}

void ODO_ResetTrip(void) {




    {
        uint8 sreg = 
# 75 "APP/odometer/odometer.c" 3
                    (*(volatile uint8_t *)((0x3F) + 0x20))
# 75 "APP/odometer/odometer.c"
                        ;
        
# 76 "APP/odometer/odometer.c" 3
       __asm__ __volatile__ ("cli" ::: "memory")
# 76 "APP/odometer/odometer.c"
            ;

        Odo_TripMetres = 0;

        
# 80 "APP/odometer/odometer.c" 3
       (*(volatile uint8_t *)((0x3F) + 0x20)) 
# 80 "APP/odometer/odometer.c"
            = sreg;
    }
}
