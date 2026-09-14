# 0 "MCAL/INTERRUPT/INTERRUPT.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/INTERRUPT/INTERRUPT.c"
# 9 "MCAL/INTERRUPT/INTERRUPT.c"
# 1 "MCAL/INTERRUPT/../../LIB/STD_TYPES.h" 1
# 11 "MCAL/INTERRUPT/../../LIB/STD_TYPES.h"
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
# 10 "MCAL/INTERRUPT/INTERRUPT.c" 2
# 1 "MCAL/INTERRUPT/INTERRUPT_interface.h" 1
# 16 "MCAL/INTERRUPT/INTERRUPT_interface.h"
typedef void (*EXTI_CallbackType)(void);
# 32 "MCAL/INTERRUPT/INTERRUPT_interface.h"
STD_ReturnType INTERRUPT_EnableGlobal(void);




STD_ReturnType INTERRUPT_DisableGlobal(void);





STD_ReturnType EXTI_SetSense(uint8 Copy_u8Int, uint8 Copy_u8Sense);





STD_ReturnType EXTI_Enable(uint8 Copy_u8Int);




STD_ReturnType EXTI_Disable(uint8 Copy_u8Int);




STD_ReturnType EXTI_ClearFlag(uint8 Copy_u8Int);
# 69 "MCAL/INTERRUPT/INTERRUPT_interface.h"
STD_ReturnType EXTI_SetCallback(uint8 Copy_u8Int, EXTI_CallbackType Copy_pfCallback);
# 11 "MCAL/INTERRUPT/INTERRUPT.c" 2
# 1 "MCAL/INTERRUPT/INTERRUPT_private.h" 1
# 12 "MCAL/INTERRUPT/INTERRUPT.c" 2
# 1 "C:/avr-gcc/avr/include/avr/interrupt.h" 1 3
# 38 "C:/avr-gcc/avr/include/avr/interrupt.h" 3
# 1 "C:/avr-gcc/avr/include/avr/io.h" 1 3
# 99 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 1 3
# 126 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 3
# 1 "C:/avr-gcc/avr/include/inttypes.h" 1 3
# 37 "C:/avr-gcc/avr/include/inttypes.h" 3
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 1 3 4
# 9 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 3 4
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
# 1 "C:/avr-gcc/avr/include/stdint.h" 1 3 4
# 125 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef signed int int8_t __attribute__((__mode__(__QI__)));
typedef unsigned int uint8_t __attribute__((__mode__(__QI__)));
typedef signed int int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int uint16_t __attribute__ ((__mode__ (__HI__)));
typedef signed int int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int uint32_t __attribute__ ((__mode__ (__SI__)));

typedef signed int int64_t __attribute__((__mode__(__DI__)));
typedef unsigned int uint64_t __attribute__((__mode__(__DI__)));
# 146 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 163 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_least8_t;




typedef uint8_t uint_least8_t;




typedef int16_t int_least16_t;




typedef uint16_t uint_least16_t;




typedef int32_t int_least32_t;




typedef uint32_t uint_least32_t;







typedef int64_t int_least64_t;






typedef uint64_t uint_least64_t;
# 217 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_fast8_t;




typedef uint8_t uint_fast8_t;




typedef int16_t int_fast16_t;




typedef uint16_t uint_fast16_t;




typedef int32_t int_fast32_t;




typedef uint32_t uint_fast32_t;







typedef int64_t int_fast64_t;






typedef uint64_t uint_fast64_t;
# 277 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int64_t intmax_t;




typedef uint64_t uintmax_t;
# 12 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 2 3 4
#pragma GCC diagnostic pop
# 38 "C:/avr-gcc/avr/include/inttypes.h" 2 3
# 77 "C:/avr-gcc/avr/include/inttypes.h" 3
typedef int32_t int_farptr_t;





typedef uint32_t uint_farptr_t;
# 127 "C:/avr-gcc/avr/include/avr/sfr_defs.h" 2 3
# 100 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 230 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/iom32.h" 1 3
# 720 "C:/avr-gcc/avr/include/avr/iom32.h" 3
       
# 721 "C:/avr-gcc/avr/include/avr/iom32.h" 3

       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
# 231 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 785 "C:/avr-gcc/avr/include/avr/io.h" 3
# 1 "C:/avr-gcc/avr/include/avr/portpins.h" 1 3
# 786 "C:/avr-gcc/avr/include/avr/io.h" 2 3

# 1 "C:/avr-gcc/avr/include/avr/common.h" 1 3
# 788 "C:/avr-gcc/avr/include/avr/io.h" 2 3

# 1 "C:/avr-gcc/avr/include/avr/version.h" 1 3
# 790 "C:/avr-gcc/avr/include/avr/io.h" 2 3






# 1 "C:/avr-gcc/avr/include/avr/fuse.h" 1 3
# 248 "C:/avr-gcc/avr/include/avr/fuse.h" 3
typedef struct
{
    unsigned char low;
    unsigned char high;
} __fuse_t;
# 797 "C:/avr-gcc/avr/include/avr/io.h" 2 3


# 1 "C:/avr-gcc/avr/include/avr/lock.h" 1 3
# 800 "C:/avr-gcc/avr/include/avr/io.h" 2 3
# 39 "C:/avr-gcc/avr/include/avr/interrupt.h" 2 3
# 13 "MCAL/INTERRUPT/INTERRUPT.c" 2


# 14 "MCAL/INTERRUPT/INTERRUPT.c"
static EXTI_CallbackType EXTI_Callbacks[3] = {((void *)0), ((void *)0), ((void *)0)};
# 23 "MCAL/INTERRUPT/INTERRUPT.c"
STD_ReturnType INTERRUPT_EnableGlobal(void)
{
    
# 25 "MCAL/INTERRUPT/INTERRUPT.c" 3
   __asm__ __volatile__ ("sei" ::: "memory")
# 25 "MCAL/INTERRUPT/INTERRUPT.c"
        ;
    return E_OK;
}

STD_ReturnType INTERRUPT_DisableGlobal(void)
{
    
# 31 "MCAL/INTERRUPT/INTERRUPT.c" 3
   __asm__ __volatile__ ("cli" ::: "memory")
# 31 "MCAL/INTERRUPT/INTERRUPT.c"
        ;
    return E_OK;
}
# 43 "MCAL/INTERRUPT/INTERRUPT.c"
STD_ReturnType EXTI_SetSense(uint8 Copy_u8Int, uint8 Copy_u8Sense)
{
    if ((Copy_u8Int > 2u) || (Copy_u8Sense > 3u))
        return E_NOK;

    if (Copy_u8Int == 0u)
    {
        (*(volatile uint8 *)0x55) = (uint8)(((*(volatile uint8 *)0x55) & (uint8)~0x03u) |
                                  Copy_u8Sense);
    }
    else if (Copy_u8Int == 1u)
    {
        (*(volatile uint8 *)0x55) = (uint8)(((*(volatile uint8 *)0x55) & (uint8)~0x0Cu) |
                                  (uint8)(Copy_u8Sense << 2u));
    }
    else
    {
        if ((Copy_u8Sense != 2u) &&
            (Copy_u8Sense != 3u))
            return E_NOK;

        if (Copy_u8Sense == 3u)
            (*(volatile uint8 *)0x54) |= (uint8)(1u << 6u);
        else
            (*(volatile uint8 *)0x54) &= (uint8) ~(1u << 6u);
    }

    return E_OK;
}





STD_ReturnType EXTI_ClearFlag(uint8 Copy_u8Int)
{
    uint8 Local_u8Mask;

    if (Copy_u8Int > 2u)
        return E_NOK;

    if (Copy_u8Int == 0u)
        Local_u8Mask = (uint8)(1u << 6u);
    else if (Copy_u8Int == 1u)
        Local_u8Mask = (uint8)(1u << 7u);
    else
        Local_u8Mask = (uint8)(1u << 5u);

    (*(volatile uint8 *)0x5A) = Local_u8Mask;
    return E_OK;
}
# 104 "MCAL/INTERRUPT/INTERRUPT.c"
STD_ReturnType EXTI_Enable(uint8 Copy_u8Int)
{
    uint8 Local_u8Mask;

    if (Copy_u8Int > 2u)
        return E_NOK;

    if (Copy_u8Int == 0u)
        Local_u8Mask = (uint8)(1u << 6u);
    else if (Copy_u8Int == 1u)
        Local_u8Mask = (uint8)(1u << 7u);
    else
        Local_u8Mask = (uint8)(1u << 5u);

    (*(volatile uint8 *)0x5A) = Local_u8Mask;
    (*(volatile uint8 *)0x5B) |= Local_u8Mask;
    return E_OK;
}

STD_ReturnType EXTI_Disable(uint8 Copy_u8Int)
{
    uint8 Local_u8Mask;

    if (Copy_u8Int > 2u)
        return E_NOK;

    if (Copy_u8Int == 0u)
        Local_u8Mask = (uint8)(1u << 6u);
    else if (Copy_u8Int == 1u)
        Local_u8Mask = (uint8)(1u << 7u);
    else
        Local_u8Mask = (uint8)(1u << 5u);

    (*(volatile uint8 *)0x5B) &= (uint8)~Local_u8Mask;
    return E_OK;
}

STD_ReturnType EXTI_SetCallback(uint8 Copy_u8Int, EXTI_CallbackType Copy_pfCallback)
{
    if ((Copy_u8Int > 2u) || (Copy_pfCallback == ((void *)0)))
        return E_NOK;

    EXTI_Callbacks[Copy_u8Int] = Copy_pfCallback;
    return E_OK;
}
