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



static volatile uint32 Odo_LifetimeMetres = 0;
static volatile uint32 Odo_TripMetres = 0;
static volatile uint16 Accumulator_mm = 0;

void ODO_AddDistance(uint16 mm_to_add) {




    {
        uint8 sreg = __builtin_avr_read_sreg();
        __asm__ __volatile__ ("cli" ::: "memory");

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

        __builtin_avr_write_sreg(sreg);
    }
}

void ODO_GetTotal(uint32 *total) {
    if (total == ((void *)0)) return;





    {
        uint8 sreg = __builtin_avr_read_sreg();
        __asm__ __volatile__ ("cli" ::: "memory");

        *total = Odo_LifetimeMetres;

        __builtin_avr_write_sreg(sreg);
    }
}

void ODO_GetTrip(uint32 *trip) {
    if (trip == ((void *)0)) return;

    {
        uint8 sreg = __builtin_avr_read_sreg();
        __asm__ __volatile__ ("cli" ::: "memory");

        *trip = Odo_TripMetres;

        __builtin_avr_write_sreg(sreg);
    }
}

void ODO_ResetTrip(void) {




    {
        uint8 sreg = __builtin_avr_read_sreg();
        __asm__ __volatile__ ("cli" ::: "memory");

        Odo_TripMetres = 0;

        __builtin_avr_write_sreg(sreg);
    }
}
