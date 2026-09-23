#include <pwm.h>
#include "stm32f1xx_hal_gpio.h"
#include "tim.h"
#include "gpio.h"
#include "main.h"
#include "log.h"



void PWM_Init(uint16_t freq, uint8_t duty)
{
#ifdef DBG_SEND
      DBG_SendStr("PWM_Init\n");
#endif
    MX_TIM2_Init(duty*10);
    // Implementation for PWM initialization
    __HAL_TIM_SET_COMPARE(&htim2, TIME_CHANNEL_PWM, duty*10);
}

void PWM_Start(void)
{
    #ifdef DBG_SEND
      DBG_SendStr("PWM_Start\n");
#endif
  HAL_TIM_PWM_Start(&htim2, TIME_CHANNEL_PWM);
}

void PWM_Stop(void)
{
    // Implementation for stopping PWM
 #ifdef DBG_SEND
      DBG_SendStr("PWM_Stop\n");
#endif
    HAL_TIM_PWM_Stop(&htim2, TIME_CHANNEL_PWM);
    HAL_GPIO_WritePin(GPIO_PWM, GPIO_PWM_PIN, GPIO_PIN_SET);
}

void PWM_DeInit(void)
{
#ifdef DBG_SEND
      DBG_SendStr("PWM_DeInit\n");
#endif
    HAL_TIM_Base_MspDeInit(&htim2);
}