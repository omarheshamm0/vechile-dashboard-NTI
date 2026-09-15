# 0 "HAL/lcd_i2c/lcd_i2c.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/lcd_i2c/lcd_i2c.c"




# 1 "C:/avr-gcc/avr/include/util/delay.h" 1 3
# 49 "C:/avr-gcc/avr/include/util/delay.h" 3
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 1 3 4
# 9 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 3 4
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
# 1 "C:/avr-gcc/avr/include/stdint.h" 1 3 4
# 125 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef signed int int8_t __attribute__((__mode__(__QI__)));
typedef unsigned int uint8_t __attribute__((__mode__(__QI__)));
typedef signed int int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int uint16_t __attribute__ ((__mode__ (__HI__)));
typedef signed int int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int uint32_t __attribute__ ((__mode__ (__SI__)));

typedef signed int int64_t __attribute__((__mode__(__DI__)));
typedef unsigned int uint64_t __attribute__((__mode__(__DI__)));
# 146 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 163 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_least8_t;




typedef uint8_t uint_least8_t;




typedef int16_t int_least16_t;




typedef uint16_t uint_least16_t;




typedef int32_t int_least32_t;




typedef uint32_t uint_least32_t;







typedef int64_t int_least64_t;






typedef uint64_t uint_least64_t;
# 217 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_fast8_t;




typedef uint8_t uint_fast8_t;




typedef int16_t int_fast16_t;




typedef uint16_t uint_fast16_t;




typedef int32_t int_fast32_t;




typedef uint32_t uint_fast32_t;







typedef int64_t int_fast64_t;






typedef uint64_t uint_fast64_t;
# 277 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int64_t intmax_t;




typedef uint64_t uintmax_t;
# 12 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 2 3 4
#pragma GCC diagnostic pop
# 50 "C:/avr-gcc/avr/include/util/delay.h" 2 3
# 1 "C:/avr-gcc/avr/include/util/delay_basic.h" 1 3
# 37 "C:/avr-gcc/avr/include/util/delay_basic.h" 3
# 1 "C:/avr-gcc/avr/include/inttypes.h" 1 3
# 77 "C:/avr-gcc/avr/include/inttypes.h" 3
typedef int32_t int_farptr_t;





typedef uint32_t uint_farptr_t;
# 38 "C:/avr-gcc/avr/include/util/delay_basic.h" 2 3


static __inline__ void _delay_loop_1(uint8_t __count) __attribute__((__always_inline__));
static __inline__ void _delay_loop_2(uint16_t __count) __attribute__((__always_inline__));
# 80 "C:/avr-gcc/avr/include/util/delay_basic.h" 3
void
_delay_loop_1(uint8_t __count)
{
 __asm__ volatile (
  "1: dec %0" "\n\t"
  "brne 1b"
  : "=r" (__count)
  : "0" (__count)
 );
}
# 102 "C:/avr-gcc/avr/include/util/delay_basic.h" 3
void
_delay_loop_2(uint16_t __count)
{
# 113 "C:/avr-gcc/avr/include/util/delay_basic.h" 3
 __asm__ volatile (
  "1: sbiw %0,1" "\n\t"
  "brne 1b"
  : "+w" (__count)
 );

}
# 51 "C:/avr-gcc/avr/include/util/delay.h" 2 3
# 151 "C:/avr-gcc/avr/include/util/delay.h" 3
static __inline__ __attribute__((__always_inline__)) void _delay_ms(double __ms);

void
_delay_ms(double __ms)
{
 double __tmp ;


 uint32_t __ticks_dc;
 extern void __builtin_avr_delay_cycles(uint32_t);
 __tmp = ((
# 161 "C:/avr-gcc/avr/include/util/delay.h"
          8000000UL
# 161 "C:/avr-gcc/avr/include/util/delay.h" 3
               ) / 1e3) * __ms;
# 171 "C:/avr-gcc/avr/include/util/delay.h" 3
  __ticks_dc = (uint32_t)(__builtin_ceil(__builtin_fabs(__tmp)));


 __builtin_avr_delay_cycles(__ticks_dc);
# 197 "C:/avr-gcc/avr/include/util/delay.h" 3
}
# 234 "C:/avr-gcc/avr/include/util/delay.h" 3
static __inline__ __attribute__((__always_inline__)) void _delay_us(double __us);

void
_delay_us(double __us)
{
 double __tmp ;


 uint32_t __ticks_dc;
 extern void __builtin_avr_delay_cycles(uint32_t);
 __tmp = ((
# 244 "C:/avr-gcc/avr/include/util/delay.h"
          8000000UL
# 244 "C:/avr-gcc/avr/include/util/delay.h" 3
               ) / 1e6) * __us;
# 254 "C:/avr-gcc/avr/include/util/delay.h" 3
  __ticks_dc = (uint32_t)(__builtin_ceil(__builtin_fabs(__tmp)));


 __builtin_avr_delay_cycles(__ticks_dc);
# 281 "C:/avr-gcc/avr/include/util/delay.h" 3
}
# 6 "HAL/lcd_i2c/lcd_i2c.c" 2

# 1 "LIB/STD_TYPES.h" 1
# 11 "LIB/STD_TYPES.h"

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
# 8 "HAL/lcd_i2c/lcd_i2c.c" 2
# 1 "MCAL/I2C/I2C_interface.h" 1
# 32 "MCAL/I2C/I2C_interface.h"
STD_ReturnType I2C_InitMaster(uint32 Copy_u32SclHz);




STD_ReturnType I2C_SendStart(void);




STD_ReturnType I2C_SendRepeatedStart(void);




void I2C_SendStop(void);





STD_ReturnType I2C_SendSlaveAddressWithWrite(uint8 Copy_u8Address);
STD_ReturnType I2C_SendSlaveAddressWithRead(uint8 Copy_u8Address);




STD_ReturnType I2C_SendByte(uint8 Copy_u8Data);





STD_ReturnType I2C_ReceiveByte(uint8 *Copy_pu8Data, uint8 Copy_u8SendAck);
# 9 "HAL/lcd_i2c/lcd_i2c.c" 2
# 1 "HAL/lcd_i2c/lcd_i2c.h" 1
# 14 "HAL/lcd_i2c/lcd_i2c.h"
# 1 "LIB/dashboard_types.h" 1



# 1 "LIB/STD_TYPES.h" 1
# 5 "LIB/dashboard_types.h" 2

typedef struct {
    uint16 speedKmh;
    uint16 rpm;
    uint8 fuelPct;
    sint16 coolantC;
    uint16 battmV;
    uint8 oilBarX10;
    uint32 odoMetres;
    uint32 tripMetres;
    uint16 maxSpeedKmh;
    uint16 avgSpeedKmh;
    uint16 warnMask;
    uint8 lampByte;
    uint8 turnLeft : 1;
    uint8 turnRight : 1;
    uint8 highBeam : 1;
    uint8 handbrake : 1;
    uint8 seatbelt : 1;
    uint8 doorOpen : 1;
    uint8 engineRun : 1;
    uint8 limpHome : 1;
    uint8 state;
    uint8 page;
    uint32 ignitionSec;
} CarData_t;




typedef struct {
    uint16 magic;
    uint8 version;
    uint32 odoMetres;
    uint32 tripMetres;
    uint16 maxSpeedRecord;
    uint16 speedLimitKmh;
    uint8 fuelWarnPct;
    uint8 coolantWarnC;
    uint8 oilWarnBarX10;
    uint16 battLowmV;
    uint16 battHighmV;
    uint8 pulsesPerRev;
    uint16 wheelCircMm;
    uint8 tachPulsesPerRev;
    uint16 ignitionCycles;
    uint8 writeSlot;
    uint8 checksum;
} DashCfg_t;

typedef enum { CS_OFF = 0, CS_ACC, CS_IGNITION, CS_BULBCHECK,
               CS_CRANKING, CS_RUNNING, CS_LIMP_HOME,
               CS_STALLED } ClusterState_t;

typedef enum { WARN_NONE = 0, WARN_OIL, WARN_BATT, WARN_COOLANT,
               WARN_CHECK, WARN_FUEL, WARN_OVERSPEED,
               WARN_SEATBELT, WARN_DOOR, WARN_HANDBRAKE } Warn_t;

typedef enum { PG_MAIN = 0, PG_TRIP, PG_ENGINE, PG_ELECTRICAL,
               PG_DIAG } DisplayPage_t;

typedef enum { SPI_SLAVE_SWITCHES = 0, SPI_SLAVE_LAMPS } SpiSlave_t;

typedef struct {
    volatile uint16 lastIcr;
    volatile uint16 ovfCount;
    volatile uint32 deltaTicks;
    volatile uint8 fresh;
    uint16 stallTicks;
} Capture_t;
# 15 "HAL/lcd_i2c/lcd_i2c.h" 2
# 29 "HAL/lcd_i2c/lcd_i2c.h"
STD_ReturnType LCD_Init(void);
STD_ReturnType LCD_Clear(void);
STD_ReturnType LCD_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col);
STD_ReturnType LCD_WriteChar(uint8 Copy_u8Char);
STD_ReturnType LCD_WriteString(const uint8 *Copy_pu8String);
STD_ReturnType LCD_SetBacklight(uint8 Copy_u8State);
STD_ReturnType LCD_WriteNumber(uint32 Copy_u32Value);


STD_ReturnType DSP_Next(void);
STD_ReturnType DSP_Render(uint8 Copy_u8Page, const uint8 *Copy_pu8Line1, const uint8 *Copy_pu8Line2);
# 10 "HAL/lcd_i2c/lcd_i2c.c" 2
# 27 "HAL/lcd_i2c/lcd_i2c.c"
static uint8 Local_u8CurrentPage;
static uint8 Local_u8Backlight;

static void Local_WriteNibble(uint8 Copy_u8Nibble, uint8 Copy_u8IsCommand)
{
    uint8 Local_u8Data;
    uint8 Local_u8EnableByte;

    Local_u8Data = (uint8)((Copy_u8Nibble & 0x0Fu) << 4u);

    if (Copy_u8IsCommand == 0u)
    {
        Local_u8Data |= (uint8)(1u << 0u);
    }
    else
    {
        Local_u8Data &= (uint8)~(1u << 0u);
    }

    Local_u8Data |= (uint8)(Local_u8Backlight << 3u);


    Local_u8EnableByte = (uint8)(Local_u8Data | (1u << 2u));
    I2C_SendStart();
    I2C_SendSlaveAddressWithWrite(0x27u);
    I2C_SendByte(Local_u8EnableByte);
    I2C_SendStop();
    _delay_us(1u);


    I2C_SendStart();
    I2C_SendSlaveAddressWithWrite(0x27u);
    I2C_SendByte(Local_u8Data);
    I2C_SendStop();
    _delay_us(40u);
}

static void Local_WriteByte(uint8 Copy_u8Byte, uint8 Copy_u8IsCommand)
{
    Local_WriteNibble((uint8)(Copy_u8Byte >> 4u), Copy_u8IsCommand);
    Local_WriteNibble((uint8)(Copy_u8Byte & 0x0Fu), Copy_u8IsCommand);
}

static void Local_SendCommand(uint8 Copy_u8Command)
{
    Local_WriteByte(Copy_u8Command, 1u);
}

static void Local_SendData(uint8 Copy_u8Data)
{
    Local_WriteByte(Copy_u8Data, 0u);
}

STD_ReturnType LCD_Init(void)
{
    Local_u8CurrentPage = PG_MAIN;
    Local_u8Backlight = 1u;

    if (I2C_InitMaster(100000UL) == E_NOK)
    {
        return E_NOK;
    }

    _delay_ms(50u);


    Local_WriteNibble(0x03u, 1u);
    _delay_ms(5u);
    Local_WriteNibble(0x03u, 1u);
    _delay_us(150u);
    Local_WriteNibble(0x03u, 1u);
    Local_WriteNibble(0x02u, 1u);

    Local_SendCommand(0x28u);
    Local_SendCommand(0x0Cu);
    Local_SendCommand(0x06u);
    Local_SendCommand(0x01u);
    _delay_ms(2u);
    Local_SendCommand(0x02u);
    _delay_ms(2u);
    return E_OK;
}

STD_ReturnType LCD_Clear(void)
{
    Local_SendCommand(0x01u);
    _delay_ms(2u);
    return E_OK;
}

STD_ReturnType LCD_SetCursor(uint8 Copy_u8Row, uint8 Copy_u8Col)
{
    uint8 Local_u8Address;

    if ((Copy_u8Row >= 2u) || (Copy_u8Col >= 16u))
    {
        return E_NOK;
    }

    Local_u8Address = Copy_u8Col;
    if (Copy_u8Row == 1u)
    {
        Local_u8Address += 0x40u;
    }

    Local_SendCommand((uint8)(0x80u | Local_u8Address));
    return E_OK;
}

STD_ReturnType LCD_WriteChar(uint8 Copy_u8Char)
{
    Local_SendData(Copy_u8Char);
    return E_OK;
}

STD_ReturnType LCD_WriteString(const uint8 *Copy_pu8String)
{
    uint8 Local_u8Index;

    if (Copy_pu8String == (const uint8 *)0)
    {
        return E_NOK;
    }

    Local_u8Index = 0u;
    while (Copy_pu8String[Local_u8Index] != '\0')
    {
        Local_SendData(Copy_pu8String[Local_u8Index]);
        Local_u8Index++;
    }

    return E_OK;
}

STD_ReturnType LCD_SetBacklight(uint8 Copy_u8State)
{
    if (Copy_u8State > 1u)
    {
        return E_NOK;
    }

    Local_u8Backlight = Copy_u8State;
    return E_OK;
}

STD_ReturnType LCD_WriteNumber(uint32 Copy_u32Value)
{
    uint8 Local_u8Buffer[11];
    uint8 Local_u8Index = 0u;
    uint32 Local_u32Temp;

    if (Copy_u32Value == 0u)
    {
        Local_SendData('0');
        return E_OK;
    }

    Local_u32Temp = Copy_u32Value;
    while (Local_u32Temp != 0u)
    {
        Local_u8Buffer[Local_u8Index] = (uint8)('0' + (Local_u32Temp % 10u));
        Local_u32Temp /= 10u;
        Local_u8Index++;
    }

    while (Local_u8Index > 0u)
    {
        Local_u8Index--;
        Local_SendData(Local_u8Buffer[Local_u8Index]);
    }

    return E_OK;
}

STD_ReturnType DSP_Next(void)
{
    Local_u8CurrentPage = (uint8)((Local_u8CurrentPage + 1u) % 5u);
    return E_OK;
}

STD_ReturnType DSP_Render(uint8 Copy_u8Page, const uint8 *Copy_pu8Line1, const uint8 *Copy_pu8Line2)
{
    if ((Copy_u8Page > PG_DIAG) || (Copy_pu8Line1 == (const uint8 *)0) || (Copy_pu8Line2 == (const uint8 *)0))
    {
        return E_NOK;
    }

    LCD_Clear();
    LCD_SetCursor(0u, 0u);
    LCD_WriteString(Copy_pu8Line1);
    LCD_SetCursor(1u, 0u);
    LCD_WriteString(Copy_pu8Line2);
    Local_u8CurrentPage = Copy_u8Page;
    return E_OK;
}
