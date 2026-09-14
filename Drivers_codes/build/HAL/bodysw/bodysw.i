# 0 "HAL/bodysw/bodysw.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "HAL/bodysw/bodysw.c"
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
# 2 "HAL/bodysw/bodysw.c" 2
# 1 "MCAL/GPIO/GPIO_interface.h" 1
# 43 "MCAL/GPIO/GPIO_interface.h"
STD_ReturnType GPIO_SetPinDirection(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin, uint8 *Copy_pu8Value);




STD_ReturnType GPIO_TogglePinValue(uint8 Copy_u8Port, uint8 Copy_u8Pin);




STD_ReturnType GPIO_SetPortDirection(uint8 Copy_u8Port, uint8 Copy_u8Direction);




STD_ReturnType GPIO_SetPortValue(uint8 Copy_u8Port, uint8 Copy_u8Value);




STD_ReturnType GPIO_GetPortValue(uint8 Copy_u8Port, uint8 *Copy_pu8Value);
# 3 "HAL/bodysw/bodysw.c" 2
# 1 "MCAL/SPI/SPI_interface.h" 1
# 30 "MCAL/SPI/SPI_interface.h"
STD_ReturnType SPI_InitMaster(uint8 Copy_u8Prescaler);




STD_ReturnType SPI_InitSlave(void);





STD_ReturnType SPI_Transceive(uint8 Copy_u8Sent, uint8 *Copy_pu8Received);





STD_ReturnType SPI_TransmitByte(uint8 Copy_u8Sent);





STD_ReturnType SPI_Acquire(uint8 Copy_u8Owner);




void SPI_Release(void);
# 4 "HAL/bodysw/bodysw.c" 2
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
# 5 "HAL/bodysw/bodysw.c" 2
# 1 "HAL/bodysw/bodysw.h" 1
# 26 "HAL/bodysw/bodysw.h"
STD_ReturnType BSW_Init(void);


STD_ReturnType BSW_Read(uint8 *Copy_pu8SwitchMask);
# 6 "HAL/bodysw/bodysw.c" 2
# 15 "HAL/bodysw/bodysw.c"
STD_ReturnType BSW_Init(void)
{
    if (GPIO_SetPinDirection(1u, 4u, 1u) == E_NOK)
    {
        return E_NOK;
    }

    if (GPIO_SetPinValue(1u, 4u, 1u) == E_NOK)
    {
        return E_NOK;
    }

    return E_OK;
}
# 39 "HAL/bodysw/bodysw.c"
STD_ReturnType BSW_Read(uint8 *Copy_pu8SwitchMask)
{
    uint8 Local_u8ShiftedByte;
    uint8 Local_u8Mask;

    if (Copy_pu8SwitchMask == (uint8 *)0)
    {
        return E_NOK;
    }

    if (SPI_Acquire(SPI_SLAVE_SWITCHES) == E_NOK)
    {
        return E_NOK;
    }

    if (GPIO_SetPinValue(1u, 4u, 0u) == E_NOK)
    {
        SPI_Release();
        return E_NOK;
    }

    if (GPIO_SetPinValue(1u, 4u, 1u) == E_NOK)
    {
        SPI_Release();
        return E_NOK;
    }

    if (SPI_Transceive(0xFFu, &Local_u8ShiftedByte) == E_NOK)
    {
        SPI_Release();
        return E_NOK;
    }

    SPI_Release();


    Local_u8Mask = (uint8)(~Local_u8ShiftedByte);
    *Copy_pu8SwitchMask = Local_u8Mask;
    return E_OK;
}
