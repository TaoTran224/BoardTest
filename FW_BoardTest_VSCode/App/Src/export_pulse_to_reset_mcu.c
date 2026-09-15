#include "main.h"
#include "tim.h"
#include "export_pulse_to_reset_mcu.h"
#include "board.h"

void Pulse_Reset_MCU(uint32_t pulse_width_us)
{
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_0, GPIO_PIN_RESET);
    delay_us(pulse_width_us);
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_0, GPIO_PIN_SET);
}