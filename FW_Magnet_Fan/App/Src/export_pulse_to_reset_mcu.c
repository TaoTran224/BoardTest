#include "main.h"
#include "tim.h"
#include "export_pulse_to_reset_mcu.h"
#include "board.h"

void Pulse_Reset_MCU(uint32_t pulse_width_us)
{
    HAL_GPIO_WritePin(OUT0_GPIO_Port, OUT0_Pin, GPIO_PIN_RESET);
    delay_us(pulse_width_us);
    HAL_GPIO_WritePin(OUT0_GPIO_Port, OUT0_Pin, GPIO_PIN_SET);
}