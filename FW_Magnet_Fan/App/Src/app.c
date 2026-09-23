
#include "app.h"
#include "interrupt.h"
#include "calculator.h"
#include "log.h"
#include "board.h"

#include "export_pulse_to_reset_mcu.h"
#include "crc16.h"
#include "stdlib.h"
#include "pwm.h"
#include "Pump.h"
#include "crc16.h"

Int_FlagInType State = {.au32Value = 0};
Int_FlagInType MaskState = {.au32Value = 0};

//UARTDataType RS485Ch1;
UARTDataType RS485Ch2;
//UARTDataType RS485Ch3;

OutputType Magnet;
MotorType Motor;

static CmdType Cmd;
static CmdResultType CmdRes;


static bool PWM_Flag_Start = false;
void RS485_SendBuffer(RS485ChannelType ch, uint8_t* buf, uint16_t len)
{
    HAL_UART_Transmit(&huart2, buf, len, (len << 1) + 10);
}

void RS485_SendStr(RS485ChannelType ch, char* str)
{
	RS485_SendBuffer(ch, (uint8_t*)str, strlen(str));
}


void MagnetRun(void)//out0
{
    if (MODE_ON == Magnet.eu8Mode)
    {
        HAL_GPIO_WritePin(GPIO_MAGNET, GPIO_MAGNET_PIN, GPIO_PIN_RESET);
    }
    else
    {
        HAL_GPIO_WritePin(GPIO_MAGNET, GPIO_MAGNET_PIN, GPIO_PIN_SET);
    }
}

static CmdType UART_GetCmd(uint8_t cmd)
{
    if (((uint8_t)CMD_CONTROL_MAGNET == cmd) || ((uint8_t)CMD_CONTROL_MOTOR == cmd))
    {
        return (CmdType)cmd;
    }
    return CMD_UNKNOWN;
}

void MotorRun(void)
{
    if (MODE_ON == Motor.eu8Mode)
    {
        HAL_GPIO_WritePin(GPIO_PWM, GPIO_PWM_PIN, GPIO_PIN_SET);
    }
    else if (MODE_OFF == Motor.eu8Mode)
    {
        HAL_GPIO_WritePin(GPIO_PWM, GPIO_PWM_PIN, GPIO_PIN_RESET);
    }
}

void MotorRandom(void)
{
    if (true == Motor.bRandom)
    { 
        if (Motor.u32TimeCycle <= (Motor.u32TimeRun++))
        {
            Motor.bRandom = false;
            Motor.bFlagCalTime = true;
            Motor.u32TimeRun = 0;
        }
    }
}

void MotorCalRandom(void)
{
    uint8_t duty;
    rando = Random(Speed_Random++)%100;
#ifdef DBG_SEND
    DBG_SendStr("MotorCalRandom\n");
    logLen = sprintf(log1, "rando = %d", rando);
    DBG_SendStr(log1);
#endif 
    if (20 > rando)
    {
        duty = 0; 
    }
    else if (80 < rando)
    {
        duty = 50;
    }
    else
    {
        duty = rando;
    }
    Motor.eu8Mode = MODE_PWM;  
  
    if (false == PWM_Flag_Start)
    {
#ifdef DBG_SEND
        DBG_SendStr("1ST PWM\n");
#endif
        PWM_Flag_Start = true;
    }
    else
    {
#ifdef DBG_SEND
        DBG_SendStr("2ND PWM\n");
#endif
        PWM_Stop();
    }
    delay_ms(2);
    PWM_Init(1000, duty);
    delay_ms(2); 
    PWM_Start();
  
  
    rando = Random(Speed_Random++)%100;
    if (5 > rando)
    {
        rando = 5;
    } 
    Motor.u32TimeCycle = (uint32_t)rando*(uint32_t)432;
    Motor.u32TimeRun = 0;
    Motor.bRandom = true;
    Motor.bFlagCalTime = false;
#ifdef DBG_SEND
    logLen = sprintf(log1, "rando = %d", rando);
    DBG_SendStr(log1);
#endif    
}

void PWM_SetFlag1st(void)
{
    if (false == PWM_Flag_Start)
    {
#ifdef DBG_SEND
        DBG_SendStr("1ST PWM\n");
#endif
        PWM_Flag_Start = true;
    }
    else
    {
#ifdef DBG_SEND
        DBG_SendStr("2ND PWM\n");
#endif
        PWM_Stop();
    }
}
static CmdType Board_UARTCheckFrameValid(CmdResultType* cmd_res, const uint8_t* src, const uint16_t src_len)
{
    uint16_t crc16_cal = 0;
    uint16_t crc16_rec = 0;

    CmdType cmd = CMD_UNKNOWN;
#ifdef DBG_SEND
    DBG_SendStr("Board_BLECheckFrameValid\n");
    DBG_SendBuffer(src, src_len);
    DBG_SendHexToStr(src, src_len);
#endif
    *cmd_res = CMD_RES_ERROR;
    if (6 > src_len)
    {
        *cmd_res = CMD_RES_ERROR;
        return CMD_UNKNOWN;
    }
    crc16_cal = crc16(src, src_len - 3); 
    memcpy(&crc16_rec, src + (uint16_t)(src_len - 3), 2);
    if (crc16_cal != crc16_rec)
    {
        *cmd_res = CMD_RES_CRC16_FAIL;
    }
    if (((7 <= src_len) && (src[2] != (src_len - 6))) || ((6 == src_len) && (0 != src[2])))
    {
        *cmd_res = CMD_RES_INVALID_PAYLOAD;
    }
    if ((SOH == src[0]) && (ETX == src[src_len - 1]))
    {
        cmd = UART_GetCmd(src[1]);
    }
	switch (cmd)
	{
        case CMD_PULSE_RESET:
            if ((10 == RS485Ch2.u8Len) && (4 == RS485Ch2.au8Buf[2]))
            {
                Pulse_Reset_MCU(RS485Ch2.au8Buf[3] | (uint32_t)RS485Ch2.au8Buf[4] << 8 | RS485Ch2.au8Buf[5] << 16 | RS485Ch2.au8Buf[6] << 24);
            }
            break;

        case CMD_CONTROL_MAGNET:
            if (8 == src_len)
            {   
                if (0 == src[4])
                {
#ifdef DBG_SEND
                    DBG_SendStr("Magnet OFF\n");
#endif
                    Magnet.eu8Mode = MODE_OFF;
                    *cmd_res = CMD_RES_SUCCESS;
                }
                else
                {
#ifdef DBG_SEND
                    DBG_SendStr("Magnet ON\n");
#endif
                    Magnet.eu8Mode = MODE_ON;
                    *cmd_res = CMD_RES_SUCCESS;
                }
            }
            return CMD_CONTROL_MAGNET;
            break;

        case CMD_CONTROL_MOTOR:
            if ( 100 < src[4])
            {
#ifdef DBG_SEND
                DBG_SendStr("CMD_CONTROL_MOTOR RANDOM\n");
#endif
                PWM_SetFlag1st();
                MotorCalRandom();
            }
            /*else if (0 == src[4])
            {
#ifdef DBG_SEND
                DBG_SendStr("MOTOR OFF\n");
#endif
                Motor.bRandom = false;
                Motor.eu8Mode = MODE_OFF;
                PWM_SetFlag1st();
            }
            else if (100 == src[4])
            {
#ifdef DBG_SEND
                DBG_SendStr("MOTOR ON\n");
#endif
                Motor.bRandom = false;
                Motor.eu8Mode = MODE_ON;
                PWM_SetFlag1st();
            }*/
            else
            {
#ifdef DBG_SEND
                DBG_SendStr("MOTOR PWM\n");
                logLen = sprintf(log1, " = %d\n", src[4]);
                DBG_SendStr(log1);
#endif
                Motor.bRandom = false;
                Motor.eu8Mode = MODE_PWM;
                PWM_SetFlag1st();
                delay_ms(2);
                PWM_Init(1000, src[4]);
                delay_ms(2); 
                PWM_Start();
            }
            *cmd_res = CMD_RES_SUCCESS;
            return CMD_CONTROL_MOTOR; 
            break;

        default:
             break;   
    }
}


static void Board_SendFrameToApp(CmdType cmd, CmdResultType cmd_res, uint8_t* payload, uint16_t len)
{

    uint8_t buf[64];
	uint8_t buf_len = len + 7;
	uint16_t crc;
#ifdef DBG_SEND
    DBG_SendStr("Board_SendFrameToApp\n");
#endif

	buf[0] = STX;
	buf[1] = cmd;
	buf[2] = cmd_res;
	buf[3] = len;
	memcpy(buf + 4, payload, len);
	crc = crc16(buf, buf_len - 3);
	memcpy(buf + buf_len - 3, &crc, 2);
	buf[buf_len - 1] = ETX;
#ifdef DBG_SEND
    DBG_SendHexToStr(buf, buf_len);
#endif
    RS485_SendBuffer(RS485_CH2, RS485Ch2.au8Buf, RS485Ch2.u8Len);
}


void RS485_CH2_Process(void)
{
	if (true == State.bits.S_PROCESS_RS485_CH2)
    {
 #ifdef DBG_SEND
        DBG_SendStr("RS485_CH2_Process\n");
#endif
        CmdType Cmd = CMD_RES_INVALID_COMMAND;
        CmdResultType CmdRes = CMD_RES_ERROR;
        CmdRes = CMD_RES_ERROR;
        Cmd = Board_UARTCheckFrameValid(&CmdRes, RS485Ch2.au8Buf, RS485Ch2.u8Len);
        Board_SendFrameToApp(Cmd, CmdRes, 0, 0);
        memset(&RS485Ch2, 0, sizeof(RS485Ch2));
        State.bits.S_PROCESS_RS485_CH2 = false;
    }
}


