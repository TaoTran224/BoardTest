#ifndef __PWM_H
#define __PWM_H

#include "main.h"
#include "stdint.h"

void PWM_Init(uint16_t freq, uint8_t duty);

void PWM_Start(void);

void PWM_Stop(void);
void PWM_DeInit(void);

#endif