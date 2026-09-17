#include "cluster.h"
#include "warnings.h" /* For WRN_Highest */

/* Timing constants based on a 10ms task period */
#define BULBCHECK_TICKS  300  /* 3 seconds[cite: 1] */
#define CRANK_MAX_TICKS  500  /* 5 seconds[cite: 1] */
#define RUN_THRESH_TICKS 50   /* 500 ms (> 500 RPM to run)[cite: 1] */
#define STALL_THRESH_TICKS 100 /* 1 second (< 300 RPM to stall)[cite: 1] */

/* Static state timers */
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
    /* Global Override: Key held for 2 seconds forces system to OFF (T12)[cite: 1] */
    if (keyHeld && CarData->state != CS_OFF) {
        CarData->state = CS_OFF;
        /* Trigger odometer save sequence here (FR-06)[cite: 1] */
        return;
    }

    /* Global Override: Critical Warning (Priority 1-3) forces Limp Home mode (T10)[cite: 1] */
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
                CarData->state = CS_ACC; /* T1: Key press[cite: 1] */
            }
            break;

        case CS_ACC:
            if (keyPress) {
                CarData->state = CS_IGNITION; /* T2: Key press[cite: 1] */
                /* Force transition into BULBCHECK (T3)[cite: 1] */
                CarData->state = CS_BULBCHECK;
                State_Timer = 0;
            }
            break;

        case CS_BULBCHECK:
            State_Timer++;
            if (State_Timer >= BULBCHECK_TICKS) {
                CarData->state = CS_IGNITION; /* T4: 3 seconds elapsed[cite: 1] */
            }
            break;

        case CS_IGNITION:
            if (startBtn) {
                CarData->state = CS_CRANKING; /* T5: Start button pressed[cite: 1] */
                State_Timer = 0;
                RPM_Timer = 0;
            }
            break;

        case CS_CRANKING:
            State_Timer++;
            
            /* Check if engine successfully started (> 500 RPM for 500ms)[cite: 1] */
            if (CarData->rpm > 500) {
                RPM_Timer++;
                if (RPM_Timer >= RUN_THRESH_TICKS) {
                    CarData->state = CS_RUNNING; /* T6: Engine started[cite: 1] */
                    CarData->engineRun = 1;
                }
            } else {
                RPM_Timer = 0;
            }

            /* Check crank timeout (5 seconds)[cite: 1] */
            if (State_Timer >= CRANK_MAX_TICKS && CarData->state == CS_CRANKING) {
                CarData->state = CS_IGNITION; /* T7: Crank failed[cite: 1] */
            }
            break;

        case CS_RUNNING:
            /* Check for engine stall (< 300 RPM for 1s)[cite: 1] */
            if (CarData->rpm < 300) {
                RPM_Timer++;
                if (RPM_Timer >= STALL_THRESH_TICKS) {
                    CarData->state = CS_STALLED; /* T8: Engine stalled[cite: 1] */
                    CarData->engineRun = 0;
                }
            } else {
                RPM_Timer = 0;
            }
            break;

        case CS_STALLED:
            if (startBtn) {
                CarData->state = CS_CRANKING; /* T9: Start button pressed to restart[cite: 1] */
                State_Timer = 0;
                RPM_Timer = 0;
            }
            break;

        case CS_LIMP_HOME:
            /* Remains in this state until key off only (handled by T12 override)[cite: 1] */
            break;

        default:
            CarData->state = CS_OFF;
            break;
    }
}