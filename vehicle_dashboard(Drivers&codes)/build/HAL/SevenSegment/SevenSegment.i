# 0 "HAL/SevenSegment/SevenSegment.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/SevenSegment/SevenSegment.c"
# 1 "HAL/SevenSegment/SevenSegment_intrface.h" 1



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
# 5 "HAL/SevenSegment/SevenSegment_intrface.h" 2


STD_ReturnType SevenSegment_init(uint8 port);
STD_ReturnType SevenSegment_display(uint8 port, uint8 number);
# 2 "HAL/SevenSegment/SevenSegment.c" 2

static const uint8 SevenSegment_u8Digits[10] =
    {
        0x3Fu, 0x06u, 0x5Bu, 0x4Fu, 0x66u,
        0x6Du, 0x7Du, 0x07u, 0x7Fu, 0x6Fu};

STD_ReturnType SevenSegment_init(uint8 port)
{
    if (port > 3u)
    {
        return E_NOK;
    }

    return GPIO_SetPortDirection(port, 0xFFu);
}

STD_ReturnType SevenSegment_display(uint8 port, uint8 number)
{
    if ((port > 3u) || (number > 9u))
    {
        return E_NOK;
    }

    return GPIO_SetPortValue(port, SevenSegment_u8Digits[number]);
}
