/*
 * File: console.c
 * Author: Ahmed Ellamie / ahmed.ellamiee@gmail.com
 * Description: Non-blocking vehicle Telemetry output and Interactive Command Handler.
 */

#include "STD_TYPES.h"
#include "UART_interface.h"
#include "dashboard_types.h"
#include "cluster.h"
#include "console.h"
#include <stdio.h>

void Console_Init(void) {
    UART_Init(9600);
}

void Console_SendTelemetry(void) {
    CarData_t *pData = Cluster_GetCarData();
    if (pData == NULL) {
        return;
    }

    char buffer[128];

    /* Format real-time vehicle metrics */
    snprintf(buffer, sizeof(buffer),
             "TEL|SPD:%u|RPM:%u|FL:%u|CLT:%d|BAT:%u|OIL:%u|ODO:%lu|WARN:0x%04X\r\n",
             pData->speedKmh,
             pData->rpm,
             pData->fuelPct,
             pData->coolantC,
             pData->battmV,
             pData->oilBarX10,
             (unsigned long)pData->odoMetres,
             pData->warnMask);

    UART_SendString((const uint8 *)buffer);
}

void Console_ProcessCommand(void) {
    uint8 receivedChar = 0;

    /* Non-blocking check: read only when a byte is available in UART buffer */
    if (UART_IsDataReady() == E_OK) {
        if (UART_ReceiveByte(&receivedChar) == E_OK) {
            switch (receivedChar) {
                case '1':
                    UART_SendString((const uint8 *)"CMD: TEST_LAMPS_ON\r\n");
                    break;

                case 'p':
                case 'P':
                    Cluster_SetPage(PG_TRIP);
                    UART_SendString((const uint8 *)"CMD: PAGE_CHANGED_TO_TRIP\r\n");
                    break;

                case 'm':
                case 'M':
                    Cluster_SetPage(PG_MAIN);
                    UART_SendString((const uint8 *)"CMD: PAGE_CHANGED_TO_MAIN\r\n");
                    break;

                default:
                    break;
            }
        }
    }
}