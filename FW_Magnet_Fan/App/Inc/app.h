
#ifndef _APP_H_
#define _APP_H_

#include "main.h"
#include "board.h"


#define UART_MAX_LEN (uint16_t)(100)

#define SOH (uint8_t)0x01
#define STX (uint8_t)0x02
#define ETX (uint8_t)0x03

typedef enum
{
RS485_CH1,
RS485_CH2,
RS485_CH3
} RS485ChannelType;
typedef struct
{
    uint8_t S_STARTUP : 1;
    uint8_t S_PROCESS_INPUT : 1;
    //uint8_t S_PROCESS_RS485_CH1 : 1;
    uint8_t S_PROCESS_RS485_CH2 : 1;
    //uint8_t S_PROCESS_RS485_CH3 : 1;
    uint8_t S_CONTROL_PUMP : 1;
} BITS;



typedef enum
{
    CMD_UNKNOWN = 0xFF,
CMD_CONTROL_MAGNET = 0xA0,
CMD_CONTROL_MOTOR = 0xA1,
CMD_PULSE_RESET = 0xA2,
} CmdType;


typedef enum
{
    CMD_RES_UNKNOWN = 0xFF,

    CMD_RES_SUCCESS = 0x00,
    CMD_RES_INVALID_COMMAND = 0x01,
    CMD_RES_CRC16_FAIL = 0x02,
    CMD_RES_INVALID_PAYLOAD = 0x03,
    CMD_RES_ERROR = 0x04
} CmdResultType;

typedef struct 
{
    bool bRandom;
    bool bFlagCalTime;
    uint32_t u32TimeRun;
    uint8_t u8Velocity;
    uint32_t u32TimeCycle;
    OutputModeType eu8Mode;
} MotorType;

extern MotorType Motor;
typedef union
{
    BITS bits;
    uint32_t au32Value;
} Int_FlagInType;

extern Int_FlagInType State;
extern Int_FlagInType MaskState;

typedef struct
{
    uint8_t au8Buf[UART_MAX_LEN];
    uint8_t u8Len;
    uint16_t u16Timeout;
    bool bFlagRec;
} __attribute__((packed)) UARTDataType;

//extern UARTDataType RS485Ch1;
extern UARTDataType RS485Ch2;
//extern UARTDataType RS485Ch3;

extern uint8_t Lora_u8Seq;

extern bool Flag_Broken;
extern bool Flag_BilletJamp;

void RS485_SendBuffer(RS485ChannelType ch, uint8_t* buf, uint16_t len);
void RS485_SendStr(RS485ChannelType ch, char* str);

void RS485_CH2_Process(void);
void MotorRandom(void);
void MagnetRun(void);
void MotorRun(void);
#endif
