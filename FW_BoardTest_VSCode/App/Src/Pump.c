#include "Pump.h"
#include "board.h"
#include "stdlib.h"
#include "log.h"
volatile uint8_t rando;
volatile uint32_t Speed_Random=0x12345678;

void OutputRun(uint8_t seq, bool on_off)
{
    if (true == on_off)
    {
        HAL_GPIO_WritePin(OutputP[seq].GPIO, OutputP[seq].GPIO_Pin, GPIO_PIN_RESET);
    }
    else
    {
        HAL_GPIO_WritePin(OutputP[seq].GPIO, OutputP[seq].GPIO_Pin, GPIO_PIN_SET);
    }
}

void OutputDisplay(void)
{
    uint8_t i;
    for (i = 0; i < 3; i++)
    {
        if (true == OutputP[i].bFlagStart)
        {
            if (OutputP[i].u32TimeOn >= (OutputP[i].u32TimeOnRun++))
            {
                OutputRun(i, 1);
            }
            else
            {
                OutputRun(i, 0);
            }
            if (OutputP[i].u32TimeOnRun >= OutputP[i].u32TimeCycle)
            {
                OutputP[i].u32TimeOnRun = 0;
                OutputP[i].bFlagStart = false;
                OutputP[i].bFlagCalTime = true;  
            }
        }
    }
}

uint8_t Random(uint8_t random)
{
    unsigned rvar=0;
    srand(random);
    rvar=(uint8_t)rand();
    return rvar;
}

void OutputCalTime(void)
{
    uint8_t i = 0;
    for (i = 0; i < 3; i++)
    {
        if (true == OutputP[i].bFlagCalTime)
        {
            rando =  Random(Speed_Random++);
            OutputP[i].u32TimeOn = (uint32_t)1987 + (uint32_t)rando*(uint32_t)567; //357
#if defined (DBG_SEND)
            memset(log1, 0, sizeof(log1));
            DBG_SendStr("OutputCalTime\n");
            logLen = sprintf(log1, "Output=%d, u32TimeOn=%d, ", i, rando);
            DBG_SendStr(log1);
#endif
            rando =  Random(Speed_Random++);
            OutputP[i].u32TimeCycle = OutputP[i].u32TimeOn + (uint32_t)rando*(uint32_t)567 + (uint32_t)2345;
#if defined (DBG_SEND)
            logLen = sprintf(log1, "u32TimeCycle=%d\n", rando);
            DBG_SendStr(log1);
#endif
            OutputP[i].bFlagStart = true;
            OutputP[i].bFlagCalTime = false;              
        }
    } 

}