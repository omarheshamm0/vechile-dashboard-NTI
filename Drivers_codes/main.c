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




static void App_ConfigPins(void)
{

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
}

static uint8 Local_u8IgnitionPrev = GPIO_HIGH;
static uint8 Local_u8StartPrev = GPIO_HIGH;
static uint8 Local_u8DispPrev = GPIO_HIGH;
static uint16 Local_u16SysTicks = 0u;



static void App_InitSystem(void)
{
    App_ConfigPins();
    TIMER0_Init();
    SPI_InitMaster(SPI_PRESC_16);
    LCD_Init();
    LCD_SetBacklight(LCD_BACKLIGHT_ON);
    BSW_Init();
    LMP_Init();
    GAU_Init();
    Console_Init();
    CHM_Init();
    SPD_Init();
    TAC_Init();
    INTERRUPT_EnableGlobal();
}

static uint8 App_ReadButton(uint8 port, uint8 pin, uint8 prevState)
{
    uint8 current = GPIO_HIGH;
    uint8 edge = 0u;

    if (GPIO_GetPinValue(port, pin, &current) == E_OK)
    {
        if ((current == GPIO_LOW) && (prevState == GPIO_HIGH))
        {
            edge = 1u;
        }
    }
    return edge;
}

static void App_UpdateSwitchInputs(CarData_t *CarData)
{
    uint8 switchMask = 0u;

    if (BSW_Read(&switchMask) == E_OK)
    {
        CarData->turnLeft  = (switchMask & (1u << BSW_TURN_LEFT)) ? 1u : 0u;
        CarData->turnRight = (switchMask & (1u << BSW_TURN_RIGHT)) ? 1u : 0u;
        CarData->highBeam  = (switchMask & (1u << BSW_HIGH_BEAM)) ? 1u : 0u;
        CarData->handbrake = (switchMask & (1u << BSW_HANDBRAKE)) ? 1u : 0u;
        CarData->seatbelt  = (switchMask & (1u << BSW_SEATBELT)) ? 1u : 0u;
        CarData->doorOpen  = (switchMask & (1u << BSW_DOOR)) ? 1u : 0u;
    }
}

static void App_UpdateLampByte(CarData_t *CarData)
{
    uint8 fuelWarn = (CarData->fuelPct < 10u) ? LMP_STATE_ON : LMP_STATE_OFF;
    uint8 oilWarn  = (CarData->warnMask & (1u << WARN_OIL)) ? LMP_STATE_ON : LMP_STATE_OFF;
    uint8 battWarn = (CarData->warnMask & (1u << WARN_BATT)) ? LMP_STATE_ON : LMP_STATE_OFF;
    uint8 coolWarn = (CarData->warnMask & (1u << WARN_COOLANT)) ? LMP_STATE_ON : LMP_STATE_OFF;
    uint8 checkWarn = (CarData->warnMask & (1u << WARN_CHECK)) ? LMP_STATE_ON : LMP_STATE_OFF;

    LMP_Set(LMP_LOW_FUEL, fuelWarn);
    LMP_Set(LMP_OIL_PRESSURE, oilWarn);
    LMP_Set(LMP_BATTERY, battWarn);
    LMP_Set(LMP_COOLANT, coolWarn);
    LMP_Set(LMP_CHECK_ENGINE, checkWarn);
    LMP_Set(LMP_LEFT_TURN, CarData->turnLeft ? LMP_STATE_ON : LMP_STATE_OFF);
    LMP_Set(LMP_RIGHT_TURN, CarData->turnRight ? LMP_STATE_ON : LMP_STATE_OFF);
    LMP_Set(LMP_HIGH_BEAM, CarData->highBeam ? LMP_STATE_ON : LMP_STATE_OFF);
    LMP_Refresh();
}

static void App_RenderDisplay(CarData_t *CarData)
{
    char line1[17] = {0};
    char line2[17] = {0};

    if (CarData->page == PG_TRIP)
    {
        snprintf(line1, sizeof(line1), "TRIP:%lu m", (unsigned long)CarData->tripMetres);
        snprintf(line2, sizeof(line2), "MAX:%u km/h", CarData->maxSpeedKmh);
    }
    else if (CarData->page == PG_ENGINE)
    {
        snprintf(line1, sizeof(line1), "RPM:%u", CarData->rpm);
        snprintf(line2, sizeof(line2), "RNG:%u%%", CarData->fuelPct);
    }
    else if (CarData->page == PG_ELECTRICAL)
    {
        snprintf(line1, sizeof(line1), "BAT:%u mV", CarData->battmV);
        snprintf(line2, sizeof(line2), "P:%u/10 OIL:%u", CarData->oilBarX10 / 10u, CarData->oilBarX10);
    }
    else if (CarData->page == PG_DIAG)
    {
        snprintf(line1, sizeof(line1), "SPD:%u RPM:%u", CarData->speedKmh, CarData->rpm);
        snprintf(line2, sizeof(line2), "WARN:0x%04X", CarData->warnMask);
    }
    else
    {
        snprintf(line1, sizeof(line1), "SPD:%3u KM/H", CarData->speedKmh);
        snprintf(line2, sizeof(line2), "ODO:%lu m", (unsigned long)CarData->odoMetres);
    }

    DSP_Render(CarData->page, (const uint8 *)line1, (const uint8 *)line2);
}

int main(void)
{
    CarData_t *CarData = NULL;
    uint16 tickCounter = 0u;
    uint8 ignitionPress = 0u;
    uint8 ignitionHeld = 0u;
    uint8 displayCycle = 0u;
    uint8 startPressed = 0u;
    uint8 keyState = 0u;
    uint8 previousKey = GPIO_HIGH;
    uint8 previousStart = GPIO_HIGH;
    uint8 previousDisp = GPIO_HIGH;
    DashCfg_t cfg;

    cfg.magic = DSH_MAGIC;
    cfg.version = DSH_VERSION;
    cfg.odoMetres = 0u;
    cfg.tripMetres = 0u;
    cfg.maxSpeedRecord = 0u;
    cfg.speedLimitKmh = 120u;
    cfg.fuelWarnPct = 10u;
    cfg.coolantWarnC = 110u;
    cfg.oilWarnBarX10 = 10u;
    cfg.battLowmV = 12000u;
    cfg.battHighmV = 15000u;
    cfg.pulsesPerRev = 4u;
    cfg.wheelCircMm = 2000u;
    cfg.tachPulsesPerRev = 2u;
    cfg.ignitionCycles = 0u;
    cfg.writeSlot = 0u;
    cfg.checksum = 0u;

    App_InitSystem();
    CarData = Cluster_GetCarData();
    FSM_Init(CarData);
    CarData->page = PG_MAIN;

    while (1)
    {
        TIMER0_DelayMS(APP_TICK_MS);
        Local_u16SysTicks++;
        tickCounter++;

        GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN3, &keyState);
        ignitionPress = (keyState == GPIO_LOW) && (previousKey == GPIO_HIGH) ? 1u : 0u;
        ignitionHeld = (keyState == GPIO_LOW) ? 1u : 0u;
        previousKey = keyState;

        GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN4, &startPressed);
        startPressed = (startPressed == GPIO_LOW) ? 1u : 0u;
        if (startPressed && (previousStart == GPIO_HIGH))
        {
            /* edge detected in the start button; state machine handles button state each tick */
        }
        previousStart = (GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN4, &keyState) == E_OK) ? keyState : previousStart;

        GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN5, &keyState);
        displayCycle = (keyState == GPIO_LOW) && (previousDisp == GPIO_HIGH) ? 1u : 0u;
        previousDisp = keyState;

        App_UpdateSwitchInputs(CarData);
        GAU_Update(CarData);
        WRN_Update(CarData);
        FSM_Run(CarData, ignitionPress, ignitionHeld, startPressed);

        if (displayCycle)
        {
            CarData->page = (CarData->page + 1u) % 5u;
        }

        App_UpdateLampByte(CarData);
        CHM_Update();

        if ((tickCounter % APP_100MS_TICKS) == 0u)
        {
            SPD_Task100ms(CarData, &cfg);
            Console_SendTelemetry();
        }

        if ((tickCounter % APP_250MS_TICKS) == 0u)
        {
            TAC_Task250ms(CarData, &cfg);
        }

        if ((tickCounter % APP_500MS_TICKS) == 0u)
        {
            App_RenderDisplay(CarData);
        }

        if ((tickCounter % APP_1S_TICKS) == 0u)
        {
            if (CarData->speedKmh > cfg.speedLimitKmh)
            {
                CHM_Play(CHM_PATTERN_OVERSPEED);
            }
            else if (CarData->limpHome)
            {
                CHM_Play(CHM_PATTERN_LIMP_HOME);
            }
            else if (CarData->turnLeft || CarData->turnRight)
            {
                CHM_Play(CHM_PATTERN_TURN_TICK);
            }
            else
            {
                CHM_Play(CHM_PATTERN_OFF);
            }
        }

        Console_ProcessCommand();
    }

    return 0;
}