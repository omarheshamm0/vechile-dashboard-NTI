#ifndef SPI_INTERFACE_H
#define SPI_INTERFACE_H

/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * MCAL SPI — public API for the ATmega32 SPI (mode 0, MSB first).
 * Include this header from HAL, Logic, and main. Do not include SPI_private.h there.
 *
 * Master pins: PB4=74HC165 SH/LD, MOSI=PB5, MISO=PB6, SCK=PB7.
 */

#include "STD_TYPES.h"

/* ---------------- Clock rate (SPCR SPR1:0, SPSR SPI2X = 0) ---------------- */
#define SPI_PRESC_4           0u
#define SPI_PRESC_16          1u
#define SPI_PRESC_64          2u
#define SPI_PRESC_128         3u

/* ---------------- Data order ---------------- */
#define SPI_MSB_FIRST         0u
#define SPI_LSB_FIRST         1u

/*
 * Description : Set PB4/PB5/PB7 as outputs and PB6 as input, then enable SPI
 *               as master, mode 0 (CPOL=0, CPHA=0), at Copy_u8Prescaler.
 */
STD_ReturnType SPI_InitMaster(uint8 Copy_u8Prescaler);

/*
 * Description : Enable SPI as slave. MISO is an output; MOSI, SCK, SS are inputs.
 */
STD_ReturnType SPI_InitSlave(void);

/*
 * Description : Write Copy_u8Sent to SPDR, wait for SPIF, then store SPDR
 *               in *Copy_pu8Received (the byte the other side shifted in).
 */
STD_ReturnType SPI_Transceive(uint8 Copy_u8Sent, uint8 *Copy_pu8Received);

/*
 * Description : Write one byte and wait for completion without exposing a
 *               received byte. Use this for output-only devices such as 74HC595.
 */
STD_ReturnType SPI_TransmitByte(uint8 Copy_u8Sent);

/*
 * Description : Acquire the shared SPI bus for one logical user.
 *               Return E_NOK when another transaction owns the bus.
 */
STD_ReturnType SPI_Acquire(uint8 Copy_u8Owner);

/*
 * Description : Release the shared SPI bus and leave it idle.
 */
void SPI_Release(void);

#define SPI_BUS_FREE 0xFFu

#endif /* SPI_INTERFACE_H */
