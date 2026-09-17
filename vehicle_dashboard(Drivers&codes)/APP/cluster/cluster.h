#ifndef CLUSTER_FSM_H
#define CLUSTER_FSM_H

#include "STD_TYPES.h"
#include "dashboard_types.h"

/* 
 * Description: Initializes the FSM to the default state (OFF).
 */
void FSM_Init(CarData_t *CarData);

CarData_t *Cluster_GetCarData(void);
void Cluster_SetPage(DisplayPage_t page);

/* 
 * Description: Runs the state machine logic. Expected to be called every 10ms.
 * Parameters:
 *   CarData   - Pointer to the main car data structure.
 *   keyPress  - 1 if the ignition key was pressed (short press).
 *   keyHeld   - 1 if the ignition key was held for 2 seconds.
 *   startBtn  - 1 if the START button is currently pressed.
 */
void FSM_Run(CarData_t *CarData, uint8 keyPress, uint8 keyHeld, uint8 startBtn);

#endif /* CLUSTER_FSM_H */