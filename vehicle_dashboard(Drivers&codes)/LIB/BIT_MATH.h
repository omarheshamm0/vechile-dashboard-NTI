#ifndef BIT_MATH_H
#define BIT_MATH_H

#include "STD_TYPES.h"

#define SET_BIT(REG, BIT)   ((REG) |= (uint32)(1u << (BIT)))
#define CLR_BIT(REG, BIT)   ((REG) &= ~((uint32)(1u << (BIT))))
#define TOGGLE_BIT(REG, BIT) ((REG) ^= (uint32)(1u << (BIT)))
#define GET_BIT(REG, BIT)   (((REG) >> (BIT)) & 0x01u)

#endif /* BIT_MATH_H */
