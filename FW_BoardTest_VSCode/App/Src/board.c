

#include <board.h>
#include "main.h"
#include "adc.h"
#include "iwdg.h"
#include "tim.h"
#include "usart.h"
#include "gpio.h"
#include "log.h"

uint8_t recUART1;
uint8_t recUART2;
uint8_t recUART3;

OutputType OutputN[OUTPUT_MAX];
OutputType OutputP[OUTPUT_MAX];

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};
  RCC_PeriphCLKInitTypeDef PeriphClkInit = {0};

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_LSI|RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.HSEPredivValue = RCC_HSE_PREDIV_DIV1;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.LSIState = RCC_LSI_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLMUL = RCC_PLL_MUL6;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_1) != HAL_OK)
  {
    Error_Handler();
  }
  PeriphClkInit.PeriphClockSelection = RCC_PERIPHCLK_ADC;
  PeriphClkInit.AdcClockSelection = RCC_ADCPCLK2_DIV8;
  if (HAL_RCCEx_PeriphCLKConfig(&PeriphClkInit) != HAL_OK)
  {
    Error_Handler();
  }
}

void SetupInit(void)
{
}

void StartUp(void)
{

	/* USER CODE BEGIN 1 */

	/* USER CODE END 1 */

	/* MCU Configuration--------------------------------------------------------*/

	/* Reset of all peripherals, Initializes the Flash interface and the Systick. */
	HAL_Init();

	/* USER CODE BEGIN Init */

	/* USER CODE END Init */

	/* Configure the system clock */
	SystemClock_Config();

	/* USER CODE BEGIN SysInit */

	/* USER CODE END SysInit */

	/* Initialize all configured peripherals */
	MX_GPIO_Init();
	//MX_ADC1_Init();

	for (uint8_t i = 0; i < 10; i++)
	{
	  HAL_GPIO_WritePin(LED_RUN_GPIO_Port, LED_RUN_Pin, GPIO_PIN_RESET);
	  HAL_Delay(100);
	  HAL_GPIO_WritePin(LED_RUN_GPIO_Port, LED_RUN_Pin, GPIO_PIN_SET);
	  HAL_Delay(400);
	}

	//MX_IWDG_Init();
	MX_TIM1_Init();
	//MX_TIM2_Init();
	//MX_TIM3_Init();
	//MX_TIM4_Init();

	HAL_TIM_Base_Start_IT(&htim1);
	//HAL_TIM_Base_Start_IT(&htim2);
	//HAL_TIM_Base_Start_IT(&htim3);
	//HAL_TIM_Base_Start_IT(&htim4);

	MX_USART1_UART_Init();
	MX_USART2_UART_Init();
	MX_USART3_UART_Init();
	/* USER CODE BEGIN 2 */
    HAL_UART_Receive_IT(&huart1, &recUART1, 1);
    HAL_UART_Receive_IT(&huart2, &recUART2, 1);
	HAL_UART_Receive_IT(&huart3, &recUART3, 1);
	/* USER CODE END 2 */

	/* Infinite loop */
	/* USER CODE BEGIN WHILE */
}

void delay_us(uint32_t t)
{
    uint32_t i = 0;
    for ( i = 0; i < (6 * t); i++)
    {
        ;;

    }

}

void delay_ms(uint32_t t)
{
    uint32_t i = 0;
    for ( i = 0; i < (6600 * t); i++)
    {
        ;;

    }

}


void WDT_Clear(void)
{
	//HAL_IWDG_Refresh(&hiwdg);
}

void OutputN_Init(void)
{
    memset(OutputN, 0, sizeof(OutputN));
    OutputN[0].GPIO_Pin = OUT_N_0_Pin;
    OutputN[0].GPIO = OUT_N_0_GPIO_Port;
    OutputN[1].GPIO_Pin = OUT_N_1_Pin;
    OutputN[1].GPIO = OUT_N_1_GPIO_Port;
    OutputN[2].GPIO_Pin = OUT_N_2_Pin;
    OutputN[2].GPIO = OUT_N_2_GPIO_Port;
    OutputN[3].GPIO_Pin = OUT_N_3_Pin;
    OutputN[3].GPIO = OUT_N_3_GPIO_Port;
}

void OutputP_Init(void)
{
    memset(OutputP, 0, sizeof(OutputP));
    OutputP[0].GPIO_Pin = OUT_P_0_Pin;
    OutputP[0].GPIO = OUT_P_0_GPIO_Port;
    OutputP[1].GPIO_Pin = OUT_P_1_Pin;
    OutputP[1].GPIO = OUT_P_1_GPIO_Port;
    OutputP[2].GPIO_Pin = OUT_P_2_Pin;
    OutputP[2].GPIO = OUT_P_2_GPIO_Port;
    OutputP[3].GPIO_Pin = OUT_P_3_Pin;
    OutputP[3].GPIO = OUT_P_3_GPIO_Port;
  }
