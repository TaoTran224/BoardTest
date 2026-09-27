
#include "Global.h"
#include "calculator.h"
#include "hardware_config.h"
#include "interrupt.h"
#include "app.h"

#include "log.h"


void main(void)
{
    HardwareInit();

    Reset_WDT();
    //=========================================
#ifdef DBG_SEND
    DBG_SendStr("START UP\n");
#endif
    Reset_WDT();
    #asm("sei")
    BoardState = S_RUN;  
    while (1)
    {
         Reset_WDT();
//		switch (BoardState)
//		{
//		case S_UART_PROCESS:
//			Board_UARTProcessRec();
//			break;
//		case S_RUN:
//            if (true == Motor.bFlagCalTime)
//            {
//                MotorCalRandom();
//            }
//			break;
//
//		default:
//			break;
//		}

        Pulse_Ouput();
        if (true == Motor.bFlagCalTime)
        {
            MotorCalRandom();
        }

    }
}