
#ifndef __BOARD_H_

#define __BOARD_H_


#include "main.h"
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "board.h"

#include "adc.h"
#include "gpio.h"
#include "iwdg.h"
#include "tim.h"
#include "usart.h"

#define BUTTON_MAX (uint8_t)8
#define OUTPUT_MAX (uint8_t)4
#define TIME_SHORT_CIRCUIT (uint32_t)60000
#define TIME_BROKEN TIME_SHORT_CIRCUIT
#define BEACON_MAX_LEN (uint16_t)(20)

#define ADDR_MASTER (uint8_t)(0xF0)
#define ADDR_SLAVE (uint8_t)(0x0C)
#define ADDR_FULL (uint8_t)(0xFC)


typedef struct
{
    uint16_t GPIO_Pin;
    GPIO_TypeDef *GPIO;
} __attribute__((packed)) ButtonInfType;

extern ButtonInfType ButtonInf[BUTTON_MAX];




typedef enum
{
M_OFF = (uint8_t)0,
M_ON = (uint8_t)1,
M_BLINK = (uint8_t)2,
} OutputModeType;

typedef struct
{
    uint16_t GPIO_Pin;
    GPIO_TypeDef *GPIO;
    GPIO_PinState PinState;
    OutputModeType eu8Mode;
    uint8_t timeout;
} __attribute__((packed)) OutputType;
extern OutputType OutputN[OUTPUT_MAX];
extern OutputType OutputP[OUTPUT_MAX];

extern uint8_t recUART1;
extern uint8_t recUART2;
extern uint8_t recUART3;

void StartUp(void);

void delay_us(uint32_t t);

void delay_ms(uint32_t t);

void SetupInit(void);
void WDT_Clear(void);
void Pulse(void);
#endif
