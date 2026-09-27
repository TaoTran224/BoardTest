#ifndef _HARDWARE_CONFIG_H
#define _HARDWARE_CONFIG_H

#include "Global.h"
#include <mega64.h>

#define GDO0          PIND.1  
#define GDO2          PIND.0 
 
#define GDO1          PINB.3
#define MISO          PINB.3
#define MOSI  		PORTB.2



//TE RE of X6, HPC V1
#define RE_X6 		PORTB.5 
#define TE_X6 		PORTB.4 
#define nSEL 		PORTB.0

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

#define POWER_ON    0
#define POWER_OFF   1

#define POWER_MSP_X6        PORTA.5
#define POWER_MSP_EKEMP     PORTB.6
#define POWER_MSP_G4_HH     PORTA.3 //nguoc muc so voi cac SCH truoc: 0: bat, 1:tat

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

//void LEDRedOn(void);
//void LEDRedOff(void);
void LEDGreenOn(void);                                                                                                                                                                                                                                                               
void LEDGreenOff(void);


//void DisableInterrupt(void);
void EnableInterrupt(void);
void Reset_WDT(void);


void HardwareInit(void);
//unsigned char Random(unsigned char random);

void UART0SendChar(uint8_t c);
void UART0SendBuffer(uint8_t *buffer, uint16_t len);
//void UART0SendString(char *str);

void Output_Init(void);

void PWM1_Init(uint32_t freq, uint8_t duty);

void PWM1_Start(void);

void PWM1_Stop(void);
void PWM1_DeInit(void);

//void PWM1_SetDuty(uint8_t duty);

//void PWM1_SetFreq(uint32_t freq);



#endif
