# 0 "HAL/KeyPad/KeyPad.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/KeyPad/KeyPad.c"
# 1 "HAL/KeyPad/KeyPad_interface.h" 1



# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 12 "MCAL/GPIO/GPIO_interface.h"
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
# 13 "MCAL/GPIO/GPIO_interface.h" 2
# 43 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 5 "HAL/KeyPad/KeyPad_interface.h" 2



STD_ReturnType KeyPad_Init(uint8 port);
STD_ReturnType KeyPad_GetPressedKey(uint8 port, uint8 *key);
# 2 "HAL/KeyPad/KeyPad.c" 2

STD_ReturnType KeyPad_Init(uint8 port)
{
  uint8 pin;

  if (port > 3u)
  {
    return E_NOK;
  }

  for (pin = 0u; pin <= 3u; pin++)
  {
    if (GPIO_SetPinDirection(port, pin, 1u) != E_OK)
    {
      return E_NOK;
    }

    if (GPIO_SetPinValue(port, pin, 1u) != E_OK)
    {
      return E_NOK;
    }
  }

  for (pin = 4u; pin <= 6u; pin++)
  {
    if (GPIO_SetPinDirection(port, pin, 2u) != E_OK)
    {
      return E_NOK;
    }
  }

  if (GPIO_SetPinDirection(port, 7u, 0u) != E_OK)
  {
    return E_NOK;
  }

  return E_OK;
}

STD_ReturnType KeyPad_GetPressedKey(uint8 port, uint8 *key)
{
  uint8 row;
  uint8 col;
  uint8 pinValue;

  if ((port > 3u) || (key == ((void *)0)))
  {
    return E_NOK;
  }

  for (row = 0u; row <= 3u; row++)
  {
    if (GPIO_SetPortValue(port, 0xFFu) != E_OK)
    {
      return E_NOK;
    }

    if (GPIO_SetPinValue(port, row, 0u) != E_OK)
    {
      return E_NOK;
    }

    for (col = 4u; col <= 6u; col++)
    {
      if (GPIO_GetPinValue(port, col, &pinValue) != E_OK)
      {
        return E_NOK;
      }

      if (pinValue == 0u)
      {
        *key = (uint8)(row * 3u + (col - 4u) + 1u);
        return E_OK;
      }
    }
  }

  return E_NOK;
}
