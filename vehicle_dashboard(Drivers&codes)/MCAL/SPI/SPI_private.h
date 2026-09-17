#ifndef SPI_PRIVATE_H
#define SPI_PRIVATE_H

/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — SPI private layer (ATmega32)
 * Include this file ONLY from SPI.c.
 *
 * What you must add here:
 * 1. Registers:
 *      SPCR  0x2D    SPIE SPE DORD MSTR CPOL CPHA SPR1 SPR0
 *      SPSR  0x2E    SPIF WCOL – – – – – SPI2X
 *      SPDR  0x2F    data — writing it starts the 8 clocks in master mode
 *
 * 2. Bit names:
 *      SPE=6, DORD=5, MSTR=4, SPR1=1, SPR0=0 in SPCR
 *      SPIF=7 in SPSR  (cleared by reading SPSR then accessing SPDR)
 *
 * 3. Pin roles on Port B (you may call GPIO from SPI.c, or set DDRB here):
 *      PB4 74HC165 SH/LD control: output HIGH when idle
 *      PB5 MOSI  master: output
 *      PB6 MISO  master: input
 *      PB7 SCK   master: output
 *
 * 4. Keep SS as an output in master mode. If it is an input and goes LOW,
 *    the hardware forces slave mode.
 *
 * 5. Mode 0: CPOL=0, CPHA=0. Leave SPI2X = 0 unless you add a 2x API.
 */

#define SPI_SPCR (*(volatile uint8 *)0x2D)
#define SPI_SPSR (*(volatile uint8 *)0x2E)
#define SPI_SPDR (*(volatile uint8 *)0x2F)

#define SPI_SPIE  7u
#define SPI_SPE   6u
#define SPI_DORD  5u
#define SPI_MSTR  4u
#define SPI_CPOL  3u
#define SPI_CPHA  2u
#define SPI_SPR1  1u
#define SPI_SPR0  0u
#define SPI_SPIF  7u
#define SPI_SPI2X 0u

#endif /* SPI_PRIVATE_H */
