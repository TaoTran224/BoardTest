
#include "log.h"
#include "usart.h"
#include <string.h>

char log1[LOG_MAX_SIZE];
uint8_t logLen;
uint16_t logTime;


void DBG_SendBuffer(uint8_t *buf, const uint16_t len)
{
    HAL_UART_Transmit(&huart2, buf, len, len);

//    HAL_GPIO_WritePin(RS485_ENB_GPIO_Port, RS485_ENB_Pin, GPIO_PIN_SET);
//    HAL_Delay(1);
//    HAL_UART_Transmit(&huart3, buf, len, len + 10);
//    HAL_Delay(4);
//    HAL_GPIO_WritePin(RS485_ENB_GPIO_Port, RS485_ENB_Pin, GPIO_PIN_RESET);
}

void DBG_SendStr(const char* str)
{
	DBG_SendBuffer((uint8_t*)str, strlen(str));

	//    HAL_GPIO_WritePin(RS485_ENB_GPIO_Port, RS485_ENB_Pin, GPIO_PIN_SET);
//    HAL_Delay(1);
//    HAL_UART_Transmit(&huart3, (uint8_t*)str, strlen(str), strlen(str) + 10);
//    HAL_Delay(4);
//    HAL_GPIO_WritePin(RS485_ENB_GPIO_Port, RS485_ENB_Pin, GPIO_PIN_RESET);

}
void ConvertHexToStr(uint8_t* ch, uint8_t hex)
{
	if (9 >= (hex>>4))
	{
		ch[0] = (hex>>4) + 0x30;
	}
	else
	{
		ch[0] = (hex>>4) + 0x37;
	}
	if (9 >= (0x0F & hex))
	{
		ch[1] = (0x0F & hex) + 0x30;
	}
	else
	{
		ch[1] = (0x0F & hex) + 0x37;
	}
}

void DBG_SendHexToStr(uint8_t* buf, uint16_t len)
{
	uint8_t str[3] = {0,0,0x20};//0x20:space
	DBG_SendStr("\nHEX[");
	for (uint16_t i = 0; i < len; i++)
	{
		ConvertHexToStr(str, buf[i]);
		if ((len - 1) == i)
		{
			DBG_SendBuffer(str, sizeof(str) - 1);
			break;
		}
		DBG_SendBuffer(str, sizeof(str));
	}
	DBG_SendStr("]ENDHEX\n");
}
