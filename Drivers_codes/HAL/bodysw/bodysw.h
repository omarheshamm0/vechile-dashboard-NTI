#ifndef BODYSW_H
#define BODYSW_H

/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * HAL 74HC165 body-switch driver.
 * The switch block is sampled with SH/LD and clocked in over the shared SPI MISO line.
 * The returned mask is interpreted in active-high form: 1 = switch active, 0 = idle.
 */

#include "STD_TYPES.h"

#define BSW_TURN_LEFT      0u
#define BSW_TURN_RIGHT     1u
#define BSW_HIGH_BEAM      2u
#define BSW_HANDBRAKE      3u
#define BSW_SEATBELT       4u
#define BSW_DOOR           5u

#define BSW_STATE_IDLE     0u
#define BSW_STATE_ACTIVE   1u

/* Configure the 74HC165 SH/LD control pin and leave the shift register idle. */
STD_ReturnType BSW_Init(void);

/* Trigger a switch scan and return the six switch bits as an active-state mask. */
STD_ReturnType BSW_Read(uint8 *Copy_pu8SwitchMask);

#endif /* BODYSW_H */
