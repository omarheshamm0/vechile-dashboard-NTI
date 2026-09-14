/*
 * File: cluster.c
 * Author: Ahmed Ellamie / ahmed.ellamieee@gmail.com
 * Description: Implementation of Cluster State Machine & Data Management
 */

#include "cluster.h"
#include "dashboard_types.h"

/* Static Global Data Instance */
static CarData_t g_carData;

void Cluster_Init(void) {
    /* Set default values for all car parameters */
    g_carData.speedKmh     = 0;
    g_carData.rpm          = 0;
    g_carData.fuelPct      = 100;    /* Default initial fuel 100% */
    g_carData.coolantC     = 25;     /* Room temperature */
    g_carData.battmV       = 12500;  /* Nominal battery voltage (12.5V) */
    g_carData.oilBarX10    = 25;     /* 2.5 bar */
    g_carData.odoMetres    = 0;
    g_carData.tripMetres   = 0;
    g_carData.maxSpeedKmh  = 0;
    g_carData.avgSpeedKmh  = 0;
    g_carData.warnMask     = WARN_NONE;
    g_carData.lampByte     = 0;
    
    /* Flags Initialization */
    g_carData.turnLeft     = 0;
    g_carData.turnRight    = 0;
    g_carData.highBeam     = 0;
    g_carData.handbrake    = 0;
    g_carData.seatbelt     = 0;
    g_carData.doorOpen     = 0;
    g_carData.engineRun    = 0;
    g_carData.limpHome     = 0;

    g_carData.state        = CS_IGNITION;
    g_carData.page         = PG_MAIN;
    g_carData.ignitionSec  = 0;
}

void Cluster_Update(void) {
    /* State Machine logic according to engine RPM and status */
    switch (g_carData.state) {
        case CS_OFF:
            g_carData.engineRun = 0;
            break;

        case CS_IGNITION:
            /* Engine starting detection threshold */
            if (g_carData.rpm > 400) {
                g_carData.state = CS_RUNNING;
                g_carData.engineRun = 1;
            }
            break;

        case CS_RUNNING:
            /* Stall detection threshold */
            if (g_carData.rpm < 200) {
                g_carData.state = CS_STALLED;
                g_carData.engineRun = 0;
            }
            break;

        case CS_STALLED:
            if (g_carData.rpm > 400) {
                g_carData.state = CS_RUNNING;
                g_carData.engineRun = 1;
            }
            break;

        default:
            g_carData.state = CS_IGNITION;
            break;
    }
}

CarData_t* Cluster_GetCarData(void) {
    return &g_carData;
}

void Cluster_SetPage(DisplayPage_t page) {
    g_carData.page = page;
}