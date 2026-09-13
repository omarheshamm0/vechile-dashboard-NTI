/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — INTERRUPT.c  (ATmega32 EXTI + global I-bit)
 * Implement every prototype from INTERRUPT_interface.h.
 */

#include "STD_TYPES.h"
#include "INTERRUPT_interface.h"
#include "INTERRUPT_private.h"
#include <avr/interrupt.h>

static EXTI_CallbackType EXTI_Callbacks[3] = {NULL, NULL, NULL};

/*
 * INTERRUPT_EnableGlobal
 * 1. Set SREG I-bit (sei). Return E_OK.
 *
 * INTERRUPT_DisableGlobal
 * 1. Clear SREG I-bit (cli). Return E_OK.
 */
STD_ReturnType INTERRUPT_EnableGlobal(void)
{
    sei();
    return E_OK;
}

STD_ReturnType INTERRUPT_DisableGlobal(void)
{
    cli();
    return E_OK;
}

/*
 * EXTI_SetSense
 * 1. Reject an unknown source.
 * 2. INT0 : write ISC01:ISC00 from Copy_u8Sense (0..3).
 * 3. INT1 : write ISC11:ISC10 the same way.
 * 4. INT2 : only EXTI_FALLING_EDGE (ISC2=0) or EXTI_RISING_EDGE (ISC2=1).
 *    Return E_NOK for low-level / any-change on INT2.
 */
STD_ReturnType EXTI_SetSense(uint8 Copy_u8Int, uint8 Copy_u8Sense)
{
    if ((Copy_u8Int > EXTI_INT2) || (Copy_u8Sense > EXTI_RISING_EDGE))
        return E_NOK;

    if (Copy_u8Int == EXTI_INT0)
    {
        INTERRUPT_MCUCR = (uint8)((INTERRUPT_MCUCR & (uint8)~INTERRUPT_ISC0_MASK) |
                                  Copy_u8Sense);
    }
    else if (Copy_u8Int == EXTI_INT1)
    {
        INTERRUPT_MCUCR = (uint8)((INTERRUPT_MCUCR & (uint8)~INTERRUPT_ISC1_MASK) |
                                  (uint8)(Copy_u8Sense << 2u));
    }
    else
    {
        if ((Copy_u8Sense != EXTI_FALLING_EDGE) &&
            (Copy_u8Sense != EXTI_RISING_EDGE))
            return E_NOK;

        if (Copy_u8Sense == EXTI_RISING_EDGE)
            INTERRUPT_MCUCSR |= (uint8)(1u << INTERRUPT_ISC2_BIT);
        else
            INTERRUPT_MCUCSR &= (uint8) ~(1u << INTERRUPT_ISC2_BIT);
    }

    return E_OK;
}

/*
 * EXTI_ClearFlag
 * 1. Write 1 to INTF0 / INTF1 / INTF2 in GIFR (w1c).
 */
STD_ReturnType EXTI_ClearFlag(uint8 Copy_u8Int)
{
    uint8 Local_u8Mask;

    if (Copy_u8Int > EXTI_INT2)
        return E_NOK;

    if (Copy_u8Int == EXTI_INT0)
        Local_u8Mask = (uint8)(1u << INTERRUPT_INT0_BIT);
    else if (Copy_u8Int == EXTI_INT1)
        Local_u8Mask = (uint8)(1u << INTERRUPT_INT1_BIT);
    else
        Local_u8Mask = (uint8)(1u << INTERRUPT_INT2_BIT);

    INTERRUPT_GIFR = Local_u8Mask;
    return E_OK;
}

/*
 * EXTI_Enable
 * 1. Validate the source.
 * 2. Clear the stale flag first, then set INT0/INT1/INT2 in GICR.
 * 3. Order that always works: sense -> clear flag -> enable source -> sei().
 *
 * EXTI_Disable
 * 1. Clear the matching GICR bit.
 */
STD_ReturnType EXTI_Enable(uint8 Copy_u8Int)
{
    uint8 Local_u8Mask;

    if (Copy_u8Int > EXTI_INT2)
        return E_NOK;

    if (Copy_u8Int == EXTI_INT0)
        Local_u8Mask = (uint8)(1u << INTERRUPT_INT0_BIT);
    else if (Copy_u8Int == EXTI_INT1)
        Local_u8Mask = (uint8)(1u << INTERRUPT_INT1_BIT);
    else
        Local_u8Mask = (uint8)(1u << INTERRUPT_INT2_BIT);

    INTERRUPT_GIFR = Local_u8Mask;
    INTERRUPT_GICR |= Local_u8Mask;
    return E_OK;
}

STD_ReturnType EXTI_Disable(uint8 Copy_u8Int)
{
    uint8 Local_u8Mask;

    if (Copy_u8Int > EXTI_INT2)
        return E_NOK;

    if (Copy_u8Int == EXTI_INT0)
        Local_u8Mask = (uint8)(1u << INTERRUPT_INT0_BIT);
    else if (Copy_u8Int == EXTI_INT1)
        Local_u8Mask = (uint8)(1u << INTERRUPT_INT1_BIT);
    else
        Local_u8Mask = (uint8)(1u << INTERRUPT_INT2_BIT);

    INTERRUPT_GICR &= (uint8)~Local_u8Mask;
    return E_OK;
}

STD_ReturnType EXTI_SetCallback(uint8 Copy_u8Int, EXTI_CallbackType Copy_pfCallback)
{
    if ((Copy_u8Int > EXTI_INT2) || (Copy_pfCallback == NULL))
        return E_NOK;

    EXTI_Callbacks[Copy_u8Int] = Copy_pfCallback;
    return E_OK;
}

/*
 * Application reminder (do not write this ISR here unless the lab asks):
 *   #include <avr/interrupt.h>
 *   ISR(INT0_vect) { set a volatile flag; do not call _delay_ms(); }
 */
