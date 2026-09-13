#ifndef SEVENSEGMENT_INTERFACE_H
#define SEVENSEGMENT_INTERFACE_H

#include "GPIO_interface.h"
#include "STD_TYPES.h"

STD_ReturnType SevenSegment_init(uint8 port);
STD_ReturnType SevenSegment_display(uint8 port, uint8 number);

#endif /* SEVENSEGMENT_INTERFACE_H */
