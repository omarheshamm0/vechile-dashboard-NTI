#ifndef CHIME_H
#define CHIME_H

#include "STD_TYPES.h"

/* Chime patterns based on the system requirements[cite: 1] */
typedef enum {
    CHM_PATTERN_OFF = 0,
    CHM_PATTERN_OVERSPEED,   /* Chime once, repeat every 5 s[cite: 1] */
    CHM_PATTERN_LIMP_HOME,   /* Continuous for 5 s, then chirp every 10 s[cite: 1] */
    CHM_PATTERN_TURN_TICK    /* Tick synchronized with 450ms turn blink[cite: 1] */
} ChimePattern_t;

/*
 * Description: Initializes Timer2 for Fast PWM on OC2 (PD7) to drive the buzzer[cite: 1].
 */
void CHM_Init(void);

/*
 * Description: Requests a specific chime pattern to be played.
 * Parameters:  pattern - The requested ChimePattern_t.
 */
void CHM_Play(ChimePattern_t pattern);

/*
 * Description: Non-blocking update function to manage chime durations and repeats.
 *              Expected to be called by the scheduler (e.g., in Task_1Hz or similar)[cite: 1].
 */
void CHM_Update(void);

#endif /* CHIME_H */