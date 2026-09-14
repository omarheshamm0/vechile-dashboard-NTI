/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — SPI.c  (ATmega32, mode 0)
 * Implement every prototype from SPI_interface.h.
 */

#include "STD_TYPES.h"
#include "SPI_interface.h"
#include "SPI_private.h"
#include "GPIO_interface.h"

/*
 * SPI_InitMaster
 * 1. Reject prescaler > SPI_PRESC_128.
 * 2. SS / MOSI / SCK = output, MISO = input. Drive SS HIGH (idle).
 * 3. SPCR = SPE | MSTR | Copy_u8Prescaler.  (mode 0, MSB first)
 * 4. 8 MHz / 16 = 500 kHz SPI clock with SPI_PRESC_16.
 */
STD_ReturnType SPI_InitMaster(uint8 Copy_u8Prescaler)
{
	if (Copy_u8Prescaler > SPI_PRESC_128)
	{
		return E_NOK;
	}

	if ((GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN4, GPIO_OUTPUT) == E_NOK) ||
		(GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN5, GPIO_OUTPUT) == E_NOK) ||
		(GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN6, GPIO_INPUT) == E_NOK) ||
		(GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN7, GPIO_OUTPUT) == E_NOK))
	{
		return E_NOK;
	}

	if (GPIO_SetPinValue(GPIO_PORTB, GPIO_PIN4, GPIO_HIGH) == E_NOK)
	{
		return E_NOK;
	}

	SPI_SPSR &= (uint8)~(1u << SPI_SPI2X);
	SPI_SPCR = (uint8)((1u << SPI_SPE) | (1u << SPI_MSTR) | Copy_u8Prescaler);
	return E_OK;
}

/*
 * SPI_InitSlave
 * 1. MISO = output. MOSI, SCK, SS = input.
 * 2. SPCR = SPE only (MSTR = 0).
 */
STD_ReturnType SPI_InitSlave(void)
{
	if ((GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN4, GPIO_INPUT) == E_NOK) ||
		(GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN5, GPIO_INPUT) == E_NOK) ||
		(GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN6, GPIO_OUTPUT) == E_NOK) ||
		(GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN7, GPIO_INPUT) == E_NOK))
	{
		return E_NOK;
	}

	SPI_SPSR &= (uint8)~(1u << SPI_SPI2X);
	SPI_SPCR = (uint8)(1u << SPI_SPE);
	return E_OK;
}

/*
 * SPI_Transceive
 * 1. Reject a NULL receive pointer.
 * 2. SPDR = Copy_u8Sent;          // starts the shift in master mode
 * 3. while (SPIF == 0) ;
 * 4. *Copy_pu8Received = SPDR;    // also clears SPIF
 */
STD_ReturnType SPI_Transceive(uint8 Copy_u8Sent, uint8 *Copy_pu8Received)
{
	if (Copy_pu8Received == (uint8 *)0)
	{
		return E_NOK;
	}

	SPI_SPDR = Copy_u8Sent;
	while ((SPI_SPSR & (uint8)(1u << SPI_SPIF)) == 0u)
	{
	}

	*Copy_pu8Received = SPI_SPDR;
	return E_OK;
}

/*
 * SPI_SelectSlave
 * 1. GPIO_SetPinDirection(port, pin, GPIO_OUTPUT);
 * 2. GPIO_SetPinValue(port, pin, GPIO_LOW);
 *
 * SPI_ReleaseSlave
 * 1. GPIO_SetPinValue(port, pin, GPIO_HIGH);
 */
STD_ReturnType SPI_SelectSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin)
{
	if (GPIO_SetPinDirection(Copy_u8Port, Copy_u8Pin, GPIO_OUTPUT) == E_NOK)
	{
		return E_NOK;
	}

	return GPIO_SetPinValue(Copy_u8Port, Copy_u8Pin, GPIO_LOW);
}

STD_ReturnType SPI_ReleaseSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin)
{
	return GPIO_SetPinValue(Copy_u8Port, Copy_u8Pin, GPIO_HIGH);
}
