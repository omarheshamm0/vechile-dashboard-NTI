/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — GPIO.c  (ATmega32)
 * Implement every prototype from GPIO_interface.h. Return E_NOK on bad arguments.
 */

#include "STD_TYPES.h"
#include "GPIO_interface.h"
#include "GPIO_private.h"

/*
 * GPIO_SetPinDirection
 * 1. Reject Port > GPIO_PORTD or Pin > GPIO_PIN7.
 * 2. INPUT        : clear DDRx bit, clear PORTx bit (Hi-Z).
 * 3. OUTPUT       : set DDRx bit.
 * 4. INPUT_PULLUP : clear DDRx bit, set PORTx bit.
 * 5. Switch on Copy_u8Port and touch only that port's DDR/PORT.
 */
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction)
{
    uint8 Local_u8Mask;

    if ((Copy_u8Port > GPIO_MAX_PORT) || (Copy_u8Pin > GPIO_MAX_PIN) ||
        (Copy_u8Direction > GPIO_INPUT_PULLUP))
    {
        return E_NOK;
    }

    Local_u8Mask = GPIO_PIN_MASK(Copy_u8Pin);

    switch (Copy_u8Port)
    {
    case GPIO_PORTA:
        if (Copy_u8Direction == GPIO_OUTPUT)
            GPIO_DDRA |= Local_u8Mask;
        else
            GPIO_DDRA &= (uint8)~Local_u8Mask;
        if (Copy_u8Direction == GPIO_INPUT_PULLUP)
            GPIO_PORTA_REG |= Local_u8Mask;
        else if (Copy_u8Direction == GPIO_INPUT)
            GPIO_PORTA_REG &= (uint8)~Local_u8Mask;
        break;
    case GPIO_PORTB:
        if (Copy_u8Direction == GPIO_OUTPUT)
            GPIO_DDRB |= Local_u8Mask;
        else
            GPIO_DDRB &= (uint8)~Local_u8Mask;
        if (Copy_u8Direction == GPIO_INPUT_PULLUP)
            GPIO_PORTB_REG |= Local_u8Mask;
        else if (Copy_u8Direction == GPIO_INPUT)
            GPIO_PORTB_REG &= (uint8)~Local_u8Mask;
        break;
    case GPIO_PORTC:
        if (Copy_u8Direction == GPIO_OUTPUT)
            GPIO_DDRC |= Local_u8Mask;
        else
            GPIO_DDRC &= (uint8)~Local_u8Mask;
        if (Copy_u8Direction == GPIO_INPUT_PULLUP)
            GPIO_PORTC_REG |= Local_u8Mask;
        else if (Copy_u8Direction == GPIO_INPUT)
            GPIO_PORTC_REG &= (uint8)~Local_u8Mask;
        break;
    case GPIO_PORTD:
        if (Copy_u8Direction == GPIO_OUTPUT)
            GPIO_DDRD |= Local_u8Mask;
        else
            GPIO_DDRD &= (uint8)~Local_u8Mask;
        if (Copy_u8Direction == GPIO_INPUT_PULLUP)
            GPIO_PORTD_REG |= Local_u8Mask;
        else if (Copy_u8Direction == GPIO_INPUT)
            GPIO_PORTD_REG &= (uint8)~Local_u8Mask;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}

/*
 * GPIO_SetPinValue
 * 1. Validate port and pin.
 * 2. GPIO_HIGH -> set PORTx bit.  GPIO_LOW -> clear PORTx bit.
 */
STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value)
{
    uint8 Local_u8Mask;

    if ((Copy_u8Port > GPIO_MAX_PORT) || (Copy_u8Pin > GPIO_MAX_PIN) || (Copy_u8Value > GPIO_HIGH))
    {
        return E_NOK;
    }

    Local_u8Mask = GPIO_PIN_MASK(Copy_u8Pin);

    switch (Copy_u8Port)
    {
    case GPIO_PORTA:
        if (Copy_u8Value == GPIO_HIGH)
            GPIO_PORTA_REG |= Local_u8Mask;
        else
            GPIO_PORTA_REG &= (uint8)~Local_u8Mask;
        break;
    case GPIO_PORTB:
        if (Copy_u8Value == GPIO_HIGH)
            GPIO_PORTB_REG |= Local_u8Mask;
        else
            GPIO_PORTB_REG &= (uint8)~Local_u8Mask;
        break;
    case GPIO_PORTC:
        if (Copy_u8Value == GPIO_HIGH)
            GPIO_PORTC_REG |= Local_u8Mask;
        else
            GPIO_PORTC_REG &= (uint8)~Local_u8Mask;
        break;
    case GPIO_PORTD:
        if (Copy_u8Value == GPIO_HIGH)
            GPIO_PORTD_REG |= Local_u8Mask;
        else
            GPIO_PORTD_REG &= (uint8)~Local_u8Mask;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}

/*
 * GPIO_GetPinValue
 * 1. Validate port, pin, and that Copy_pu8Value is not NULL.
 * 2. Read PINx bit into *Copy_pu8Value as GPIO_HIGH or GPIO_LOW.
 */
STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value)
{
    uint8 Local_u8Mask;

    if ((Copy_u8Port > GPIO_MAX_PORT) || (Copy_u8Pin > GPIO_MAX_PIN) ||
        (Copy_pu8Value == (uint8 *)0))
    {
        return E_NOK;
    }

    Local_u8Mask = GPIO_PIN_MASK(Copy_u8Pin);

    switch (Copy_u8Port)
    {
    case GPIO_PORTA:
        *Copy_pu8Value = (GPIO_PINA & Local_u8Mask) ? GPIO_HIGH : GPIO_LOW;
        break;
    case GPIO_PORTB:
        *Copy_pu8Value = (GPIO_PINB & Local_u8Mask) ? GPIO_HIGH : GPIO_LOW;
        break;
    case GPIO_PORTC:
        *Copy_pu8Value = (GPIO_PINC & Local_u8Mask) ? GPIO_HIGH : GPIO_LOW;
        break;
    case GPIO_PORTD:
        *Copy_pu8Value = (GPIO_PIND & Local_u8Mask) ? GPIO_HIGH : GPIO_LOW;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}

/*
 * GPIO_TogglePinValue
 * 1. Validate port and pin.
 * 2. Flip the matching PORTx bit (PORTx ^= mask).
 */
STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin)
{
    uint8 Local_u8Mask;

    if ((Copy_u8Port > GPIO_MAX_PORT) || (Copy_u8Pin > GPIO_MAX_PIN))
    {
        return E_NOK;
    }

    Local_u8Mask = GPIO_PIN_MASK(Copy_u8Pin);

    switch (Copy_u8Port)
    {
    case GPIO_PORTA:
        GPIO_PORTA_REG ^= Local_u8Mask;
        break;
    case GPIO_PORTB:
        GPIO_PORTB_REG ^= Local_u8Mask;
        break;
    case GPIO_PORTC:
        GPIO_PORTC_REG ^= Local_u8Mask;
        break;
    case GPIO_PORTD:
        GPIO_PORTD_REG ^= Local_u8Mask;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}

/*
 * GPIO_SetPortDirection
 * 1. Validate port. Direction is GPIO_INPUT or GPIO_OUTPUT.
 * 2. Write 0x00 or 0xFF to that port's DDRx.
 */
STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction)
{
    if ((Copy_u8Port > GPIO_MAX_PORT))
    {
        return E_NOK;
    }

    switch (Copy_u8Port)
    {
    case GPIO_PORTA:
        GPIO_DDRA = Copy_u8Direction;
        break;
    case GPIO_PORTB:
        GPIO_DDRB = Copy_u8Direction;
        break;
    case GPIO_PORTC:
        GPIO_DDRC = Copy_u8Direction;
        break;
    case GPIO_PORTD:
        GPIO_DDRD = Copy_u8Direction;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}

/*
 * GPIO_SetPortValue
 * 1. Validate port.
 * 2. Write Copy_u8Value to PORTx.
 */
STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value)
{
    if (Copy_u8Port > GPIO_MAX_PORT)
    {
        return E_NOK;
    }

    switch (Copy_u8Port)
    {
    case GPIO_PORTA:
        GPIO_PORTA_REG = Copy_u8Value;
        break;
    case GPIO_PORTB:
        GPIO_PORTB_REG = Copy_u8Value;
        break;
    case GPIO_PORTC:
        GPIO_PORTC_REG = Copy_u8Value;
        break;
    case GPIO_PORTD:
        GPIO_PORTD_REG = Copy_u8Value;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}

/*
 * GPIO_GetPortValue
 * 1. Validate port and that Copy_pu8Value is not NULL.
 * 2. Read PINx into *Copy_pu8Value.
 */
STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value)
{
    if ((Copy_u8Port > GPIO_MAX_PORT) || NULL == Copy_pu8Value)
    {
        return E_NOK;
    }

    switch (Copy_u8Port)
    {
    case GPIO_PORTA:
        *Copy_pu8Value = GPIO_PINA;
        break;
    case GPIO_PORTB:
        *Copy_pu8Value = GPIO_PINB;
        break;
    case GPIO_PORTC:
        *Copy_pu8Value = GPIO_PINC;
        break;
    case GPIO_PORTD:
        *Copy_pu8Value = GPIO_PIND;
        break;
    default:
        return E_NOK;
    }

    return E_OK;
}
