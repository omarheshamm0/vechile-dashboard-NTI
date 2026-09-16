#include <avr/io.h>
#include <stddef.h>

#include "LIB/STD_TYPES.h"
#include "LIB/dashboard_types.h"
#include "HAL/SPEEDO/speedo.h"

void SPD_Init(void)
{
    /* Set PD5 (T1) as Input with Pull-up */
    DDRD &= ~(1 << PD5);
    PORTD |= (1 << PD5);

    /* Timer1 Normal Mode, External Clock on T1 Pin (Rising Edge) */
    TCCR1A = 0x00;
    TCCR1B = (1 << CS12) | (1 << CS11) | (1 << CS10);

    /* Clear Timer1 Hardware Counter */
    TCNT1 = 0;
}

void SPD_Task100ms(CarData_t *pData, const DashCfg_t *pCfg)
{
    if ((pData == NULL) || (pCfg == NULL) || (pCfg->pulsesPerRev == 0))
    {
        return;
    }

    /* Read accumulated pulse count directly from Timer1 Hardware Register */
    uint16_t pulses = TCNT1;
    TCNT1 = 0; /* Clear counter for next window */

    /* 
     * Speed Math (64-bit to prevent 32-bit overflow):
     * Speed (km/h) = (pulses * 10 * 3600 * wheelCircMm) / (pulsesPerRev * 1,000,000)
     */
    uint64_t num = (uint64_t)pulses * 36000ULL * (uint64_t)pCfg->wheelCircMm;
    uint64_t den = (uint64_t)pCfg->pulsesPerRev * 1000000ULL;

    pData->speedKmh = (uint16_t)(num / den);
}