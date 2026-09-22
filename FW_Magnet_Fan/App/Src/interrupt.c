
#include "interrupt.h"
#include "board.h"
#include "log.h"
#include "inc_def.h"
#include "Pump.h"
#include "app.h"

volatile uint16_t LED_Blink = 0;


void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef* htim)
{
	if (htim->Instance == htim1.Instance) //1ms
	{
        if (900 <= (LED_Blink++))
        {
            HAL_GPIO_WritePin(LED_RUN_GPIO_Port, LED_RUN_Pin, GPIO_PIN_RESET);
		}
        if (1000 <= LED_Blink)
        {
			HAL_GPIO_WritePin(LED_RUN_GPIO_Port, LED_RUN_Pin, GPIO_PIN_SET);
            LED_Blink = 0;
        }
        Speed_Random++;
		if ((true == RS485Ch2.bFlagRec) && (false == State.bits.S_PROCESS_RS485_CH2))
        {
            if (100 <= RS485Ch2.u16Timeout++)
            {
            	RS485Ch2.bFlagRec = false;
                State.bits.S_PROCESS_RS485_CH2 = true;
            }
        }
        if (true == State.bits.S_CONTROL_PUMP)
        {
            OutputDisplay();
        }
        Speed_Random++;
        MotorRandom();
        MagnetRun();
        MotorRun();
    }
	else if (htim->Instance == htim2.Instance) // 10ms
	{

	}
	else if (htim->Instance == htim4.Instance)
	{

	}
}


void HAL_UART_RxCpltCallback(UART_HandleTypeDef* huart)
{
    if (huart->Instance == USART1)
	{
		HAL_UART_Receive_IT(&huart1, &recUART1, 1);
	}
    else if (huart->Instance == USART2) //DBG
	{
        if (false == State.bits.S_PROCESS_RS485_CH2)
        {
            RS485Ch2.au8Buf[RS485Ch2.u8Len++] = recUART2;
            RS485Ch2.u16Timeout = 0;
            RS485Ch2.bFlagRec = true;
            if (UART_MAX_LEN <= RS485Ch2.u8Len)
            {
                memset(&RS485Ch2.au8Buf, 0, sizeof(RS485Ch2.au8Buf));
                RS485Ch2.u8Len = 0;
            }
        }
		HAL_UART_Receive_IT(&huart2, &recUART2, 1);
	}
    else if (huart->Instance == USART3)
	{
		HAL_UART_Receive_IT(&huart3, &recUART3, 1);
	}
}


