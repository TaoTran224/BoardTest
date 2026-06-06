/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2026 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32f1xx_hal.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
#define LED_RUN_Pin GPIO_PIN_13
#define LED_RUN_GPIO_Port GPIOC
#define OUT_P_0_Pin GPIO_PIN_4
#define OUT_P_0_GPIO_Port GPIOA
#define OUT_P_1_Pin GPIO_PIN_5
#define OUT_P_1_GPIO_Port GPIOA
#define OUT_P_2_Pin GPIO_PIN_6
#define OUT_P_2_GPIO_Port GPIOA
#define OUT_P_3_Pin GPIO_PIN_7
#define OUT_P_3_GPIO_Port GPIOA
#define OUT_N_0_Pin GPIO_PIN_0
#define OUT_N_0_GPIO_Port GPIOB
#define OUT_N_1_Pin GPIO_PIN_1
#define OUT_N_1_GPIO_Port GPIOB
#define ENB_485_3_Pin GPIO_PIN_12
#define ENB_485_3_GPIO_Port GPIOB
#define OUT_N_2_Pin GPIO_PIN_13
#define OUT_N_2_GPIO_Port GPIOB
#define OUT_N_3_Pin GPIO_PIN_14
#define OUT_N_3_GPIO_Port GPIOB
#define ENB_485_1_Pin GPIO_PIN_11
#define ENB_485_1_GPIO_Port GPIOA
#define INPUT_0_Pin GPIO_PIN_15
#define INPUT_0_GPIO_Port GPIOA
#define INPUT_1_Pin GPIO_PIN_3
#define INPUT_1_GPIO_Port GPIOB
#define INPUT_2_Pin GPIO_PIN_6
#define INPUT_2_GPIO_Port GPIOB
#define INPUT_3_Pin GPIO_PIN_7
#define INPUT_3_GPIO_Port GPIOB
#define INPUT_4_Pin GPIO_PIN_8
#define INPUT_4_GPIO_Port GPIOB
#define INPUT_5_Pin GPIO_PIN_9
#define INPUT_5_GPIO_Port GPIOB

/* USER CODE BEGIN Private defines */

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */
