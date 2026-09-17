# 0 "MCAL/UART/UART.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/UART/UART.c"
# 9 "MCAL/UART/UART.c"
# 1 "LIB/STD_TYPES.h" 1
# 11 "LIB/STD_TYPES.h"
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long uint32;
typedef signed char sint8;
typedef signed short sint16;
typedef signed long sint32;

typedef unsigned char uint8_h;

typedef enum
{
    E_OK = 0,
    E_NOK = 1
} STD_ReturnType;
# 10 "MCAL/UART/UART.c" 2
# 1 "MCAL/UART/UART_interface.h" 1
# 20 "MCAL/UART/UART_interface.h"
STD_ReturnType UART_Init(uint32 Copy_u32BaudRate);




STD_ReturnType UART_SendByte(uint8 Copy_u8Data);




STD_ReturnType UART_ReceiveByte(uint8 *Copy_pu8Data);




STD_ReturnType UART_SendString(const uint8 *Copy_pu8String);





STD_ReturnType UART_IsDataReady(void);





STD_ReturnType UART_SetRxInterrupt(uint8 Copy_u8State);
STD_ReturnType UART_SetTxInterrupt(uint8 Copy_u8State);
# 11 "MCAL/UART/UART.c" 2
# 1 "MCAL/UART/UART_private.h" 1
# 12 "MCAL/UART/UART.c" 2
# 1 "MCAL/INTERRUPT/INTERRUPT_interface.h" 1
# 14 "MCAL/INTERRUPT/INTERRUPT_interface.h"
# 1 "MCAL/INTERRUPT/../../LIB/STD_TYPES.h" 1
# 15 "MCAL/INTERRUPT/INTERRUPT_interface.h" 2

typedef void (*EXTI_CallbackType)(void);
# 32 "MCAL/INTERRUPT/INTERRUPT_interface.h"
STD_ReturnType INTERRUPT_EnableGlobal(void);




STD_ReturnType INTERRUPT_DisableGlobal(void);





STD_ReturnType EXTI_SetSense(uint8 Copy_u8Int, uint8 Copy_u8Sense);





STD_ReturnType EXTI_Enable(uint8 Copy_u8Int);




STD_ReturnType EXTI_Disable(uint8 Copy_u8Int);




STD_ReturnType EXTI_ClearFlag(uint8 Copy_u8Int);
# 69 "MCAL/INTERRUPT/INTERRUPT_interface.h"
STD_ReturnType EXTI_SetCallback(uint8 Copy_u8Int, EXTI_CallbackType Copy_pfCallback);
# 13 "MCAL/UART/UART.c" 2
# 26 "MCAL/UART/UART.c"
STD_ReturnType UART_Init(uint32 Copy_u32BaudRate)
{
 uint32 Local_u32Ubrr;

 if (Copy_u32BaudRate == 0UL)
 {
  return E_NOK;
 }

 Local_u32Ubrr = (8000000UL / (16UL * Copy_u32BaudRate)) - 1UL;
 if (Local_u32Ubrr > 0x0FFFUL)
 {
  return E_NOK;
 }

 (*(volatile uint8 *)0x40) = (uint8)(Local_u32Ubrr >> 8);
 (*(volatile uint8 *)0x29) = (uint8)Local_u32Ubrr;
 (*(volatile uint8 *)0x40) = (uint8)((1u << 7u) | (1u << 2u) | (1u << 1u));
 (*(volatile uint8 *)0x2A) = (uint8)((1u << 4u) | (1u << 3u));

 return E_OK;
}





STD_ReturnType UART_SendByte(uint8 Copy_u8Data)
{
 while (((*(volatile uint8 *)0x2B) & (uint8)(1u << 5u)) == 0u)
 {
 }

 (*(volatile uint8 *)0x2C) = Copy_u8Data;
 return E_OK;
}






STD_ReturnType UART_ReceiveByte(uint8 *Copy_pu8Data)
{
 if (Copy_pu8Data == (uint8 *)0)
 {
  return E_NOK;
 }

 while (((*(volatile uint8 *)0x2B) & (uint8)(1u << 7u)) == 0u)
 {
 }

 *Copy_pu8Data = (*(volatile uint8 *)0x2C);
 return E_OK;
}






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





STD_ReturnType UART_IsDataReady(void)
{
 return (((*(volatile uint8 *)0x2B) & (uint8)(1u << 7u)) != 0u) ? E_OK : E_NOK;
}






STD_ReturnType UART_SetRxInterrupt(uint8 Copy_u8State)
{
 if (Copy_u8State > 1u)
 {
  return E_NOK;
 }

 if (Copy_u8State == 1u)
 {
  (*(volatile uint8 *)0x2A) |= (uint8)(1u << 7u);
  INTERRUPT_EnableGlobal();
 }
 else
 {
  (*(volatile uint8 *)0x2A) &= (uint8)~(1u << 7u);
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
  (*(volatile uint8 *)0x2A) |= (uint8)(1u << 5u);
  INTERRUPT_EnableGlobal();
 }
 else
 {
  (*(volatile uint8 *)0x2A) &= (uint8)~(1u << 5u);
 }

 return E_OK;
}
