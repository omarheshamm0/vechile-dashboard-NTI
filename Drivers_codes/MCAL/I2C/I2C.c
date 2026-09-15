/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — I2C.c  (ATmega32 TWI master)
 * Implement every prototype from I2C_interface.h.
 */

#include "STD_TYPES.h"
#include "I2C_interface.h"
#include "I2C_private.h"

/*
 * I2C_InitMaster
 * 1. Reject SCL == 0.
 * 2. TWBR = ((F_CPU / Copy_u32SclHz) - 16) / 2.  TWSR prescaler bits = 00.
 * 3. TWCR = (1 << TWEN). Do not send START here.
 */
STD_ReturnType I2C_InitMaster(uint32 Copy_u32SclHz)
{
    uint32 Local_u32Twbr;

    if (Copy_u32SclHz == 0u)
    {
        return E_NOK;
    }

    Local_u32Twbr = ((F_CPU / Copy_u32SclHz) - 16UL) / 2UL;
    if (Local_u32Twbr > 255UL)
    {
        return E_NOK;
    }

    TWBR = (uint8)Local_u32Twbr;
    TWSR = 0u;
    TWCR = (uint8)(1u << TWEN);
    return E_OK;
}

/*
 * I2C_SendStart
 * 1. TWCR = TWINT | TWSTA | TWEN.
 * 2. Wait for TWINT. Return E_OK only if status == I2C_START_ACK.
 */
STD_ReturnType I2C_SendStart(void)
{
    TWCR = (uint8)((1u << TWINT) | (1u << TWSTA) | (1u << TWEN));
    while ((TWCR & (uint8)(1u << TWINT)) == 0u)
    {
    }

    if ((TWSR & 0xF8u) != I2C_START_ACK)
    {
        return E_NOK;
    }

    return E_OK;
}

/*
 * I2C_SendRepeatedStart
 * 1. Same as START, but expect I2C_REP_START_ACK (0x10).
 */
STD_ReturnType I2C_SendRepeatedStart(void)
{
    TWCR = (uint8)((1u << TWINT) | (1u << TWSTA) | (1u << TWEN));
    while ((TWCR & (uint8)(1u << TWINT)) == 0u)
    {
    }

    if ((TWSR & 0xF8u) != I2C_REP_START_ACK)
    {
        return E_NOK;
    }

    return E_OK;
}

/*
 * I2C_SendStop
 * 1. TWCR = TWINT | TWSTO | TWEN. No status check.
 */
void I2C_SendStop(void)
{
    TWCR = (uint8)((1u << TWINT) | (1u << TWSTO) | (1u << TWEN));
    while ((TWCR & (uint8)(1u << TWSTO)) != 0u)
    {
    }
}

/*
 * I2C_SendSlaveAddressWithWrite
 * 1. TWDR = (Copy_u8Address << 1) | 0.
 * 2. TWCR = TWINT | TWEN. Expect I2C_SLA_W_ACK (0x18).
 *
 * I2C_SendSlaveAddressWithRead
 * 1. TWDR = (Copy_u8Address << 1) | 1.
 * 2. Expect I2C_SLA_R_ACK (0x40).
 */
STD_ReturnType I2C_SendSlaveAddressWithWrite(uint8 Copy_u8Address)
{
    TWDR = (uint8)((Copy_u8Address << 1u) | 0u);
    TWCR = (uint8)((1u << TWINT) | (1u << TWEN));

    while ((TWCR & (uint8)(1u << TWINT)) == 0u)
    {
    }

    if ((TWSR & 0xF8u) != I2C_SLA_W_ACK)
    {
        return E_NOK;
    }

    return E_OK;
}

STD_ReturnType I2C_SendSlaveAddressWithRead(uint8 Copy_u8Address)
{
    TWDR = (uint8)((Copy_u8Address << 1u) | 1u);
    TWCR = (uint8)((1u << TWINT) | (1u << TWEN));

    while ((TWCR & (uint8)(1u << TWINT)) == 0u)
    {
    }

    if ((TWSR & 0xF8u) != I2C_SLA_R_ACK)
    {
        return E_NOK;
    }

    return E_OK;
}

/*
 * I2C_SendByte
 * 1. TWDR = Copy_u8Data. TWCR = TWINT | TWEN. Expect I2C_DATA_TX_ACK (0x28).
 */
STD_ReturnType I2C_SendByte(uint8 Copy_u8Data)
{
    TWDR = Copy_u8Data;
    TWCR = (uint8)((1u << TWINT) | (1u << TWEN));

    while ((TWCR & (uint8)(1u << TWINT)) == 0u)
    {
    }

    if ((TWSR & 0xF8u) != I2C_DATA_TX_ACK)
    {
        return E_NOK;
    }

    return E_OK;
}

/*
 * I2C_ReceiveByte
 * 1. Reject a NULL pointer.
 * 2. If Copy_u8SendAck == I2C_ACK: TWCR = TWINT | TWEA | TWEN, expect 0x50.
 *    If I2C_NACK:                 TWCR = TWINT | TWEN,        expect 0x58.
 * 3. *Copy_pu8Data = TWDR.
 */
STD_ReturnType I2C_ReceiveByte(uint8 *Copy_pu8Data, uint8 Copy_u8SendAck)
{
    uint8 Local_u8ExpectedStatus;

    if (Copy_pu8Data == (uint8 *)0)
    {
        return E_NOK;
    }

    if (Copy_u8SendAck == I2C_ACK)
    {
        TWCR = (uint8)((1u << TWINT) | (1u << TWEA) | (1u << TWEN));
        Local_u8ExpectedStatus = I2C_DATA_RX_ACK;
    }
    else if (Copy_u8SendAck == I2C_NACK)
    {
        TWCR = (uint8)((1u << TWINT) | (1u << TWEN));
        Local_u8ExpectedStatus = I2C_DATA_RX_NACK;
    }
    else
    {
        return E_NOK;
    }

    while ((TWCR & (uint8)(1u << TWINT)) == 0u)
    {
    }

    if ((TWSR & 0xF8u) != Local_u8ExpectedStatus)
    {
        return E_NOK;
    }

    *Copy_pu8Data = TWDR;
    return E_OK;
}

/*
 * Typical 24Cxx write: START -> SLA+W -> word address -> data -> STOP
 * Typical 24Cxx read : START -> SLA+W -> word address -> REP START -> SLA+R -> data+NACK -> STOP
 */
