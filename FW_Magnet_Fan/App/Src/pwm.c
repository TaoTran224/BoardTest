#include <pwm.h>
#include "tim.h"
#include "gpio.h"
#include "main.h"

void PWM_Init(uint16_t freq, uint8_t duty)
{
    (void)freq;
    (void)duty;

    MX_TIM2_Init();
    // Implementation for PWM initialization
    // __HAL_TIM_SET_COMPARE(&htim2, TIM_CHANNEL_1, 500);
    __HAL_TIM_SET_COMPARE(&htim2, TIM_CHANNEL_2, 500);
}

void PWM_Start(void)
{
  //HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_1);
  HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_2);
}

void PWM_Stop(void)
{
    // Implementation for stopping PWM
    //HAL_TIM_PWM_Stop(&htim2, TIM_CHANNEL_1);
    HAL_TIM_PWM_Stop(&htim2, TIM_CHANNEL_2);
    HAL_GPIO_WritePin(OUT0_GPIO_Port, OUT0_Pin, GPIO_PIN_SET);
}

void PWM_DeInit(void)
{
    //HAL_TIM_PWM_Stop(&htim2, TIM_CHANNEL_1);
    HAL_TIM_PWM_Stop(&htim2, TIM_CHANNEL_2);

    if (HAL_TIM_PWM_DeInit(&htim2) != HAL_OK)
    {
        Error_Handler();
    }
}