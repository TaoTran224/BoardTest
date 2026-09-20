#ifndef _PUMP_H
#define _PUMP_H

#include "stdlib.h"
#include "stdint.h"

extern volatile uint8_t rando;
extern volatile uint32_t Speed_Random;

void OutputDisplay(void);
void OutputCalTime(void);
#endif /* _PUMP_H */