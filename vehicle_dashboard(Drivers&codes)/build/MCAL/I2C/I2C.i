# 0 "MCAL/I2C/I2C.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "MCAL/I2C/I2C.c"
# 12 "MCAL/I2C/I2C.c"
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
# 13 "MCAL/I2C/I2C.c" 2
# 1 "MCAL/I2C/I2C_interface.h" 1
# 32 "MCAL/I2C/I2C_interface.h"
STD_ReturnType I2C_InitMaster(uint32 Copy_u32SclHz);




STD_ReturnType I2C_SendStart(void);




STD_ReturnType I2C_SendRepeatedStart(void);




void I2C_SendStop(void);





STD_ReturnType I2C_SendSlaveAddressWithWrite(uint8 Copy_u8Address);
STD_ReturnType I2C_SendSlaveAddressWithRead(uint8 Copy_u8Address);




STD_ReturnType I2C_SendByte(uint8 Copy_u8Data);





STD_ReturnType I2C_ReceiveByte(uint8 *Copy_pu8Data, uint8 Copy_u8SendAck);
# 14 "MCAL/I2C/I2C.c" 2
# 1 "MCAL/I2C/I2C_private.h" 1
# 15 "MCAL/I2C/I2C.c" 2







STD_ReturnType I2C_InitMaster(uint32 Copy_u32SclHz)
{
    uint32 Local_u32Twbr;

    if (Copy_u32SclHz == 0u)
    {
        return E_NOK;
    }

    Local_u32Twbr = ((8000000UL / Copy_u32SclHz) - 16UL) / 2UL;
    if (Local_u32Twbr > 255UL)
    {
        return E_NOK;
    }

    (*(volatile uint8 *)0x20u) = (uint8)Local_u32Twbr;
    (*(volatile uint8 *)0x21u) = 0u;
    (*(volatile uint8 *)0x56u) = (uint8)(1u << 2u);
    return E_OK;
}






STD_ReturnType I2C_SendStart(void)
{
    (*(volatile uint8 *)0x56u) = (uint8)((1u << 7u) | (1u << 5u) | (1u << 2u));
    while (((*(volatile uint8 *)0x56u) & (uint8)(1u << 7u)) == 0u)
    {
    }

    if (((*(volatile uint8 *)0x21u) & 0xF8u) != 0x08u)
    {
        return E_NOK;
    }

    return E_OK;
}





STD_ReturnType I2C_SendRepeatedStart(void)
{
    (*(volatile uint8 *)0x56u) = (uint8)((1u << 7u) | (1u << 5u) | (1u << 2u));
    while (((*(volatile uint8 *)0x56u) & (uint8)(1u << 7u)) == 0u)
    {
    }

    if (((*(volatile uint8 *)0x21u) & 0xF8u) != 0x10u)
    {
        return E_NOK;
    }

    return E_OK;
}





void I2C_SendStop(void)
{
    (*(volatile uint8 *)0x56u) = (uint8)((1u << 7u) | (1u << 4u) | (1u << 2u));
    while (((*(volatile uint8 *)0x56u) & (uint8)(1u << 4u)) != 0u)
    {
    }
}
# 103 "MCAL/I2C/I2C.c"
STD_ReturnType I2C_SendSlaveAddressWithWrite(uint8 Copy_u8Address)
{
    (*(volatile uint8 *)0x23u) = (uint8)((Copy_u8Address << 1u) | 0u);
    (*(volatile uint8 *)0x56u) = (uint8)((1u << 7u) | (1u << 2u));

    while (((*(volatile uint8 *)0x56u) & (uint8)(1u << 7u)) == 0u)
    {
    }

    if (((*(volatile uint8 *)0x21u) & 0xF8u) != 0x18u)
    {
        return E_NOK;
    }

    return E_OK;
}

STD_ReturnType I2C_SendSlaveAddressWithRead(uint8 Copy_u8Address)
{
    (*(volatile uint8 *)0x23u) = (uint8)((Copy_u8Address << 1u) | 1u);
    (*(volatile uint8 *)0x56u) = (uint8)((1u << 7u) | (1u << 2u));

    while (((*(volatile uint8 *)0x56u) & (uint8)(1u << 7u)) == 0u)
    {
    }

    if (((*(volatile uint8 *)0x21u) & 0xF8u) != 0x40u)
    {
        return E_NOK;
    }

    return E_OK;
}





STD_ReturnType I2C_SendByte(uint8 Copy_u8Data)
{
    (*(volatile uint8 *)0x23u) = Copy_u8Data;
    (*(volatile uint8 *)0x56u) = (uint8)((1u << 7u) | (1u << 2u));

    while (((*(volatile uint8 *)0x56u) & (uint8)(1u << 7u)) == 0u)
    {
    }

    if (((*(volatile uint8 *)0x21u) & 0xF8u) != 0x28u)
    {
        return E_NOK;
    }

    return E_OK;
}
# 165 "MCAL/I2C/I2C.c"
STD_ReturnType I2C_ReceiveByte(uint8 *Copy_pu8Data, uint8 Copy_u8SendAck)
{
    uint8 Local_u8ExpectedStatus;

    if (Copy_pu8Data == (uint8 *)0)
    {
        return E_NOK;
    }

    if (Copy_u8SendAck == 1u)
    {
        (*(volatile uint8 *)0x56u) = (uint8)((1u << 7u) | (1u << 6u) | (1u << 2u));
        Local_u8ExpectedStatus = 0x50u;
    }
    else if (Copy_u8SendAck == 0u)
    {
        (*(volatile uint8 *)0x56u) = (uint8)((1u << 7u) | (1u << 2u));
        Local_u8ExpectedStatus = 0x58u;
    }
    else
    {
        return E_NOK;
    }

    while (((*(volatile uint8 *)0x56u) & (uint8)(1u << 7u)) == 0u)
    {
    }

    if (((*(volatile uint8 *)0x21u) & 0xF8u) != Local_u8ExpectedStatus)
    {
        return E_NOK;
    }

    *Copy_pu8Data = (*(volatile uint8 *)0x23u);
    return E_OK;
}
