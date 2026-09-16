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
   
    FSM_Init(&myCar);

    uint8 last_key_state = GPIO_HIGH; // حالة زرار الكونتاكت السابقة
    uint16 key_hold_counter = 0;
    const char* StateNames[] = {
    "State: OFF      ", 
    "State: ACC      ", 
    "State: BULBCHK  ", 
    "State: IGNITION ",
    "State: CRANKING ", 
    "State: RUNNING  ", 
    "State: STALLED  ", 
    "State: LIMP_HOME"
};
   
    while (1) {
        /* تحديث الحساسات وقراءتها من الـ ADC مع الفلترة */
        /*GAU_Update(&myCar);

        /* عرض النتائج على الشاشة للتأكد من التحويل والـ Scaling */
       // snprintf(line1, sizeof(line1), "F:%3d%% C:%3dC", myCar.fuelPct, myCar.coolantC);
        //snprintf(line2, sizeof(line2), "Bat:%uV Oil:%u", myCar.battmV, myCar.oilBarX10);

       // DSP_Render(PG_MAIN, (const uint8*)line1, (const uint8*)line2);

       // TIMER0_DelayMS(500); /* تحديث كل نص ثانية */
        //LCD_Clear();
        
        // قراءة زرار الكونتاكت (PD3) وزرار التشغيل (PD4) - Active Low
        uint8 current_key_state ;
         GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN3,&current_key_state);
        uint8 start_btn_state ; 
        GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN4,&start_btn_state);
        
        uint8 keyPress = 0;
        uint8 keyHeld = 0;
        uint8 startBtn = (start_btn_state == GPIO_LOW) ? 1 : 0;

        /* فحص ضغطة الكونتاكت (Falling Edge) */
        if (last_key_state == GPIO_HIGH && current_key_state == GPIO_LOW) {
            keyPress = 1;
        }
        
        /* فحص الضغطة المطولة للكونتاكت (لعمل الإطفاء الإجباري) */
        if (current_key_state == GPIO_LOW) {
            key_hold_counter++;
            if (key_hold_counter >= 200) { // 200 * 10ms = 2 ثانية
                keyHeld = 1; 
            }
        } else {
            key_hold_counter = 0;
        }
        last_key_state = current_key_state;

        /* ==========================================================
         * 2. محاكاة الـ RPM (عشان الموتور يشتغل)
         * ========================================================== */
        // لو بندوس Start، ارفع الـ RPM وهمياً عشان السيستم يحس إن الموتور قام
        if (myCar.state == CS_CRANKING && startBtn) {
            myCar.rpm = 800; 
        } 
        // لو شيلنا إيدنا والموتور كان شغال، سيبه 800 عشان مايقعش في الـ Stall
        else if (myCar.state == CS_RUNNING) {
            myCar.rpm = 800;
        }
        else {
            myCar.rpm = 0;
        }

        /* ==========================================================
         * 3. تشغيل الـ State Machine
         * ========================================================== */
        FSM_Run(&myCar, keyPress, keyHeld, startBtn);

        /* ==========================================================
         * 4. طباعة الحالة الحالية على الـ LCD
         * ========================================================== */
        LCD_SetCursor(0, 0);
        LCD_WriteString((const uint8*)StateNames[myCar.state]);

        /* ==========================================================
         * 5. قلب التايمر (Delay 10ms) - ده أهم سطر لضبط الوقت!
         * ========================================================== */
        TIMER0_DelayMS(10); 
    }

    /* 1. اقرأ الحساسات وحدث القيم */
    
        
        /* 2. شغل دالة التحذيرات عشان تحسب وتفلتر وتعمل Latching */
}





