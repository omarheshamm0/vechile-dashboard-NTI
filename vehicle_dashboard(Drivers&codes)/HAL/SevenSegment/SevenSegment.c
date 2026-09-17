#include "SevenSegment_intrface.h"

static const uint8 SevenSegment_u8Digits[10] =
    {
        0x3Fu, 0x06u, 0x5Bu, 0x4Fu, 0x66u,
        0x6Du, 0x7Du, 0x07u, 0x7Fu, 0x6Fu};

STD_ReturnType SevenSegment_init(uint8 port)
{
    if (port > GPIO_PORTD)
    {
        return E_NOK;
    }

    return GPIO_SetPortDirection(port, 0xFFu);
}

STD_ReturnType SevenSegment_display(uint8 port, uint8 number)
{
    if ((port > GPIO_PORTD) || (number > 9u))
    {
        return E_NOK;
    }

    return GPIO_SetPortValue(port, SevenSegment_u8Digits[number]);
}