/*
 * main.c - PRJ-04-DASHBOARD  (Vehicle Instrument Cluster, ATmega32A @ 8 MHz)
 *
 * This revises the previous draft to match README.md. Three things in that
 * draft were breaking the design and are fixed here - read this block before
 * changing anything below:
 *
 * 1. TIMER1 conflict (critical).
 *    The draft used TIMER1_DelayMS(10) as the 10 ms scheduler tick. TIMER1
 *    is the same hardware timer speedo.c dedicates to Input-Capture wheel
 *    speed measurement (SPD_Init configures TCCR1A/TCCR1B for ICU). Calling
 *    TIMER1_DelayMS every loop re-programs those same registers for a CTC
 *    delay on every iteration, so road speed can never be captured
 *    correctly. The tick is now a free-running TIMER0 CTC interrupt
 *    (prescaler 1024, OCR0 = 77 -> ~10 ms @ 8 MHz), exactly as specified in
 *    README S8, and it is fully non-blocking (NFR-02). TIMER1 is left
 *    untouched for speedo.c.
 *
 * 2. Missing lamp driver.
 *    The draft included "lamps595.h" and called LMP_Set/LMP_Refresh/LMP_Init
 *    and lamp-name enums, but no lamps595.c/.h were ever provided among the
 *    project sources, so that draft cannot compile. The 74HC595 driver is
 *    implemented directly in this file (Lmp_* functions below) using the
 *    same SPI_Acquire/SPI_Release contract bodysw.c already uses for the
 *    74HC165. Functionally it is a drop-in replacement; move it into
 *    HAL/lamps595.c later to match the layer diagram in README S9.1.
 *
 * 3. Scheduling bugs.
 *    - GAU_Update() was called every 10 ms tick instead of every 500 ms.
 *      gauges.c's plausibility counter assumes it is called every 500 ms
 *      ("10 cycles * 500 ms = 5 s" in its own comment); calling it at 10 ms
 *      would raise WARN_CHECK after ~100 ms instead of 5 s (FR-18).
 *    - CHM_Update() was called every 10 ms tick instead of every 100 ms.
 *      chime.c's own header comment says it assumes a 100 ms call period;
 *      calling it 10x faster makes every chime pattern run 10x too fast.
 *    - Console_SendTelemetry() was sent every 100 ms instead of every 5 s
 *      (README S18.1 / task T-9).
 *    - The LCD was refreshed every 500 ms instead of every 250 ms (FR-17 /
 *      task T-6).
 *    All periods below now follow README S19's task table, including the
 *    listed offsets so tasks do not all land on the same tick.
 *
 * Gaps filled in that no provided module owns (warnings.c's own comment
 * says these are "updated by their respective modules", but no such
 * modules exist among the given sources):
 *   - Over-speed warning + 5 km/h hysteresis + chime (FR-15).
 *   - Seatbelt / door / handbrake warnings gated by speed (README S11.4).
 *   - Turn-signal blinking at 450 ms on/off with a synchronised chime tick
 *     (FR-11) - the switches were being shown as steady lamps, not blinked.
 *   - Session max-speed reset at key-on and the all-time record (FR-16).
 *   - Trip-reset button (2 s hold) - it was configured as an input but
 *     never read anywhere in the draft (FR-07).
 *   - Lamp cluster overrides per the Operating Modes table in README S15
 *     (dark in OFF/ACC, all-on during bulb check, oil+battery only during
 *     cranking/stalled).
 *   - Basic debounce on the key / start / display / trip-reset buttons.
 *
 * Known limitations carried over from the provided modules (not fixed here
 * since they live in files outside main.c - flag them in the report):
 *   - gauges.c raises WARN_CHECK when ALL four channels are plausible and
 *     clears it when any one is implausible - inverted from FR-18.
 *   - gauges.c initialises the ADC with ADC_REF_AREF; README S8 calls for
 *     AVCC as the reference.
 *   - warnings.c latches oil/coolant instantly instead of after the 2 s / 3 s
 *     persistence the spec (README S11.4) calls for.
 *   - odometer.c's atomic ODO_* accessors operate on their own private
 *     static counters, never connected to CarData_t; speedo.c integrates
 *     distance straight into CarData_t instead, so the atomic-read module
 *     is currently unused. Since only Task_Speed (single context) writes
 *     odoMetres/tripMetres here, no ISR ever touches them, so a torn read
 *     is not currently possible - but wire ODO_AddDistance/ODO_GetTotal
 *     through speedo.c if that changes.
 *   - No EEPROM persistence: SimulIDE has no non-volatile memory, so per
 *     README's own note the odometer legitimately starts at zero every
 *     boot. The 8-slot wear-levelling scheme (README S19.2) is not
 *     implemented.
 */

#ifndef F_CPU
#define F_CPU 8000000UL
#endif

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <stdio.h>

#include "STD_TYPES.h"
#include "dashboard_types.h"
#include "GPIO_interface.h"
#include "SPI_interface.h"
#include "INTERRUPT_interface.h"

#include "bodysw.h"
#include "lcd_i2c.h"
#include "gauges.h"
#include "chime.h"
#include "speedo.h"
#include "tacho.h"
#include "warnings.h"
#include "cluster.h"
#include "console.h"

/* ===========================================================================
 *  10 ms scheduler tick - TIMER0 CTC, prescaler 1024, OCR0 = 77 (README S8)
 * ===========================================================================
 */
static volatile uint8 g_tick10ms = 0u;

ISR(TIMER0_COMP_vect)
{
    g_tick10ms = 1u;
}

static void SchedulerTick_Init(void)
{
    TCCR0  = (uint8)(1u << WGM01);                 /* CTC mode                */
    OCR0   = 77u;                                  /* ~10 ms @ 8 MHz / 1024   */
    TCNT0  = 0u;
    TIMSK |= (uint8)(1u << OCIE0);                 /* enable compare match IT */
    TCCR0 |= (uint8)((1u << CS02) | (1u << CS00)); /* start, prescaler 1024   */
}

/* ===========================================================================
 *  74HC595 lamp cluster - Q0..Q7 map from README S7
 * ===========================================================================
 */
#define LMP_LATCH_PORT   GPIO_PORTC
#define LMP_LATCH_PIN    GPIO_PIN2

#define LMP_BIT_FUEL      0u
#define LMP_BIT_OIL       1u
#define LMP_BIT_BATT      2u
#define LMP_BIT_COOLANT   3u
#define LMP_BIT_CHECK     4u
#define LMP_BIT_TURNL     5u
#define LMP_BIT_TURNR     6u
#define LMP_BIT_HIGHBEAM  7u

/* Shift one byte to the 74HC595 and latch it. Every SPI transaction is
 * bracketed by SPI_Acquire/SPI_Release (README S9.2, NFR-05); the latch
 * pulse happens strictly after SPI_Release(), never between bytes. If the
 * bus is busy this cycle the refresh is simply skipped - README S19 notes
 * a skipped 50 ms lamp refresh is invisible.
 */
static void Lmp_Shift(uint8 Copy_u8Byte)
{
    if (SPI_Acquire(SPI_SLAVE_LAMPS) == E_OK)
    {
        SPI_TransmitByte(Copy_u8Byte);
        SPI_Release();

        GPIO_SetPinValue(LMP_LATCH_PORT, LMP_LATCH_PIN, GPIO_HIGH);
        _delay_us(2u);
        GPIO_SetPinValue(LMP_LATCH_PORT, LMP_LATCH_PIN, GPIO_LOW);
    }
}

/* Builds the lamp byte from CarData_t, applying the per-state overrides in
 * README S15 (Operating Modes) on top of the plain warning bits.
 */
static uint8 Lmp_BuildByte(const CarData_t *Copy_pCarData, uint8 Copy_u8BlinkOn)
{
    uint8 Local_u8Byte = 0u;

    switch ((ClusterState_t)Copy_pCarData->state)
    {
        case CS_OFF:
        case CS_ACC:
            return 0x00u; /* cluster dark */

        case CS_BULBCHECK:
            return 0xFFu; /* FR-09: all eight lamps on for the bulb check */

        case CS_CRANKING:
        case CS_STALLED:
            /* README S15: oil + battery lamps only, like a real key-on/engine-off cluster */
            return (uint8)((1u << LMP_BIT_OIL) | (1u << LMP_BIT_BATT));

        default:
            if (Copy_pCarData->warnMask & (1u << WARN_FUEL))    Local_u8Byte |= (uint8)(1u << LMP_BIT_FUEL);
            if (Copy_pCarData->warnMask & (1u << WARN_OIL))     Local_u8Byte |= (uint8)(1u << LMP_BIT_OIL);
            if (Copy_pCarData->warnMask & (1u << WARN_BATT))    Local_u8Byte |= (uint8)(1u << LMP_BIT_BATT);
            if (Copy_pCarData->warnMask & (1u << WARN_COOLANT)) Local_u8Byte |= (uint8)(1u << LMP_BIT_COOLANT);
            if (Copy_pCarData->warnMask & (1u << WARN_CHECK))   Local_u8Byte |= (uint8)(1u << LMP_BIT_CHECK);
            break;
    }

    if (Copy_pCarData->highBeam) Local_u8Byte |= (uint8)(1u << LMP_BIT_HIGHBEAM);
    if (Copy_u8BlinkOn && Copy_pCarData->turnLeft)  Local_u8Byte |= (uint8)(1u << LMP_BIT_TURNL);
    if (Copy_u8BlinkOn && Copy_pCarData->turnRight) Local_u8Byte |= (uint8)(1u << LMP_BIT_TURNR);

    return Local_u8Byte;
}

/* ===========================================================================
 *  Button debounce - key / start / display-cycle / trip-reset
 * ===========================================================================
 */
typedef struct
{
    uint8 stable;
    uint8 candidate;
    uint8 count;
} Debounce_t;

#define DEBOUNCE_TICKS 3u /* ~30 ms of consistent reads before a level is trusted */

static uint8 Debounce_Sample(Debounce_t *Copy_pState, uint8 Copy_u8Raw)
{
    if (Copy_u8Raw != Copy_pState->candidate)
    {
        Copy_pState->candidate = Copy_u8Raw;
        Copy_pState->count = 0u;
    }
    else if (Copy_pState->count < DEBOUNCE_TICKS)
    {
        Copy_pState->count++;
    }

    if (Copy_pState->count >= DEBOUNCE_TICKS)
    {
        Copy_pState->stable = Copy_pState->candidate;
    }

    return Copy_pState->stable;
}

static uint8 App_FallingEdge(uint8 Copy_u8Current, uint8 Copy_u8Previous)
{
    return (uint8)((Copy_u8Current == GPIO_LOW) && (Copy_u8Previous == GPIO_HIGH));
}

/* ===========================================================================
 *  Pin / peripheral init
 * ===========================================================================
 */
static void App_ConfigPins(void)
{
    /* ADC channels for the four analog sensors */
    GPIO_SetPinDirection(GPIO_PORTA, GPIO_PIN0, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTA, GPIO_PIN1, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTA, GPIO_PIN2, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTA, GPIO_PIN3, GPIO_INPUT);

    /* Direct-GPIO buttons and the shared SPI pins */
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN0, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN1, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN2, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN3, GPIO_INPUT_PULLUP); /* trip-reset button */
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN4, GPIO_OUTPUT);       /* 74HC165 SH/LD      */
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN5, GPIO_OUTPUT);       /* MOSI               */
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN6, GPIO_INPUT);        /* MISO               */
    GPIO_SetPinDirection(GPIO_PORTB, GPIO_PIN7, GPIO_OUTPUT);       /* SCK                */

    /* 595 latch, I2C pins, body-switch inputs and control outputs */
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN0, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN1, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN2, GPIO_OUTPUT);       /* 74HC595 RCLK latch */
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN3, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN4, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN5, GPIO_INPUT_PULLUP);
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN6, GPIO_OUTPUT);       /* CPU-load test pin (was INPUT - fixed) */
    GPIO_SetPinDirection(GPIO_PORTC, GPIO_PIN7, GPIO_OUTPUT);

    /* UART, INT0 / INT1, speed input and buzzer */
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN0, GPIO_INPUT);
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN1, GPIO_OUTPUT);
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN2, GPIO_INPUT);        /* tach pulses / INT0 */
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN3, GPIO_INPUT_PULLUP); /* ignition key        */
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN4, GPIO_INPUT_PULLUP); /* start button        */
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN5, GPIO_INPUT_PULLUP); /* display-cycle button*/
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN6, GPIO_INPUT);        /* wheel pulses / ICP1 */
    GPIO_SetPinDirection(GPIO_PORTD, GPIO_PIN7, GPIO_OUTPUT);       /* buzzer / OC2        */

    /* Keep the 74HC165 SH/LD and 595 latch idle at startup */
    GPIO_SetPinValue(GPIO_PORTB, GPIO_PIN4, GPIO_HIGH);
    GPIO_SetPinValue(GPIO_PORTC, GPIO_PIN2, GPIO_LOW);
    GPIO_SetPinValue(GPIO_PORTC, GPIO_PIN6, GPIO_LOW);
    GPIO_SetPinValue(GPIO_PORTC, GPIO_PIN7, GPIO_LOW);
    GPIO_SetPinValue(GPIO_PORTD, GPIO_PIN7, GPIO_LOW);
}

static void App_InitSystem(void)
{
    /* README S16 flow: MCAL init -> 595 cleared / all lamps off -> zero
       odometer/trip -> CS_OFF -> sei(). */
    App_ConfigPins();
    SchedulerTick_Init();
    SPI_InitMaster(SPI_PRESC_16);
    LCD_Init();
    LCD_SetBacklight(LCD_BACKLIGHT_ON);
    BSW_Init();
    Lmp_Shift(0x00u); /* all lamps off at boot */
    GAU_Init();
    Console_Init();
    CHM_Init();
    SPD_Init();
    TAC_Init();
    INTERRUPT_EnableGlobal();
}

/* ===========================================================================
 *  Per-task helpers
 * ===========================================================================
 */
static void App_UpdateSwitchInputs(CarData_t *Copy_pCarData)
{
    uint8 Local_u8Mask = 0u;

    if (BSW_Read(&Local_u8Mask) == E_OK)
    {
        Copy_pCarData->turnLeft  = (Local_u8Mask & (1u << BSW_TURN_LEFT))  ? 1u : 0u;
        Copy_pCarData->turnRight = (Local_u8Mask & (1u << BSW_TURN_RIGHT)) ? 1u : 0u;
        Copy_pCarData->highBeam  = (Local_u8Mask & (1u << BSW_HIGH_BEAM))  ? 1u : 0u;
        Copy_pCarData->handbrake = (Local_u8Mask & (1u << BSW_HANDBRAKE))  ? 1u : 0u;
        Copy_pCarData->seatbelt  = (Local_u8Mask & (1u << BSW_SEATBELT))   ? 1u : 0u;
        Copy_pCarData->doorOpen  = (Local_u8Mask & (1u << BSW_DOOR))       ? 1u : 0u;
    }
}

static uint8 s_overspeedActive = 0u;

/* Fills in the warnings no provided module owns, on top of WRN_Update()'s
 * oil/battery/coolant/fuel latches (README S9.3 / S11.4).
 */
static void App_UpdateWarnings(CarData_t *Copy_pCarData, const DashCfg_t *Copy_pCfg)
{
    WRN_Update(Copy_pCarData);

    if (Copy_pCarData->seatbelt && (Copy_pCarData->speedKmh > 10u))
        Copy_pCarData->warnMask |= (uint16)(1u << WARN_SEATBELT);
    else
        Copy_pCarData->warnMask &= (uint16)~(1u << WARN_SEATBELT);

    if (Copy_pCarData->doorOpen && (Copy_pCarData->speedKmh > 5u))
        Copy_pCarData->warnMask |= (uint16)(1u << WARN_DOOR);
    else
        Copy_pCarData->warnMask &= (uint16)~(1u << WARN_DOOR);

    if (Copy_pCarData->handbrake && (Copy_pCarData->speedKmh > 5u))
        Copy_pCarData->warnMask |= (uint16)(1u << WARN_HANDBRAKE);
    else
        Copy_pCarData->warnMask &= (uint16)~(1u << WARN_HANDBRAKE);

    /* Over-speed with 5 km/h hysteresis (FR-15) */
    if (!s_overspeedActive && (Copy_pCarData->speedKmh > Copy_pCfg->speedLimitKmh))
    {
        s_overspeedActive = 1u;
    }
    else if (s_overspeedActive && (Copy_pCarData->speedKmh < (uint16)(Copy_pCfg->speedLimitKmh - 5u)))
    {
        s_overspeedActive = 0u;
    }

    if (s_overspeedActive)
        Copy_pCarData->warnMask |= (uint16)(1u << WARN_OVERSPEED);
    else
        Copy_pCarData->warnMask &= (uint16)~(1u << WARN_OVERSPEED);
}

#define TURN_BLINK_TICKS 45u /* 45 * 10 ms = 450 ms on/off, README DD-05 */

static uint8  s_blinkOn = 0u;
static uint16 s_blinkTickCount = 0u;

/* Called every 10 ms tick regardless of the lamp task's own 50 ms period,
 * so the 450 ms blink period stays accurate (FR-11).
 */
static void App_UpdateBlinkPhase(void)
{
    s_blinkTickCount++;
    if (s_blinkTickCount >= TURN_BLINK_TICKS)
    {
        s_blinkTickCount = 0u;
        s_blinkOn = (uint8)!s_blinkOn;
    }
}

/* Chime pattern arbitration (limp-home > over-speed > turn tick > off) and
 * the chime state machine tick. CHM_Update() must run every 100 ms - see
 * the note at the top of this file.
 */
static void App_UpdateChime(const CarData_t *Copy_pCarData)
{
    uint8 Local_u8TurnActive = (uint8)((Copy_pCarData->turnLeft || Copy_pCarData->turnRight) && s_blinkOn);

    if (Copy_pCarData->state == CS_LIMP_HOME)
        CHM_Play(CHM_PATTERN_LIMP_HOME);
    else if (s_overspeedActive)
        CHM_Play(CHM_PATTERN_OVERSPEED);
    else if (Local_u8TurnActive)
        CHM_Play(CHM_PATTERN_TURN_TICK);
    else
        CHM_Play(CHM_PATTERN_OFF);

    CHM_Update();
}

static void App_RenderDisplay(CarData_t *CarData)
{
    char line1[17] = {0};
    char line2[17] = {0};

    if (CarData->state == (uint8)CS_BULBCHECK)
    {
        snprintf(line1, sizeof(line1), "BULB CHECK");
        snprintf(line2, sizeof(line2), "ALL LAMPS ON");
    }
    else if (CarData->state == (uint8)CS_LIMP_HOME)
    {
        snprintf(line1, sizeof(line1), "!! STOP ENGINE !!");
        snprintf(line2, sizeof(line2), "SPD:%u RPM:%u", CarData->speedKmh, CarData->rpm);
    }
    else if (CarData->page == PG_TRIP)
    {
        snprintf(line1, sizeof(line1), "TRIP:%lu m", (unsigned long)CarData->tripMetres);
        snprintf(line2, sizeof(line2), "AVG:%u MAX:%u", CarData->avgSpeedKmh, CarData->maxSpeedKmh);
    }
    else if (CarData->page == PG_ENGINE)
    {
        snprintf(line1, sizeof(line1), "RPM:%u C:%dC", CarData->rpm, CarData->coolantC);
        snprintf(line2, sizeof(line2), "OIL:%u.%ubar", CarData->oilBarX10 / 10u, CarData->oilBarX10 % 10u);
    }
    else if (CarData->page == PG_ELECTRICAL)
    {
        snprintf(line1, sizeof(line1), "BAT:%u mV", CarData->battmV);
        snprintf(line2, sizeof(line2), "ODO:%lu m", (unsigned long)CarData->odoMetres);
    }
    else if (CarData->page == PG_DIAG)
    {
        snprintf(line1, sizeof(line1), "SPD:%u RPM:%u", CarData->speedKmh, CarData->rpm);
        snprintf(line2, sizeof(line2), "WARN:0x%04X", CarData->warnMask);
    }
    else
    {
        snprintf(line1, sizeof(line1), "SPD:%3u KM/H", CarData->speedKmh);
        snprintf(line2, sizeof(line2), "RPM:%u F:%u%%", CarData->rpm, CarData->fuelPct);
    }

    DSP_Render(CarData->page, (const uint8 *)line1, (const uint8 *)line2);
}

/* ===========================================================================
 *  main
 * ===========================================================================
 */
int main(void)
{
    CarData_t *CarData = NULL;
    DashCfg_t  cfg;

    uint32 tickCounter = 0u;

    Debounce_t dbKey   = {GPIO_HIGH, GPIO_HIGH, 0u};
    Debounce_t dbStart = {GPIO_HIGH, GPIO_HIGH, 0u};
    Debounce_t dbDisp  = {GPIO_HIGH, GPIO_HIGH, 0u};
    Debounce_t dbTrip  = {GPIO_HIGH, GPIO_HIGH, 0u};

    uint8  prevKeyStable  = GPIO_HIGH;
    uint8  prevDispStable = GPIO_HIGH;
    uint8  prevTripStable = GPIO_HIGH;
    uint16 keyHoldTicks   = 0u;
    uint16 tripHoldTicks  = 0u;
    uint8  keyHeldFired   = 0u;
    uint8  tripHeldFired  = 0u;
    uint32 tripSeconds    = 0u;

    /* README S10.2 defaults - no EEPROM in SimulIDE, so these are the whole
       config; nothing is loaded/validated from non-volatile storage. */
    cfg.magic            = DSH_MAGIC;
    cfg.version          = DSH_VERSION;
    cfg.odoMetres        = 0u;
    cfg.tripMetres       = 0u;
    cfg.maxSpeedRecord   = 0u;
    cfg.speedLimitKmh    = 120u;
    cfg.fuelWarnPct      = 10u;
    cfg.coolantWarnC     = 110u;
    cfg.oilWarnBarX10    = 10u;
    cfg.battLowmV        = 12000u;
    cfg.battHighmV       = 15000u;
    cfg.pulsesPerRev     = 4u;
    cfg.wheelCircMm      = 2000u;
    cfg.tachPulsesPerRev = 2u;
    cfg.ignitionCycles   = 0u;
    cfg.writeSlot        = 0u;
    cfg.checksum         = 0u;

    App_InitSystem();

    /* console.c reads/writes the cluster's own CarData_t via
       Cluster_GetCarData()/Cluster_SetPage() - use the SAME pointer here so
       telemetry and console commands stay in sync with the FSM state. */
    CarData = Cluster_GetCarData();
    FSM_Init(CarData);
    CarData->page = PG_MAIN;

    for (;;)
    {
        if (g_tick10ms)
        {
            uint8 rawKey, rawStart, rawDisp, rawTrip;
            uint8 keyLevel, startLevel, dispLevel, tripLevel;
            uint8 ignitionPress, ignitionHeld, startPressed;
            uint8 dispPress, tripShortPress;
            static uint8 prevFsmState = 0xFFu;

            g_tick10ms = 0u;
            tickCounter++;
            GPIO_SetPinValue(GPIO_PORTC, GPIO_PIN6, GPIO_HIGH); /* NFR-11 CPU-load probe */

            /* ---------------- T-1 / T-2 : inputs + FSM, every 10 ms ---------------- */
            GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN3, &rawKey);
            GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN4, &rawStart);
            GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN5, &rawDisp);
            GPIO_GetPinValue(GPIO_PORTB, GPIO_PIN3, &rawTrip);

            keyLevel   = Debounce_Sample(&dbKey,   rawKey);
            startLevel = Debounce_Sample(&dbStart, rawStart);
            dispLevel  = Debounce_Sample(&dbDisp,  rawDisp);
            tripLevel  = Debounce_Sample(&dbTrip,  rawTrip);

            /* Ignition key: press fires on the falling edge; 2 s continuous
               low forces CS_OFF from any state (T12, handled in FSM_Run). */
            ignitionPress = App_FallingEdge(keyLevel, prevKeyStable);
            ignitionHeld = 0u;
            if (keyLevel == GPIO_LOW)
            {
                if (keyHoldTicks < 0xFFFFu) keyHoldTicks++;
                if (!keyHeldFired && (keyHoldTicks >= 200u))
                {
                    ignitionHeld = 1u;
                    keyHeldFired = 1u;
                }
            }
            else
            {
                keyHoldTicks = 0u;
                keyHeldFired = 0u;
            }
            prevKeyStable = keyLevel;

            startPressed = (uint8)(startLevel == GPIO_LOW);

            dispPress = App_FallingEdge(dispLevel, prevDispStable);
            prevDispStable = dispLevel;

            /* Trip-reset button: short press cycles the page, a 2 s hold
               zeroes the trip meter and its elapsed-time accumulator; the
               lifetime odometer is untouched (FR-07). */
            tripShortPress = 0u;
            if (tripLevel == GPIO_LOW)
            {
                if (tripHoldTicks < 0xFFFFu) tripHoldTicks++;
                if (!tripHeldFired && (tripHoldTicks >= 200u))
                {
                    tripHeldFired = 1u;
                    CarData->tripMetres = 0u;
                    tripSeconds = 0u;
                }
            }
            else
            {
                if ((prevTripStable == GPIO_LOW) && !tripHeldFired) tripShortPress = 1u;
                tripHoldTicks = 0u;
                tripHeldFired = 0u;
            }
            prevTripStable = tripLevel;

            if (dispPress || tripShortPress)
            {
                CarData->page = (uint8)((CarData->page + 1u) % 5u);
            }

            App_UpdateSwitchInputs(CarData);        /* 74HC165 over the shared SPI bus */
            App_UpdateWarnings(CarData, &cfg);      /* oil/batt/coolant/fuel + gaps above */
            FSM_Run(CarData, ignitionPress, ignitionHeld, startPressed);

            if (prevFsmState != CarData->state)
            {
                if (CarData->state == (uint8)CS_ACC)
                {
                    CarData->maxSpeedKmh = 0u; /* T1: session max resets at key-on (FR-16) */
                }
                prevFsmState = CarData->state;
            }

            App_UpdateBlinkPhase();

            /* ---------------- T-10 : console, 20 ms, offset 1 ---------------- */
            if ((tickCounter % 2u) == 1u)
            {
                Console_ProcessCommand();
            }

            /* ---------------- T-3 : lamp refresh, 50 ms, offset 1 ---------------- */
            if ((tickCounter % 5u) == 1u)
            {
                uint8 lampByte = Lmp_BuildByte(CarData, s_blinkOn);
                CarData->lampByte = lampByte;
                Lmp_Shift(lampByte);
            }

            /* ---------------- T-4 : speed + chime, 100 ms, offset 2 ---------------- */
            if ((tickCounter % 10u) == 2u)
            {
                SPD_Task100ms(CarData, &cfg);

                if ((CarData->speedKmh <= 250u) && (CarData->speedKmh > cfg.maxSpeedRecord))
                {
                    cfg.maxSpeedRecord = CarData->speedKmh; /* all-time record (FR-16) */
                }

                App_UpdateChime(CarData); /* also calls CHM_Update() - needs the 100 ms period */
            }

            /* ---------------- T-5 : tacho, 250 ms, offset 3 ---------------- */
            if ((tickCounter % 25u) == 3u)
            {
                TAC_Task250ms(CarData, &cfg);
            }

            /* ---------------- T-6 : LCD repaint, 250 ms, offset 5 ---------------- */
            if ((tickCounter % 25u) == 5u)
            {
                App_RenderDisplay(CarData);
            }

            /* ---------------- T-7 : gauges, 500 ms, offset 4 ---------------- */
            if ((tickCounter % 50u) == 4u)
            {
                GAU_Update(CarData);
            }

            /* ---------------- T-8 : trip timers, 1 s, offset 6 ---------------- */
            if ((tickCounter % 100u) == 6u)
            {
                if (CarData->state != (uint8)CS_OFF)
                {
                    CarData->ignitionSec++;
                    tripSeconds++;
                }

                CarData->avgSpeedKmh = (tripSeconds > 0u)
                    ? (uint16)((CarData->tripMetres * 36UL) / (tripSeconds * 10UL))
                    : 0u;
            }

            /* ---------------- T-9 : diagnostics frame, 5 s, offset 8 ---------------- */
            if ((tickCounter % 500u) == 8u)
            {
                Console_SendTelemetry();
            }

            GPIO_SetPinValue(GPIO_PORTC, GPIO_PIN6, GPIO_LOW);
        }
    }

    return 0;
}