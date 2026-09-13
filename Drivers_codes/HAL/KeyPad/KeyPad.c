#include "KeyPad_interface.h"

STD_ReturnType KeyPad_Init(uint8 port)
{
  uint8 pin;

  if (port > GPIO_PORTD)
  {
    return E_NOK;
  }

  for (pin = GPIO_PIN0; pin <= GPIO_PIN3; pin++)
  {
    if (GPIO_SetPinDirection(port, pin, GPIO_OUTPUT) != E_OK)
    {
      return E_NOK;
    }

    if (GPIO_SetPinValue(port, pin, GPIO_HIGH) != E_OK)
    {
      return E_NOK;
    }
  }

  for (pin = GPIO_PIN4; pin <= GPIO_PIN6; pin++)
  {
    if (GPIO_SetPinDirection(port, pin, GPIO_INPUT_PULLUP) != E_OK)
    {
      return E_NOK;
    }
  }

  if (GPIO_SetPinDirection(port, GPIO_PIN7, GPIO_INPUT) != E_OK)
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

  if ((port > GPIO_PORTD) || (key == NULL))
  {
    return E_NOK;
  }

  for (row = GPIO_PIN0; row <= GPIO_PIN3; row++)
  {
    if (GPIO_SetPortValue(port, 0xFFu) != E_OK)
    {
      return E_NOK;
    }

    if (GPIO_SetPinValue(port, row, GPIO_LOW) != E_OK)
    {
      return E_NOK;
    }

    for (col = GPIO_PIN4; col <= GPIO_PIN6; col++)
    {
      if (GPIO_GetPinValue(port, col, &pinValue) != E_OK)
      {
        return E_NOK;
      }

      if (pinValue == GPIO_LOW)
      {
        *key = (uint8)(row * 3u + (col - GPIO_PIN4) + 1u);
        return E_OK;
      }
    }
  }

  return E_NOK;
}