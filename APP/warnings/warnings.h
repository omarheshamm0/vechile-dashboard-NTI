#ifndef WARNINGS_H
#define WARNINGS_H

#include "STD_TYPES.h"
#include "dashboard_types.h"

void WRN_Update(CarData_t *CarData);
Warn_t WRN_Highest(const CarData_t *CarData);

#endif /* WARNINGS_H */