#include "console.h"
#include "UART_interface.h"

typedef unsigned char u8;

// تهيئة الاتصال
void Console_Init(void) {
    UART_Init(9600); // ضبط سرعة النقل على 9600
}

// إرسال إطار البيانات (Telemetry Frame)
void Console_SendTelemetry(void) {
    UART_SendString("SYS_STATUS: RUNNING\r\n");
}

// استقبال الأوامر (Command Parser Baseline)
void Console_ProcessCommand(void) {
    u8 receivedChar = 0;
    // قراءة الحرف القادم عبر الـ UART
    if (UART_ReceiveByte(&receivedChar) == 0) { // لو في حرف جه
        if (receivedChar == '1') {
            UART_SendString("CMD: TEST_LAMPS_ON\r\n");
        }
    }
}