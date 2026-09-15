#ifndef F_CPU
#define F_CPU 8000000UL
#endif

#include <util/delay.h>

#include "STD_TYPES.h"
#include "I2C_interface.h"
#include "lcd_i2c.h"

#define LCD_RS_BIT   0u
#define LCD_RW_BIT   1u
#define LCD_EN_BIT   2u
#define LCD_BL_BIT   3u
#define LCD_D4_BIT   4u
#define LCD_D5_BIT   5u
#define LCD_D6_BIT   6u
#define LCD_D7_BIT   7u

#define LCD_CMD_CLEAR            0x01u
#define LCD_CMD_HOME             0x02u
#define LCD_CMD_ENTRY_MODE       0x06u
#define LCD_CMD_DISPLAY_ON       0x0Cu
#define LCD_CMD_FUNCTION_4BIT    0x28u
#define LCD_CMD_DDRAM            0x80u

static uint8 Local_u8CurrentPage;
static uint8 Local_u8Backlight;

static void Local_WriteNibble(uint8 Copy_u8Nibble, uint8 Copy_u8IsCommand)
{
    uint8 Local_u8Data;
    uint8 Local_u8EnableByte;

    Local_u8Data = (uint8)((Copy_u8Nibble & 0x0Fu) << LCD_D4_BIT);

    if (Copy_u8IsCommand == 0u)
    {
        Local_u8Data |= (uint8)(1u << LCD_RS_BIT);
    }
    else
    {
        Local_u8Data &= (uint8)~(1u << LCD_RS_BIT);
    }

    Local_u8Data |= (uint8)(Local_u8Backlight << LCD_BL_BIT);

    /* Send high pulse on EN (PCF8574 P2). */
    Local_u8EnableByte = (uint8)(Local_u8Data | (1u << LCD_EN_BIT));
    I2C_SendStart();
    I2C_SendSlaveAddressWithWrite(LCD_I2C_ADDRESS);
    I2C_SendByte(Local_u8EnableByte);
    I2C_SendStop();
    _delay_us(1u);

    /* Remove EN to create the falling edge. */
    I2C_SendStart();
    I2C_SendSlaveAddressWithWrite(LCD_I2C_ADDRESS);
    I2C_SendByte(Local_u8Data);
    I2C_SendStop();
    _delay_us(40u);
}

static void Local_WriteByte(uint8 Copy_u8Byte, uint8 Copy_u8IsCommand)
{
    Local_WriteNibble((uint8)(Copy_u8Byte >> 4u), Copy_u8IsCommand);
    Local_WriteNibble((uint8)(Copy_u8Byte & 0x0Fu), Copy_u8IsCommand);
}

static void Local_SendCommand(uint8 Copy_u8Command)
{
    Local_WriteByte(Copy_u8Command, 1u);
}

static void Local_SendData(uint8 Copy_u8Data)
{
    Local_WriteByte(Copy_u8Data, 0u);
}

STD_ReturnType LCD_Init(void)
{
    Local_u8CurrentPage = PG_MAIN;
    Local_u8Backlight = LCD_BACKLIGHT_ON;

    if (I2C_InitMaster(100000UL) == E_NOK)
    {
        return E_NOK;
    }

    _delay_ms(50u);

    /* HD44780 4-bit initialization sequence. */
    Local_WriteNibble(0x03u, 1u);
    _delay_ms(5u);
    Local_WriteNibble(0x03u, 1u);
    _delay_us(150u);
    Local_WriteNibble(0x03u, 1u);
    Local_WriteNibble(0x02u, 1u);

    Local_SendCommand(LCD_CMD_FUNCTION_4BIT);
    Local_SendCommand(LCD_CMD_DISPLAY_ON);
    Local_SendCommand(LCD_CMD_ENTRY_MODE);
    Local_SendCommand(LCD_CMD_CLEAR);
    _delay_ms(2u);
    Local_SendCommand(LCD_CMD_HOME);
    _delay_ms(2u);
    return E_OK;
}

STD_ReturnType LCD_Clear(void)
{
    Local_SendCommand(LCD_CMD_CLEAR);
    _delay_ms(2u);
    return E_OK;
}

STD_ReturnType LCD_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col)
{
    uint8 Local_u8Address;

    if ((Copy_u8Row >= LCD_ROWS) || (Copy_u8Col >= LCD_COLS))
    {
        return E_NOK;
    }

    Local_u8Address = Copy_u8Col;
    if (Copy_u8Row == 1u)
    {
        Local_u8Address += 0x40u;
    }

    Local_SendCommand((uint8)(LCD_CMD_DDRAM | Local_u8Address));
    return E_OK;
}

STD_ReturnType LCD_WriteChar(uint8 Copy_u8Char)
{
    Local_SendData(Copy_u8Char);
    return E_OK;
}

STD_ReturnType LCD_WriteString(const uint8 *Copy_pu8String)
{
    uint8 Local_u8Index;

    if (Copy_pu8String == (const uint8 *)0)
    {
        return E_NOK;
    }

    Local_u8Index = 0u;
    while (Copy_pu8String[Local_u8Index] != '\0')
    {
        Local_SendData(Copy_pu8String[Local_u8Index]);
        Local_u8Index++;
    }

    return E_OK;
}

STD_ReturnType LCD_SetBacklight(uint8 Copy_u8State)
{
    if (Copy_u8State > 1u)
    {
        return E_NOK;
    }

    Local_u8Backlight = Copy_u8State;
    return E_OK;
}

STD_ReturnType LCD_WriteNumber(uint32 Copy_u32Value)
{
    uint8 Local_u8Buffer[11];
    uint8 Local_u8Index = 0u;
    uint32 Local_u32Temp;

    if (Copy_u32Value == 0u)
    {
        Local_SendData('0');
        return E_OK;
    }

    Local_u32Temp = Copy_u32Value;
    while (Local_u32Temp != 0u)
    {
        Local_u8Buffer[Local_u8Index] = (uint8)('0' + (Local_u32Temp % 10u));
        Local_u32Temp /= 10u;
        Local_u8Index++;
    }

    while (Local_u8Index > 0u)
    {
        Local_u8Index--;
        Local_SendData(Local_u8Buffer[Local_u8Index]);
    }

    return E_OK;
}

STD_ReturnType DSP_Next(void)
{
    Local_u8CurrentPage = (uint8)((Local_u8CurrentPage + 1u) % 5u);
    return E_OK;
}

STD_ReturnType DSP_Render(uint8 Copy_u8Page, const uint8 *Copy_pu8Line1, const uint8 *Copy_pu8Line2)
{
    if ((Copy_u8Page > PG_DIAG) || (Copy_pu8Line1 == (const uint8 *)0) || (Copy_pu8Line2 == (const uint8 *)0))
    {
        return E_NOK;
    }

    LCD_Clear();
    LCD_SetCursor(0u, 0u);
    LCD_WriteString(Copy_pu8Line1);
    LCD_SetCursor(1u, 0u);
    LCD_WriteString(Copy_pu8Line2);
    Local_u8CurrentPage = Copy_u8Page;
    return E_OK;
}
