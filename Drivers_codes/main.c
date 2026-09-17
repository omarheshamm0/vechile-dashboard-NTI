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
 *
 * 4. Pin map corrected against the actual Proteus schematic.
 *    The switch wiring in the schematic does not match the pin map this
 *    file was originally written against:
 *      - Turn-left/turn-right/trip-reset and the four "info" switches
 *        (high beam, door, seat belt, hand brake) each have their own
 *        dedicated wire straight to a port pin - NOT through the 74HC165.
 *      - The ignition key ("contag"), start button and display-cycle
 *        button are the ones actually drawn going into the 74HC165, next
 *        to it at the bottom-left of the sheet.
 *    That is the opposite of bodysw.h's BSW_TURN_LEFT/RIGHT/HIGH_BEAM/
 *    HANDBRAKE/SEATBELT/DOOR constants, which assume those six are the
 *    ones read over the shift register. bodysw.c/BSW_Read() is still used
 *    here - it is a correct, reusable "read one byte from the 165" driver
 *    regardless of what is wired to it - but this file now reads its
 *    result as three raw bits (key/start/display-cycle) instead of using
 *    bodysw.h's six named bits, which do not apply to this circuit.
 *    Best-effort pin map, please check this against your sheet and fix
 *    whichever line is wrong - two things could not be read with
 *    confidence from the image: (a) the exact 165 bit each of
 *    key/start/display-cycle lands on (assumed bit0/bit1/bit2, D3..D7
 *    assumed unused), and (b) one unlabeled component near "Trip reset"
 *    that was left unconnected here:
 *        PB0  turn-left switch      PC4  hand brake
 *        PB1  turn-right switch     PC5  seat belt
 *        PB3  trip-reset (2 s hold) PC6  door switch
 *        PB4..PB7  shared SPI (165 + 595, fixed by hardware)
 *                                   PC7  high beam
 *        165 bit0  ignition key ("contag")
 *        165 bit1  start button
 *        165 bit2  display-cycle button
 *    The dedicated CPU-load test pin (PC6) from the previous revision is
 *    removed, since the schematic uses that pin for the door switch.
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

        case CS_LIMP_HOME:
        {
            /* README S15: "Cause + check engine" - only the lamp that
               actually forced limp-home, plus the check-engine lamp. */
            Warn_t Local_Cause = WRN_Highest(Copy_pCarData);
            uint8  Local_u8CauseBit = 0u;

            if (Local_Cause == WARN_OIL)          Local_u8CauseBit = (uint8)(1u << LMP_BIT_OIL);
            else if (Local_Cause == WARN_COOLANT) Local_u8CauseBit = (uint8)(1u << LMP_BIT_COOLANT);
            else if (Local_Cause == WARN_BATT)    Local_u8CauseBit = (uint8)(1u << LMP_BIT_BATT);

            return (uint8)(Local_u8CauseBit | (1u << LMP_BIT_CHECK));
        }

        case CS_IGNITION:
            /* README S15: "Warnings only" - no turn signals / high beam yet,
               the engine is not running and the car is not being driven. */
            if (Copy_pCarData->warnMask & (1u << WARN_FUEL))    Local_u8Byte |= (uint8)(1u << LMP_BIT_FUEL);
            if (Copy_pCarData->warnMask & (1u << WARN_OIL))     Local_u8Byte |= (uint8)(1u << LMP_BIT_OIL);
            if (Copy_pCarData->warnMask & (1u << WARN_BATT))    Local_u8Byte |= (uint8)(1u << LMP_BIT_BATT);
            if (Copy_pCarData->warnMask & (1u << WARN_COOLANT)) Local_u8Byte |= (uint8)(1u << LMP_BIT_COOLANT);
            if (Copy_pCarData->warnMask & (1u << WARN_CHECK))   Local_u8Byte |= (uint8)(1u << LMP_BIT_CHECK);
            return Local_u8Byte;

        case CS_RUNNING:
        default:
            /* README S15: "Active warnings" - full picture, including the
               turn indicators (blinked) and high beam. */
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
    LCD_SetBacklight(LCD_BACKLIGHT_OFF); /* stays dark until the key leaves CS_OFF */
    LCD_Clear();                         /* push the backlight-off byte out now */
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
 *  Per-task functions - named and scheduled exactly per README S19
 * ===========================================================================
 */

/* ---- shared task state (kept file-scope so each Task_* stays a plain
 *      void(CarData_t*[, DashCfg_t*]) function, matching the table) ---- */
static uint8  s_overspeedActive = 0u;
static uint8  s_blinkOn         = 0u;
static uint8  s_blinkCallCount  = 0u;
static uint32 s_tripSeconds     = 0u;
static uint16 s_offTicks250     = 0u; /* 250 ms ticks spent so far in CS_OFF */
static uint8  s_lcdBacklightOn  = 0u; /* mirrors App_InitSystem's initial OFF */

static Debounce_t s_dbKey   = {GPIO_HIGH, GPIO_HIGH, 0u};
static Debounce_t s_dbStart = {GPIO_HIGH, GPIO_HIGH, 0u};
static Debounce_t s_dbDisp  = {GPIO_HIGH, GPIO_HIGH, 0u};
static Debounce_t s_dbTrip  = {GPIO_HIGH, GPIO_HIGH, 0u};

static uint8  s_prevKeyStable  = GPIO_HIGH;
static uint8  s_prevDispStable = GPIO_HIGH;
static uint8  s_prevTripStable = GPIO_HIGH;
static uint16 s_keyHoldTicks   = 0u;
static uint16 s_tripHoldTicks  = 0u;
static uint8  s_keyHeldFired   = 0u;
static uint8  s_tripHeldFired  = 0u;

/* Outputs of Task_Inputs, consumed by Task_FSM the same tick. */
static uint8 s_ignitionPress = 0u;
static uint8 s_ignitionHeld  = 0u;
static uint8 s_startPressed  = 0u;

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

/* T-1  Task_Inputs  10 ms  offset 0 - buttons, body switches, debounce */
static void Task_Inputs(CarData_t *Copy_pCarData)
{
    uint8 Local_u8RawKey, Local_u8RawStart, Local_u8RawDisp, Local_u8RawTrip;
    uint8 Local_u8KeyLevel, Local_u8StartLevel, Local_u8DispLevel, Local_u8TripLevel;
    uint8 Local_u8DispPress, Local_u8TripShortPress;

    GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN3, &Local_u8RawKey);
    GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN4, &Local_u8RawStart);
    GPIO_GetPinValue(GPIO_PORTD, GPIO_PIN5, &Local_u8RawDisp);
    GPIO_GetPinValue(GPIO_PORTB, GPIO_PIN3, &Local_u8RawTrip);

    Local_u8KeyLevel   = Debounce_Sample(&s_dbKey,   Local_u8RawKey);
    Local_u8StartLevel = Debounce_Sample(&s_dbStart, Local_u8RawStart);
    Local_u8DispLevel  = Debounce_Sample(&s_dbDisp,  Local_u8RawDisp);
    Local_u8TripLevel  = Debounce_Sample(&s_dbTrip,  Local_u8RawTrip);

    /* Ignition key: a short press fires on the falling edge; 2 s continuous
       low is the T12 "key held" force-off, sensed here and consumed by
       FSM_Run() in Task_FSM. */
    s_ignitionPress = App_FallingEdge(Local_u8KeyLevel, s_prevKeyStable);
    s_ignitionHeld = 0u;
    if (Local_u8KeyLevel == GPIO_LOW)
    {
        if (s_keyHoldTicks < 0xFFFFu) s_keyHoldTicks++;
        if (!s_keyHeldFired && (s_keyHoldTicks >= 200u))
        {
            s_ignitionHeld = 1u;
            s_keyHeldFired = 1u;
        }
    }
    else
    {
        s_keyHoldTicks = 0u;
        s_keyHeldFired = 0u;
    }
    s_prevKeyStable = Local_u8KeyLevel;

    s_startPressed = (uint8)(Local_u8StartLevel == GPIO_LOW);

    Local_u8DispPress = App_FallingEdge(Local_u8DispLevel, s_prevDispStable);
    s_prevDispStable = Local_u8DispLevel;

    /* Trip-reset button: short press cycles the page, a 2 s hold zeroes the
       trip meter and its elapsed-time accumulator; the lifetime odometer is
       untouched (FR-07). */
    Local_u8TripShortPress = 0u;
    if (Local_u8TripLevel == GPIO_LOW)
    {
        if (s_tripHoldTicks < 0xFFFFu) s_tripHoldTicks++;
        if (!s_tripHeldFired && (s_tripHoldTicks >= 200u))
        {
            s_tripHeldFired = 1u;
            Copy_pCarData->tripMetres = 0u;
            s_tripSeconds = 0u;
        }
    }
    else
    {
        if ((s_prevTripStable == GPIO_LOW) && !s_tripHeldFired) Local_u8TripShortPress = 1u;
        s_tripHoldTicks = 0u;
        s_tripHeldFired = 0u;
    }
    s_prevTripStable = Local_u8TripLevel;

    if (Local_u8DispPress || Local_u8TripShortPress)
    {
        Copy_pCarData->page = (uint8)((Copy_pCarData->page + 1u) % 5u);
    }

    App_UpdateSwitchInputs(Copy_pCarData); /* 74HC165 over the shared SPI bus */
}

/* T-2  Task_FSM  10 ms  offset 0 - cluster switch */
static void Task_FSM(CarData_t *Copy_pCarData)
{
    static uint8 s_prevState = 0xFFu;

    FSM_Run(Copy_pCarData, s_ignitionPress, s_ignitionHeld, s_startPressed);

    if (s_prevState != Copy_pCarData->state)
    {
        if (Copy_pCarData->state == (uint8)CS_ACC)
        {
            Copy_pCarData->maxSpeedKmh = 0u; /* T1: session max resets at key-on (FR-16) */
        }
        s_prevState = Copy_pCarData->state;
    }
}

/* T-3  Task_Lamps  50 ms  offset 1 - warning eval + 595 shift + latch */
static void Task_Lamps(CarData_t *Copy_pCarData, const DashCfg_t *Copy_pCfg)
{
    uint8 Local_u8Byte;

    WRN_Update(Copy_pCarData); /* oil / battery / coolant / fuel latches */

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

    /* Over-speed with 5 km/h hysteresis (FR-15, T13) */
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

    /* 450 ms on/off blink, timed in Task_Lamps' own 50 ms period
       (9 calls * 50 ms = 450 ms, README DD-05). */
    s_blinkCallCount++;
    if (s_blinkCallCount >= 9u)
    {
        s_blinkCallCount = 0u;
        s_blinkOn = (uint8)!s_blinkOn;
    }

    Local_u8Byte = Lmp_BuildByte(Copy_pCarData, s_blinkOn);
    Copy_pCarData->lampByte = Local_u8Byte;
    Lmp_Shift(Local_u8Byte);
}

/* Chime pattern arbitration (limp-home > over-speed > turn tick > off).
 * CHM_Update() itself must still be called every 100 ms - chime.c's own
 * header comment says its pattern timers assume a 100 ms tick - so this is
 * invoked from Task_Speed rather than Task_1Hz even though README S19
 * groups "chime schedule" with the 1 s task; calling CHM_Play() with an
 * unchanged pattern is a no-op in chime.c, so doing the decision at 100 ms
 * instead of 1 s changes nothing observable.
 */
static void App_UpdateChime(const CarData_t *Copy_pCarData)
{
    uint8 Local_u8TurnActive;

    if (Copy_pCarData->state == (uint8)CS_OFF)
    {
        CHM_Play(CHM_PATTERN_OFF);
        CHM_Update();
        return;
    }

    Local_u8TurnActive = (uint8)((Copy_pCarData->turnLeft || Copy_pCarData->turnRight) && s_blinkOn);

    if (Copy_pCarData->state == (uint8)CS_LIMP_HOME)
        CHM_Play(CHM_PATTERN_LIMP_HOME);
    else if (s_overspeedActive)
        CHM_Play(CHM_PATTERN_OVERSPEED);
    else if (Local_u8TurnActive)
        CHM_Play(CHM_PATTERN_TURN_TICK);
    else
        CHM_Play(CHM_PATTERN_OFF);

    CHM_Update();
}

/* T-4  Task_Speed  100 ms  offset 2 - capture delta -> km/h, odometer carry */
static void Task_Speed(CarData_t *Copy_pCarData, DashCfg_t *Copy_pCfg)
{
    if (Copy_pCarData->state != (uint8)CS_OFF)
    {
        SPD_Task100ms(Copy_pCarData, Copy_pCfg); /* README S15: "Speed measured: Yes" everywhere but CS_OFF */
    }
    else
    {
        Copy_pCarData->speedKmh = 0u; /* README S15: "Speed measured: No" in CS_OFF */
    }

    if ((Copy_pCarData->speedKmh <= 250u) && (Copy_pCarData->speedKmh > Copy_pCfg->maxSpeedRecord))
    {
        Copy_pCfg->maxSpeedRecord = Copy_pCarData->speedKmh; /* all-time record (FR-16) */
    }

    App_UpdateChime(Copy_pCarData);
}

/* T-5  Task_Tacho  250 ms  offset 3 - close RPM window */
static void Task_Tacho(CarData_t *Copy_pCarData, const DashCfg_t *Copy_pCfg)
{
    TAC_Task250ms(Copy_pCarData, Copy_pCfg);
}

/* T-6  Task_LCD  250 ms  offset 5 - page repaint, per README S15's table */
static void Task_LCD(CarData_t *Copy_pCarData)
{
    char Local_Line1[17] = {0};
    char Local_Line2[17] = {0};

    if (Copy_pCarData->state == (uint8)CS_OFF)
    {
        s_offTicks250++;
        if (s_offTicks250 <= 40u) /* README S15: "Odometer 10 s then blank" (10 s / 250 ms = 40) */
        {
            if (!s_lcdBacklightOn)
            {
                LCD_SetBacklight(LCD_BACKLIGHT_ON);
                s_lcdBacklightOn = 1u;
            }
            snprintf(Local_Line1, sizeof(Local_Line1), "ODO:%lu m", (unsigned long)Copy_pCarData->odoMetres);
            snprintf(Local_Line2, sizeof(Local_Line2), "KEY OFF");
            DSP_Render(PG_MAIN, (const uint8 *)Local_Line1, (const uint8 *)Local_Line2);
        }
        else if (s_lcdBacklightOn)
        {
            LCD_SetBacklight(LCD_BACKLIGHT_OFF);
            LCD_Clear();
            s_lcdBacklightOn = 0u;
        }
        return;
    }

    s_offTicks250 = 0u; /* leaving CS_OFF re-arms the 10 s window for next time */
    if (!s_lcdBacklightOn)
    {
        LCD_SetBacklight(LCD_BACKLIGHT_ON);
        s_lcdBacklightOn = 1u;
    }

    switch ((ClusterState_t)Copy_pCarData->state)
    {
        case CS_ACC:
            /* README S15: "Odometer + trip" */
            snprintf(Local_Line1, sizeof(Local_Line1), "ODO:%lu m", (unsigned long)Copy_pCarData->odoMetres);
            snprintf(Local_Line2, sizeof(Local_Line2), "TRIP:%lu m", (unsigned long)Copy_pCarData->tripMetres);
            DSP_Render(PG_MAIN, (const uint8 *)Local_Line1, (const uint8 *)Local_Line2);
            return;

        case CS_BULBCHECK:
            snprintf(Local_Line1, sizeof(Local_Line1), "BULB CHECK");
            snprintf(Local_Line2, sizeof(Local_Line2), "ALL LAMPS ON");
            DSP_Render(PG_DIAG, (const uint8 *)Local_Line1, (const uint8 *)Local_Line2);
            return;

        case CS_CRANKING:
            snprintf(Local_Line1, sizeof(Local_Line1), "CRANKING...");
            snprintf(Local_Line2, sizeof(Local_Line2), "RPM:%u", Copy_pCarData->rpm);
            DSP_Render(PG_DIAG, (const uint8 *)Local_Line1, (const uint8 *)Local_Line2);
            return;

        case CS_STALLED:
            snprintf(Local_Line1, sizeof(Local_Line1), "ENGINE STOPPED");
            snprintf(Local_Line2, sizeof(Local_Line2), "PRESS START");
            DSP_Render(PG_DIAG, (const uint8 *)Local_Line1, (const uint8 *)Local_Line2);
            return;

        case CS_LIMP_HOME:
            snprintf(Local_Line1, sizeof(Local_Line1), "!! STOP ENGINE !!");
            snprintf(Local_Line2, sizeof(Local_Line2), "SPD:%u RPM:%u", Copy_pCarData->speedKmh, Copy_pCarData->rpm);
            DSP_Render(PG_DIAG, (const uint8 *)Local_Line1, (const uint8 *)Local_Line2);
            return;

        case CS_IGNITION:
        case CS_RUNNING:
        default:
            break; /* fall through to the normal per-page repaint below */
    }

    /* README S15: CS_IGNITION = "Page", CS_RUNNING = "Selected page" - the
       page the display-cycle / trip-reset buttons picked. */
    switch ((DisplayPage_t)Copy_pCarData->page)
    {
        case PG_TRIP:
            snprintf(Local_Line1, sizeof(Local_Line1), "TRIP:%lu m", (unsigned long)Copy_pCarData->tripMetres);
            snprintf(Local_Line2, sizeof(Local_Line2), "AVG:%u MAX:%u", Copy_pCarData->avgSpeedKmh, Copy_pCarData->maxSpeedKmh);
            break;
        case PG_ENGINE:
            snprintf(Local_Line1, sizeof(Local_Line1), "RPM:%u C:%dC", Copy_pCarData->rpm, Copy_pCarData->coolantC);
            snprintf(Local_Line2, sizeof(Local_Line2), "OIL:%u.%ubar", Copy_pCarData->oilBarX10 / 10u, Copy_pCarData->oilBarX10 % 10u);
            break;
        case PG_ELECTRICAL:
            snprintf(Local_Line1, sizeof(Local_Line1), "BAT:%u mV", Copy_pCarData->battmV);
            snprintf(Local_Line2, sizeof(Local_Line2), "ODO:%lu m", (unsigned long)Copy_pCarData->odoMetres);
            break;
        case PG_DIAG:
            snprintf(Local_Line1, sizeof(Local_Line1), "SPD:%u RPM:%u", Copy_pCarData->speedKmh, Copy_pCarData->rpm);
            snprintf(Local_Line2, sizeof(Local_Line2), "WARN:0x%04X", Copy_pCarData->warnMask);
            break;
        case PG_MAIN:
        default:
            snprintf(Local_Line1, sizeof(Local_Line1), "SPD:%3u KM/H", Copy_pCarData->speedKmh);
            snprintf(Local_Line2, sizeof(Local_Line2), "RPM:%u F:%u%%", Copy_pCarData->rpm, Copy_pCarData->fuelPct);
            break;
    }

    DSP_Render(Copy_pCarData->page, (const uint8 *)Local_Line1, (const uint8 *)Local_Line2);
}

/* T-7  Task_Gauges  500 ms  offset 4 - 4 ADC channels + filters */
static void Task_Gauges(CarData_t *Copy_pCarData)
{
    GAU_Update(Copy_pCarData);
}

/* T-8  Task_1Hz  1 s  offset 6 - trip timers (chime schedule: see Task_Speed) */
static void Task_1Hz(CarData_t *Copy_pCarData)
{
    if (Copy_pCarData->state != (uint8)CS_OFF)
    {
        Copy_pCarData->ignitionSec++;
        s_tripSeconds++;
    }

    Copy_pCarData->avgSpeedKmh = (s_tripSeconds > 0u)
        ? (uint16)((Copy_pCarData->tripMetres * 36UL) / (s_tripSeconds * 10UL))
        : 0u;
}

/* T-9  Task_Report  5 s  offset 8 - diagnostics frame */
static void Task_Report(void)
{
    Console_SendTelemetry();
}

/* T-10  Task_Console  20 ms  offset 7 - parse one line */
static void Task_Console(void)
{
    Console_ProcessCommand();
}

/* ===========================================================================
 *  main
 * ===========================================================================
 */
int main(void)
{
    CarData_t *CarData = NULL;
    DashCfg_t  cfg;
    uint32     tickCounter = 0u;

    /* README S16 flow step "Validate magic + checksum -> none valid ->
       Defaults, odo = 0": SimulIDE has no non-volatile memory, so there is
       never a saved config to validate - this always takes the "none
       valid" branch and starts from the README S10.2 compiled-in defaults. */
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
    CarData->page      = PG_MAIN;
    CarData->odoMetres = 0u;  /* README S16: "Zero the odometer and trip meters" */
    CarData->tripMetres = 0u;

    for (;;)
    {
        if (g_tick10ms)
        {
            g_tick10ms = 0u;
            tickCounter++;
            GPIO_SetPinValue(GPIO_PORTC, GPIO_PIN6, GPIO_HIGH); /* NFR-11 CPU-load probe */

            Task_Inputs(CarData); /* T-1, 10 ms, offset 0 */
            Task_FSM(CarData);    /* T-2, 10 ms, offset 0 */

            if ((tickCounter % 2u) == 1u)   Task_Console();          /* T-10, 20 ms,  offset 7 */
            if ((tickCounter % 5u) == 1u)   Task_Lamps(CarData, &cfg); /* T-3, 50 ms,  offset 1 */
            if ((tickCounter % 10u) == 2u)  Task_Speed(CarData, &cfg); /* T-4, 100 ms, offset 2 */
            if ((tickCounter % 25u) == 3u)  Task_Tacho(CarData, &cfg); /* T-5, 250 ms, offset 3 */
            if ((tickCounter % 25u) == 5u)  Task_LCD(CarData);         /* T-6, 250 ms, offset 5 */
            if ((tickCounter % 50u) == 4u)  Task_Gauges(CarData);      /* T-7, 500 ms, offset 4 */
            if ((tickCounter % 100u) == 6u) Task_1Hz(CarData);         /* T-8, 1 s,    offset 6 */
            if ((tickCounter % 500u) == 8u) Task_Report();             /* T-9, 5 s,    offset 8 */

            GPIO_SetPinValue(GPIO_PORTC, GPIO_PIN6, GPIO_LOW);
        }
    }

    return 0;
}