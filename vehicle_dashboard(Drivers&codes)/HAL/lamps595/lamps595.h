#ifndef LAMPS595_H
#define LAMPS595_H

/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * HAL 74HC595 warning-lamp driver.
 * The byte is shifted on SPI MOSI, then latched with the PC2 RCLK strobe.
 */

#include "STD_TYPES.h"

#define LMP_LOW_FUEL       0u
#define LMP_OIL_PRESSURE   1u
#define LMP_BATTERY        2u
#define LMP_COOLANT        3u
#define LMP_CHECK_ENGINE   4u
#define LMP_LEFT_TURN      5u
#define LMP_RIGHT_TURN     6u
#define LMP_HIGH_BEAM      7u

#define LMP_STATE_OFF      0u
#define LMP_STATE_ON       1u

/* Configure the latch pin and clear the physical lamp outputs. */
STD_ReturnType LMP_Init(void);

/* Set or clear one bit in the pending lamp byte. */
STD_ReturnType LMP_Set(uint8 Copy_u8Lamp, uint8 Copy_u8State);

/* Shift the pending byte and pulse the 74HC595 latch on PC2. */
STD_ReturnType LMP_Refresh(void);

/* Start and service the nonblocking three-second bulb check. */
STD_ReturnType LMP_BulbCheckStart(void);
STD_ReturnType LMP_BulbCheckUpdate(uint16 Copy_u16ElapsedMs);

#endif /* LAMPS595_H */
