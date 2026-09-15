#ifndef CONSOLE_H_
#define CONSOLE_H_

#include "STD_TYPES.h"

/* --- Public Function Prototypes --- */

/* Initialize UART interface for telemetry console */
void Console_Init(void);

/* Send real-time vehicle metrics via UART */
void Console_SendTelemetry(void);

/* Process incoming UART command bytes */
void Console_ProcessCommand(void);

#endif /* CONSOLE_H_ */