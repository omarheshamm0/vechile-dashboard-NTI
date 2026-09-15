#ifndef I2C_PRIVATE_H
#define I2C_PRIVATE_H

/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — I2C / TWI private layer (ATmega32)
 * Include this file ONLY from I2C.c.
 *
 * What you must add here:
 * 1. Registers:
 *      TWBR  0x20    bit rate
 *      TWSR  0x21    TWS7..TWS3 are status; TWPS1:0 are the prescaler
 *      TWAR  0x22    own slave address (not needed for master-only labs)
 *      TWDR  0x23    address / data
 *      TWCR  0x56    TWINT TWEA TWSTA TWSTO TWWC TWEN – TWIE
 *
 * 2. Bit names in TWCR:
 *      TWINT=7  write 1 to start the next action, poll until hardware sets it
 *      TWEA=6   ACK enable when receiving
 *      TWSTA=5  START
 *      TWSTO=4  STOP
 *      TWEN=2   TWI enable
 *
 * 3. Status mask: (TWSR & 0xF8)  — never compare the raw TWSR (prescaler bits).
 *
 * 4. Every master step is the same pattern:
 *      TWCR = (1<<TWINT) | (1<<TWEN) | extra bits (TWSTA / TWSTO / TWEA)
 *      while (TWINT == 0) ;
 *      if ((TWSR & 0xF8) != expected) return E_NOK;
 *
 * 5. Address byte: (Copy_u8Address << 1) | 0  for write
 *                  (Copy_u8Address << 1) | 1  for read
 *
 * 6. SCL formula (TWPS = 00):
 *      TWBR = ((F_CPU / SCL) - 16) / 2
 *      8 MHz, 100 kHz -> TWBR = 32
 */

#define TWBR  (*(volatile uint8 *)0x20u)
#define TWSR  (*(volatile uint8 *)0x21u)
#define TWAR  (*(volatile uint8 *)0x22u)
#define TWDR  (*(volatile uint8 *)0x23u)
#define TWCR  (*(volatile uint8 *)0x56u)

#define TWINT  7u
#define TWEA   6u
#define TWSTA  5u
#define TWSTO  4u
#define TWWC   3u
#define TWEN   2u
#define TWIE   0u

#define TWPS0  0u
#define TWPS1  1u
#define TWS3   3u
#define TWS4   4u
#define TWS5   5u
#define TWS6   6u
#define TWS7   7u

#endif /* I2C_PRIVATE_H */
