/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — TIMER.c  (ATmega32 Timer0 + Timer1, F_CPU = 8 MHz)
 * Implement every prototype from TIMER_interface.h.
 *
 * Rules for this file:
 *   - The application only ever sees what TIMER_interface.h declares.
 *   - Anything only this file needs is static, so no other .c can reach it.
 *   - Register names and bit numbers come from TIMER_private.h. Fill that in
 *     first, or nothing here will compile.
 *
 * Numbers you will need, all at 8 MHz:
 *   prescaler 64 -> 1 tick = 8 us      prescaler 8 -> 1 tick = 1 us
 *   A flag in TIFR is cleared by writing 1 to it, not 0.
 */

#include "STD_TYPES.h"
#include "MATH.h"
#include "GPIO_interface.h"
#include "TIMER_interface.h"
#include "TIMER_private.h"

/*==================================================================
 *  Local helpers — static, used only inside TIMER.c
 *==================================================================*/

/*
 * TIMER_WaitFlag
 * 1. Sit in an empty while loop until the bit Copy_u8BitMask is set in the
 *    register Copy_pu8Register (that register is TIFR).
 * 2. Clear the flag by writing 1 to that bit, so the next period starts clean.
 * 3. Both delay functions call this, which is the whole reason it exists —
 *    the wait-then-clear pattern is written once and cannot drift apart.
 */
static void TIMER_WaitFlag(volatile uint8 *Copy_pu8Register, uint8 Copy_u8BitMask);

/*
 * TIMER_DutyToCompare
 * 1. Turn a 0..100 percent into a compare value: (Top + 1) * percent / 100.
 * 2. Do the multiply in uint32. Timer1 can reach 20000 * 100 = 2,000,000,
 *    which overflows uint16 long before the divide happens.
 * 3. Return the result; the caller writes it to OCR0 or OCR1A.
 */
static uint16 TIMER_DutyToCompare(uint16 Copy_u16Top, uint8 Copy_u8DutyPercent);

/*==================================================================
 *  Timer0 — 8-bit
 *==================================================================*/

/* Configure Timer0 for a stopped 1 ms CTC time base. */
STD_ReturnType TIMER0_Init(void)
{
    CLR_BIT(TIMER0_REG_TCCR0, TIMER0_WGM00);
    SET_BIT(TIMER0_REG_TCCR0, TIMER0_WGM01);
    TIMER0_REG_OCR0 = 124u;
    TIMER0_REG_TCNT0 = 0u;
    TIMER0_REG_TCCR0 &= (uint8) ~((1u << TIMER0_CS02) | (1u << TIMER0_CS01) | (1u << TIMER0_CS00));
    return E_OK;
}

/* Wait for the requested number of Timer0 milliseconds, then stop Timer0. */
STD_ReturnType TIMER0_DelayMS(uint16 Copy_u16Milliseconds)
{
    TIFR_REG = (uint8)(1u << TIMER0_OCF0);
    TIMER0_REG_TCCR0 = (uint8)((TIMER0_REG_TCCR0 & (uint8)~0x07u) | (1u << TIMER0_CS01) | (1u << TIMER0_CS00));

    while (Copy_u16Milliseconds-- > 0u)
        TIMER_WaitFlag(&TIFR_REG, (uint8)(1u << TIMER0_OCF0));

    TIMER0_REG_TCCR0 &= (uint8)~0x07u;
    return E_OK;
}

/* Express seconds as separate 1000 ms waits so the uint16 millisecond count cannot wrap. */
STD_ReturnType TIMER0_DelayS(uint16 Copy_u16Seconds)
{
    while (Copy_u16Seconds-- > 0u)
        TIMER0_DelayMS(1000u);

    return E_OK;
}

/* Configure OC0 for non-inverting Fast PWM at approximately 488 Hz. */
STD_ReturnType TIMER0_PWM(uint8 Copy_u8DutyPercent)
{
    if (Copy_u8DutyPercent > 100u)
        return E_NOK;

    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN3, GPIO_OUTPUT);
    SET_BIT(TIMER0_REG_TCCR0, TIMER0_WGM00);
    SET_BIT(TIMER0_REG_TCCR0, TIMER0_WGM01);
    SET_BIT(TIMER0_REG_TCCR0, TIMER0_COM01);
    CLR_BIT(TIMER0_REG_TCCR0, TIMER0_COM00);
    TIMER0_REG_OCR0 = (uint8)TIMER_DutyToCompare(255u, Copy_u8DutyPercent);
    TIMER0_REG_TCCR0 = (uint8)((TIMER0_REG_TCCR0 & (uint8)~0x07u) | (1u << TIMER0_CS02) | (1u << TIMER0_CS01));
    return E_OK;
}

/* Stop Timer0 and disconnect its compare output from OC0. */
STD_ReturnType TIMER0_Stop(void)
{
    TIMER0_REG_TCCR0 &= (uint8) ~((1u << TIMER0_CS02) | (1u << TIMER0_CS01) | (1u << TIMER0_CS00));
    TIMER0_REG_TCCR0 &= (uint8) ~((1u << TIMER0_COM01) | (1u << TIMER0_COM00));
    return E_OK;
}

/*==================================================================
 *  Timer1 — 16-bit
 *==================================================================*/

/* Configure Timer1 for a stopped 1 ms CTC time base. */
STD_ReturnType TIMER1_Init(void)
{
    TIMER1_REG_TCCR1A &= (uint8) ~((1u << TIMER1_WGM11) | (1u << TIMER1_WGM10));
    CLR_BIT(TIMER1_REG_TCCR1B, TIMER1_WGM13);
    SET_BIT(TIMER1_REG_TCCR1B, TIMER1_WGM12);
    TIMER1_REG_OCR1A = 999u;
    TIMER1_REG_TCNT1 = 0u;
    TIMER1_REG_TCCR1B &= (uint8) ~((1u << TIMER1_CS12) | (1u << TIMER1_CS11) | (1u << TIMER1_CS10));
    return E_OK;
}

/* Wait for the requested number of Timer1 milliseconds, then stop Timer1. */
STD_ReturnType TIMER1_DelayMS(uint16 Copy_u16Milliseconds)
{
    TIFR_REG = (uint8)(1u << TIMER1_OCF1A);
    TIMER1_REG_TCCR1B = (uint8)((TIMER1_REG_TCCR1B & (uint8)~0x07u) | (1u << TIMER1_CS11));

    while (Copy_u16Milliseconds-- > 0u)
        TIMER_WaitFlag(&TIFR_REG, (uint8)(1u << TIMER1_OCF1A));

    TIMER1_REG_TCCR1B &= (uint8)~0x07u;
    return E_OK;
}

/* Configure OC1A for non-inverting Fast PWM with a caller-selected frequency. */
STD_ReturnType TIMER1_PWM(uint16 Copy_u16FrequencyHz, uint8 Copy_u8DutyPercent)
{
    if ((Copy_u16FrequencyHz < 16u) || (Copy_u16FrequencyHz > 20000u) ||
        (Copy_u8DutyPercent > 100u))
        return E_NOK;

    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN5, GPIO_OUTPUT);
    SET_BIT(TIMER1_REG_TCCR1A, TIMER1_WGM11);
    CLR_BIT(TIMER1_REG_TCCR1A, TIMER1_WGM10);
    SET_BIT(TIMER1_REG_TCCR1B, TIMER1_WGM13);
    SET_BIT(TIMER1_REG_TCCR1B, TIMER1_WGM12);
    SET_BIT(TIMER1_REG_TCCR1A, TIMER1_COM1A1);
    CLR_BIT(TIMER1_REG_TCCR1A, TIMER1_COM1A0);
    TIMER1_REG_ICR1 = (uint16)((1000000UL / Copy_u16FrequencyHz) - 1UL);
    TIMER1_REG_OCR1A = TIMER_DutyToCompare(TIMER1_REG_ICR1, Copy_u8DutyPercent);
    TIMER1_REG_TCCR1B = (uint8)((TIMER1_REG_TCCR1B & (uint8)~0x07u) | (1u << TIMER1_CS11));
    return E_OK;
}

/* Stop Timer1 and disconnect its compare output from OC1A. */
STD_ReturnType TIMER1_Stop(void)
{
    TIMER1_REG_TCCR1B &= (uint8) ~((1u << TIMER1_CS12) | (1u << TIMER1_CS11) | (1u << TIMER1_CS10));
    TIMER1_REG_TCCR1A &= (uint8) ~((1u << TIMER1_COM1A1) | (1u << TIMER1_COM1A0));
    return E_OK;
}

/*==================================================================
 *  Local helper bodies
 *==================================================================*/

static void TIMER_WaitFlag(volatile uint8 *Copy_pu8Register, uint8 Copy_u8BitMask)
{
    while ((*Copy_pu8Register & Copy_u8BitMask) == 0u)
    {
    }

    *Copy_pu8Register = Copy_u8BitMask;
}

static uint16 TIMER_DutyToCompare(uint16 Copy_u16Top, uint8 Copy_u8DutyPercent)
{
    return (uint16)((((uint32)Copy_u16Top + 1UL) * Copy_u8DutyPercent) / 100UL);
}
