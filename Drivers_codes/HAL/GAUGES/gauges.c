#include "gauges.h"
#include "ADC_interface.h"
#include"STD_TYPES.h"

/* ADC Channel definitions based on the Pin Map[cite: 1] */
#define GAU_CH_FUEL     ADC_CHANNEL_0
#define GAU_CH_COOLANT  ADC_CHANNEL_1
#define GAU_CH_BATT     ADC_CHANNEL_2
#define GAU_CH_OIL      ADC_CHANNEL_3

static uint16 Fuel_Buffer[8] = {0};
static uint16 Coolant_Buffer[8] = {0};
static uint8 Filter_Idx = 0;

/* عدادات أخطاء فحص الصلاحية (Plausibility Check) - 5 ثوانٍ */
static uint8 ErrCount_Fuel = 0;
static uint8 ErrCount_Coolant = 0;
static uint8 ErrCount_Batt = 0;
static uint8 ErrCount_Oil = 0;

/* دالة فحص الصلاحية: لو القراءة علقت على 0 أو 1023 لفترة تتراكم الخطأ */
static uint8 Check_Plausibility(uint16 raw, uint8 *err_count) {
    if (raw == 0 || raw == 1023) {
        (*err_count)++;
        if (*err_count >= 10) { /* 10 دورات تقريبا = 5 ثواني */
            *err_count = 10;
            return E_NOK; /* قراءة غير صالحة */
        }
    } else {
        *err_count = 0; /* إعادة تعيين لو رجعت قراءة طبيعية */
    }
    return E_OK; /* قراءة صالحة */
}

void GAU_Init(void) {
    /* تهيئة الـ ADC (تأكد أن الـ Reference متوافق مع هاردوير SimulIDE لديك، مثل AVCC أو AREF) */
    ADC_Init(ADC_REF_AVCC, ADC_PRESC_64);
}

void GAU_Update(CarData_t *CarData) {
    uint16 raw_fuel = 0, raw_coolant = 0, raw_batt = 0, raw_oil = 0;
    uint32 sum_fuel = 0, sum_coolant = 0;
    uint8 i;
    
    /* قراءة القنوات الأربعة للـ ADC بنجاح */
    ADC_ReadChannel(GAU_CH_FUEL, &raw_fuel);
    ADC_ReadChannel(GAU_CH_COOLANT, &raw_coolant);
    ADC_ReadChannel(GAU_CH_BATT, &raw_batt);
    ADC_ReadChannel(GAU_CH_OIL, &raw_oil);

    /* 1. فحص الصلاحية (Plausibility Checks) */
    uint8 fuel_ok = Check_Plausibility(raw_fuel, &ErrCount_Fuel);
    uint8 cool_ok = Check_Plausibility(raw_coolant, &ErrCount_Coolant);
    uint8 batt_ok = Check_Plausibility(raw_batt, &ErrCount_Batt);
    uint8 oil_ok  = Check_Plausibility(raw_oil, &ErrCount_Oil);

    /* تفعيل لمبة Check Engine لو أي حساس جاب خطأ (E_NOK = 1) */
    if ((fuel_ok == E_NOK) || (cool_ok == E_NOK) || (batt_ok == E_NOK) || (oil_ok == E_NOK)) {
        CarData->warnMask |= (1 << WARN_CHECK); 
    } else {
        CarData->warnMask &= ~(1 << WARN_CHECK); 
    }

    /* 2. تطبيق فلتر المتوسط المتحرك (Moving Average) للبنزين والحرارة */
    Fuel_Buffer[Filter_Idx] = raw_fuel;
    Coolant_Buffer[Filter_Idx] = raw_coolant;
    Filter_Idx = (Filter_Idx + 1) % 8;
    
    for (i = 0; i < 8; i++) {
        sum_fuel += Fuel_Buffer[i];
        sum_coolant += Coolant_Buffer[i];
    }
    raw_fuel = sum_fuel / 8;
    raw_coolant = sum_coolant / 8;

    /* 3. حساب المعادلات التحويلية (Scaling) وتخزينها في CarData */
    if (fuel_ok == E_OK) {
        CarData->fuelPct = (uint8)(((uint32)raw_fuel * 100) / 1023);
    }
    
    if (cool_ok == E_OK) {
        CarData->coolantC = (uint16)((((uint32)raw_coolant * 170) / 1023) - 40);
    }
    
    if (batt_ok == E_OK) {
       CarData->battmV = (uint16)(((uint32)raw_batt * 16) / 1023);
    }
    
    if (oil_ok == E_OK) {
        CarData->oilBarX10 = (uint8)(((uint32)raw_oil * 100) / 1023);
    }
}
