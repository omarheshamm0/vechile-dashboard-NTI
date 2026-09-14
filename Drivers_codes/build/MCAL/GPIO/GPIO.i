# 0 "MCAL/GPIO/GPIO.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/GPIO/GPIO.c"
# 9 "MCAL/GPIO/GPIO.c"
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
# 10 "MCAL/GPIO/GPIO.c" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 43 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 11 "MCAL/GPIO/GPIO.c" 2
# 1 "MCAL/GPIO/GPIO_private.h" 1
# 12 "MCAL/GPIO/GPIO.c" 2
# 21 "MCAL/GPIO/GPIO.c"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction)
{
    uint8 Local_u8Mask;

    if ((Copy_u8Port > 3u) || (Copy_u8Pin > 7u) ||
        (Copy_u8Direction > 2u))
    {
        return E_NOK;
    }

    Local_u8Mask = ((uint8)(1u << (Copy_u8Pin)));

    switch (Copy_u8Port)
    {
    case 0u:
        if (Copy_u8Direction == 1u)
            (*(volatile uint8 *)0x3A) |= Local_u8Mask;
        else
            (*(volatile uint8 *)0x3A) &= (uint8)~Local_u8Mask;
        if (Copy_u8Direction == 2u)
            (*(volatile uint8 *)0x3B) |= Local_u8Mask;
        else if (Copy_u8Direction == 0u)
            (*(volatile uint8 *)0x3B) &= (uint8)~Local_u8Mask;
        break;
    case 1u:
        if (Copy_u8Direction == 1u)
            (*(volatile uint8 *)0x37) |= Local_u8Mask;
        else
            (*(volatile uint8 *)0x37) &= (uint8)~Local_u8Mask;
        if (Copy_u8Direction == 2u)
            (*(volatile uint8 *)0x38) |= Local_u8Mask;
        else if (Copy_u8Direction == 0u)
            (*(volatile uint8 *)0x38) &= (uint8)~Local_u8Mask;
        break;
    case 2u:
        if (Copy_u8Direction == 1u)
            (*(volatile uint8 *)0x34) |= Local_u8Mask;
        else
            (*(volatile uint8 *)0x34) &= (uint8)~Local_u8Mask;
        if (Copy_u8Direction == 2u)
            (*(volatile uint8 *)0x35) |= Local_u8Mask;
        else if (Copy_u8Direction == 0u)
            (*(volatile uint8 *)0x35) &= (uint8)~Local_u8Mask;
        break;
    case 3u:
        if (Copy_u8Direction == 1u)
            (*(volatile uint8 *)0x31) |= Local_u8Mask;
        else
            (*(volatile uint8 *)0x31) &= (uint8)~Local_u8Mask;
        if (Copy_u8Direction == 2u)
            (*(volatile uint8 *)0x32) |= Local_u8Mask;
        else if (Copy_u8Direction == 0u)
            (*(volatile uint8 *)0x32) &= (uint8)~Local_u8Mask;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}






STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value)
{
    uint8 Local_u8Mask;

    if ((Copy_u8Port > 3u) || (Copy_u8Pin > 7u) || (Copy_u8Value > 1u))
    {
        return E_NOK;
    }

    Local_u8Mask = ((uint8)(1u << (Copy_u8Pin)));

    switch (Copy_u8Port)
    {
    case 0u:
        if (Copy_u8Value == 1u)
            (*(volatile uint8 *)0x3B) |= Local_u8Mask;
        else
            (*(volatile uint8 *)0x3B) &= (uint8)~Local_u8Mask;
        break;
    case 1u:
        if (Copy_u8Value == 1u)
            (*(volatile uint8 *)0x38) |= Local_u8Mask;
        else
            (*(volatile uint8 *)0x38) &= (uint8)~Local_u8Mask;
        break;
    case 2u:
        if (Copy_u8Value == 1u)
            (*(volatile uint8 *)0x35) |= Local_u8Mask;
        else
            (*(volatile uint8 *)0x35) &= (uint8)~Local_u8Mask;
        break;
    case 3u:
        if (Copy_u8Value == 1u)
            (*(volatile uint8 *)0x32) |= Local_u8Mask;
        else
            (*(volatile uint8 *)0x32) &= (uint8)~Local_u8Mask;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}






STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value)
{
    uint8 Local_u8Mask;

    if ((Copy_u8Port > 3u) || (Copy_u8Pin > 7u) ||
        (Copy_pu8Value == (uint8 *)0))
    {
        return E_NOK;
    }

    Local_u8Mask = ((uint8)(1u << (Copy_u8Pin)));

    switch (Copy_u8Port)
    {
    case 0u:
        *Copy_pu8Value = ((*(volatile uint8 *)0x39) & Local_u8Mask) ? 1u : 0u;
        break;
    case 1u:
        *Copy_pu8Value = ((*(volatile uint8 *)0x36) & Local_u8Mask) ? 1u : 0u;
        break;
    case 2u:
        *Copy_pu8Value = ((*(volatile uint8 *)0x33) & Local_u8Mask) ? 1u : 0u;
        break;
    case 3u:
        *Copy_pu8Value = ((*(volatile uint8 *)0x30) & Local_u8Mask) ? 1u : 0u;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}






STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin)
{
    uint8 Local_u8Mask;

    if ((Copy_u8Port > 3u) || (Copy_u8Pin > 7u))
    {
        return E_NOK;
    }

    Local_u8Mask = ((uint8)(1u << (Copy_u8Pin)));

    switch (Copy_u8Port)
    {
    case 0u:
        (*(volatile uint8 *)0x3B) ^= Local_u8Mask;
        break;
    case 1u:
        (*(volatile uint8 *)0x38) ^= Local_u8Mask;
        break;
    case 2u:
        (*(volatile uint8 *)0x35) ^= Local_u8Mask;
        break;
    case 3u:
        (*(volatile uint8 *)0x32) ^= Local_u8Mask;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}






STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction)
{
    if ((Copy_u8Port > 3u))
    {
        return E_NOK;
    }

    switch (Copy_u8Port)
    {
    case 0u:
        (*(volatile uint8 *)0x3A) = Copy_u8Direction;
        break;
    case 1u:
        (*(volatile uint8 *)0x37) = Copy_u8Direction;
        break;
    case 2u:
        (*(volatile uint8 *)0x34) = Copy_u8Direction;
        break;
    case 3u:
        (*(volatile uint8 *)0x31) = Copy_u8Direction;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}






STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value)
{
    if (Copy_u8Port > 3u)
    {
        return E_NOK;
    }

    switch (Copy_u8Port)
    {
    case 0u:
        (*(volatile uint8 *)0x3B) = Copy_u8Value;
        break;
    case 1u:
        (*(volatile uint8 *)0x38) = Copy_u8Value;
        break;
    case 2u:
        (*(volatile uint8 *)0x35) = Copy_u8Value;
        break;
    case 3u:
        (*(volatile uint8 *)0x32) = Copy_u8Value;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}






STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value)
{
    if ((Copy_u8Port > 3u) || ((void *)0) == Copy_pu8Value)
    {
        return E_NOK;
    }

    switch (Copy_u8Port)
    {
    case 0u:
        *Copy_pu8Value = (*(volatile uint8 *)0x39);
        break;
    case 1u:
        *Copy_pu8Value = (*(volatile uint8 *)0x36);
        break;
    case 2u:
        *Copy_pu8Value = (*(volatile uint8 *)0x33);
        break;
    case 3u:
        *Copy_pu8Value = (*(volatile uint8 *)0x30);
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}
