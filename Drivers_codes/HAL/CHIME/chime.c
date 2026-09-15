#include "chime.h"
#include "GPIO_interface.h"

/* Hardware definitions for Timer2 (ATmega32)[cite: 1] */
#define TIMER2_TCCR2  (*(volatile uint8 *)0x45)
#define TIMER2_TCNT2  (*(volatile uint8 *)0x44)
#define TIMER2_OCR2   (*(volatile uint8 *)0x43)

/* TCCR2 Bits */
#define WGM20_BIT 6u
#define WGM21_BIT 3u
#define COM21_BIT 5u
#define CS22_BIT  2u
#define CS21_BIT  1u

static ChimePattern_t Current_Pattern = CHM_PATTERN_OFF; //initial state

static uint16 Timer_Ticks = 0; //intialize timer ticks to 0

static uint8  Is_Playing = 0; //initial state

/* Helper function to turn the PWM tone ON */
static void Tone_On(void) {
    /* Set OCR2 to ~50% duty cycle for a standard tone */
    TIMER2_OCR2 = 127;
    /* Enable Fast PWM, Clear OC2 on compare match, Prescaler 64 */
    TIMER2_TCCR2 = (1u << WGM20_BIT) | (1u << WGM21_BIT) | (1u << COM21_BIT) | (1u << CS22_BIT);
    Is_Playing = 1;
}

/* Helper function to turn the PWM tone OFF */
static void Tone_Off(void) {
    /* Disconnect OC2 and stop timer clock */
    TIMER2_TCCR2 = 0x00;
    TIMER2_OCR2 = 0;
    Is_Playing = 0;
}

void CHM_Init(void) {
    /* Set PD7 (OC2) as Output for the Buzzer[cite: 1] */
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN7, GPIO_OUTPUT);
    Tone_Off(); // initialize with tone off
}
void CHM_Play(ChimePattern_t pattern) {
    if (Current_Pattern != pattern) { //see if the pattern is different from the current one
        Current_Pattern = pattern; // Update the current pattern
        Timer_Ticks = 0; /* Reset state machine timer on new pattern */
        
        /* Immediate actions on pattern start */
        if (pattern == CHM_PATTERN_OFF) {
            Tone_Off();
        } else {
            Tone_On();
        }
    }
}

void CHM_Update(void) {
    /* 
     * This function should ideally be called every 100ms or 1s depending on your scheduler setup.
     * For this implementation, we assume it is called every 100ms for decent resolution.
     */
    if (Current_Pattern == CHM_PATTERN_OFF) {
        return;
    }

    Timer_Ticks++;

    switch (Current_Pattern) {
        case CHM_PATTERN_OVERSPEED:
            /* Chime once, repeat every 5 s[cite: 1] */
            /* 5 seconds = 50 ticks of 100ms */  // 5 ticks of 100ms = 500ms, 50 ticks = 5s
            if (Timer_Ticks == 5) {
                Tone_Off(); /* Turn off after 500ms */
            } else if (Timer_Ticks >= 50) {
                Tone_On();  /* Turn back on at 5s mark */
                Timer_Ticks = 0;
            }
            break;

        case CHM_PATTERN_LIMP_HOME:
            /* Continuous for 5 s, then one chirp every 10 s[cite: 1] */
            if (Timer_Ticks <= 50) {
                /* Continuous for first 5 seconds */
                if (!Is_Playing) Tone_On();
            } else if (Timer_Ticks == 55) {
                /* Chirp ends after 500ms */
                Tone_Off();
            } else if (Timer_Ticks >= 150) {
                /* 10 seconds after the continuous tone ended */
                Tone_On();
                Timer_Ticks = 50; /* Reset to just before chirp ends */
            }
            break;

        case CHM_PATTERN_TURN_TICK:
            /* 450 ms on / 450 ms off[cite: 1] - requires ~50ms resolution ideally, 
               but using 400ms/500ms for 100ms tick approximation */
            if (Timer_Ticks == 4) {
                Tone_Off();
            } else if (Timer_Ticks >= 9) {
                Tone_On();
                Timer_Ticks = 0;
            }
            break;

        default:
            Tone_Off();
            break;
    }
}