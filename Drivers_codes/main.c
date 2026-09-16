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
    _delay_ms(100);

    while (1) {
        /* تحديث الحساسات وقراءتها من الـ ADC مع الفلترة */
        GAU_Update(&myCar);

        /* عرض النتائج على الشاشة للتأكد من التحويل والـ Scaling */
        snprintf(line1, sizeof(line1), "F:%3d%% C:%3dC", myCar.fuelPct, myCar.coolantC);
        snprintf(line2, sizeof(line2), "Bat:%umV Oil:%u", myCar.battmV, myCar.oilBarX10);

        DSP_Render(PG_MAIN, (const uint8*)line1, (const uint8*)line2);

        TIMER0_DelayMS(500); /* تحديث كل نص ثانية */

    /* 1. اقرأ الحساسات وحدث القيم */
    
        
        /* 2. شغل دالة التحذيرات عشان تحسب وتفلتر وتعمل Latching */
        WRN_Update(&myCar);
        
        /* 3. هات أعلى تحذير موجود حالياً */
        Warn_t current_warn = WRN_Highest(&myCar);
        
        char warn_text[17]; /* 16 حرف للشاشة + 1 للـ Null terminator */

        /* 4. حدد النص اللي هيتكتب بناءً على نوع الخطر */
        switch (current_warn) {
            case WARN_OIL:       
                sprintf(warn_text, "ERR: Oil Press  "); 
                break;
            case WARN_BATT:      
                sprintf(warn_text, "ERR: Battery    "); 
                break;
            case WARN_COOLANT:   
                sprintf(warn_text, "ERR: Overheat!  "); 
                break;
            case WARN_CHECK:     
                sprintf(warn_text, "Check Engine!   "); 
                break;
            case WARN_FUEL:      
                sprintf(warn_text, "Warn: Low Fuel  "); 
                break;
            case WARN_OVERSPEED: 
                sprintf(warn_text, "Warn: Overspeed "); 
                break;
            case WARN_SEATBELT:  
                sprintf(warn_text, "Fasten Seatbelt "); 
                break;
            case WARN_DOOR:      
                sprintf(warn_text, "Door is Open!   "); 
                break;
            case WARN_HANDBRAKE: 
                sprintf(warn_text, "Handbrake ON!   "); 
                break;
            case WARN_NONE:      
                sprintf(warn_text, "System Normal   "); 
                break;
            default:             
                sprintf(warn_text, "                "); 
                break;
        }

        /* 5. اطبع الجملة دي على السطر التاني في الشاشة */
        LCD_SetCursor(0, 1);
        LCD_WriteString((const uint8*)warn_text);
        
        TIMER0_DelayMS(500);


    }
    return 0;

}




