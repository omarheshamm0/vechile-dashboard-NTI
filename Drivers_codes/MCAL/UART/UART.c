/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — UART.c  (ATmega32 USART, 8N1 polling)
 * Implement every prototype from UART_interface.h.
 */

#include "STD_TYPES.h"
#include "UART_interface.h"
#include "UART_private.h"
#include "INTERRUPT_interface.h"

#ifndef F_CPU
#define F_CPU 8000000UL
#endif

/*
 * UART_Init
 * 1. Reject baud == 0.
 * 2. Compute UBRR = F_CPU / (16 * baud) - 1. Write UBRRH then UBRRL.
 * 3. UCSRC = URSEL | UCSZ1 | UCSZ0   (8N1, async).
 * 4. UCSRB = RXEN | TXEN.
 * 5. At 8 MHz, 9600 baud -> UBRR = 51.
 */
STD_ReturnType UART_Init(uint32 Copy_u32BaudRate)
{
	uint32 Local_u32Ubrr;

	if (Copy_u32BaudRate == 0UL)
	{
		return E_NOK;
	}

	Local_u32Ubrr = (F_CPU / (16UL * Copy_u32BaudRate)) - 1UL;
	if (Local_u32Ubrr > 0x0FFFUL)
	{
		return E_NOK;
	}

	UART_UBRRH = (uint8)(Local_u32Ubrr >> 8);
	UART_UBRRL = (uint8)Local_u32Ubrr;
	UART_UCSRC = (uint8)((1u << UART_URSEL) | (1u << UART_UCSZ1) | (1u << UART_UCSZ0));
	UART_UCSRB = (uint8)((1u << UART_RXEN) | (1u << UART_TXEN));

	return E_OK;
}

/*
 * UART_SendByte
 * 1. while (UDRE == 0) ;   then UDR = Copy_u8Data.
 */
STD_ReturnType UART_SendByte(uint8 Copy_u8Data)
{
	while ((UART_UCSRA & (uint8)(1u << UART_UDRE)) == 0u)
	{
	}

	UART_UDR = Copy_u8Data;
	return E_OK;
}

/*
 * UART_ReceiveByte
 * 1. Reject a NULL pointer.
 * 2. while (RXC == 0) ;    then *Copy_pu8Data = UDR.
 */
STD_ReturnType UART_ReceiveByte(uint8 *Copy_pu8Data)
{
	if (Copy_pu8Data == (uint8 *)0)
	{
		return E_NOK;
	}

	while ((UART_UCSRA & (uint8)(1u << UART_RXC)) == 0u)
	{
	}

	*Copy_pu8Data = UART_UDR;
	return E_OK;
}

/*
 * UART_SendString
 * 1. Reject a NULL pointer.
 * 2. Send bytes until '\0'. Do not send the terminator unless the lab asks.
 */
STD_ReturnType UART_SendString(const uint8 *Copy_pu8String)
{
	if (Copy_pu8String == (const uint8 *)0)
	{
		return E_NOK;
	}

	while (*Copy_pu8String != '\0')
	{
		UART_SendByte(*Copy_pu8String);
		Copy_pu8String++;
	}

	return E_OK;
}

/*
 * UART_IsDataReady
 * 1. Return E_OK if RXC is 1, else E_NOK.
 */
STD_ReturnType UART_IsDataReady(void)
{
	return ((UART_UCSRA & (uint8)(1u << UART_RXC)) != 0u) ? E_OK : E_NOK;
}

/*
 * UART_SetRxInterrupt / UART_SetTxInterrupt
 * 1. Set or clear RXCIE / UDRIE in UCSRB.
 * 2. Vectors: USART_RXC_vect , USART_UDRE_vect.
 */
STD_ReturnType UART_SetRxInterrupt(uint8 Copy_u8State)
{
	if (Copy_u8State > 1u)
	{
		return E_NOK;
	}

	if (Copy_u8State == 1u)
	{
		UART_UCSRB |= (uint8)(1u << UART_RXCIE);
		INTERRUPT_EnableGlobal();
	}
	else
	{
		UART_UCSRB &= (uint8)~(1u << UART_RXCIE);
	}

	return E_OK;
}

STD_ReturnType UART_SetTxInterrupt(uint8 Copy_u8State)
{
	if (Copy_u8State > 1u)
	{
		return E_NOK;
	}

	if (Copy_u8State == 1u)
	{
		UART_UCSRB |= (uint8)(1u << UART_UDRIE);
		INTERRUPT_EnableGlobal();
	}
	else
	{
		UART_UCSRB &= (uint8)~(1u << UART_UDRIE);
	}

	return E_OK;
}
