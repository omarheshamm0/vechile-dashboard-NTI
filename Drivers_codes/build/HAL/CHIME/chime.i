# 0 "HAL/CHIME/chime.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/CHIME/chime.c"
# 1 "HAL/CHIME/chime.h" 1



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
# 5 "HAL/CHIME/chime.h" 2


typedef enum {
    CHM_PATTERN_OFF = 0,
    CHM_PATTERN_OVERSPEED,
    CHM_PATTERN_LIMP_HOME,
    CHM_PATTERN_TURN_TICK
} ChimePattern_t;




void CHM_Init(void);





void CHM_Play(ChimePattern_t pattern);





void CHM_Update(void);
# 2 "HAL/CHIME/chime.c" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 43 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 3 "HAL/CHIME/chime.c" 2
# 16 "HAL/CHIME/chime.c"
static ChimePattern_t Current_Pattern = CHM_PATTERN_OFF;

static uint16 Timer_Ticks = 0;

static uint8 Is_Playing = 0;


static void Tone_On(void) {

    (*(volatile uint8 *)0x43) = 127;

    (*(volatile uint8 *)0x45) = (1u << 6u) | (1u << 3u) | (1u << 5u) | (1u << 2u);
    Is_Playing = 1;
}


static void Tone_Off(void) {

    (*(volatile uint8 *)0x45) = 0x00;
    (*(volatile uint8 *)0x43) = 0;
    Is_Playing = 0;
}

void CHM_Init(void) {

    GPIO_SetPinDirection(3u, 7u, 1u);
    Tone_Off();
}
void CHM_Play(ChimePattern_t pattern) {
    if (Current_Pattern != pattern) {
        Current_Pattern = pattern;
        Timer_Ticks = 0;


        if (pattern == CHM_PATTERN_OFF) {
            Tone_Off();
        } else {
            Tone_On();
        }
    }
}

void CHM_Update(void) {




    if (Current_Pattern == CHM_PATTERN_OFF) {
        return;
    }

    Timer_Ticks++;

    switch (Current_Pattern) {
        case CHM_PATTERN_OVERSPEED:


            if (Timer_Ticks == 5) {
                Tone_Off();
            } else if (Timer_Ticks >= 50) {
                Tone_On();
                Timer_Ticks = 0;
            }
            break;

        case CHM_PATTERN_LIMP_HOME:

            if (Timer_Ticks <= 50) {

                if (!Is_Playing) Tone_On();
            } else if (Timer_Ticks == 55) {

                Tone_Off();
            } else if (Timer_Ticks >= 150) {

                Tone_On();
                Timer_Ticks = 50;
            }
            break;

        case CHM_PATTERN_TURN_TICK:


            if (Timer_Ticks == 4) {
                Tone_Off();
            } else if (Timer_Ticks >= 9) {
                Tone_On();
                Timer_Ticks = 0;
            }
            break;

        default:
            Tone_Off();
            break;
    }
}
