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

static uint8 Local_u8BusOwner = SPI_BUS_FREE;

/*
 * SPI_InitMaster
 * 1. Reject prescaler > SPI_PRESC_128.
 * 2. SH/LD / MOSI / SCK = output, MISO = input. Drive SH/LD HIGH (idle).
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
 * SPI_TransmitByte
 * 1. Write SPDR to start the transfer.
 * 2. Wait for SPIF, then read SPDR only to clear the completion condition.
 */
STD_ReturnType SPI_TransmitByte(uint8 Copy_u8Sent)
{
	volatile uint8 Local_u8Discarded;

	SPI_SPDR = Copy_u8Sent;
	while ((SPI_SPSR & (uint8)(1u << SPI_SPIF)) == 0u)
	{
	}

	Local_u8Discarded = SPI_SPDR;
	(void)Local_u8Discarded;
	return E_OK;
}

/*
 * SPI_Acquire
 * 1. Reject an already-owned bus.
 * 2. Record the logical owner for the complete multi-step transaction.
 */
STD_ReturnType SPI_Acquire(uint8 Copy_u8Owner)
{
	if ((Copy_u8Owner == SPI_BUS_FREE) || (Local_u8BusOwner != SPI_BUS_FREE))
	{
		return E_NOK;
	}

	Local_u8BusOwner = Copy_u8Owner;
	return E_OK;
}

/*
 * SPI_Release
 * 1. Mark the bus idle after the complete transaction is finished.
 */
void SPI_Release(void)
{
	Local_u8BusOwner = SPI_BUS_FREE;
}
