#include "odometer.h"
#include <avr/interrupt.h>
#include <avr/io.h>

/* Shared variables (must be volatile as they might be accessed concurrently)[cite: 1] */
static volatile uint32 Odo_LifetimeMetres = 0;
static volatile uint32 Odo_TripMetres = 0;
static volatile uint16 Accumulator_mm = 0;

void ODO_AddDistance(uint16 mm_to_add) {
    /* 
     * This operation must be atomic to prevent a context switch while carrying
     * over millimeters to meters.
     */
    {
        uint8 sreg = SREG;
        cli();
        
        Accumulator_mm += mm_to_add;
        
        /* Convert millimeters to meters exactly, no float drift[cite: 1] */
        while (Accumulator_mm >= 1000) {
            Accumulator_mm -= 1000;
            
            /* Prevent wrapping of the lifetime odometer[cite: 1] */
            if (Odo_LifetimeMetres < 0xFFFFFFFF) {
                Odo_LifetimeMetres++;
            }
            
            if (Odo_TripMetres < 0xFFFFFFFF) {
                Odo_TripMetres++;
            }
        }
        
        SREG = sreg;
    }
}

void ODO_GetTotal(uint32 *total) {
    if (total == NULL) return;
    
    /* 
     * Read a 32-bit counter shared with an ISR atomically to prevent Data Tearing bug
     * (NFR-10, NFR-14)[cite: 1].
     */
    {
        uint8 sreg = SREG;
        cli();
        
        *total = Odo_LifetimeMetres;
        
        SREG = sreg;
    }
}

void ODO_GetTrip(uint32 *trip) {
    if (trip == NULL) return;
    
    {
        uint8 sreg = SREG;
        cli();
        
        *trip = Odo_TripMetres;
        
        SREG = sreg;
    }
}

void ODO_ResetTrip(void) {
    /* 
     * Holding the trip-reset button for 2s zeroes trip distance. 
     * Lifetime odometer is untouched (FR-07)[cite: 1].
     */
    {
        uint8 sreg = SREG;
        cli();
        
        Odo_TripMetres = 0;
        
        SREG = sreg;
    }
}