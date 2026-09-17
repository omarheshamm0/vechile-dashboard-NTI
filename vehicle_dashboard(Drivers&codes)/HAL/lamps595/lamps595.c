#include "STD_TYPES.h"
#include "GPIO_interface.h"
#include "SPI_interface.h"
#include "dashboard_types.h"
#include "lamps595.h"

#define LMP_LATCH_PORT GPIO_PORTC
#define LMP_LATCH_PIN  GPIO_PIN2
#define LMP_BULB_CHECK_MS 3000u
#define LMP_LATCH_DELAY_CYCLES 4u

static uint8 Local_u8LampByte;
static uint8 Local_u8SavedLampByte;
static uint8 Local_u8BulbCheckActive;

static void Local_LatchPulse(void)
{

	volatile uint8 Local_u8Cycles;

	GPIO_SetPinValue(LMP_LATCH_PORT, LMP_LATCH_PIN, GPIO_HIGH);
	for (Local_u8Cycles = 0u; Local_u8Cycles < LMP_LATCH_DELAY_CYCLES; Local_u8Cycles++)
	{
	}
	GPIO_SetPinValue(LMP_LATCH_PORT, LMP_LATCH_PIN, GPIO_LOW);
}

STD_ReturnType LMP_Init(void)
{
	if (GPIO_SetPinDirection(LMP_LATCH_PORT, LMP_LATCH_PIN, GPIO_OUTPUT) == E_NOK)
	{
		return E_NOK;
	}

	if (GPIO_SetPinValue(LMP_LATCH_PORT, LMP_LATCH_PIN, GPIO_LOW) == E_NOK)
	{
		return E_NOK;
	}

	Local_u8LampByte = 0u;
	Local_u8SavedLampByte = 0u;
	Local_u8BulbCheckActive = 0u;
	return LMP_Refresh();
}

STD_ReturnType LMP_Set(uint8 Copy_u8Lamp, uint8 Copy_u8State)
{
	uint8 Local_u8Mask;

	if ((Copy_u8Lamp > LMP_HIGH_BEAM) || (Copy_u8State > LMP_STATE_ON))
	{
		return E_NOK;
	}

	Local_u8Mask = (uint8)(1u << Copy_u8Lamp);
	if (Copy_u8State == LMP_STATE_ON)
	{
		Local_u8LampByte |= Local_u8Mask;
	}
	else
	{
		Local_u8LampByte &= (uint8)~Local_u8Mask;
	}

	return E_OK;
}

STD_ReturnType LMP_Refresh(void)
{
	if (SPI_Acquire(SPI_SLAVE_LAMPS) == E_NOK)
	{
		return E_NOK;
	}

	if (SPI_TransmitByte(Local_u8LampByte) == E_NOK)
	{
		SPI_Release();
		return E_NOK;
	}

	SPI_Release();
	Local_LatchPulse();
	return E_OK;
}

STD_ReturnType LMP_BulbCheckStart(void)
{
	Local_u8SavedLampByte = Local_u8LampByte;
	Local_u8LampByte = 0xFFu;
	Local_u8BulbCheckActive = 1u;
	return LMP_Refresh();
}

STD_ReturnType LMP_BulbCheckUpdate(uint16 Copy_u16ElapsedMs)
{
	if (Local_u8BulbCheckActive == 0u)
	{
		return E_OK;
	}

	if (Copy_u16ElapsedMs >= LMP_BULB_CHECK_MS)
	{
		Local_u8BulbCheckActive = 0u;
		Local_u8LampByte = Local_u8SavedLampByte;
		return LMP_Refresh();
	}

	return E_OK;
}
