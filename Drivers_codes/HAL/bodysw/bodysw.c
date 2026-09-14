#include "STD_TYPES.h"
#include "GPIO_interface.h"
#include "SPI_interface.h"
#include "dashboard_types.h"
#include "bodysw.h"

#define BSW_SHLD_PORT GPIO_PORTB
#define BSW_SHLD_PIN  GPIO_PIN4

/*
 * BSW_Init
 * 1. Configure PB4 as output and keep SH/LD high while idle.
 * 2. In the 74HC165, SH/LD high = shift mode, low = sample the parallel inputs.
 */
STD_ReturnType BSW_Init(void)
{
    if (GPIO_SetPinDirection(BSW_SHLD_PORT, BSW_SHLD_PIN, GPIO_OUTPUT) == E_NOK)
    {
        return E_NOK;
    }

    if (GPIO_SetPinValue(BSW_SHLD_PORT, BSW_SHLD_PIN, GPIO_HIGH) == E_NOK)
    {
        return E_NOK;
    }

    return E_OK;
}

/*
 * BSW_Read
 * 1. Reject a NULL destination.
 * 2. Acquire the shared SPI bus for the switch block.
 * 3. Pulse SH/LD low to capture the current switch states, then high to begin shifting.
 * 4. Clock in 8 bits from the 74HC165 on MISO.
 * 5. Invert the result because the physical switches are active low.
 * 6. Release the bus and return the active-state mask.
 */
STD_ReturnType BSW_Read(uint8 *Copy_pu8SwitchMask)
{
    uint8 Local_u8ShiftedByte;
    uint8 Local_u8Mask;

    if (Copy_pu8SwitchMask == (uint8 *)0)
    {
        return E_NOK;
    }

    if (SPI_Acquire(SPI_SLAVE_SWITCHES) == E_NOK)
    {
        return E_NOK;
    }

    if (GPIO_SetPinValue(BSW_SHLD_PORT, BSW_SHLD_PIN, GPIO_LOW) == E_NOK)
    {
        SPI_Release();
        return E_NOK;
    }

    if (GPIO_SetPinValue(BSW_SHLD_PORT, BSW_SHLD_PIN, GPIO_HIGH) == E_NOK)
    {
        SPI_Release();
        return E_NOK;
    }

    if (SPI_Transceive(0xFFu, &Local_u8ShiftedByte) == E_NOK)
    {
        SPI_Release();
        return E_NOK;
    }

    SPI_Release();

    /* The 74HC165 outputs a 1 when the switch input is open and 0 when it is pressed. */
    Local_u8Mask = (uint8)(~Local_u8ShiftedByte);
    *Copy_pu8SwitchMask = Local_u8Mask;
    return E_OK;
}
