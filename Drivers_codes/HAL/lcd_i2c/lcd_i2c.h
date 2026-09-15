#ifndef LCD_I2C_H
#define LCD_I2C_H

/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * HAL 16x2 LCD over PCF8574 I2C backpack.
 * This driver provides the low-level LCD interface and the display-page API
 * suggested by the dashboard README.
 */

#include "STD_TYPES.h"
#include "dashboard_types.h"

#define LCD_I2C_ADDRESS      0x27u
#define LCD_COLS             16u
#define LCD_ROWS             2u

#define LCD_PAGE_MAIN        PG_MAIN
#define LCD_PAGE_TRIP        PG_TRIP
#define LCD_PAGE_ENGINE      PG_ENGINE
#define LCD_PAGE_ELECTRICAL  PG_ELECTRICAL
#define LCD_PAGE_DIAG        PG_DIAG

#define LCD_BACKLIGHT_ON     1u
#define LCD_BACKLIGHT_OFF    0u

STD_ReturnType LCD_Init(void);
STD_ReturnType LCD_Clear(void);
STD_ReturnType LCD_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col);
STD_ReturnType LCD_WriteChar(uint8 Copy_u8Char);
STD_ReturnType LCD_WriteString(const uint8 *Copy_pu8String);
STD_ReturnType LCD_SetBacklight(uint8 Copy_u8State);
STD_ReturnType LCD_WriteNumber(uint32 Copy_u32Value);

/* Display page API suggested in the project README. */
STD_ReturnType DSP_Next(void);
STD_ReturnType DSP_Render(uint8 Copy_u8Page, const uint8 *Copy_pu8Line1, const uint8 *Copy_pu8Line2);

#endif /* LCD_I2C_H */
