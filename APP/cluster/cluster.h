#ifndef CLUSTER_H_
#define CLUSTER_H_

#include "STD_TYPES.h"
#include "dashboard_types.h"

/* --- Public Function Prototypes --- */

/* تهيئة نظام الـ Cluster وإعداد القيم الأولية */
void Cluster_Init(void);

/* الدالة الرئيسية التي تعمل داخل loop وتدير حالة السيارة وقراءة الحساسات */
void Cluster_Update(void);

/* إرجاع مؤشر لهيكل البيانات الرئيسي لاستخدامه في الـ Console والـ Telemetry */
CarData_t* Cluster_GetCarData(void);

/* تغيير الصفحة المعروضة على الشاشة */
void Cluster_SetPage(DisplayPage_t page);

#endif /* CLUSTER_H_ */