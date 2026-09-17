#ifndef F_CPU
#define F_CPU 8000000UL
#endif

#include <util/delay.h>

#include "STD_TYPES.h"
#include "I2C_interface.h"
#include "lcd_i2c.h"

#define LCD_AIP31068_CMD_FLAG       0x00u
#define LCD_AIP31068_DATA_FLAG      0x40u
#define LCD_AIP31068_BACKLIGHT_BIT  0x08u

#define LCD_CMD_CLEAR               0x01u
#define LCD_CMD_HOME                0x02u
#define LCD_CMD_ENTRY_MODE          0x06u
#define LCD_CMD_DISPLAY_ON          0x0Cu
#define LCD_CMD_FUNCTION_8BIT       0x38u
#define LCD_CMD_DDRAM               0x80u

static uint8 Local_u8CurrentPage;
static uint8 Local_u8Backlight;

static STD_ReturnType Local_WriteByteDirect(uint8 Copy_u8ControlByte, uint8 Copy_u8Payload)
{
    if ((I2C_SendStart() != E_OK) ||
        (I2C_SendSlaveAddressWithWrite(LCD_I2C_ADDRESS) != E_OK) ||
        (I2C_SendByte(Copy_u8ControlByte) != E_OK) ||
        (I2C_SendByte(Copy_u8Payload) != E_OK))
    {
        I2C_SendStop();
        return E_NOK;
    }

    I2C_SendStop();
    return E_OK;
}

static STD_ReturnType Local_SendCommand(uint8 Copy_u8Command)
{
    uint8 Local_u8ControlByte;

    Local_u8ControlByte = (uint8)(LCD_AIP31068_CMD_FLAG |
                                 (Local_u8Backlight ? LCD_AIP31068_BACKLIGHT_BIT : 0u));
    return Local_WriteByteDirect(Local_u8ControlByte, Copy_u8Command);
}

static STD_ReturnType Local_SendData(uint8 Copy_u8Data)
{
    uint8 Local_u8ControlByte;

    Local_u8ControlByte = (uint8)(LCD_AIP31068_DATA_FLAG |
                                 (Local_u8Backlight ? LCD_AIP31068_BACKLIGHT_BIT : 0u));
    return Local_WriteByteDirect(Local_u8ControlByte, Copy_u8Data);
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

    if ((Local_SendCommand(0x30u) != E_OK) ||
        (Local_SendCommand(0x30u) != E_OK) ||
        (Local_SendCommand(0x30u) != E_OK) ||
        (Local_SendCommand(LCD_CMD_FUNCTION_8BIT) != E_OK) ||
        (Local_SendCommand(LCD_CMD_DISPLAY_ON) != E_OK) ||
        (Local_SendCommand(LCD_CMD_ENTRY_MODE) != E_OK) ||
        (Local_SendCommand(LCD_CMD_CLEAR) != E_OK))
    {
        return E_NOK;
    }

    _delay_ms(2u);
    if (Local_SendCommand(LCD_CMD_HOME) != E_OK)
    {
        return E_NOK;
    }
    _delay_ms(2u);
    return E_OK;
}

STD_ReturnType LCD_Clear(void)
{
    if (Local_SendCommand(LCD_CMD_CLEAR) != E_OK)
    {
        return E_NOK;
    }
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

    return Local_SendCommand((uint8)(LCD_CMD_DDRAM | Local_u8Address));
}

STD_ReturnType LCD_WriteChar(uint8 Copy_u8Char)
{
    return Local_SendData(Copy_u8Char);
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
        if (Local_SendData(Copy_pu8String[Local_u8Index]) != E_OK)
        {
            return E_NOK;
        }
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
        return Local_SendData('0');
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
        if (Local_SendData(Local_u8Buffer[Local_u8Index]) != E_OK)
        {
            return E_NOK;
        }
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

    if ((LCD_Clear() != E_OK) ||
        (LCD_SetCursor(0u, 0u) != E_OK) ||
        (LCD_WriteString(Copy_pu8Line1) != E_OK) ||
        (LCD_SetCursor(1u, 0u) != E_OK) ||
        (LCD_WriteString(Copy_pu8Line2) != E_OK))
    {
        return E_NOK;
    }

    Local_u8CurrentPage = Copy_u8Page;
    return E_OK;
}
