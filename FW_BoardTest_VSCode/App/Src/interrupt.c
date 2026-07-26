
#include "interrupt.h"
#include "board.h"
#include "log.h"
#include "inc_def.h"


volatile uint16_t LED_Blink = 0;


void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef* htim)
{
	if (htim->Instance == htim1.Instance) //1ms
	{
        /*if (900 <= (LED_Blink++))
        {
            HAL_GPIO_WritePin(LED_RUN_GPIO_Port, LED_RUN_Pin, GPIO_PIN_RESET);
		}
        if (1000 <= LED_Blink)
        {
			HAL_GPIO_WritePin(LED_RUN_GPIO_Port, LED_RUN_Pin, GPIO_PIN_SET);
            LED_Blink = 0;
        }*/

		if ((true == RS485Ch1.bFlagRec) && (false == State.bits.S_PROCESS_RS485_CH1))
        {
            if (30 <= RS485Ch1.u16Timeout++)
            {
            	RS485Ch1.bFlagRec = false;
                State.bits.S_PROCESS_RS485_CH1 = true;
            }
        }

		if ((true == RS485Ch3.bFlagRec) && (false == State.bits.S_PROCESS_RS485_CH3))
        {
            if (30 <= RS485Ch3.u16Timeout++)
            {
            	RS485Ch3.bFlagRec = false;
                State.bits.S_PROCESS_RS485_CH1 = true;
            }
        }
	}
	else if (htim->Instance == htim2.Instance) // 10ms
	{
        Input_Detect();
        OutputP_Display();
        OutputN_Display();
        if (90 <= (LED_Blink++))
        {
            HAL_GPIO_WritePin(LED_RUN_GPIO_Port, LED_RUN_Pin, GPIO_PIN_RESET);
		}
        if (100 <= LED_Blink)
        {
			HAL_GPIO_WritePin(LED_RUN_GPIO_Port, LED_RUN_Pin, GPIO_PIN_SET);
            LED_Blink = 0;
        }
	}
	else if (htim->Instance == htim4.Instance)
	{

	}
}


void HAL_UART_RxCpltCallback(UART_HandleTypeDef* huart)
{
    if (huart->Instance == USART1)
	{
        if (false == State.bits.S_PROCESS_RS485_CH1)
        {
            RS485Ch1.au8Buf[RS485Ch1.u8Len++] = recUART1;
            RS485Ch1.u16Timeout = 0;
            RS485Ch1.bFlagRec = true;
            if (UART_MAX_LEN <= RS485Ch1.u8Len)
            {
                memset(&RS485Ch1.au8Buf, 0, sizeof(RS485Ch1.au8Buf));
                RS485Ch1.u8Len = 0;
            }
        }
		HAL_UART_Receive_IT(&huart1, &recUART1, 1);
	}
    else if (huart->Instance == USART2) //DBG
	{
        //if (false == State.bits.S_SEND_DBG)
        {

        }
		HAL_UART_Receive_IT(&huart2, &recUART2, 1);
	}
    else if (huart->Instance == USART3)
	{
        if (false == State.bits.S_PROCESS_RS485_CH3)
        {
            RS485Ch3.au8Buf[RS485Ch3.u8Len++] = recUART3;
            RS485Ch3.u16Timeout = 0;
            RS485Ch3.bFlagRec = true;
            if (UART_MAX_LEN <= RS485Ch3.u8Len)
            {
                memset(&RS485Ch3.au8Buf, 0, sizeof(RS485Ch3.au8Buf));
                RS485Ch3.u8Len = 0;
            }
        }
		HAL_UART_Receive_IT(&huart1, &recUART1, 3);
	}

}


