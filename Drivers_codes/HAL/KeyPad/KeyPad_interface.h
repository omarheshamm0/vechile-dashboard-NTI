#ifndef KEYPAD_INTERFACE_H
#define KEYPAD_INTERFACE_H

#include "GPIO_interface.h"

#include "STD_TYPES.h"

STD_ReturnType KeyPad_Init(uint8 port);
STD_ReturnType KeyPad_GetPressedKey(uint8 port, uint8 *key);

#endif