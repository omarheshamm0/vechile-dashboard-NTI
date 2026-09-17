#ifndef ADC_PRIVATE_H
#define ADC_PRIVATE_H

/*
 * Author: Ahmed Ellamie
 * Email:  ahmed.ellamiee@gmail.com
 *
 * STUDENT TASK — ADC private layer (ATmega32)
 * Include this file ONLY from ADC.c.
 *
 * What you must add here:
 * 1. Register-address macros (I/O space):
 *      ADMUX   0x27    REFS1 REFS0 ADLAR MUX4..MUX0
 *      ADCSRA  0x26    ADEN  ADSC  ADATE ADIF ADIE ADPS2..0
 *      ADCH    0x25
 *      ADCL    0x24    — always read ADCL first, then ADCH
 *
 * 2. Bit-position macros used by ADC.c:
 *      ADMUX  : REFS1=7, REFS0=6, ADLAR=5
 *      ADCSRA : ADEN=7, ADSC=6, ADATE=5, ADIF=4, ADIE=3, ADPS2=2, ADPS1=1, ADPS0=0
 *
 * 3. A helper that builds ADMUX from reference + channel without touching
 *    the rest of the chip, for example:
 *      ADMUX = (ref << 6) | (channel & 0x1F)
 *
 * 4. Keep channel range 0..7 and reject anything else in ADC.c.
 */

#define ADC_ADMUX (*(volatile uint8 *)0x27)
#define ADC_ADCSRA (*(volatile uint8 *)0x26)
#define ADC_ADCH (*(volatile uint8 *)0x25)
#define ADC_ADCL (*(volatile uint8 *)0x24)

#define ADC_REFS1_BIT 7u
#define ADC_REFS0_BIT 6u
#define ADC_ADLAR_BIT 5u
#define ADC_MUX4_BIT 4u
#define ADC_MUX3_BIT 3u
#define ADC_MUX2_BIT 2u
#define ADC_MUX1_BIT 1u
#define ADC_MUX0_BIT 0u

#define ADC_ADEN_BIT 7u
#define ADC_ADSC_BIT 6u
#define ADC_ADATE_BIT 5u
#define ADC_ADIF_BIT 4u
#define ADC_ADIE_BIT 3u
#define ADC_ADPS2_BIT 2u
#define ADC_ADPS1_BIT 1u
#define ADC_ADPS0_BIT 0u

#define ADC_REFS_MASK 0xC0u
#define ADC_MUX_MASK 0x1Fu
#define ADC_ADPS_MASK 0x07u
#define ADC_ADCHOFFSET 8u

#endif /* ADC_PRIVATE_H */
