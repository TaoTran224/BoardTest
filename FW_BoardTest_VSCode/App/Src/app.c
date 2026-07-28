
#include "app.h"
#include "interrupt.h"
#include "calculator.h"
#include "log.h"
#include "board.h"

Int_FlagInType State = {.au32Value = 0};
Int_FlagInType MaskState = {.au32Value = 0};

UARTDataType RS485Ch1;
UARTDataType RS485Ch3;

uint8_t Lora_u8Seq;

bool Flag_Broken = false;
bool Flag_BilletJamp = false;

void RS485_SendBuffer(RS485ChannelType ch, uint8_t* buf, uint16_t len)
{
	if (RS485_CH1 == ch)
	{
		HAL_GPIO_WritePin(ENB_485_1_GPIO_Port, ENB_485_1_Pin, GPIO_PIN_SET);
	}
	else if (RS485_CH3 == ch)
	{
		HAL_GPIO_WritePin(ENB_485_3_GPIO_Port, ENB_485_3_Pin, GPIO_PIN_SET);
	}
    HAL_Delay(1);
	if (RS485_CH1 == ch)
	{
		 HAL_UART_Transmit(&huart1, buf, len, len + 10);
	}
	else if (RS485_CH3 == ch)
	{
		 HAL_UART_Transmit(&huart3, buf, len, len + 10);
	}
    HAL_Delay(1);
	if (RS485_CH1 == ch)
	{
		HAL_GPIO_WritePin(ENB_485_1_GPIO_Port, ENB_485_1_Pin, GPIO_PIN_RESET);
	}
	else if (RS485_CH3 == ch)
	{
		HAL_GPIO_WritePin(ENB_485_3_GPIO_Port, ENB_485_3_Pin, GPIO_PIN_RESET);
	}
}

void RS485_SendStr(RS485ChannelType ch, char* str)
{
	RS485_SendBuffer(ch, (uint8_t*)str, strlen(str));
}


void RS485_CH1_Process(void)
{
	if (true == State.bits.S_PROCESS_RS485_CH1)
	{
#if defined (DBG_SEND)
		DBG_SendStr("RS485_CH1_Process\n");
		DBG_SendBuffer(RS485Ch1.au8Buf, RS485Ch1.u8Len);
#endif
        RS485_SendStr(RS485_CH1, "Return CH1\n");
		RS485_SendBuffer(RS485_CH1, RS485Ch1.au8Buf, RS485Ch1.u8Len);
		memset(&RS485Ch1, 0, sizeof(RS485Ch1));
		State.bits.S_PROCESS_RS485_CH1 = false;
	}
}

void RS485_CH3_Process(void)
{
	if (true == State.bits.S_PROCESS_RS485_CH3)
	{
#if defined (DBG_SEND)
		DBG_SendStr("RS485_CH3_Process\n");
		DBG_SendBuffer(RS485Ch3.au8Buf, RS485Ch3.u8Len);
#endif
		RS485_SendStr(RS485_CH3, "Return CH3\n");
		RS485_SendBuffer(RS485_CH3, RS485Ch3.au8Buf, RS485Ch3.u8Len);
		memset(&RS485Ch3, 0, sizeof(RS485Ch3));
		State.bits.S_PROCESS_RS485_CH3 = false;
	}
}
