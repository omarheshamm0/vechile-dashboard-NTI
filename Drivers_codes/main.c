#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <stdio.h>

#include "STD_TYPES.h"
#include "dashboard_types.h"
#include "GPIO_interface.h"
#include "TIMER_interface.h"
#include "UART_interface.h"
#include "SPI_interface.h"
#include "INTERRUPT_interface.h"

#include "bodysw.h"
#include "lamps595.h"
#include "lcd_i2c.h"
#include "gauges.h"
#include "chime.h"
#include "speedo.h"
#include "tacho.h"
#include "warnings.h"
#include "odometer.h"
#include "cluster.h"
#include "console.h"
#include"ADC_interface.h"

#define F_CPU 8000000UL
#define APP_TICK_MS     10u
#define APP_100MS_TICKS 10u
#define APP_250MS_TICKS 25u
#define APP_500MS_TICKS 50u
#define APP_1S_TICKS    100u
#define F_CPU 8000000UL

const char* PatternNames[] = {
    "Chime: OFF      ",
    "Chime: OVERSPEED",
    "Chime: LIMP_HOME",
    "Chime: TURN_TICK"
};
int main(void) {



    GPIO_SetPinDirection(GPIO_PORTA, GPIO_PIN0, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTA, GPIO_PIN1, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTA, GPIO_PIN2, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTA, GPIO_PIN3, GPIO_INPUT);

    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN0, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN1, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN2, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN3, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN4, GPIO_OUTPUT);
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN5, GPIO_OUTPUT);
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN6, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN7, GPIO_OUTPUT);

    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN0,GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN1, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN2, GPIO_OUTPUT);
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN3, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN4, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN5, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN6, GPIO_OUTPUT);
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN7, GPIO_OUTPUT);

    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN0, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN1, GPIO_OUTPUT);
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN2, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN3, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN4, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN5, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN6, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN7, GPIO_OUTPUT);

    GPIO_SetPinValue(GPIO_PORTB, GPIO_PIN4, GPIO_HIGH);
    GPIO_SetPinValue(GPIO_PORTC, GPIO_PIN2, GPIO_LOW);
    GPIO_SetPinValue(GPIO_PORTC, GPIO_PIN6, GPIO_LOW);
    GPIO_SetPinValue(GPIO_PORTC, GPIO_PIN7, GPIO_LOW);
    GPIO_SetPinValue(GPIO_PORTD, GPIO_PIN7, GPIO_LOW);





    char line1[17];
    char line2[17];
    CarData_t myCar = {0};

    /* تهيئة الشاشة والـ ADC */
    LCD_Init();
    GAU_Init();
    TIMER0_DelayMS(100);
   
    // LCD_Init();
    CHM_Init(); /* تهيئة البازر والتايمر 2 */

    uint8 last_btn_state = GPIO_HIGH;
    ChimePattern_t test_pattern = CHM_PATTERN_OFF;
    while (1) {
        /* ========================================================== */
        uint8 current_btn_state ;
         GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN5,&current_btn_state);
        
        /* فحص ضغطة الزرار (Falling Edge) */
        if (last_btn_state == GPIO_HIGH && current_btn_state == GPIO_LOW) {
            /* قلب للحالة اللي بعدها */
            test_pattern++;
            if (test_pattern > CHM_PATTERN_TURN_TICK) {
                test_pattern = CHM_PATTERN_OFF;
            }
            
            /* شغل النغمة الجديدة */
            CHM_Play(test_pattern);
        }
        last_btn_state = current_btn_state;

        /* ==========================================================
         * 2. تحديث حالة البازر (دي الدالة اللي بتعد الـ 100ms)
         * ========================================================== */
        CHM_Update();

        /* ==========================================================
         * 3. طباعة النغمة الحالية على الشاشة
         * ========================================================== */
        LCD_SetCursor(0, 0);
        LCD_WriteString((const uint8*)PatternNames[test_pattern]);

        /* ==========================================================
         * 4.หน Delay 100ms (أساسي عشان CHM_Update تشتغل صح)
         * ========================================================== */
        TIMER0_DelayMS(100); 
    }
    
        
        /* 2. شغل دالة التحذيرات عشان تحسب وتفلتر وتعمل Latching */
}





