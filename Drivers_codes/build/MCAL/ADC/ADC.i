# 0 "MCAL/ADC/ADC.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/ADC/ADC.c"
# 9 "MCAL/ADC/ADC.c"
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
# 10 "MCAL/ADC/ADC.c" 2
# 1 "LIB/MATH.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "LIB/MATH.h" 2
# 11 "MCAL/ADC/ADC.c" 2
# 1 "MCAL/ADC/ADC_interface.h" 1
# 46 "MCAL/ADC/ADC_interface.h"
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler);





STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading);




STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel);





STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading);





STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State);
# 12 "MCAL/ADC/ADC.c" 2
# 1 "MCAL/ADC/ADC_private.h" 1
# 13 "MCAL/ADC/ADC.c" 2
# 21 "MCAL/ADC/ADC.c"
STD_ReturnType ADC_Init(uint8 Copy_u8Ref, uint8 Copy_u8Prescaler)
{
    if ((Copy_u8Ref > 3u) || (Copy_u8Prescaler < 1u) || (Copy_u8Prescaler > 7u))
    {
        return E_NOK;
    }

    (((*(volatile uint8 *)0x27)) &= ~((uint32)(1u << (5u))));
    (*(volatile uint8 *)0x27) = (uint8)(((*(volatile uint8 *)0x27) & (uint8)~0xC0u) | ((Copy_u8Ref << 6u) & 0xC0u));

    (*(volatile uint8 *)0x26) = (uint8)((*(volatile uint8 *)0x26) & (uint8)~0x07u);
    (*(volatile uint8 *)0x26) = (uint8)((*(volatile uint8 *)0x26) | (Copy_u8Prescaler & 0x07u));
    (((*(volatile uint8 *)0x26)) |= (uint32)(1u << (7u)));

    return E_OK;
}
# 46 "MCAL/ADC/ADC.c"
STD_ReturnType ADC_ReadChannel(uint8 Copy_u8Channel, uint16 *Copy_pu16Reading)
{
    if (Copy_u8Channel > 7u || Copy_pu16Reading == ((void *)0))
    {
        return E_NOK;
    }

    (*(volatile uint8 *)0x27) = (uint8)(((*(volatile uint8 *)0x27) & (uint8)~0x1Fu) | (Copy_u8Channel & 0x1Fu));
    (((*(volatile uint8 *)0x26)) |= (uint32)(1u << (6u)));

    while ((*(volatile uint8 *)0x26) & (1u << 6u))
    {

    }

    (((*(volatile uint8 *)0x26)) |= (uint32)(1u << (4u)));
    *Copy_pu16Reading = (uint16)(*(volatile uint8 *)0x24) | ((uint16)(*(volatile uint8 *)0x25) << 8u);

    return E_OK;
}






STD_ReturnType ADC_StartConversion(uint8 Copy_u8Channel)
{
    if (Copy_u8Channel > 7u)
    {
        return E_NOK;
    }

    (*(volatile uint8 *)0x27) = (uint8)(((*(volatile uint8 *)0x27) & (uint8)~0x1Fu) | (Copy_u8Channel & 0x1Fu));
    (((*(volatile uint8 *)0x26)) |= (uint32)(1u << (6u)));

    return E_OK;
}






STD_ReturnType ADC_GetResult(uint16 *Copy_pu16Reading)
{
    if (Copy_pu16Reading == ((void *)0))
    {
        return E_NOK;
    }

    if (((*(volatile uint8 *)0x26) & (1u << 4u)) == 0u)
    {
        return E_NOK;
    }

    (((*(volatile uint8 *)0x26)) |= (uint32)(1u << (4u)));
    *Copy_pu16Reading = (uint16)(*(volatile uint8 *)0x24) | ((uint16)(*(volatile uint8 *)0x25) << 8u);

    return E_OK;
}






STD_ReturnType ADC_SetInterrupt(uint8 Copy_u8State)
{

    (void)Copy_u8State;
    return E_OK;
}
