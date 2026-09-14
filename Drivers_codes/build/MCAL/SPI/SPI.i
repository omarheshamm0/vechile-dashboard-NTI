# 0 "MCAL/SPI/SPI.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/SPI/SPI.c"
# 9 "MCAL/SPI/SPI.c"
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
# 10 "MCAL/SPI/SPI.c" 2
# 1 "MCAL/SPI/SPI_interface.h" 1
# 30 "MCAL/SPI/SPI_interface.h"
STD_ReturnType SPI_InitMaster(uint8 Copy_u8Prescaler);




STD_ReturnType SPI_InitSlave(void);





STD_ReturnType SPI_Transceive(uint8 Copy_u8Sent, uint8 *Copy_pu8Received);





STD_ReturnType SPI_SelectSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin);
STD_ReturnType SPI_ReleaseSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin);
# 11 "MCAL/SPI/SPI.c" 2
# 1 "MCAL/SPI/SPI_private.h" 1
# 12 "MCAL/SPI/SPI.c" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 43 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 13 "MCAL/SPI/SPI.c" 2
# 21 "MCAL/SPI/SPI.c"
STD_ReturnType SPI_InitMaster(uint8 Copy_u8Prescaler)
{
 if (Copy_u8Prescaler > 3u)
 {
  return E_NOK;
 }

 if ((GPIO_SetPinDirection(1u, 4u, 1u) == E_NOK) ||
  (GPIO_SetPinDirection(1u, 5u, 1u) == E_NOK) ||
  (GPIO_SetPinDirection(1u, 6u, 0u) == E_NOK) ||
  (GPIO_SetPinDirection(1u, 7u, 1u) == E_NOK))
 {
  return E_NOK;
 }

 if (GPIO_SetPinValue(1u, 4u, 1u) == E_NOK)
 {
  return E_NOK;
 }

 (*(volatile uint8 *)0x2E) &= (uint8)~(1u << 0u);
 (*(volatile uint8 *)0x2D) = (uint8)((1u << 6u) | (1u << 4u) | Copy_u8Prescaler);
 return E_OK;
}






STD_ReturnType SPI_InitSlave(void)
{
 if ((GPIO_SetPinDirection(1u, 4u, 0u) == E_NOK) ||
  (GPIO_SetPinDirection(1u, 5u, 0u) == E_NOK) ||
  (GPIO_SetPinDirection(1u, 6u, 1u) == E_NOK) ||
  (GPIO_SetPinDirection(1u, 7u, 0u) == E_NOK))
 {
  return E_NOK;
 }

 (*(volatile uint8 *)0x2E) &= (uint8)~(1u << 0u);
 (*(volatile uint8 *)0x2D) = (uint8)(1u << 6u);
 return E_OK;
}
# 73 "MCAL/SPI/SPI.c"
STD_ReturnType SPI_Transceive(uint8 Copy_u8Sent, uint8 *Copy_pu8Received)
{
 if (Copy_pu8Received == (uint8 *)0)
 {
  return E_NOK;
 }

 (*(volatile uint8 *)0x2F) = Copy_u8Sent;
 while (((*(volatile uint8 *)0x2E) & (uint8)(1u << 7u)) == 0u)
 {
 }

 *Copy_pu8Received = (*(volatile uint8 *)0x2F);
 return E_OK;
}
# 97 "MCAL/SPI/SPI.c"
STD_ReturnType SPI_SelectSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin)
{
 if (GPIO_SetPinDirection(Copy_u8Port, Copy_u8Pin, 1u) == E_NOK)
 {
  return E_NOK;
 }

 return GPIO_SetPinValue(Copy_u8Port, Copy_u8Pin, 0u);
}

STD_ReturnType SPI_ReleaseSlave(uint8 Copy_u8Port, uint8 Copy_u8Pin)
{
 return GPIO_SetPinValue(Copy_u8Port, Copy_u8Pin, 1u);
}
