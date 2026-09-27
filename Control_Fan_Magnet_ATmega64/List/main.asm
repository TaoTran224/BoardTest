
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega64L
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega64L
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _tx_index=R5
	.DEF _tx_counter=R4
	.DEF _rx_wr_index1=R7
	.DEF _rx_counter1=R6
	.DEF _ucBegin1=R9
	.DEF _ucLength1=R8
	.DEF _iWait=R10
	.DEF _Command_ID=R13
	.DEF _STATE_ID=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x64
_0x55:
	.DB  0x1
_0x121:
	.DB  0x0,0x0,0x0,0x0,0xB8,0xB,0x0,0x0
_0x60003:
	.DB  0x1
_0x60004:
	.DB  0xAA
_0x60005:
	.DB  0xAA
_0x60037:
	.DB  0x0,0x16,0x0,0x1,0x0,0x11,0x0,0x1
	.DB  0x0,0xE,0xC0,0x1,0x81,0x0,0x3,0x1
	.DB  0x0,0x1,0x8,0x0,0xFF,0x2,0x0,0x71
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x80003:
	.DB  0x2C,0x92,0x1D,0xA3,0x90,0xFA,0xCC,0xBA
	.DB  0x86,0xD4,0xA0,0xDF,0x21,0xDE,0xB0,0xF5
_0x80004:
	.DB  0xDD,0x6B,0x3B,0xA7,0x1D,0x3,0xC0,0x8E
	.DB  0x71,0x8B,0xAD,0xF7,0xA2,0xC8,0x10,0x56
_0xA0003:
	.DB  0x63,0x7C,0x77,0x7B,0xF2,0x6B,0x6F,0xC5
	.DB  0x30,0x1,0x67,0x2B,0xFE,0xD7,0xAB,0x76
	.DB  0xCA,0x82,0xC9,0x7D,0xFA,0x59,0x47,0xF0
	.DB  0xAD,0xD4,0xA2,0xAF,0x9C,0xA4,0x72,0xC0
	.DB  0xB7,0xFD,0x93,0x26,0x36,0x3F,0xF7,0xCC
	.DB  0x34,0xA5,0xE5,0xF1,0x71,0xD8,0x31,0x15
	.DB  0x4,0xC7,0x23,0xC3,0x18,0x96,0x5,0x9A
	.DB  0x7,0x12,0x80,0xE2,0xEB,0x27,0xB2,0x75
	.DB  0x9,0x83,0x2C,0x1A,0x1B,0x6E,0x5A,0xA0
	.DB  0x52,0x3B,0xD6,0xB3,0x29,0xE3,0x2F,0x84
	.DB  0x53,0xD1,0x0,0xED,0x20,0xFC,0xB1,0x5B
	.DB  0x6A,0xCB,0xBE,0x39,0x4A,0x4C,0x58,0xCF
	.DB  0xD0,0xEF,0xAA,0xFB,0x43,0x4D,0x33,0x85
	.DB  0x45,0xF9,0x2,0x7F,0x50,0x3C,0x9F,0xA8
	.DB  0x51,0xA3,0x40,0x8F,0x92,0x9D,0x38,0xF5
	.DB  0xBC,0xB6,0xDA,0x21,0x10,0xFF,0xF3,0xD2
	.DB  0xCD,0xC,0x13,0xEC,0x5F,0x97,0x44,0x17
	.DB  0xC4,0xA7,0x7E,0x3D,0x64,0x5D,0x19,0x73
	.DB  0x60,0x81,0x4F,0xDC,0x22,0x2A,0x90,0x88
	.DB  0x46,0xEE,0xB8,0x14,0xDE,0x5E,0xB,0xDB
	.DB  0xE0,0x32,0x3A,0xA,0x49,0x6,0x24,0x5C
	.DB  0xC2,0xD3,0xAC,0x62,0x91,0x95,0xE4,0x79
	.DB  0xE7,0xC8,0x37,0x6D,0x8D,0xD5,0x4E,0xA9
	.DB  0x6C,0x56,0xF4,0xEA,0x65,0x7A,0xAE,0x8
	.DB  0xBA,0x78,0x25,0x2E,0x1C,0xA6,0xB4,0xC6
	.DB  0xE8,0xDD,0x74,0x1F,0x4B,0xBD,0x8B,0x8A
	.DB  0x70,0x3E,0xB5,0x66,0x48,0x3,0xF6,0xE
	.DB  0x61,0x35,0x57,0xB9,0x86,0xC1,0x1D,0x9E
	.DB  0xE1,0xF8,0x98,0x11,0x69,0xD9,0x8E,0x94
	.DB  0x9B,0x1E,0x87,0xE9,0xCE,0x55,0x28,0xDF
	.DB  0x8C,0xA1,0x89,0xD,0xBF,0xE6,0x42,0x68
	.DB  0x41,0x99,0x2D,0xF,0xB0,0x54,0xBB,0x16
_0xA0004:
	.DB  0x52,0x9,0x6A,0xD5,0x30,0x36,0xA5,0x38
	.DB  0xBF,0x40,0xA3,0x9E,0x81,0xF3,0xD7,0xFB
	.DB  0x7C,0xE3,0x39,0x82,0x9B,0x2F,0xFF,0x87
	.DB  0x34,0x8E,0x43,0x44,0xC4,0xDE,0xE9,0xCB
	.DB  0x54,0x7B,0x94,0x32,0xA6,0xC2,0x23,0x3D
	.DB  0xEE,0x4C,0x95,0xB,0x42,0xFA,0xC3,0x4E
	.DB  0x8,0x2E,0xA1,0x66,0x28,0xD9,0x24,0xB2
	.DB  0x76,0x5B,0xA2,0x49,0x6D,0x8B,0xD1,0x25
	.DB  0x72,0xF8,0xF6,0x64,0x86,0x68,0x98,0x16
	.DB  0xD4,0xA4,0x5C,0xCC,0x5D,0x65,0xB6,0x92
	.DB  0x6C,0x70,0x48,0x50,0xFD,0xED,0xB9,0xDA
	.DB  0x5E,0x15,0x46,0x57,0xA7,0x8D,0x9D,0x84
	.DB  0x90,0xD8,0xAB,0x0,0x8C,0xBC,0xD3,0xA
	.DB  0xF7,0xE4,0x58,0x5,0xB8,0xB3,0x45,0x6
	.DB  0xD0,0x2C,0x1E,0x8F,0xCA,0x3F,0xF,0x2
	.DB  0xC1,0xAF,0xBD,0x3,0x1,0x13,0x8A,0x6B
	.DB  0x3A,0x91,0x11,0x41,0x4F,0x67,0xDC,0xEA
	.DB  0x97,0xF2,0xCF,0xCE,0xF0,0xB4,0xE6,0x73
	.DB  0x96,0xAC,0x74,0x22,0xE7,0xAD,0x35,0x85
	.DB  0xE2,0xF9,0x37,0xE8,0x1C,0x75,0xDF,0x6E
	.DB  0x47,0xF1,0x1A,0x71,0x1D,0x29,0xC5,0x89
	.DB  0x6F,0xB7,0x62,0xE,0xAA,0x18,0xBE,0x1B
	.DB  0xFC,0x56,0x3E,0x4B,0xC6,0xD2,0x79,0x20
	.DB  0x9A,0xDB,0xC0,0xFE,0x78,0xCD,0x5A,0xF4
	.DB  0x1F,0xDD,0xA8,0x33,0x88,0x7,0xC7,0x31
	.DB  0xB1,0x12,0x10,0x59,0x27,0x80,0xEC,0x5F
	.DB  0x60,0x51,0x7F,0xA9,0x19,0xB5,0x4A,0xD
	.DB  0x2D,0xE5,0x7A,0x9F,0x93,0xC9,0x9C,0xEF
	.DB  0xA0,0xE0,0x3B,0x4D,0xAE,0x2A,0xF5,0xB0
	.DB  0xC8,0xEB,0xBB,0x3C,0x83,0x53,0x99,0x61
	.DB  0x17,0x2B,0x4,0x7E,0xBA,0x77,0xD6,0x26
	.DB  0xE1,0x69,0x14,0x63,0x55,0x21,0xC,0x7D
_0xA0005:
	.DB  0x1,0x2,0x4,0x8,0x10,0x20,0x40,0x80
	.DB  0x1B,0x36
_0xC0017:
	.DB  0x92,0xEB,0x28,0x18,0x3D,0x67,0x4A,0x15
	.DB  0x2F,0x81,0xB7,0x3B,0x16,0x1C,0x0,0x63
	.DB  0xB,0xBE,0x7,0x19,0xEA,0x81,0xFF,0x1E
	.DB  0x66,0x23,0x52,0x25,0x9B,0x6D,0x39,0x90
	.DB  0x59,0x97,0x42,0xD,0x29,0xE0,0x3E,0x7A
	.DB  0x37,0xEB,0x98,0xB1,0x65,0x7,0x37,0x8B
	.DB  0x2C,0x7C,0xFD,0xD8,0x56,0x9E,0x2C,0xB8
	.DB  0x4F,0x6,0x9F,0x24,0xD0,0xBF,0xBC,0x41
	.DB  0xE9,0x1C,0x91,0xBF,0x29,0xB2,0xED,0x3F
	.DB  0x4,0xEF,0xC3,0x6D,0x4E,0x10,0x4E,0xA0
_0xC0020:
	.DB  0x0,0x40,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x9E,0x3,0x63,0xB3,0x44,0x40
	.DB  0xCA,0x32,0xA8,0x6E,0x47,0x8F,0x76,0xFB
	.DB  0x11,0x43,0xFB,0x4D,0xE,0xBE,0x37,0xC
	.DB  0xDE,0xA1,0x88,0x6,0x5F,0x92,0x24,0x5A
	.DB  0x74,0x1B,0x7,0xA5,0xB4,0x84,0x74,0xD7
	.DB  0x1,0x42,0xD4,0x96,0x9,0xD7,0x6,0xDA
	.DB  0x8,0xE3,0x9A,0x24,0xEA,0x96,0xD4,0x25
	.DB  0x23,0xAB,0x77,0x92,0x5E,0x3C,0x1E,0x2
	.DB  0xC9,0x50,0x13,0x3B,0x75,0x31,0xBC,0x9C
	.DB  0x7E,0xD3,0xEC,0x66,0x9A,0x41,0x9E,0xAF
	.DB  0x39,0x95
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _UART1_Byte_Timeout
	.DW  _0x3*2

	.DW  0x01
	.DW  _Only_First_Time_Flag_S0000012000
	.DW  _0x55*2

	.DW  0x08
	.DW  0x06
	.DW  _0x121*2

	.DW  0x01
	.DW  _Frame_Seq_Num
	.DW  _0x60003*2

	.DW  0x01
	.DW  _HHU_ID1
	.DW  _0x60004*2

	.DW  0x01
	.DW  _HHU_ID0
	.DW  _0x60005*2

	.DW  0x10
	.DW  _aes_key_default_G004
	.DW  _0x80003*2

	.DW  0x10
	.DW  _aes_iv_default_G004
	.DW  _0x80004*2

	.DW  0x100
	.DW  _sbox
	.DW  _0xA0003*2

	.DW  0x100
	.DW  _rsbox
	.DW  _0xA0004*2

	.DW  0x0A
	.DW  _Rcon
	.DW  _0xA0005*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;
;
;#include <mega64.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include "Global.h"
;#include <stdio.h>
;#include <stdlib.h>
;#include "main.h"
;
;#include "rfcc1101.h"
;#include "serial.h"
;#include "Mesh_RF.h"
;#include "ME41_42.h"
;
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;#define STATE_WAITHHU       0
;#define STATE_SENDGELEX     3
;#define STATE_WAITGELEX     4
;
;#define STATE_INIT_RF_MESH          6
;#define STATE_SEND_SCAN_MESH        7
;#define STATE_WAIT_SCAN_MESH        8
;#define STATE_SEND_READ_MESH        9
;#define STATE_WAIT_READ_MESH        10
;#define STATE_UART_PROCESS_MESH     11
;#define STATE_INIT_RF_NO_MESH       12
;#define STATE_SEND_READ_MESH2       13
;#define STATE_WAIT_READ_MESH2       14
;#define STATE_SEND_CLOSE_MESH       15
;#define SEND_SW_ID                  16
;#define SEND_RST_CHIP_ID            17
;
;//For Tao add new ID 011118--------------------------
;#define STATE_ME41_42_SCAN          18
;#define STATE_ME41_42_WAIT_SCAN     19
;#define STATE_ME41_42_PASSWORD      20
;#define STATE_ME41_42_WAIT_PASSWORD 21
;#define STATE_ME41_42_READ          22
;#define STATE_ME41_42_WAIT_READ     23
;#define STATE_ME41_42_CLOSE         24
;#define STATE_ME41_41_SEND_UART     25
;//---------------------------------------------------
;
;
;//---------------------------------------------------
;
;
;
;
;#define POWER_ON    0
;#define POWER_OFF   1
;
;#define POWER_MSP_X6        PORTA.5
;#define POWER_MSP_EKEMP     PORTB.6
;#define POWER_MSP_G4_HH     PORTA.3 //nguoc muc so voi cac SCH truoc: 0: bat, 1:tat
;
;
;unsigned char STATE_ID = 0 ;
;int iTimeout =0 ;
;unsigned char rfFlag =0 ;
;
;
;//unsigned char sx[18]={1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8};
;
;int iCounter =0 ;
;
;unsigned long Speed_Random;
;
;#define UART1_BYTE_TIMEOUT_DEF   100
;unsigned char UART1_Byte_Timeout=UART1_BYTE_TIMEOUT_DEF;// 100ms default: xac dinh form GLX hay HH

	.DSEG
;
;#define UART1_FORM_TIMEOUT_DEF  1000 //ms
;unsigned int UART1_Form_Timeout=0;  ///timeout cho 1 form GLX 68 12...
;
;
;void Power_MSP_ON(void)
; 0000 006E {

	.CSEG
_Power_MSP_ON:
; 0000 006F     POWER_MSP_X6=POWER_ON;
	CBI  0x1B,5
; 0000 0070     POWER_MSP_EKEMP=POWER_ON;
	CBI  0x18,6
; 0000 0071     POWER_MSP_G4_HH=POWER_ON;
	CBI  0x1B,3
; 0000 0072 }
	RET
;
;void Power_MSP_OFF(void)
; 0000 0075 {
_Power_MSP_OFF:
; 0000 0076     POWER_MSP_X6=POWER_OFF;
	SBI  0x1B,5
; 0000 0077     POWER_MSP_EKEMP=POWER_OFF;
	SBI  0x18,6
; 0000 0078     POWER_MSP_G4_HH=POWER_OFF;
	SBI  0x1B,3
; 0000 0079 }
	RET
;
;void PortControl_init(void)
; 0000 007C {
_PortControl_init:
; 0000 007D         DDRB.6=1;   //  POWER_MSP_EKEMP
	SBI  0x17,6
; 0000 007E         DDRA.5=1;   //  POWER_MSP_X6
	SBI  0x1A,5
; 0000 007F         DDRA.3=1;
	SBI  0x1A,3
; 0000 0080 
; 0000 0081         PORTA.3=0;
	CBI  0x1B,3
; 0000 0082         PORTB.6=1;  //  POWER_MSP_EKEMP = OFF
	SBI  0x18,6
; 0000 0083         PORTA.5=1;  //  POWER_MSP_X6 = OFF
	SBI  0x1B,5
; 0000 0084 }
	RET
;
;void Timer0_init(void)
; 0000 0087 {
_Timer0_init:
; 0000 0088         ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0089         OCR0=0x00;
	OUT  0x31,R30
; 0000 008A 
; 0000 008B         TCCR0=0x04;             // Prescaling = 64
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 008C         TCNT0=131;               // 56 <=>1.6ms;  131 <=>1 ms
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 008D         TIMSK |= (1<<TOIE0);    // TC0 overflow interrupt enable
	IN   R30,0x37
	ORI  R30,1
	OUT  0x37,R30
; 0000 008E }
	RET
;
;interrupt [TIM0_OVF] void timer0_ovf(void)
; 0000 0091 {
_timer0_ovf:
	CALL SUBOPT_0x0
; 0000 0092         TCNT0=131;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0093         iTimeout++;
	LDI  R26,LOW(_iTimeout)
	LDI  R27,HIGH(_iTimeout)
	CALL SUBOPT_0x1
; 0000 0094         Speed_Random++;
	LDI  R26,LOW(_Speed_Random)
	LDI  R27,HIGH(_Speed_Random)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 0095         //byte timeout process
; 0000 0096         UART1_Byte_Timeout++;
	LDS  R30,_UART1_Byte_Timeout
	SUBI R30,-LOW(1)
	STS  _UART1_Byte_Timeout,R30
; 0000 0097         if(UART1_Byte_Timeout>=UART1_BYTE_TIMEOUT_DEF)
	LDS  R26,_UART1_Byte_Timeout
	CPI  R26,LOW(0x64)
	BRLO _0x1C
; 0000 0098             UART1_Byte_Timeout=UART1_BYTE_TIMEOUT_DEF;
	LDI  R30,LOW(100)
	STS  _UART1_Byte_Timeout,R30
; 0000 0099 
; 0000 009A         if(ucBegin1)
_0x1C:
	TST  R9
	BREQ _0x1D
; 0000 009B         {
; 0000 009C             UART1_Form_Timeout++;
	LDI  R26,LOW(_UART1_Form_Timeout)
	LDI  R27,HIGH(_UART1_Form_Timeout)
	CALL SUBOPT_0x1
; 0000 009D             if(UART1_Form_Timeout>UART1_FORM_TIMEOUT_DEF) //form timeout-->error
	LDS  R26,_UART1_Form_Timeout
	LDS  R27,_UART1_Form_Timeout+1
	CPI  R26,LOW(0x3E9)
	LDI  R30,HIGH(0x3E9)
	CPC  R27,R30
	BRLO _0x1E
; 0000 009E             {
; 0000 009F                 UART1_Form_Timeout=0;
	CALL SUBOPT_0x2
; 0000 00A0                 ucBegin1 = 0;
	CALL SUBOPT_0x3
; 0000 00A1                 ucLength1 =0;
; 0000 00A2                 rx_wr_index1 = 0;
; 0000 00A3                 iTimeout=0;
; 0000 00A4                 STATE_ID=STATE_WAITHHU;
; 0000 00A5             }
; 0000 00A6         }
_0x1E:
; 0000 00A7 
; 0000 00A8         // NOTE: calculations are in *TICKS* (not milliseconds)
; 0000 00A9         if(STATE_ID==STATE_WAITHHU)
_0x1D:
	TST  R12
	BRNE _0x1F
; 0000 00AA         {
; 0000 00AB             iCounter++;
	LDI  R26,LOW(_iCounter)
	LDI  R27,HIGH(_iCounter)
	CALL SUBOPT_0x1
; 0000 00AC             if(iCounter>=1900)
	LDS  R26,_iCounter
	LDS  R27,_iCounter+1
	CPI  R26,LOW(0x76C)
	LDI  R30,HIGH(0x76C)
	CPC  R27,R30
	BRLT _0x20
; 0000 00AD             {
; 0000 00AE                 LED_Orange();
	CALL _LED_Orange
; 0000 00AF             }
; 0000 00B0             if(iCounter>=2000)
_0x20:
	LDS  R26,_iCounter
	LDS  R27,_iCounter+1
	CPI  R26,LOW(0x7D0)
	LDI  R30,HIGH(0x7D0)
	CPC  R27,R30
	BRLT _0x21
; 0000 00B1             {
; 0000 00B2                 LED_Off();
	CALL _LED_Off
; 0000 00B3                 iCounter=0;
	LDI  R30,LOW(0)
	STS  _iCounter,R30
	STS  _iCounter+1,R30
; 0000 00B4             }
; 0000 00B5         }
_0x21:
; 0000 00B6 }
_0x1F:
	RJMP _0x120
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 00BA {
_usart0_rx_isr:
	CALL SUBOPT_0x0
; 0000 00BB     char status,data;
; 0000 00BC     status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 00BD     data=UDR0;
	IN   R16,12
; 0000 00BE 
; 0000 00BF 
; 0000 00C0     if((STATE_ID == STATE_WAITHHU))
	TST  R12
	BRNE _0x22
; 0000 00C1     {
; 0000 00C2 
; 0000 00C3         if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x23
; 0000 00C4         {
; 0000 00C5             putchar1(data);
	ST   -Y,R16
	RCALL _putchar1
; 0000 00C6         }
; 0000 00C7     }
_0x23:
; 0000 00C8 
; 0000 00C9 
; 0000 00CA }
_0x22:
	RJMP _0x11F
;
;void putchar0(char c)
; 0000 00CD {
_putchar0:
; 0000 00CE     while(!(UCSR0A & DATA_REGISTER_EMPTY)) {}
;	c -> Y+0
_0x24:
	SBIS 0xB,5
	RJMP _0x24
; 0000 00CF     UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00D0 }
	RJMP _0x20A001E
;
;void putBuffer0(unsigned char *buffer, unsigned char len)
; 0000 00D3 {
; 0000 00D4     unsigned char i=0;
; 0000 00D5     #asm("cli")
;	*buffer -> Y+2
;	len -> Y+1
;	i -> R17
; 0000 00D6     for(i=0; i<len;i++)
; 0000 00D7     {
; 0000 00D8         putchar0(buffer[i]);
; 0000 00D9     }
; 0000 00DA     #asm("sei")
; 0000 00DB     LED_Off();
; 0000 00DC }
;
;
;void putchar1(unsigned char c)
; 0000 00E0 {
_putchar1:
; 0000 00E1     while(!(UCSR1A & DATA_REGISTER_EMPTY)) {}
;	c -> Y+0
_0x2A:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0x2A
; 0000 00E2     UDR1=c;
	LD   R30,Y
	STS  156,R30
; 0000 00E3 }
_0x20A001E:
	ADIW R28,1
	RET
;
;void putBuffer1(unsigned char *buffer, unsigned char len)
; 0000 00E6 {
_putBuffer1:
; 0000 00E7     unsigned char i=0;
; 0000 00E8     #asm("cli")
	ST   -Y,R17
;	*buffer -> Y+2
;	len -> Y+1
;	i -> R17
	LDI  R17,0
	cli
; 0000 00E9     for(i=0; i<len;i++)
	LDI  R17,LOW(0)
_0x2E:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0x2F
; 0000 00EA     {
; 0000 00EB         putchar1(buffer[i]);
	CALL SUBOPT_0x4
	RCALL _putchar1
; 0000 00EC     }
	SUBI R17,-1
	RJMP _0x2E
_0x2F:
; 0000 00ED     #asm("sei")
	sei
; 0000 00EE     //delay_ms(100); //de delay thi chuong trinh tren HHU a Hung bi treo
; 0000 00EF     LED_Off();
	CALL _LED_Off
; 0000 00F0 }
	LDD  R17,Y+0
	ADIW R28,4
	RET
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 00F4 {
_usart1_rx_isr:
	CALL SUBOPT_0x0
; 0000 00F5     char status,data;
; 0000 00F6     status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,155
; 0000 00F7     data=UDR1;
	LDS  R16,156
; 0000 00F8 
; 0000 00F9     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BREQ PC+3
	JMP _0x30
; 0000 00FA     {
; 0000 00FB        if(STATE_ID==STATE_WAITHHU)
	TST  R12
	BREQ PC+3
	JMP _0x31
; 0000 00FC         {
; 0000 00FD             putchar0(data);//alway put data to HH PCB
	ST   -Y,R16
	RCALL _putchar0
; 0000 00FE 
; 0000 00FF             //GLX process
; 0000 0100             if(rx_wr_index1 == 0)
	TST  R7
	BRNE _0x32
; 0000 0101             {
; 0000 0102 
; 0000 0103 
; 0000 0104                  // Neu la byte 0x68 o dau thi timeout=100; neu o giua form thi timeout<100
; 0000 0105                 if( ((data == 0x68)||(data == 'R'))&&(UART1_Byte_Timeout>=UART1_BYTE_TIMEOUT_DEF))// nhan duoc byte 0x68 o dau form chu khong phai giua form 0x68 .....0x68 0x12...0x16....0x16
	CPI  R16,104
	BREQ _0x34
	CPI  R16,82
	BRNE _0x36
_0x34:
	LDS  R26,_UART1_Byte_Timeout
	CPI  R26,LOW(0x64)
	BRSH _0x37
_0x36:
	RJMP _0x33
_0x37:
; 0000 0106                 {
; 0000 0107 
; 0000 0108                     rx_counter1=0;
	CLR  R6
; 0000 0109                     ucBegin1=1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 010A                     UART1_Form_Timeout=0;
	CALL SUBOPT_0x2
; 0000 010B                 }
; 0000 010C             }
_0x33:
; 0000 010D 
; 0000 010E             if(ucBegin1)
_0x32:
	TST  R9
	BRNE PC+3
	JMP _0x38
; 0000 010F             {
; 0000 0110                 rx_buffer1[rx_wr_index1]=data;
	MOV  R30,R7
	CALL SUBOPT_0x5
	ST   Z,R16
; 0000 0111                 rx_wr_index1++;
	INC  R7
; 0000 0112                 rx_counter1++;
	INC  R6
; 0000 0113                 if(rx_wr_index1==2)
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x39
; 0000 0114                 {
; 0000 0115                     if(rx_buffer1[0]==0x68)
	LDS  R26,_rx_buffer1
	CPI  R26,LOW(0x68)
	BRNE _0x3A
; 0000 0116                     {
; 0000 0117                         ucLength1= rx_buffer1[1];  //byte [1]=lengh=0x12; 18 byte
	__GETBRMN 8,_rx_buffer1,1
; 0000 0118                         if(ucLength1!=0x12)//byte lengh of GELEX EMIC Form: ERROR FORM GLX
	LDI  R30,LOW(18)
	CP   R30,R8
	BREQ _0x3B
; 0000 0119                         {
; 0000 011A                             ucBegin1 = 0;
	CALL SUBOPT_0x3
; 0000 011B                             ucLength1 =0;
; 0000 011C                             rx_wr_index1 = 0;
; 0000 011D                             iTimeout=0;
; 0000 011E                             STATE_ID=STATE_WAITHHU;
; 0000 011F                             UART1_Form_Timeout=0;
	CALL SUBOPT_0x2
; 0000 0120                         }
; 0000 0121                     }
_0x3B:
; 0000 0122                     else if(rx_buffer1[0]=='R')
	RJMP _0x3C
_0x3A:
	LDS  R26,_rx_buffer1
	CPI  R26,LOW(0x52)
	BRNE _0x3D
; 0000 0123                     {
; 0000 0124                       ucLength1=5;//RESET
	LDI  R30,LOW(5)
	MOV  R8,R30
; 0000 0125                     }
; 0000 0126                 }
_0x3D:
_0x3C:
; 0000 0127 
; 0000 0128                     if(rx_wr_index1 == ucLength1)//du so byte :18
_0x39:
	CP   R8,R7
	BREQ PC+3
	JMP _0x3E
; 0000 0129                     {
; 0000 012A                         ucBegin1 = 0;
	CLR  R9
; 0000 012B                         ucLength1 =0;
	CLR  R8
; 0000 012C                         rx_wr_index1 = 0;
	CLR  R7
; 0000 012D                         iTimeout=0;
	CALL SUBOPT_0x6
; 0000 012E                         UART1_Form_Timeout=0;
	CALL SUBOPT_0x2
; 0000 012F 
; 0000 0130                         if(rx_buffer1[0]==0x68)//byte header
	LDS  R26,_rx_buffer1
	CPI  R26,LOW(0x68)
	BREQ PC+3
	JMP _0x3F
; 0000 0131                         {
; 0000 0132                             if((rx_buffer1[1] == 0x12) && (rx_buffer1[3] != 0x7E))//byte [1]
	__GETB2MN _rx_buffer1,1
	CPI  R26,LOW(0x12)
	BRNE _0x41
	__GETB2MN _rx_buffer1,3
	CPI  R26,LOW(0x7E)
	BRNE _0x42
_0x41:
	RJMP _0x40
_0x42:
; 0000 0133                             {
; 0000 0134                                 if( (rx_buffer1[4] == CE18_Mesh_16CH_NoIEC_Type)||(rx_buffer1[4] == CE18_Mesh_1CH_NoIEC_Type)
; 0000 0135                                   ||(rx_buffer1[4] == CE14_Mesh_16CH_NoIEC_Type)||(rx_buffer1[4] == CE14_Mesh_1CH_NoIEC_Type)
; 0000 0136                                   ||(rx_buffer1[4] == ME40_Mesh_16CH_NoIEC_Type)||(rx_buffer1[4] == ME40_Mesh_1CH_NoIEC_Type)
; 0000 0137                                   ||(rx_buffer1[4] == ME41_Mesh_16CH_NoIEC_Type)||(rx_buffer1[4] == ME41_Mesh_1CH_NoIEC_Type)
; 0000 0138                                   ||(rx_buffer1[4] == ME42_Mesh_16CH_NoIEC_Type)||(rx_buffer1[4] == ME42_Mesh_1CH_NoIEC_Type))
	__GETB2MN _rx_buffer1,4
	CPI  R26,LOW(0x2)
	BREQ _0x44
	__GETB2MN _rx_buffer1,4
	CPI  R26,LOW(0x12)
	BREQ _0x44
	__GETB2MN _rx_buffer1,4
	CPI  R26,LOW(0x3)
	BREQ _0x44
	__GETB2MN _rx_buffer1,4
	CPI  R26,LOW(0x13)
	BREQ _0x44
	__GETB2MN _rx_buffer1,4
	CPI  R26,LOW(0x4)
	BREQ _0x44
	__GETB2MN _rx_buffer1,4
	CPI  R26,LOW(0x14)
	BREQ _0x44
	__GETB2MN _rx_buffer1,4
	CPI  R26,LOW(0x5)
	BREQ _0x44
	__GETB2MN _rx_buffer1,4
	CPI  R26,LOW(0x15)
	BREQ _0x44
	__GETB2MN _rx_buffer1,4
	CPI  R26,LOW(0x6)
	BREQ _0x44
	__GETB2MN _rx_buffer1,4
	CPI  R26,LOW(0x16)
	BRNE _0x43
_0x44:
; 0000 0139                                 {
; 0000 013A                                     if(STATE_ID==STATE_WAITHHU)
	TST  R12
	BRNE _0x46
; 0000 013B                                     {
; 0000 013C                                         {
; 0000 013D                                             STATE_ID=STATE_INIT_RF_MESH;
	LDI  R30,LOW(6)
	MOV  R12,R30
; 0000 013E                                         }
; 0000 013F                                     }
; 0000 0140 
; 0000 0141                                 }
_0x46:
; 0000 0142                                 else if(rx_buffer1[4] == CE18G_Type)//CE-18G metter
	RJMP _0x47
_0x43:
	__GETB2MN _rx_buffer1,4
	CPI  R26,LOW(0x1)
	BRNE _0x48
; 0000 0143                                 {
; 0000 0144                                     if(STATE_ID==STATE_WAITHHU)
	TST  R12
	BRNE _0x49
; 0000 0145                                     {
; 0000 0146                                         if(rx_buffer1[9]==SW_Cmd_ID)//lenh doc sw Id
	__GETB2MN _rx_buffer1,9
	CPI  R26,LOW(0x88)
	BRNE _0x4A
; 0000 0147                                         {
; 0000 0148                                             STATE_ID=SEND_SW_ID;
	LDI  R30,LOW(16)
	RJMP _0x119
; 0000 0149                                         }
; 0000 014A                                         else
_0x4A:
; 0000 014B                                         {
; 0000 014C                                             STATE_ID=STATE_INIT_RF_NO_MESH;
	LDI  R30,LOW(12)
_0x119:
	MOV  R12,R30
; 0000 014D                                         }
; 0000 014E 
; 0000 014F                                     }
; 0000 0150 
; 0000 0151                                 }
_0x49:
; 0000 0152                             }
_0x48:
_0x47:
; 0000 0153                         }
_0x40:
; 0000 0154                          else if(rx_buffer1[0]=='R')//byte header
	RJMP _0x4C
_0x3F:
	LDS  R26,_rx_buffer1
	CPI  R26,LOW(0x52)
	BRNE _0x4D
; 0000 0155                         {
; 0000 0156                             if( (rx_buffer1[1]=='E')&&(rx_buffer1[2]=='S')&&(rx_buffer1[3]=='E')&&(rx_buffer1[4]=='T'))
	__GETB2MN _rx_buffer1,1
	CPI  R26,LOW(0x45)
	BRNE _0x4F
	__GETB2MN _rx_buffer1,2
	CPI  R26,LOW(0x53)
	BRNE _0x4F
	__GETB2MN _rx_buffer1,3
	CPI  R26,LOW(0x45)
	BRNE _0x4F
	__GETB2MN _rx_buffer1,4
	CPI  R26,LOW(0x54)
	BREQ _0x50
_0x4F:
	RJMP _0x4E
_0x50:
; 0000 0157                             {
; 0000 0158                                  STATE_ID=SEND_RST_CHIP_ID;
	LDI  R30,LOW(17)
	MOV  R12,R30
; 0000 0159                             }
; 0000 015A                         }
_0x4E:
; 0000 015B                     }
_0x4D:
_0x4C:
; 0000 015C 
; 0000 015D             }
_0x3E:
; 0000 015E        }
_0x38:
; 0000 015F    }
_0x31:
; 0000 0160 }
_0x30:
_0x11F:
	LD   R16,Y+
	LD   R17,Y+
_0x120:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0165 {
_ext_int0_isr:
	ST   -Y,R30
; 0000 0166     // Place your code here
; 0000 0167     rfFlag =1 ;
	LDI  R30,LOW(1)
	STS  _rfFlag,R30
; 0000 0168 
; 0000 0169 }
	LD   R30,Y+
	RETI
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 016D {
_ext_int1_isr:
; 0000 016E     // Place your code here
; 0000 016F }
	RETI
;
;
;void Init(void)
; 0000 0173 {
_Init:
; 0000 0174     // Input/Output Ports initialization
; 0000 0175     // Port A initialization
; 0000 0176     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0177     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0178     PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0179     DDRA=0x00;
	OUT  0x1A,R30
; 0000 017A 
; 0000 017B     // Port B initialization
; 0000 017C     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 017D     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 017E     PORTB=0x00;
	OUT  0x18,R30
; 0000 017F     DDRB=0x00;
	OUT  0x17,R30
; 0000 0180 
; 0000 0181     // Port C initialization
; 0000 0182     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0183     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0184     PORTC=0x00;
	OUT  0x15,R30
; 0000 0185     DDRC=0x00;
	OUT  0x14,R30
; 0000 0186 
; 0000 0187     // Port D initialization
; 0000 0188     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0189     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 018A     PORTD=0x00;
	OUT  0x12,R30
; 0000 018B     DDRD=0x00;
	OUT  0x11,R30
; 0000 018C 
; 0000 018D     // Port E initialization
; 0000 018E     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 018F     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0190     PORTE=0x00;
	OUT  0x3,R30
; 0000 0191     DDRE=0x00;
	OUT  0x2,R30
; 0000 0192 
; 0000 0193     // Port F initialization
; 0000 0194     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0195     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0196     PORTF=0x00;
	STS  98,R30
; 0000 0197     DDRF=0x00;
	STS  97,R30
; 0000 0198 
; 0000 0199     // Port G initialization
; 0000 019A     // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 019B     // State4=T State3=T State2=T State1=T State0=T
; 0000 019C     PORTG=0x00;
	STS  101,R30
; 0000 019D     DDRG=0x00;
	STS  100,R30
; 0000 019E 
; 0000 019F     // Timer/Counter 0 initialization
; 0000 01A0     // Clock source: System Clock
; 0000 01A1     // Clock value: Timer 0 Stopped
; 0000 01A2     // Mode: Normal top=0xFF
; 0000 01A3     // OC0 output: Disconnected
; 0000 01A4     ASSR=0x00;
	OUT  0x30,R30
; 0000 01A5     TCCR0=0x00;
	OUT  0x33,R30
; 0000 01A6     TCNT0=0x00;
	OUT  0x32,R30
; 0000 01A7     OCR0=0x00;
	OUT  0x31,R30
; 0000 01A8 
; 0000 01A9     // Timer/Counter 1 initialization
; 0000 01AA     // Clock source: System Clock
; 0000 01AB     // Clock value: Timer1 Stopped
; 0000 01AC     // Mode: Normal top=0xFFFF
; 0000 01AD     // OC1A output: Discon.
; 0000 01AE     // OC1B output: Discon.
; 0000 01AF     // OC1C output: Discon.
; 0000 01B0     // Noise Canceler: Off
; 0000 01B1     // Input Capture on Falling Edge
; 0000 01B2     // Timer1 Overflow Interrupt: Off
; 0000 01B3     // Input Capture Interrupt: Off
; 0000 01B4     // Compare A Match Interrupt: Off
; 0000 01B5     // Compare B Match Interrupt: Off
; 0000 01B6     // Compare C Match Interrupt: Off
; 0000 01B7     TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 01B8     TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 01B9     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 01BA     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01BB     ICR1H=0x00;
	OUT  0x27,R30
; 0000 01BC     ICR1L=0x00;
	OUT  0x26,R30
; 0000 01BD     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01BE     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01BF     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01C0     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01C1     OCR1CH=0x00;
	STS  121,R30
; 0000 01C2     OCR1CL=0x00;
	STS  120,R30
; 0000 01C3 
; 0000 01C4     // Timer/Counter 2 initialization
; 0000 01C5     // Clock source: System Clock
; 0000 01C6     // Clock value: Timer2 Stopped
; 0000 01C7     // Mode: Normal top=0xFF
; 0000 01C8     // OC2 output: Disconnected
; 0000 01C9     TCCR2=0x00;
	OUT  0x25,R30
; 0000 01CA     TCNT2=0x00;
	OUT  0x24,R30
; 0000 01CB     OCR2=0x00;
	OUT  0x23,R30
; 0000 01CC 
; 0000 01CD     // Timer/Counter 3 initialization
; 0000 01CE     // Clock source: System Clock
; 0000 01CF     // Clock value: Timer3 Stopped
; 0000 01D0     // Mode: Normal top=0xFFFF
; 0000 01D1     // OC3A output: Discon.
; 0000 01D2     // OC3B output: Discon.
; 0000 01D3     // OC3C output: Discon.
; 0000 01D4     // Noise Canceler: Off
; 0000 01D5     // Input Capture on Falling Edge
; 0000 01D6     // Timer3 Overflow Interrupt: Off
; 0000 01D7     // Input Capture Interrupt: Off
; 0000 01D8     // Compare A Match Interrupt: Off
; 0000 01D9     // Compare B Match Interrupt: Off
; 0000 01DA     // Compare C Match Interrupt: Off
; 0000 01DB     TCCR3A=0x00;
	STS  139,R30
; 0000 01DC     TCCR3B=0x00;
	STS  138,R30
; 0000 01DD     TCNT3H=0x00;
	STS  137,R30
; 0000 01DE     TCNT3L=0x00;
	STS  136,R30
; 0000 01DF     ICR3H=0x00;
	STS  129,R30
; 0000 01E0     ICR3L=0x00;
	STS  128,R30
; 0000 01E1     OCR3AH=0x00;
	STS  135,R30
; 0000 01E2     OCR3AL=0x00;
	STS  134,R30
; 0000 01E3     OCR3BH=0x00;
	STS  133,R30
; 0000 01E4     OCR3BL=0x00;
	STS  132,R30
; 0000 01E5     OCR3CH=0x00;
	STS  131,R30
; 0000 01E6     OCR3CL=0x00;
	STS  130,R30
; 0000 01E7 
; 0000 01E8     // External Interrupt(s) initialization
; 0000 01E9     // INT0: On
; 0000 01EA     // INT0 Mode: Rising Edge
; 0000 01EB     // INT1: On
; 0000 01EC     // INT1 Mode: Rising Edge
; 0000 01ED     // INT2: Off
; 0000 01EE     // INT3: Off
; 0000 01EF     // INT4: Off
; 0000 01F0     // INT5: Off
; 0000 01F1     // INT6: Off
; 0000 01F2     // INT7: Off
; 0000 01F3     EICRA=0x0F;
	LDI  R30,LOW(15)
	STS  106,R30
; 0000 01F4     EICRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3A,R30
; 0000 01F5     EIMSK=0x03;
	LDI  R30,LOW(3)
	OUT  0x39,R30
; 0000 01F6     EIFR=0x03;
	OUT  0x38,R30
; 0000 01F7 
; 0000 01F8     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01F9     TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x37,R30
; 0000 01FA 
; 0000 01FB     ETIMSK=0x00;
	STS  125,R30
; 0000 01FC    /*
; 0000 01FD     // USART0 initialization
; 0000 01FE     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01FF     // USART0 Receiver: On
; 0000 0200     // USART0 Transmitter: Off
; 0000 0201     // USART0 Mode: Asynchronous
; 0000 0202     // USART0 Baud Rate: 57600
; 0000 0203     UCSR0A=0x00;
; 0000 0204     UCSR0B=0x98;
; 0000 0205     UCSR0C=0x06;
; 0000 0206     UBRR0H=0x00;
; 0000 0207     UBRR0L=0x08;
; 0000 0208     */
; 0000 0209 // USART0 initialization
; 0000 020A // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 020B // USART0 Receiver: On
; 0000 020C // USART0 Transmitter: On
; 0000 020D // USART0 Mode: Asynchronous
; 0000 020E // USART0 Baud Rate: 57600 (Double Speed Mode)
; 0000 020F     UCSR0A=0x02;
	LDI  R30,LOW(2)
	OUT  0xB,R30
; 0000 0210     UCSR0B=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0211     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0212     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0213     UBRR0L=0x10;
	LDI  R30,LOW(16)
	OUT  0x9,R30
; 0000 0214 
; 0000 0215 // USART1 initialization
; 0000 0216 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0217 // USART1 Receiver: On
; 0000 0218 // USART1 Transmitter: On
; 0000 0219 // USART1 Mode: Asynchronous
; 0000 021A // USART1 Baud Rate: 57600 (Double Speed Mode)
; 0000 021B 
; 0000 021C     UCSR1A=0x02;
	LDI  R30,LOW(2)
	STS  155,R30
; 0000 021D     UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  154,R30
; 0000 021E     UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 021F     UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 0220     UBRR1L=0x10;
	LDI  R30,LOW(16)
	STS  153,R30
; 0000 0221 
; 0000 0222 
; 0000 0223     // Analog Comparator initialization
; 0000 0224     // Analog Comparator: Off
; 0000 0225     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0226     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0227     SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0228 
; 0000 0229     // ADC initialization
; 0000 022A     // ADC disabled
; 0000 022B     ADCSRA=0x00;
	OUT  0x6,R30
; 0000 022C 
; 0000 022D     // SPI initialization
; 0000 022E     // SPI disabled
; 0000 022F     SPCR=0x00;
	OUT  0xD,R30
; 0000 0230 
; 0000 0231     // TWI initialization
; 0000 0232     // TWI disabled
; 0000 0233     TWCR=0x00;
	STS  116,R30
; 0000 0234 
; 0000 0235 
; 0000 0236 }
	RET
;
;
;void Reset_WDT(void)
; 0000 023A {
_Reset_WDT:
; 0000 023B     //internal WDT
; 0000 023C     #asm("WDR") ;//clear WDT
	WDR
; 0000 023D }
	RET
;
;void PullupRxTx(void)
; 0000 0240 {
_PullupRxTx:
; 0000 0241     PORTE.0=1; //RXD0 pullup
	SBI  0x3,0
; 0000 0242     PORTD.2=1; //RXD1 pullup
	SBI  0x12,2
; 0000 0243 }
	RET
;
;void Internal_Watchdog_Init()//1s wdt
; 0000 0246 {
_Internal_Watchdog_Init:
; 0000 0247     WDTCR=0x1E;
	LDI  R30,LOW(30)
	OUT  0x21,R30
; 0000 0248     WDTCR=0x0E;//disable change WDE
	LDI  R30,LOW(14)
	OUT  0x21,R30
; 0000 0249 }
	RET
;unsigned char Random()
; 0000 024B {
_Random:
; 0000 024C     unsigned rvar=0;
; 0000 024D 
; 0000 024E     srand(Speed_Random);
	ST   -Y,R17
	ST   -Y,R16
;	rvar -> R16,R17
	__GETWRN 16,17,0
	LDS  R30,_Speed_Random
	LDS  R31,_Speed_Random+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _srand
; 0000 024F     rvar=(unsigned char)rand();
	CALL _rand
	MOV  R16,R30
	CLR  R17
; 0000 0250     return rvar;
	MOV  R30,R16
	RJMP _0x20A001D
; 0000 0251 }
;void Make_HHU_ID()
; 0000 0253 {
_Make_HHU_ID:
; 0000 0254     static unsigned char Only_First_Time_Flag=TRUE;

	.DSEG

	.CSEG
; 0000 0255 
; 0000 0256 
; 0000 0257      HHU_ID0=Random();
	RCALL _Random
	STS  _HHU_ID0,R30
; 0000 0258      if(Only_First_Time_Flag)
	LDS  R30,_Only_First_Time_Flag_S0000012000
	CPI  R30,0
	BREQ _0x56
; 0000 0259      {
; 0000 025A         HHU_ID1=HHU_ID0;
	LDS  R30,_HHU_ID0
	STS  _HHU_ID1,R30
; 0000 025B         Only_First_Time_Flag=FALSE;
	LDI  R30,LOW(0)
	STS  _Only_First_Time_Flag_S0000012000,R30
; 0000 025C      }
; 0000 025D      else
	RJMP _0x57
_0x56:
; 0000 025E      {
; 0000 025F         HHU_ID1++;
	LDS  R30,_HHU_ID1
	SUBI R30,-LOW(1)
	STS  _HHU_ID1,R30
; 0000 0260      }
_0x57:
; 0000 0261 }
	RET
;void Clear_Tx_Buff()
; 0000 0263 {
_Clear_Tx_Buff:
; 0000 0264     unsigned char i=0;
; 0000 0265     for(i=0;i<18;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x59:
	CPI  R17,18
	BRSH _0x5A
; 0000 0266     {
; 0000 0267        tx_buffer[i]=0xFF;
	CALL SUBOPT_0x7
	LDI  R26,LOW(255)
	STD  Z+0,R26
; 0000 0268     }
	SUBI R17,-1
	RJMP _0x59
_0x5A:
; 0000 0269 }
	RJMP _0x20A001C
;
;void Frame_SW_ID()
; 0000 026C {
_Frame_SW_ID:
; 0000 026D     unsigned char i, XOR_byte=0;
; 0000 026E     tx_buffer[0]=0x68;    //start form
	CALL SUBOPT_0x8
;	i -> R17
;	XOR_byte -> R16
; 0000 026F     tx_buffer[1]=0x12;
; 0000 0270     tx_buffer[2]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _tx_buffer,2
; 0000 0271     tx_buffer[3]=0x00;
	__PUTB1MN _tx_buffer,3
; 0000 0272     tx_buffer[4]=0x02;//type mesh
	LDI  R30,LOW(2)
	__PUTB1MN _tx_buffer,4
; 0000 0273     tx_buffer[5]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _tx_buffer,5
; 0000 0274     tx_buffer[6]=0x00;
	__PUTB1MN _tx_buffer,6
; 0000 0275     tx_buffer[7]=0x00;
	__PUTB1MN _tx_buffer,7
; 0000 0276     tx_buffer[8]=0x00;
	__PUTB1MN _tx_buffer,8
; 0000 0277     tx_buffer[9]=SW_Cmd_ID;
	LDI  R30,LOW(136)
	__PUTB1MN _tx_buffer,9
; 0000 0278 
; 0000 0279     tx_buffer[10]=SW_ID;
	LDI  R30,LOW(18)
	__PUTB1MN _tx_buffer,10
; 0000 027A     tx_buffer[11]=SW_Date;
	LDI  R30,LOW(37)
	__PUTB1MN _tx_buffer,11
; 0000 027B     tx_buffer[12]=SW_Month;
	LDI  R30,LOW(9)
	__PUTB1MN _tx_buffer,12
; 0000 027C     tx_buffer[13]=SW_Year;
	LDI  R30,LOW(130)
	__PUTB1MN _tx_buffer,13
; 0000 027D 
; 0000 027E 
; 0000 027F 
; 0000 0280 
; 0000 0281     tx_buffer[14]=0x00;
	CALL SUBOPT_0x9
; 0000 0282     tx_buffer[15]=0x00;
; 0000 0283 
; 0000 0284      for(i=1; i<16;i++)
_0x5C:
	CPI  R17,16
	BRSH _0x5D
; 0000 0285      {
; 0000 0286         XOR_byte^= tx_buffer[i];
	CALL SUBOPT_0x7
	LD   R30,Z
	EOR  R16,R30
; 0000 0287      }
	SUBI R17,-1
	RJMP _0x5C
_0x5D:
; 0000 0288      tx_buffer[16]=XOR_byte;
	CALL SUBOPT_0xA
; 0000 0289      tx_buffer[17]=0x16;      //end form
; 0000 028A 
; 0000 028B }
_0x20A001D:
	LD   R16,Y+
	LD   R17,Y+
	RET
;void Delay_3s(void)
; 0000 028D {
_Delay_3s:
; 0000 028E     unsigned char i;
; 0000 028F     for(i=0;i<10;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x5F:
	CPI  R17,10
	BRSH _0x60
; 0000 0290     {
; 0000 0291         LED_Orange();
	CALL _LED_Orange
; 0000 0292         delay_ms(100);
	CALL SUBOPT_0xB
; 0000 0293         LED_Off();
	CALL _LED_Off
; 0000 0294         delay_ms(100);
	CALL SUBOPT_0xB
; 0000 0295         Reset_WDT();
	RCALL _Reset_WDT
; 0000 0296     }
	SUBI R17,-1
	RJMP _0x5F
_0x60:
; 0000 0297 }
_0x20A001C:
	LD   R17,Y+
	RET
;// Declare your global variables here
;void main(void)
; 0000 029A {
_main:
; 0000 029B     // Declare your local variables here
; 0000 029C 
; 0000 029D     STATE_ID=STATE_WAITHHU;
	CLR  R12
; 0000 029E     rx_wr_index1=0;
	CLR  R7
; 0000 029F     rx_counter1=0;
	CLR  R6
; 0000 02A0 
; 0000 02A1 
; 0000 02A2 
; 0000 02A3     Init();
	RCALL _Init
; 0000 02A4     PortControl_init();
	RCALL _PortControl_init
; 0000 02A5 
; 0000 02A6     PullupRxTx();
	RCALL _PullupRxTx
; 0000 02A7 
; 0000 02A8     Power_MSP_OFF();
	RCALL _Power_MSP_OFF
; 0000 02A9 
; 0000 02AA     Timer0_init();
	RCALL _Timer0_init
; 0000 02AB     spi_Init();
	CALL _spi_Init
; 0000 02AC     LED_init();
	CALL _LED_init
; 0000 02AD 
; 0000 02AE     Reset_WDT();
	RCALL _Reset_WDT
; 0000 02AF     CC1101_Init();
	CALL _CC1101_Init
; 0000 02B0     Power_MSP_ON();
	RCALL _Power_MSP_ON
; 0000 02B1 
; 0000 02B2 
; 0000 02B3 
; 0000 02B4     Reset_WDT();
	CALL SUBOPT_0xC
; 0000 02B5     LED_Red();
; 0000 02B6     delay_ms(300); // putBuffer1(sx,18);
; 0000 02B7     LED_Green();
; 0000 02B8     delay_ms(300);  // putBuffer1(sx,18);
; 0000 02B9     Reset_WDT();
	CALL SUBOPT_0xC
; 0000 02BA     LED_Red();
; 0000 02BB     delay_ms(300);  // putBuffer1(sx,18);
; 0000 02BC     LED_Green();
; 0000 02BD     delay_ms(300);   // putBuffer1(sx,18);
; 0000 02BE     Reset_WDT();
	RCALL _Reset_WDT
; 0000 02BF     LED_Off();
	CALL _LED_Off
; 0000 02C0     Internal_Watchdog_Init();
	RCALL _Internal_Watchdog_Init
; 0000 02C1     //=========================================
; 0000 02C2 
; 0000 02C3     //
; 0000 02C4     //
; 0000 02C5     // Global enable interrupts
; 0000 02C6     #asm("sei")
	sei
; 0000 02C7 
; 0000 02C8     while (1)
_0x61:
; 0000 02C9     {
; 0000 02CA 
; 0000 02CB         #asm("WDR") ;//clear WDT
	WDR
; 0000 02CC         switch(STATE_ID)
	MOV  R30,R12
	LDI  R31,0
; 0000 02CD         {
; 0000 02CE             //-----------------------------------------
; 0000 02CF              case STATE_INIT_RF_NO_MESH:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x67
; 0000 02D0 
; 0000 02D1                 if(Last_RF_Config!=NO_MESH_TYPE)
	LDS  R30,_Last_RF_Config
	CPI  R30,0
	BREQ _0x68
; 0000 02D2                 {
; 0000 02D3                     //CC1101_Init();
; 0000 02D4                     power_on_Reset_cc1101();
	CALL SUBOPT_0xD
; 0000 02D5                     delay_ms(20);
; 0000 02D6                     CC1101_Setup();
; 0000 02D7                     delay_ms(100);
	CALL SUBOPT_0xB
; 0000 02D8                     Strobes_Comm(SIDLE);
	CALL SUBOPT_0xE
; 0000 02D9                     Strobes_Comm(SFRX);
; 0000 02DA                     //Strobes_Comm(SFTX);
; 0000 02DB                     Strobes_Comm(SPWD);
	CALL SUBOPT_0xF
; 0000 02DC                     Last_RF_Config=NO_MESH_TYPE;
	LDI  R30,LOW(0)
	STS  _Last_RF_Config,R30
; 0000 02DD                 }
; 0000 02DE                 STATE_ID=STATE_SENDGELEX;  //finish state
_0x68:
	LDI  R30,LOW(3)
	MOV  R12,R30
; 0000 02DF              break;
	RJMP _0x66
; 0000 02E0               //-----------------------------------------
; 0000 02E1             case STATE_SENDGELEX:
_0x67:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x69
; 0000 02E2 
; 0000 02E3                 Reset_WDT();
	RCALL _Reset_WDT
; 0000 02E4                 usart_ProcessCommand();
	CALL _usart_ProcessCommand
; 0000 02E5                 STATE_ID=STATE_WAITGELEX;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x10
; 0000 02E6                 rfFlag =0 ;
; 0000 02E7                 iTimeout=0;
; 0000 02E8                 iWait=1500;
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	MOVW R10,R30
; 0000 02E9                 Reset_WDT();
	RCALL _Reset_WDT
; 0000 02EA             break;
	RJMP _0x66
; 0000 02EB             //-----------------------------------------
; 0000 02EC             case STATE_WAITGELEX:
_0x69:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x6A
; 0000 02ED                 Reset_WDT();
	CALL SUBOPT_0x11
; 0000 02EE                 if(rfFlag == 1)
	BRNE _0x6B
; 0000 02EF                 {
; 0000 02F0                     Reset_WDT();
	RCALL _Reset_WDT
; 0000 02F1                     delay_ms(100);   //need this delay for FIFO
	CALL SUBOPT_0xB
; 0000 02F2                     ProcessRF();
	CALL _ProcessRF
; 0000 02F3                     putBuffer1(tx_buffer,tx_counter);
	CALL SUBOPT_0x12
	ST   -Y,R4
	CALL SUBOPT_0x13
; 0000 02F4                     iTimeout=0;
; 0000 02F5                     rfFlag =0 ;
	CALL SUBOPT_0x14
; 0000 02F6                     tx_index=0;
; 0000 02F7                     //CC1101_ReInit();
; 0000 02F8                     Reset_WDT();
	RCALL _Reset_WDT
; 0000 02F9                     STATE_ID=STATE_WAITHHU;
	CLR  R12
; 0000 02FA                 }
; 0000 02FB                 if(iTimeout>=iWait)//ms
_0x6B:
	CALL SUBOPT_0x15
	CP   R26,R10
	CPC  R27,R11
	BRLT _0x6C
; 0000 02FC                 {
; 0000 02FD                     iTimeout=0;
	CALL SUBOPT_0x6
; 0000 02FE                     rfFlag =0 ;
	CALL SUBOPT_0x14
; 0000 02FF                     tx_index=0;
; 0000 0300                     STATE_ID=STATE_WAITHHU;
	CLR  R12
; 0000 0301                     CC1101_ReInit();
	CALL _CC1101_ReInit
; 0000 0302                     Reset_WDT();
	RCALL _Reset_WDT
; 0000 0303                 }
; 0000 0304 
; 0000 0305                 if((iTimeout%1000)==0)Reset_WDT();
_0x6C:
	CALL SUBOPT_0x16
	BRNE _0x6D
	RCALL _Reset_WDT
; 0000 0306             break;
_0x6D:
	RJMP _0x66
; 0000 0307 
; 0000 0308 
; 0000 0309             //   mesh funtion--------------------------------------------------------------------------------
; 0000 030A             //-----------------------------------------
; 0000 030B              case STATE_INIT_RF_MESH:
_0x6A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x6E
; 0000 030C                 if(Last_RF_Config!=MESH_TYPE)
	LDS  R26,_Last_RF_Config
	CPI  R26,LOW(0x1)
	BREQ _0x6F
; 0000 030D                 {
; 0000 030E                     Reset_WDT();
	RCALL _Reset_WDT
; 0000 030F                     CC1101_Init_Mesh();  //F0=408.125MHz
	CALL _CC1101_Init_Mesh
; 0000 0310                     Last_RF_Config=MESH_TYPE;
	LDI  R30,LOW(1)
	STS  _Last_RF_Config,R30
; 0000 0311                 }
; 0000 0312                 if(Mesh_Get_Data232())// check XOR,lay No, Comand ID tu form 232
_0x6F:
	CALL _Mesh_Get_Data232
	CPI  R30,0
	BREQ _0x70
; 0000 0313                 {
; 0000 0314 
; 0000 0315                     if( (Meter_Type_ID == ME41_Mesh_16CH_NoIEC_Type)||(Meter_Type_ID == ME41_Mesh_1CH_NoIEC_Type)
; 0000 0316                       ||(Meter_Type_ID == ME42_Mesh_16CH_NoIEC_Type)||(Meter_Type_ID == ME42_Mesh_1CH_NoIEC_Type))
	LDS  R26,_Meter_Type_ID
	CPI  R26,LOW(0x5)
	BREQ _0x72
	CPI  R26,LOW(0x15)
	BREQ _0x72
	CPI  R26,LOW(0x6)
	BREQ _0x72
	CPI  R26,LOW(0x16)
	BRNE _0x71
_0x72:
; 0000 0317                     {
; 0000 0318                         STATE_ID=STATE_ME41_42_SCAN  ;   //next state: process ME-41 ME-42: Tao
	LDI  R30,LOW(18)
	RJMP _0x11A
; 0000 0319                     }
; 0000 031A                     else
_0x71:
; 0000 031B                     {
; 0000 031C                             //HHU ID random
; 0000 031D                             Make_HHU_ID();
	RCALL _Make_HHU_ID
; 0000 031E 
; 0000 031F                             STATE_ID=STATE_SEND_SCAN_MESH;
	LDI  R30,LOW(7)
_0x11A:
	MOV  R12,R30
; 0000 0320                             //xoa log cu
; 0000 0321                             #ifdef Send_Log_Option
; 0000 0322                                 Clear_Data_Log_Buff();
; 0000 0323                                 Send_2log_Flag=FALSE;
; 0000 0324                             #endif
; 0000 0325                     }
; 0000 0326 
; 0000 0327                 }
; 0000 0328                 else
	RJMP _0x75
_0x70:
; 0000 0329                 {
; 0000 032A                     STATE_ID=STATE_WAITHHU;  //next state
	CLR  R12
; 0000 032B 
; 0000 032C                 }
_0x75:
; 0000 032D 
; 0000 032E                 rx_wr_index1 = 0;
	CLR  R7
; 0000 032F                 rx_counter1=0;
	CLR  R6
; 0000 0330                 iTimeout=0;
	CALL SUBOPT_0x6
; 0000 0331                 rfFlag =0 ;
	CALL SUBOPT_0x14
; 0000 0332                 tx_index=0;
; 0000 0333                 tx_counter=0;
	CLR  R4
; 0000 0334 
; 0000 0335 
; 0000 0336             break;
	RJMP _0x66
; 0000 0337             //-----------------------------------------
; 0000 0338             case STATE_SEND_SCAN_MESH:
_0x6E:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x76
; 0000 0339 
; 0000 033A                 Reset_WDT();
	CALL SUBOPT_0x17
; 0000 033B                 Frame_Seq_Num=1; //imit first time
; 0000 033C                 RF_Send_Scan(Frame_Seq_Num,Current_Channel);
; 0000 033D                 STATE_ID=STATE_WAIT_SCAN_MESH;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x10
; 0000 033E                 //
; 0000 033F                 rfFlag =0 ;
; 0000 0340                 iTimeout=0;
; 0000 0341                 iWait=35; //thoi gian timeout    ms
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	MOVW R10,R30
; 0000 0342                 Reset_WDT();
	RCALL _Reset_WDT
; 0000 0343             break;
	RJMP _0x66
; 0000 0344             //-----------------------------------------
; 0000 0345 
; 0000 0346 
; 0000 0347             case STATE_WAIT_SCAN_MESH:
_0x76:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x77
; 0000 0348                 Reset_WDT();
	CALL SUBOPT_0x11
; 0000 0349                 if(rfFlag == 1)
	BRNE _0x78
; 0000 034A                 {
; 0000 034B 
; 0000 034C                     delay_ms(20);   //need this delay for FIFO
	CALL SUBOPT_0x18
; 0000 034D                     //LED_Green();
; 0000 034E                     Reset_WDT();
; 0000 034F 
; 0000 0350                     if(ProcessRF_Scan_Frame()==1) //form OK
	BRNE _0x79
; 0000 0351                     {
; 0000 0352 
; 0000 0353                       STATE_ID=STATE_SEND_READ_MESH; //next state
	LDI  R30,LOW(9)
	CALL SUBOPT_0x19
; 0000 0354 
; 0000 0355                       Mesh_RF_Retry_Flag=0;
; 0000 0356                       Mesh_RF_Retry_Count=0;
; 0000 0357                       iTimeout=0;
; 0000 0358 
; 0000 0359                     }
; 0000 035A                     else
	RJMP _0x7A
_0x79:
; 0000 035B                     {
; 0000 035C                         iTimeout=0;
	CALL SUBOPT_0x6
; 0000 035D                         Mesh_RF_Retry_Flag=1;
	LDI  R30,LOW(1)
	STS  _Mesh_RF_Retry_Flag,R30
; 0000 035E                     }
_0x7A:
; 0000 035F 
; 0000 0360 
; 0000 0361                     rfFlag =0 ;
	CALL SUBOPT_0x1A
; 0000 0362                     Reset_WDT();
; 0000 0363                 }
; 0000 0364                 if(iTimeout>=iWait)
_0x78:
	CALL SUBOPT_0x1B
	BRLT _0x7B
; 0000 0365                 {
; 0000 0366                     iTimeout=0;
	CALL SUBOPT_0x6
; 0000 0367                     rfFlag =0 ;
	CALL SUBOPT_0x1C
; 0000 0368                     Mesh_RF_Retry_Flag=1;
; 0000 0369                     Reset_WDT();
; 0000 036A                 }
; 0000 036B 
; 0000 036C                 if(Mesh_RF_Retry_Flag)
_0x7B:
	LDS  R30,_Mesh_RF_Retry_Flag
	CPI  R30,0
	BREQ _0x7C
; 0000 036D                 {
; 0000 036E                     Mesh_RF_Retry_Flag=0;
	CALL SUBOPT_0x1D
; 0000 036F                     Mesh_RF_Retry_Count++;
; 0000 0370                     //For next sequen
; 0000 0371                     STATE_ID=STATE_SEND_SCAN_MESH;  //next channel
	LDI  R30,LOW(7)
	MOV  R12,R30
; 0000 0372 
; 0000 0373                     if(Mesh_RF_Retry_Count>RF_Retry_Time)  //doc lai tai tan so ban dau
	LDS  R26,_Mesh_RF_Retry_Count
	CPI  R26,LOW(0x4)
	BRLO _0x7D
; 0000 0374                     {
; 0000 0375                         if(++Current_Channel>15)  Current_Channel=0;
	CALL SUBOPT_0x1E
	BRLO _0x7E
	LDI  R30,LOW(0)
	STS  _Current_Channel,R30
; 0000 0376                     }
_0x7E:
; 0000 0377 
; 0000 0378                     if(Mesh_RF_Retry_Count>(RF_Retry_Time+45))//2 lanx16 channel -->error
_0x7D:
	LDS  R26,_Mesh_RF_Retry_Count
	CPI  R26,LOW(0x31)
	BRLO _0x7F
; 0000 0379                     {
; 0000 037A 
; 0000 037B                         Mesh_RF_Retry_Count=0;
	CALL SUBOPT_0x1F
; 0000 037C 
; 0000 037D 
; 0000 037E                         STATE_ID=STATE_SEND_CLOSE_MESH;  //finish with error
; 0000 037F                         CC1101_ReInit();//goto sleep mode
; 0000 0380                         iTimeout=0;
; 0000 0381                         rfFlag =0 ;
	LDI  R30,LOW(0)
	STS  _rfFlag,R30
; 0000 0382 
; 0000 0383                     }
; 0000 0384 
; 0000 0385                 }
_0x7F:
; 0000 0386                 if((iTimeout%1000)==0)Reset_WDT();
_0x7C:
	CALL SUBOPT_0x16
	BRNE _0x80
	RCALL _Reset_WDT
; 0000 0387             break;
_0x80:
	RJMP _0x66
; 0000 0388 
; 0000 0389              //-----------------------------------------
; 0000 038A             case STATE_SEND_READ_MESH:
_0x77:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x81
; 0000 038B 
; 0000 038C                 Reset_WDT();
	RCALL _Reset_WDT
; 0000 038D                 Frame_Seq_Num=2; //imit second time
	LDI  R30,LOW(2)
	STS  _Frame_Seq_Num,R30
; 0000 038E 
; 0000 038F                 if(Command_ID==Cmd_UI_ID)
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0x82
; 0000 0390                 {
; 0000 0391 
; 0000 0392                     RF_Send_Read_Mesh(Frame_Seq_Num,Current_Channel,Cmd_UA_ID);//first is read U
	CALL SUBOPT_0x20
	LDI  R30,LOW(23)
	ST   -Y,R30
	RJMP _0x11B
; 0000 0393 
; 0000 0394                 }
; 0000 0395                 else
_0x82:
; 0000 0396                 {
; 0000 0397                     RF_Send_Read_Mesh(Frame_Seq_Num,Current_Channel,Command_ID);
	CALL SUBOPT_0x20
	ST   -Y,R13
_0x11B:
	CALL _RF_Send_Read_Mesh
; 0000 0398                 }
; 0000 0399                 STATE_ID=STATE_WAIT_READ_MESH;
	LDI  R30,LOW(10)
	CALL SUBOPT_0x10
; 0000 039A                 //
; 0000 039B                 rfFlag =0 ;
; 0000 039C                 iTimeout=0;
; 0000 039D                 iWait=500; //thoi gian timeout
	CALL SUBOPT_0x21
; 0000 039E                 Reset_WDT();
; 0000 039F             break;
	RJMP _0x66
; 0000 03A0               //-----------------------------------------
; 0000 03A1              case STATE_WAIT_READ_MESH:
_0x81:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x84
; 0000 03A2 
; 0000 03A3                 Reset_WDT();
	CALL SUBOPT_0x11
; 0000 03A4                 if(rfFlag == 1)
	BREQ PC+3
	JMP _0x85
; 0000 03A5                 {
; 0000 03A6 
; 0000 03A7                     delay_ms(40);    //need to delay for FIFO
	CALL SUBOPT_0x22
; 0000 03A8                    // LED_Green();// RF interrupt
; 0000 03A9                     Reset_WDT();
; 0000 03AA                     if(ProcessRF_Mesh()) //form OK
	BRNE PC+3
	JMP _0x86
; 0000 03AB                     {
; 0000 03AC                          switch(Command_ID)
	CALL SUBOPT_0x23
; 0000 03AD                         {
; 0000 03AE 
; 0000 03AF                             case Cmd_180_ID:
	BREQ _0x8B
; 0000 03B0                             case Cmd_181_ID:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x8C
_0x8B:
; 0000 03B1                             case Cmd_182_ID:
	RJMP _0x8D
_0x8C:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x8E
_0x8D:
; 0000 03B2                             case Cmd_183_ID:
	RJMP _0x8F
_0x8E:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x90
_0x8F:
; 0000 03B3 
; 0000 03B4                             case Cmd_280_ID:
	RJMP _0x91
_0x90:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x92
_0x91:
; 0000 03B5                             case Cmd_281_ID:
	RJMP _0x93
_0x92:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0x94
_0x93:
; 0000 03B6                             case Cmd_282_ID:
	RJMP _0x95
_0x94:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0x96
_0x95:
; 0000 03B7                             case Cmd_283_ID:
	RJMP _0x97
_0x96:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0x98
_0x97:
; 0000 03B8 
; 0000 03B9                             case Cmd_380_ID:
	RJMP _0x99
_0x98:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x9A
_0x99:
; 0000 03BA                             case Cmd_381_ID:
	RJMP _0x9B
_0x9A:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x9C
_0x9B:
; 0000 03BB                             case Cmd_382_ID:
	RJMP _0x9D
_0x9C:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x9E
_0x9D:
; 0000 03BC                             case Cmd_383_ID:
	RJMP _0x9F
_0x9E:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0xA0
_0x9F:
; 0000 03BD 
; 0000 03BE                             case Cmd_480_ID:
	RJMP _0xA1
_0xA0:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xA2
_0xA1:
; 0000 03BF                             case Cmd_481_ID:
	RJMP _0xA3
_0xA2:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0xA4
_0xA3:
; 0000 03C0                             case Cmd_482_ID:
	RJMP _0xA5
_0xA4:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0xA6
_0xA5:
; 0000 03C1                             case Cmd_483_ID:
	RJMP _0xA7
_0xA6:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xA8
_0xA7:
; 0000 03C2 
; 0000 03C3                             case Cmd_UA_ID:
	RJMP _0xA9
_0xA8:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0xAA
_0xA9:
; 0000 03C4                             case Cmd_UB_ID:
	RJMP _0xAB
_0xAA:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xAC
_0xAB:
; 0000 03C5                             case Cmd_UC_ID:
	RJMP _0xAD
_0xAC:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0xAE
_0xAD:
; 0000 03C6                             case Cmd_IA_ID:
	RJMP _0xAF
_0xAE:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0xB0
_0xAF:
; 0000 03C7                             case Cmd_IB_ID:
	RJMP _0xB1
_0xB0:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0xB2
_0xB1:
; 0000 03C8                             case Cmd_IC_ID:
	RJMP _0xB3
_0xB2:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0xB4
_0xB3:
; 0000 03C9                                 //kWh value
; 0000 03CA                                 Real_Data[0]=((unsigned long)Payload_Buff[13]<<24)&0xFF000000;
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
; 0000 03CB                                 Real_Data[0]|=((unsigned long)Payload_Buff[14]<<16)&0x00FF0000;
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
; 0000 03CC                                 Real_Data[0]|=((unsigned long)Payload_Buff[15]<<8)&0x0000FF00;
	CALL SUBOPT_0x28
	CALL SUBOPT_0x27
; 0000 03CD                                 Real_Data[0]|=((unsigned long)Payload_Buff[16]<<0)&0x000000FF;
	CALL SUBOPT_0x29
	CALL SUBOPT_0x27
; 0000 03CE                                 STATE_ID=STATE_UART_PROCESS_MESH;  //next state :UART
	LDI  R30,LOW(11)
	MOV  R12,R30
; 0000 03CF                                 iTimeout=0;
	RJMP _0x11C
; 0000 03D0                             break;
; 0000 03D1 
; 0000 03D2                             case Cmd_UI_ID:
_0xB4:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x89
; 0000 03D3 
; 0000 03D4                                 //voltage value
; 0000 03D5                                 Real_Data[1]=((unsigned long)Payload_Buff[13]<<24)&0xFF000000;
	CALL SUBOPT_0x24
	CALL SUBOPT_0x2A
; 0000 03D6                                 Real_Data[1]|=((unsigned long)Payload_Buff[14]<<16)&0x00FF0000;
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x26
	CALL SUBOPT_0x2C
; 0000 03D7                                 Real_Data[1]|=((unsigned long)Payload_Buff[15]<<8)&0x0000FF00;
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 03D8                                 Real_Data[1]|=((unsigned long)Payload_Buff[16]<<0)&0x000000FF;
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2C
; 0000 03D9                                 STATE_ID=STATE_SEND_READ_MESH2;  //next state: read I
	LDI  R30,LOW(13)
	MOV  R12,R30
; 0000 03DA                                 #ifdef Send_Log_Option
; 0000 03DB                                     Load_2nd_Log();//load log to buff
; 0000 03DC                                 #endif
; 0000 03DD                                 iWait=200;  //delay for next
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	MOVW R10,R30
; 0000 03DE                                 iTimeout=0;
_0x11C:
	LDI  R30,LOW(0)
	STS  _iTimeout,R30
	STS  _iTimeout+1,R30
; 0000 03DF                             break;
; 0000 03E0                         }
_0x89:
; 0000 03E1                     }
; 0000 03E2                     rfFlag =0 ;
_0x86:
	CALL SUBOPT_0x1A
; 0000 03E3                     Reset_WDT();
; 0000 03E4 
; 0000 03E5 
; 0000 03E6                 }
; 0000 03E7                 if(iTimeout>=iWait)
_0x85:
	CALL SUBOPT_0x1B
	BRLT _0xB6
; 0000 03E8                 {
; 0000 03E9                     iTimeout=0;
	CALL SUBOPT_0x6
; 0000 03EA                     rfFlag =0 ;
	CALL SUBOPT_0x1C
; 0000 03EB                     Mesh_RF_Retry_Flag=1;
; 0000 03EC                     Reset_WDT();
; 0000 03ED 
; 0000 03EE                 }
; 0000 03EF 
; 0000 03F0                 if(Mesh_RF_Retry_Flag)
_0xB6:
	LDS  R30,_Mesh_RF_Retry_Flag
	CPI  R30,0
	BREQ _0xB7
; 0000 03F1                 {
; 0000 03F2 
; 0000 03F3                     Mesh_RF_Retry_Flag=0;
	LDI  R30,LOW(0)
	STS  _Mesh_RF_Retry_Flag,R30
; 0000 03F4                     STATE_ID=STATE_SEND_READ_MESH;
	LDI  R30,LOW(9)
	CALL SUBOPT_0x2D
; 0000 03F5 
; 0000 03F6                     if(++Mesh_RF_Retry_Count>RF_Retry_Time)  //retry
	BRLO _0xB8
; 0000 03F7                     {
; 0000 03F8 
; 0000 03F9                         Mesh_RF_Retry_Count=0;
	CALL SUBOPT_0x1F
; 0000 03FA                         STATE_ID=STATE_SEND_CLOSE_MESH;  //finish with error
; 0000 03FB                         CC1101_ReInit();//goto sleep mode
; 0000 03FC                         iTimeout=0;
; 0000 03FD                         rfFlag =0 ;
	LDI  R30,LOW(0)
	STS  _rfFlag,R30
; 0000 03FE 
; 0000 03FF                     }
; 0000 0400 
; 0000 0401                 }
_0xB8:
; 0000 0402                 if((iTimeout%1000)==0)Reset_WDT();
_0xB7:
	CALL SUBOPT_0x16
	BRNE _0xB9
	RCALL _Reset_WDT
; 0000 0403 
; 0000 0404             break;
_0xB9:
	RJMP _0x66
; 0000 0405             //-----------------------------------------
; 0000 0406 
; 0000 0407             case STATE_SEND_READ_MESH2:
_0x84:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xBA
; 0000 0408                 Reset_WDT();
	RCALL _Reset_WDT
; 0000 0409                 if(iTimeout>=iWait)
	CALL SUBOPT_0x1B
	BRLT _0xBB
; 0000 040A                 {
; 0000 040B 
; 0000 040C                     Frame_Seq_Num=3; //imit 3rd time
	LDI  R30,LOW(3)
	CALL SUBOPT_0x2E
; 0000 040D                     RF_Send_Read_Mesh(Frame_Seq_Num,Current_Channel,Cmd_IA_ID);//Second is read I
	LDI  R30,LOW(39)
	ST   -Y,R30
	CALL _RF_Send_Read_Mesh
; 0000 040E                     STATE_ID=STATE_WAIT_READ_MESH2;
	LDI  R30,LOW(14)
	CALL SUBOPT_0x10
; 0000 040F                     //
; 0000 0410                     rfFlag =0 ;
; 0000 0411                     iTimeout=0;
; 0000 0412                     iWait=500; //thoi gian timeout
	CALL SUBOPT_0x21
; 0000 0413                     Reset_WDT();
; 0000 0414                 }
; 0000 0415 
; 0000 0416             break;
_0xBB:
	RJMP _0x66
; 0000 0417               //-----------------------------------------
; 0000 0418              case STATE_WAIT_READ_MESH2:
_0xBA:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xBC
; 0000 0419 
; 0000 041A                 Reset_WDT();
	CALL SUBOPT_0x11
; 0000 041B 
; 0000 041C                 if(rfFlag == 1)
	BRNE _0xBD
; 0000 041D                 {
; 0000 041E 
; 0000 041F                     delay_ms(40);    //need to delay for FIFO
	CALL SUBOPT_0x22
; 0000 0420                    // LED_Green();// RF interrupt
; 0000 0421                     Reset_WDT();
; 0000 0422                     if(ProcessRF_Mesh()) //form OK
	BREQ _0xBE
; 0000 0423                     {
; 0000 0424                             //Current value
; 0000 0425                             Real_Data[2]=((unsigned long)Payload_Buff[13]<<24)&0xFF000000;
	CALL SUBOPT_0x24
	CALL SUBOPT_0x2F
; 0000 0426                             Real_Data[2]|=((unsigned long)Payload_Buff[14]<<16)&0x00FF0000;
	CALL SUBOPT_0x30
	CALL SUBOPT_0x26
	CALL SUBOPT_0x31
; 0000 0427                             Real_Data[2]|=((unsigned long)Payload_Buff[15]<<8)&0x0000FF00;
	CALL SUBOPT_0x28
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0428                             Real_Data[2]|=((unsigned long)Payload_Buff[16]<<0)&0x000000FF;
	CALL SUBOPT_0x30
	CALL SUBOPT_0x29
	CALL SUBOPT_0x31
; 0000 0429 
; 0000 042A                             if(Real_Data[2]>20000) //check khac U -->error
	CALL SUBOPT_0x30
	__CPD2N 0x4E21
	BRLO _0xBF
; 0000 042B                             {
; 0000 042C                                 Mesh_RF_Retry_Flag=1;
	LDI  R30,LOW(1)
	STS  _Mesh_RF_Retry_Flag,R30
; 0000 042D                                 iTimeout=0;
	RJMP _0x11D
; 0000 042E                             }
; 0000 042F                             else
_0xBF:
; 0000 0430                             {
; 0000 0431                                 STATE_ID=STATE_UART_PROCESS_MESH;  //next state: read I
	LDI  R30,LOW(11)
	MOV  R12,R30
; 0000 0432                                 iTimeout=0;
_0x11D:
	LDI  R30,LOW(0)
	STS  _iTimeout,R30
	STS  _iTimeout+1,R30
; 0000 0433                                 #ifdef Send_Log_Option
; 0000 0434                                     Send_2log_Flag=TRUE;
; 0000 0435                                 #endif
; 0000 0436                             }
; 0000 0437 
; 0000 0438 
; 0000 0439                     }
; 0000 043A                     rfFlag =0 ;
_0xBE:
	CALL SUBOPT_0x1A
; 0000 043B                     Reset_WDT();
; 0000 043C 
; 0000 043D 
; 0000 043E                 }
; 0000 043F                 if(iTimeout>=iWait)
_0xBD:
	CALL SUBOPT_0x1B
	BRLT _0xC1
; 0000 0440                 {
; 0000 0441                     iTimeout=0;
	CALL SUBOPT_0x6
; 0000 0442                     rfFlag =0 ;
	CALL SUBOPT_0x1C
; 0000 0443                     Mesh_RF_Retry_Flag=1;
; 0000 0444                     Reset_WDT();
; 0000 0445 
; 0000 0446                 }
; 0000 0447 
; 0000 0448                 if(Mesh_RF_Retry_Flag)
_0xC1:
	LDS  R30,_Mesh_RF_Retry_Flag
	CPI  R30,0
	BREQ _0xC2
; 0000 0449                 {
; 0000 044A 
; 0000 044B                     Mesh_RF_Retry_Flag=0;
	LDI  R30,LOW(0)
	STS  _Mesh_RF_Retry_Flag,R30
; 0000 044C                     STATE_ID=STATE_SEND_READ_MESH2;
	LDI  R30,LOW(13)
	CALL SUBOPT_0x2D
; 0000 044D 
; 0000 044E                     if(++Mesh_RF_Retry_Count>RF_Retry_Time)  //retry
	BRLO _0xC3
; 0000 044F                     {
; 0000 0450 
; 0000 0451                         Mesh_RF_Retry_Count=0;
	CALL SUBOPT_0x1F
; 0000 0452                         STATE_ID=STATE_SEND_CLOSE_MESH;  //finish with error
; 0000 0453                         CC1101_ReInit();//goto sleep mode
; 0000 0454                         iTimeout=0;
; 0000 0455                         rfFlag =0 ;
	LDI  R30,LOW(0)
	STS  _rfFlag,R30
; 0000 0456 
; 0000 0457 
; 0000 0458                     }
; 0000 0459 
; 0000 045A                 }
_0xC3:
; 0000 045B                 if((iTimeout%1000)==0)Reset_WDT();
_0xC2:
	CALL SUBOPT_0x16
	BRNE _0xC4
	RCALL _Reset_WDT
; 0000 045C 
; 0000 045D             break;
_0xC4:
	RJMP _0x66
; 0000 045E             //-----------------------------------------
; 0000 045F             case STATE_UART_PROCESS_MESH:
_0xBC:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xC5
; 0000 0460 
; 0000 0461                 LED_Green();
	CALL SUBOPT_0x32
; 0000 0462                 Clear_Tx_Buff();
; 0000 0463                 Frame_RS232_Mesh(Command_ID);
	ST   -Y,R13
	CALL _Frame_RS232_Mesh
; 0000 0464                 putBuffer1(tx_buffer,18);//18 byte data
	CALL SUBOPT_0x12
	LDI  R30,LOW(18)
	ST   -Y,R30
	CALL SUBOPT_0x13
; 0000 0465 
; 0000 0466                 //send log
; 0000 0467                 #ifdef Send_Log_Option
; 0000 0468 
; 0000 0469                     if(Send_2log_Flag)//log of U
; 0000 046A                     {
; 0000 046B                         putBuffer1(TX_Data_Log_RF_After_Dec_Buff2,49);//49 byte data       sau giai ma
; 0000 046C                         putBuffer1(TX_Data_Log_RF_Buff2,49);//49 byte data                 chua giai ma
; 0000 046D                         putBuffer1(Data_Log_RF_Buff2,49);//49 byte data                    chua giai ma
; 0000 046E                         putBuffer1(Data_Log_RF_After_Dec_Buff2,49);//49 byte data          sau giai ma
; 0000 046F                     }
; 0000 0470                     putBuffer1(TX_Data_Log_RF_After_Dec_Buff,49);//49 byte data       sau giai ma
; 0000 0471                     putBuffer1(TX_Data_Log_RF_Buff,49);//49 byte data                 chua giai ma
; 0000 0472                     putBuffer1(Data_Log_RF_Buff,49);//49 byte data                    chua giai ma
; 0000 0473                     putBuffer1(Data_Log_RF_After_Dec_Buff,49);//49 byte data          sau giai ma
; 0000 0474 
; 0000 0475                 #endif
; 0000 0476 
; 0000 0477                 iTimeout=0;
; 0000 0478                 rfFlag =0 ;
	CALL SUBOPT_0x1A
; 0000 0479                 Reset_WDT();
; 0000 047A                 CC1101_ReInit();//goto sleep mode
	RCALL _CC1101_ReInit
; 0000 047B                 STATE_ID=STATE_SEND_CLOSE_MESH;  //next state
	LDI  R30,LOW(15)
	MOV  R12,R30
; 0000 047C             break;
	RJMP _0x66
; 0000 047D 
; 0000 047E             case STATE_SEND_CLOSE_MESH:
_0xC5:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xC6
; 0000 047F                 //delay_ms(100);
; 0000 0480                 Frame_Seq_Num++; //=3 neu khong send read UI, =4 neu send read UI
	LDS  R30,_Frame_Seq_Num
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x2E
; 0000 0481                 RF_Send_Close(Frame_Seq_Num,Current_Channel);
	CALL _RF_Send_Close
; 0000 0482                 CC1101_ReInit();//goto sleep mode
	RCALL _CC1101_ReInit
; 0000 0483 
; 0000 0484                 STATE_ID=STATE_WAITHHU;  //finish state
	CLR  R12
; 0000 0485 
; 0000 0486             break;
	RJMP _0x66
; 0000 0487 
; 0000 0488             case SEND_SW_ID:
_0xC6:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xC7
; 0000 0489 
; 0000 048A 
; 0000 048B                 LED_Green();
	CALL SUBOPT_0x32
; 0000 048C                 Clear_Tx_Buff();
; 0000 048D                 Frame_SW_ID();
	RCALL _Frame_SW_ID
; 0000 048E                 putBuffer1(tx_buffer,18);//18 byte data
	CALL SUBOPT_0x12
	LDI  R30,LOW(18)
	ST   -Y,R30
	RCALL _putBuffer1
; 0000 048F                 STATE_ID=STATE_WAITHHU;  //finish state
	CLR  R12
; 0000 0490 
; 0000 0491 
; 0000 0492             break;
	RJMP _0x66
; 0000 0493 
; 0000 0494              case SEND_RST_CHIP_ID:
_0xC7:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xC8
; 0000 0495                    Delay_3s();
	RCALL _Delay_3s
; 0000 0496                    while(1);
_0xC9:
	RJMP _0xC9
; 0000 0497             break;
; 0000 0498 
; 0000 0499 
; 0000 049A 
; 0000 049B             //------------------------------------------------------------------------------------------------
; 0000 049C            // ME-41, ME-42 Process here
; 0000 049D 
; 0000 049E 
; 0000 049F             case STATE_ME41_42_SCAN:
_0xC8:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xCC
; 0000 04A0                 //HHU ID random
; 0000 04A1                 Make_HHU_ID();
	RCALL _Make_HHU_ID
; 0000 04A2                 Reset_WDT();
	CALL SUBOPT_0x17
; 0000 04A3                 Frame_Seq_Num=1; //imit first time
; 0000 04A4                 RF_Send_Scan(Frame_Seq_Num,Current_Channel);
; 0000 04A5                 STATE_ID=STATE_ME41_42_WAIT_SCAN;
	LDI  R30,LOW(19)
	CALL SUBOPT_0x10
; 0000 04A6                 //
; 0000 04A7                 rfFlag =0 ;
; 0000 04A8                 iTimeout=0;
; 0000 04A9                 iWait=35; //thoi gian timeout    ms
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	MOVW R10,R30
; 0000 04AA                 Reset_WDT();
	RCALL _Reset_WDT
; 0000 04AB 
; 0000 04AC             break;
	RJMP _0x66
; 0000 04AD 
; 0000 04AE 
; 0000 04AF             case STATE_ME41_42_WAIT_SCAN:
_0xCC:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xCD
; 0000 04B0                 Reset_WDT();
	CALL SUBOPT_0x11
; 0000 04B1                 if(rfFlag == 1)
	BRNE _0xCE
; 0000 04B2                 {
; 0000 04B3 
; 0000 04B4                     delay_ms(20);   //need this delay for FIFO
	CALL SUBOPT_0x18
; 0000 04B5                     //LED_Green();
; 0000 04B6                     Reset_WDT();
; 0000 04B7 
; 0000 04B8                     if(ProcessRF_Scan_Frame()==1) //form OK
	BRNE _0xCF
; 0000 04B9                     {
; 0000 04BA 
; 0000 04BB                       STATE_ID=STATE_ME41_42_PASSWORD; //next state
	LDI  R30,LOW(20)
	CALL SUBOPT_0x19
; 0000 04BC                       Mesh_RF_Retry_Flag=0;
; 0000 04BD                       Mesh_RF_Retry_Count=0;
; 0000 04BE                       iTimeout=0;
; 0000 04BF 
; 0000 04C0                     }
; 0000 04C1                     else
	RJMP _0xD0
_0xCF:
; 0000 04C2                     {
; 0000 04C3                         iTimeout=0;
	CALL SUBOPT_0x6
; 0000 04C4                         Mesh_RF_Retry_Flag=1;
	LDI  R30,LOW(1)
	STS  _Mesh_RF_Retry_Flag,R30
; 0000 04C5                     }
_0xD0:
; 0000 04C6 
; 0000 04C7 
; 0000 04C8                     rfFlag =0 ;
	CALL SUBOPT_0x1A
; 0000 04C9                     Reset_WDT();
; 0000 04CA                 }
; 0000 04CB                 if(iTimeout>=iWait)
_0xCE:
	CALL SUBOPT_0x1B
	BRLT _0xD1
; 0000 04CC                 {
; 0000 04CD                     iTimeout=0;
	CALL SUBOPT_0x6
; 0000 04CE                     rfFlag =0 ;
	CALL SUBOPT_0x1C
; 0000 04CF                     Mesh_RF_Retry_Flag=1;
; 0000 04D0                     Reset_WDT();
; 0000 04D1                 }
; 0000 04D2 
; 0000 04D3                 if(Mesh_RF_Retry_Flag)
_0xD1:
	LDS  R30,_Mesh_RF_Retry_Flag
	CPI  R30,0
	BREQ _0xD2
; 0000 04D4                 {
; 0000 04D5                     Mesh_RF_Retry_Flag=0;
	CALL SUBOPT_0x1D
; 0000 04D6                     Mesh_RF_Retry_Count++;
; 0000 04D7                     //For next sequen
; 0000 04D8                     STATE_ID=STATE_ME41_42_SCAN;  //next channel
	LDI  R30,LOW(18)
	MOV  R12,R30
; 0000 04D9 
; 0000 04DA                     if(Mesh_RF_Retry_Count>RF_Retry_Time)  //doc lai tai tan so ban dau
	LDS  R26,_Mesh_RF_Retry_Count
	CPI  R26,LOW(0x4)
	BRLO _0xD3
; 0000 04DB                     {
; 0000 04DC                         if(++Current_Channel>15)  Current_Channel=0;
	CALL SUBOPT_0x1E
	BRLO _0xD4
	LDI  R30,LOW(0)
	STS  _Current_Channel,R30
; 0000 04DD                     }
_0xD4:
; 0000 04DE 
; 0000 04DF                     if(Mesh_RF_Retry_Count>(RF_Retry_Time+45))//2 lanx16 channel -->error
_0xD3:
	LDS  R26,_Mesh_RF_Retry_Count
	CPI  R26,LOW(0x31)
	BRLO _0xD5
; 0000 04E0                     {
; 0000 04E1                         Mesh_RF_Retry_Count=0;
	CALL SUBOPT_0x33
; 0000 04E2 
; 0000 04E3                         STATE_ID=STATE_ME41_42_CLOSE;  //finish with error
; 0000 04E4                         CC1101_ReInit();//goto sleep mode
; 0000 04E5                         iTimeout=0;
; 0000 04E6                         rfFlag =0 ;
	LDI  R30,LOW(0)
	STS  _rfFlag,R30
; 0000 04E7 
; 0000 04E8                     }
; 0000 04E9 
; 0000 04EA                 }
_0xD5:
; 0000 04EB                 if((iTimeout%1000)==0)Reset_WDT();
_0xD2:
	CALL SUBOPT_0x16
	BRNE _0xD6
	RCALL _Reset_WDT
; 0000 04EC 
; 0000 04ED             break;
_0xD6:
	RJMP _0x66
; 0000 04EE 
; 0000 04EF             case STATE_ME41_42_PASSWORD:
_0xCD:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0xD7
; 0000 04F0                Clear_Data(Old_Data,64);
	LDI  R30,LOW(_Old_Data)
	LDI  R31,HIGH(_Old_Data)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	CALL _Clear_Data
; 0000 04F1                 Reset_WDT();
	RCALL _Reset_WDT
; 0000 04F2                 Frame_Seq_Num=2; //imit second time
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2E
; 0000 04F3 
; 0000 04F4                 RF_Send_Password(Frame_Seq_Num, Current_Channel, 1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _RF_Send_Password
; 0000 04F5                 delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x34
; 0000 04F6                 Frame_Seq_Num=3;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x2E
; 0000 04F7                 RF_Send_Password(Frame_Seq_Num, Current_Channel, 2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _RF_Send_Password
; 0000 04F8                 To_Process_WaitRF();// goto RX mode
	CALL SUBOPT_0x35
; 0000 04F9                  write_Reg(PKTLEN,64);// for Recive data
	LDI  R30,LOW(64)
	CALL SUBOPT_0x36
; 0000 04FA 
; 0000 04FB                 STATE_ID=STATE_ME41_42_WAIT_PASSWORD;
	CALL SUBOPT_0x10
; 0000 04FC                 //
; 0000 04FD                 rfFlag =0 ;
; 0000 04FE                 iTimeout=0;
; 0000 04FF                 iWait=500; //thoi gian timeout
	CALL SUBOPT_0x21
; 0000 0500                 Reset_WDT();
; 0000 0501              break;
	RJMP _0x66
; 0000 0502 
; 0000 0503             case STATE_ME41_42_WAIT_PASSWORD:
_0xD7:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0xD8
; 0000 0504                 Reset_WDT();
	CALL SUBOPT_0x11
; 0000 0505                 if(rfFlag == 1)
	BRNE _0xD9
; 0000 0506                 {
; 0000 0507                     delay_ms(55);    //need to delay for FIFO
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	CALL SUBOPT_0x34
; 0000 0508                    // LED_Green();// RF interrupt
; 0000 0509                     Reset_WDT();
	RCALL _Reset_WDT
; 0000 050A                     if(ProcessRF_Password()==1) //form OK
	CALL _ProcessRF_Password
	CPI  R30,LOW(0x1)
	BRNE _0xDA
; 0000 050B                     {
; 0000 050C 
; 0000 050D                     STATE_ID=STATE_ME41_42_WAIT_PASSWORD;  //next state: read I
	LDI  R30,LOW(21)
	MOV  R12,R30
; 0000 050E                     #ifdef Send_Log_Option
; 0000 050F                         Load_2nd_Log();//load log to buff
; 0000 0510                     #endif
; 0000 0511 
; 0000 0512                     }
; 0000 0513 
; 0000 0514                     if(ProcessRF_Password()==2) //form OK
_0xDA:
	CALL _ProcessRF_Password
	CPI  R30,LOW(0x2)
	BRNE _0xDB
; 0000 0515                     {
; 0000 0516 
; 0000 0517                     STATE_ID=STATE_ME41_42_READ;  //next state: read I
	LDI  R30,LOW(22)
	MOV  R12,R30
; 0000 0518 //                    #ifdef Send_Log_Option
; 0000 0519 //                        Load_2nd_Log();//load log to buff
; 0000 051A //                    #endif
; 0000 051B 
; 0000 051C                     }
; 0000 051D                     rfFlag =0 ;
_0xDB:
	CALL SUBOPT_0x1A
; 0000 051E                     Reset_WDT();
; 0000 051F                     iWait=500;  //delay for next
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	MOVW R10,R30
; 0000 0520                     iTimeout=0;
	CALL SUBOPT_0x6
; 0000 0521                 }
; 0000 0522                 if(iTimeout>=iWait)
_0xD9:
	CALL SUBOPT_0x1B
	BRLT _0xDC
; 0000 0523                 {
; 0000 0524                     iTimeout=0;
	CALL SUBOPT_0x6
; 0000 0525                     rfFlag =0 ;
	LDI  R30,LOW(0)
	STS  _rfFlag,R30
; 0000 0526                     STATE_ID=STATE_ME41_42_CLOSE;
	LDI  R30,LOW(24)
	MOV  R12,R30
; 0000 0527                     Reset_WDT();
	RCALL _Reset_WDT
; 0000 0528 
; 0000 0529                 }
; 0000 052A 
; 0000 052B              Reset_WDT();
_0xDC:
	RCALL _Reset_WDT
; 0000 052C              break;
	RJMP _0x66
; 0000 052D 
; 0000 052E             case STATE_ME41_42_READ:
_0xD8:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0xDD
; 0000 052F                 Reset_WDT();
	RCALL _Reset_WDT
; 0000 0530                 if(password_len == LONG_PASSWORD)
	LDS  R26,_password_len
	CPI  R26,LOW(0x3)
	BRNE _0xDE
; 0000 0531                   {Frame_Seq_Num=4;}
	LDI  R30,LOW(4)
	STS  _Frame_Seq_Num,R30
; 0000 0532                 if(password_len == SHORT_PASSWORD)
_0xDE:
	LDS  R26,_password_len
	CPI  R26,LOW(0x2)
	BRNE _0xDF
; 0000 0533                   {Frame_Seq_Num=3;}
	LDI  R30,LOW(3)
	STS  _Frame_Seq_Num,R30
; 0000 0534 
; 0000 0535 
; 0000 0536                 RF_Send_Read_Mesh(Frame_Seq_Num,Current_Channel,Command_ID);
_0xDF:
	CALL SUBOPT_0x20
	ST   -Y,R13
	CALL _RF_Send_Read_Mesh
; 0000 0537                 STATE_ID=STATE_ME41_42_WAIT_READ;
	LDI  R30,LOW(23)
	CALL SUBOPT_0x10
; 0000 0538                 //
; 0000 0539                 rfFlag =0 ;
; 0000 053A                 iTimeout=0;
; 0000 053B                 iWait=500; //thoi gian timeout
	CALL SUBOPT_0x21
; 0000 053C                 Reset_WDT();
; 0000 053D              break;
	RJMP _0x66
; 0000 053E 
; 0000 053F             case STATE_ME41_42_WAIT_READ:
_0xDD:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xE0
; 0000 0540                 Reset_WDT();
	CALL SUBOPT_0x11
; 0000 0541                 if(rfFlag == 1)
	BREQ PC+3
	JMP _0xE1
; 0000 0542                 {
; 0000 0543 
; 0000 0544                     delay_ms(40);    //need to delay for FIFO
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x34
; 0000 0545                    // LED_Green();// RF interrupt
; 0000 0546                     Reset_WDT();
	RCALL _Reset_WDT
; 0000 0547                     if(ProcessRF_Read_ME41_42()) //form OK
	CALL _ProcessRF_Read_ME41_42
	CPI  R30,0
	BRNE PC+3
	JMP _0xE2
; 0000 0548                     {
; 0000 0549                          switch(Command_ID)
	CALL SUBOPT_0x23
; 0000 054A                         {
; 0000 054B 
; 0000 054C                             case Cmd_180_ID:
	BREQ _0xE7
; 0000 054D                             case Cmd_181_ID:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xE8
_0xE7:
; 0000 054E                             case Cmd_182_ID:
	RJMP _0xE9
_0xE8:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xEA
_0xE9:
; 0000 054F                             case Cmd_183_ID:
	RJMP _0xEB
_0xEA:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xEC
_0xEB:
; 0000 0550 
; 0000 0551                             case Cmd_280_ID:
	RJMP _0xED
_0xEC:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xEE
_0xED:
; 0000 0552                             case Cmd_281_ID:
	RJMP _0xEF
_0xEE:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xF0
_0xEF:
; 0000 0553                             case Cmd_282_ID:
	RJMP _0xF1
_0xF0:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0xF2
_0xF1:
; 0000 0554                             case Cmd_283_ID:
	RJMP _0xF3
_0xF2:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0xF4
_0xF3:
; 0000 0555 
; 0000 0556                             case Cmd_380_ID:
	RJMP _0xF5
_0xF4:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xF6
_0xF5:
; 0000 0557                             case Cmd_381_ID:
	RJMP _0xF7
_0xF6:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xF8
_0xF7:
; 0000 0558                             case Cmd_382_ID:
	RJMP _0xF9
_0xF8:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0xFA
_0xF9:
; 0000 0559                             case Cmd_383_ID:
	RJMP _0xFB
_0xFA:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0xFC
_0xFB:
; 0000 055A 
; 0000 055B                             case Cmd_480_ID:
	RJMP _0xFD
_0xFC:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xFE
_0xFD:
; 0000 055C                             case Cmd_481_ID:
	RJMP _0xFF
_0xFE:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0x100
_0xFF:
; 0000 055D                             case Cmd_482_ID:
	RJMP _0x101
_0x100:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0x102
_0x101:
; 0000 055E                             case Cmd_483_ID:
	RJMP _0x103
_0x102:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x104
_0x103:
; 0000 055F                                 ME41_42_PQ[0]=payload_rec[15];
	__GETB1MN _payload_rec,15
	STS  _ME41_42_PQ,R30
; 0000 0560                                 ME41_42_PQ[1]=payload_rec[16];
	__GETB1MN _payload_rec,16
	__PUTB1MN _ME41_42_PQ,1
; 0000 0561                                 ME41_42_PQ[2]=payload_rec[17];
	__GETB1MN _payload_rec,17
	__PUTB1MN _ME41_42_PQ,2
; 0000 0562                                 ME41_42_PQ[3]=payload_rec[18];
	__GETB1MN _payload_rec,18
	__PUTB1MN _ME41_42_PQ,3
; 0000 0563                                 STATE_ID=STATE_ME41_41_SEND_UART;  //next state :UART
	RJMP _0x11E
; 0000 0564                                 iTimeout=0;
; 0000 0565                                 break;
; 0000 0566 
; 0000 0567                             case Cmd_UA_ID:
_0x104:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BREQ _0x106
; 0000 0568                             case Cmd_UB_ID:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x107
_0x106:
; 0000 0569                             case Cmd_UC_ID:
	RJMP _0x108
_0x107:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0x109
_0x108:
; 0000 056A                             case Cmd_IA_ID:
	RJMP _0x10A
_0x109:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0x10B
_0x10A:
; 0000 056B                             case Cmd_IB_ID:
	RJMP _0x10C
_0x10B:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0x10D
_0x10C:
; 0000 056C                             case Cmd_IC_ID:
	RJMP _0x10E
_0x10D:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0xE5
_0x10E:
; 0000 056D 
; 0000 056E                                 ME41_42_UI[0]=payload_rec[15];
	__GETB1MN _payload_rec,15
	STS  _ME41_42_UI,R30
; 0000 056F                                 ME41_42_UI[1]=payload_rec[16];
	__GETB1MN _payload_rec,16
	__PUTB1MN _ME41_42_UI,1
; 0000 0570                                 STATE_ID=STATE_ME41_41_SEND_UART;  //next state :UART
_0x11E:
	LDI  R30,LOW(25)
	MOV  R12,R30
; 0000 0571                                 iTimeout=0;
	CALL SUBOPT_0x6
; 0000 0572                                 break;
; 0000 0573 
; 0000 0574                         }
_0xE5:
; 0000 0575                     }
; 0000 0576                     rfFlag =0 ;
_0xE2:
	CALL SUBOPT_0x1A
; 0000 0577                     Reset_WDT();
; 0000 0578                 }
; 0000 0579                 if(iTimeout>=iWait)
_0xE1:
	CALL SUBOPT_0x1B
	BRLT _0x110
; 0000 057A                 {
; 0000 057B                     iTimeout=0;
	CALL SUBOPT_0x6
; 0000 057C                     rfFlag =0 ;
	CALL SUBOPT_0x1C
; 0000 057D                     Mesh_RF_Retry_Flag=1;
; 0000 057E                     Reset_WDT();
; 0000 057F 
; 0000 0580                 }
; 0000 0581 
; 0000 0582                 if(Mesh_RF_Retry_Flag)
_0x110:
	LDS  R30,_Mesh_RF_Retry_Flag
	CPI  R30,0
	BREQ _0x111
; 0000 0583                 {
; 0000 0584 
; 0000 0585                     Mesh_RF_Retry_Flag=0;
	LDI  R30,LOW(0)
	STS  _Mesh_RF_Retry_Flag,R30
; 0000 0586                     STATE_ID=STATE_ME41_42_READ;
	LDI  R30,LOW(22)
	CALL SUBOPT_0x2D
; 0000 0587 
; 0000 0588                     if(++Mesh_RF_Retry_Count>RF_Retry_Time)  //retry
	BRLO _0x112
; 0000 0589                     {
; 0000 058A 
; 0000 058B                         Mesh_RF_Retry_Count=0;
	CALL SUBOPT_0x33
; 0000 058C                         STATE_ID=STATE_ME41_42_CLOSE;  //finish with error
; 0000 058D                         CC1101_ReInit();//goto sleep mode
; 0000 058E                         iTimeout=0;
; 0000 058F                         rfFlag =0 ;
	LDI  R30,LOW(0)
	STS  _rfFlag,R30
; 0000 0590 
; 0000 0591                     }
; 0000 0592 
; 0000 0593                 }
_0x112:
; 0000 0594                 if((iTimeout%1000)==0)Reset_WDT();
_0x111:
	CALL SUBOPT_0x16
	BRNE _0x113
	RCALL _Reset_WDT
; 0000 0595 
; 0000 0596               break;
_0x113:
	RJMP _0x66
; 0000 0597 
; 0000 0598 
; 0000 0599 
; 0000 059A             case STATE_ME41_41_SEND_UART:
_0xE0:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0x114
; 0000 059B                 LED_Green();
	CALL SUBOPT_0x32
; 0000 059C                 Clear_Tx_Buff();
; 0000 059D                 Frame_RS232_ME41_42(Command_ID);
	ST   -Y,R13
	CALL _Frame_RS232_ME41_42
; 0000 059E                 putBuffer1(tx_buffer,18); //18 byte data
	CALL SUBOPT_0x12
	LDI  R30,LOW(18)
	ST   -Y,R30
	CALL SUBOPT_0x13
; 0000 059F 
; 0000 05A0                 //send log
; 0000 05A1 //                #ifdef Send_Log_Option
; 0000 05A2 //
; 0000 05A3 //                    if(Send_2log_Flag)//log of U
; 0000 05A4 //                    {
; 0000 05A5 //                        putBuffer1(TX_Data_Log_RF_After_Dec_Buff2,49);//49 byte data       sau giai ma
; 0000 05A6 //                        putBuffer1(TX_Data_Log_RF_Buff2,49);//49 byte data                 chua giai ma
; 0000 05A7 //                        putBuffer1(Data_Log_RF_Buff2,49);//49 byte data                    chua giai ma
; 0000 05A8 //                        putBuffer1(Data_Log_RF_After_Dec_Buff2,49);//49 byte data          sau giai ma
; 0000 05A9 //                    }
; 0000 05AA //                    putBuffer1(TX_Data_Log_RF_After_Dec_Buff,49);//49 byte data       sau giai ma
; 0000 05AB //                    putBuffer1(TX_Data_Log_RF_Buff,49);//49 byte data                 chua giai ma
; 0000 05AC //                    putBuffer1(Data_Log_RF_Buff,49);//49 byte data                    chua giai ma
; 0000 05AD //                    putBuffer1(Data_Log_RF_After_Dec_Buff,49);//49 byte data          sau giai ma
; 0000 05AE //
; 0000 05AF //                #endif
; 0000 05B0 
; 0000 05B1                 iTimeout=0;
; 0000 05B2                 rfFlag =0 ;
	CALL SUBOPT_0x1A
; 0000 05B3                 Reset_WDT();
; 0000 05B4                 CC1101_ReInit();//goto sleep mode
	RCALL _CC1101_ReInit
; 0000 05B5                 STATE_ID=STATE_SEND_CLOSE_MESH;  //next state
	LDI  R30,LOW(15)
	MOV  R12,R30
; 0000 05B6 
; 0000 05B7               break;
	RJMP _0x66
; 0000 05B8 
; 0000 05B9             case STATE_ME41_42_CLOSE:
_0x114:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x115
; 0000 05BA                 //delay_ms(100);
; 0000 05BB                 Frame_Seq_Num++; //=5
	LDS  R30,_Frame_Seq_Num
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x2E
; 0000 05BC                 RF_Send_Close(Frame_Seq_Num,Current_Channel);
	CALL _RF_Send_Close
; 0000 05BD                 CC1101_ReInit();//goto sleep mode
	RCALL _CC1101_ReInit
; 0000 05BE 
; 0000 05BF                 STATE_ID=STATE_WAITHHU;  //finish state
	CLR  R12
; 0000 05C0 
; 0000 05C1               break;
; 0000 05C2 
; 0000 05C3             //------------------------------------------------------------------------------------------------
; 0000 05C4 
; 0000 05C5             case STATE_WAITHHU:
_0x115:
; 0000 05C6             default:
; 0000 05C7             break;
; 0000 05C8         }
_0x66:
; 0000 05C9     }
	RJMP _0x61
; 0000 05CA }
_0x118:
	RJMP _0x118
;/*----------------------------------------------------------------------------------*-
;------------------------------- rfcc1101.c -----------------------------------------------
;-*----------------------------------------------------------------------------------*/
;#include "Global.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include "rfcc1101.h"
;#include "delay.h"
;
;unsigned char Signal_RSSI_CE18G;
;
;void LED_init(void)
; 0001 000B {

	.CSEG
_LED_init:
; 0001 000C         DDRD.6=1;
	SBI  0x11,6
; 0001 000D         DDRD.7=1;
	SBI  0x11,7
; 0001 000E 
; 0001 000F         DDRE.5=1; //LED 2 EKEMP
	SBI  0x2,5
; 0001 0010         DDRE.6=1; //LED 1 EKEMP
	SBI  0x2,6
; 0001 0011 
; 0001 0012 
; 0001 0013         LED_Orange();
	RCALL _LED_Orange
; 0001 0014 }
	RET
;
;void LED_Orange(void)
; 0001 0017 {
_LED_Orange:
; 0001 0018         LED0=0;
	CBI  0x12,6
; 0001 0019         LED1=0;
	CBI  0x12,7
; 0001 001A 
; 0001 001B         PORTE.5=0;
	CBI  0x3,5
; 0001 001C         PORTE.6=0;
	RJMP _0x20A001B
; 0001 001D }
;
;void LED_Red(void)
; 0001 0020 {
_LED_Red:
; 0001 0021         LED0=0;
	CBI  0x12,6
; 0001 0022         LED1=1;
	SBI  0x12,7
; 0001 0023 
; 0001 0024         PORTE.5=0;
	CBI  0x3,5
; 0001 0025         PORTE.6=1;
	RJMP _0x20A001A
; 0001 0026 }
;
;void LED_Green(void)
; 0001 0029 {
_LED_Green:
; 0001 002A         LED0=1;
	SBI  0x12,6
; 0001 002B         LED1=0;
	CBI  0x12,7
; 0001 002C 
; 0001 002D         PORTE.5=1;
	SBI  0x3,5
; 0001 002E         PORTE.6=0;
_0x20A001B:
	CBI  0x3,6
; 0001 002F }
	RET
;
;void LED_Off(void)
; 0001 0032 {
_LED_Off:
; 0001 0033         LED0=1;
	SBI  0x12,6
; 0001 0034         LED1=1;
	SBI  0x12,7
; 0001 0035 
; 0001 0036         PORTE.5=1;
	SBI  0x3,5
; 0001 0037         PORTE.6=1;
_0x20A001A:
	SBI  0x3,6
; 0001 0038 }
	RET
;
;// SPI initialization
;void spi_Init()
; 0001 003C {
_spi_Init:
; 0001 003D         DDRB.1=1;               // SCK=SCLK : output
	SBI  0x17,1
; 0001 003E         DDRB.3=0;               // MISO : input
	CBI  0x17,3
; 0001 003F         DDRB.2=1;               // MOSI : output
	SBI  0x17,2
; 0001 0040         DDRB.0=1;               // nSEL : output
	SBI  0x17,0
; 0001 0041         DDRD.0=0;               // GDO2 : input
	CBI  0x11,0
; 0001 0042         DDRD.1=0;               // GDO0 : input
	CBI  0x11,1
; 0001 0043 
; 0001 0044         PORTB.3=1;
	SBI  0x18,3
; 0001 0045         PORTD.0=1;
	SBI  0x12,0
; 0001 0046         PORTD.1=1;
	SBI  0x12,1
; 0001 0047 
; 0001 0048         DDRB.5=1;               // RE_X6: output
	SBI  0x17,5
; 0001 0049         DDRB.4=1;               // TE_X6: output
	SBI  0x17,4
; 0001 004A 
; 0001 004B         #ifdef USE_HHU_G4_HH        //HHU G4 huu hong
; 0001 004C             DDRA.1=1;               // RE_EKEMP: output
; 0001 004D             DDRA.2=1;               // TE_EKEMP: output
; 0001 004E         #else
; 0001 004F             DDRA.0=1;               // RE_EKEMP: output
	SBI  0x1A,0
; 0001 0050             DDRA.1=1;               // TE_EKEMP: output
	SBI  0x1A,1
; 0001 0051         #endif
; 0001 0052 
; 0001 0053         idle_mode_PA();
	RCALL _idle_mode_PA
; 0001 0054 
; 0001 0055         //SPIE = 0:             SPI Interrupt Enable
; 0001 0056         //SPE = 1:              SPI Enable
; 0001 0057         //DORD = 0:             Data Order ; MSB is transmitted first
; 0001 0058         //MSTR = 1:             Master/Slave Select
; 0001 0059         //CPOL = 0:             Clock Polarity  ::: Low
; 0001 005A         //CPHA = 0:             Clock Phase :: Cycle Start
; 0001 005B         //SPR1, SPR0 = 0,0:     SPI Clock Rate Select ::: fosc/4
; 0001 005C         SPCR=0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0001 005D 
; 0001 005E         SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0001 005F 
; 0001 0060         //SPSR|=0x01;             // SPIX2  4MHz
; 0001 0061 }
	RET
;
;unsigned char spi_put(unsigned char ucdata)
; 0001 0064 {
_spi_put:
; 0001 0065         SPDR = ucdata;                  // Start transmission
;	ucdata -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0001 0066         while(!(SPSR & (1<<SPIF))){}    // Wait for transmission complete
_0x20045:
	SBIS 0xE,7
	RJMP _0x20045
; 0001 0067         return  SPDR;                   // Return data register
	IN   R30,0xF
	RJMP _0x20A0019
; 0001 0068 }
;
;//--------------------------------------------------------------------------------------
;//  void write_Reg(unsigned char address, unsigned char value)
;//
;//  DESCRIPTION:
;//      Function for writing to a single CC1101 register
;//
;//  ARGUMENTS:
;//      unsigned char address
;//                    Address of a specific CC1101 register to accessed.
;//      unsigned char value
;//                    Value to be written to the specified CC1101 register.
;void write_Reg(uchar address, uchar value)
; 0001 0076 {
_write_Reg:
; 0001 0077         nSEL=0;
;	address -> Y+1
;	value -> Y+0
	CBI  0x18,0
; 0001 0078         while (MISO){}
_0x2004A:
	SBIC 0x16,3
	RJMP _0x2004A
; 0001 0079         spi_put(address|Single_Write);
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _spi_put
; 0001 007A         spi_put(value);
	LD   R30,Y
	CALL SUBOPT_0x37
; 0001 007B         nSEL=1;
; 0001 007C }
	ADIW R28,2
	RET
;unsigned char read_Reg(uchar address)
; 0001 007E {
_read_Reg:
; 0001 007F 		volatile unsigned int timeout = 0xffff;
; 0001 0080         unsigned char Result;
; 0001 0081         nSEL=0;
	SBIW R28,2
	LDI  R30,LOW(255)
	ST   Y,R30
	STD  Y+1,R30
	ST   -Y,R17
;	address -> Y+3
;	timeout -> Y+1
;	Result -> R17
	CBI  0x18,0
; 0001 0082         while((MISO) && ((--timeout) > 0));			// Wait for CC1101 ready ( //Wait until SOMI goes low)
_0x20051:
	SBIS 0x16,3
	RJMP _0x20054
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,1
	STD  Y+1,R26
	STD  Y+1+1,R27
	CALL __CPW02
	BRLO _0x20055
_0x20054:
	RJMP _0x20053
_0x20055:
	RJMP _0x20051
_0x20053:
; 0001 0083         spi_put(address | 0x80);
	LDD  R30,Y+3
	ORI  R30,0x80
	ST   -Y,R30
	RCALL _spi_put
; 0001 0084   		Result = spi_put(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _spi_put
	MOV  R17,R30
; 0001 0085         nSEL=1;
	SBI  0x18,0
; 0001 0086         return Result;
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x20A0010
; 0001 0087 }
;//--------------------------------------------------------------------------------------
;//  void Strobes_Comm(unsigned char addr_Strobes)
;//
;//  DESCRIPTION:
;//      Function for writting a command strobe to CC1101
;//
;//  ARGUMENTS:
;//      unsigned char addr_Strobes
;//                    Address of a specific command strobe register.
;void Strobes_Comm(uchar addr_Strobes)
; 0001 0092 {
_Strobes_Comm:
; 0001 0093         nSEL=0;
;	addr_Strobes -> Y+0
	CBI  0x18,0
; 0001 0094         while (MISO){}
_0x2005A:
	SBIC 0x16,3
	RJMP _0x2005A
; 0001 0095         spi_put(addr_Strobes);
	LD   R30,Y
	CALL SUBOPT_0x37
; 0001 0096         nSEL=1;
; 0001 0097 }
_0x20A0019:
	ADIW R28,1
	RET
;//--------------------------------------------------------------------------------------
;//
;// Note this reset procedure is only required just after the power supply is first turned on.
;// If the user wants to reset the CC1101 after this, it is only necessary to issue an SRES command strobe.
;//
;void power_on_Reset_cc1101(void)
; 0001 009E {
_power_on_Reset_cc1101:
; 0001 009F          nSEL=0;                        // Strobe CSn low / high
	CBI  0x18,0
; 0001 00A0          delay_ms(1);
	CALL SUBOPT_0x38
; 0001 00A1          nSEL=1;                        // Hold CSn high for at least 40µs relative to pulling CSn low
	SBI  0x18,0
; 0001 00A2          delay_ms(1);
	CALL SUBOPT_0x38
; 0001 00A3          nSEL=0;                        // Pull CSn low
	CBI  0x18,0
; 0001 00A4          while (MISO){}                 // Wait for SO to go low (CHIP_RDYn)
_0x20065:
	SBIC 0x16,3
	RJMP _0x20065
; 0001 00A5          spi_put(SRES);                 // Issue the SRES strobe on the SI line
	LDI  R30,LOW(48)
	CALL SUBOPT_0x37
; 0001 00A6          nSEL=1;                        // When SO goes low again, reset is complete and the chip is in the IDLE state
; 0001 00A7          delay_ms(1);
	CALL SUBOPT_0x38
; 0001 00A8 }
	RET
;//--------------------------------------------------------------------------------------
;void CC1101_Setup(void)
; 0001 00AB {
_CC1101_Setup:
; 0001 00AC         /*
; 0001 00AD         write_Reg(IOCFG2,0x07);         // Asserts when a packet has been received with CRC OK. De-asserts when the first byte is read from the RX FIFO.
; 0001 00AE         write_Reg(IOCFG1,0x2E);         // MISO  // Default
; 0001 00AF         write_Reg(IOCFG0,0x06);       //0x09  // Asserts when sync word has been sent / received, and de-asserts at the end of the packet.
; 0001 00B0 
; 0001 00B1         write_Reg(FIFOTHR,0x47);        // Default (not importance if length of package less than 64)
; 0001 00B2         write_Reg(SYNC1,0xD3);          // SYNC bytes   // Default
; 0001 00B3         write_Reg(SYNC0,0x91);          // SYNC bytes   // Default
; 0001 00B4 
; 0001 00B5         write_Reg(PKTLEN,0xFF);         // Max 255 bytes payload
; 0001 00B6         write_Reg(PKTCTRL1,0x64);       // (3)CRC_AUTOFLUSH =1: Enable automatic flush of RX FIFO when CRC is not OK;    0x0C
; 0001 00B7                                         // (2)APPEND_STATUS=1: Add RSSI and LQI byte to the payload,
; 0001 00B8                                         // (1:0) ADR_CHK[1:0]=0: No address check
; 0001 00B9 
; 0001 00BA         write_Reg(PKTCTRL0,0x45);       // (6)WHITE_DATA=0: Data whitening off,       0x05
; 0001 00BB                                         // (5:4)PKT_FORMAT[1:0]=0: Normal mode, use FIFOs for RX and TX
; 0001 00BC                                         // (2)CRC_EN=1: CRC calculation in TX and CRC check in RX enabled
; 0001 00BD                                         // (1:0)LENGTH_CONFIG[1:0]=1: Variable packet length mode. Packet length configured by the first byte after sync word
; 0001 00BE 
; 0001 00BF 
; 0001 00C0         write_Reg(ADDR,0x00);           // Address used for packet filtration.
; 0001 00C1         write_Reg(CHANNR,0x00);         // Channel number
; 0001 00C2 
; 0001 00C3         write_Reg(FSCTRL1,0x06);        // (4:0)FREQ_IF[4:0]=6: The desired IF frequency to employ in RX  f(IF)=(f(XOSC)/2^10)* FREQ_IF
; 0001 00C4         write_Reg(FSCTRL0,0x00);        // (7:0)FREQOFF[7:0]=0: Frequency offset added to the base frequency before being used by the frequency synthesizer
; 0001 00C5 
; 0001 00C6         write_Reg(FREQ2,0x0F);	        // (7:6)FREQ[23:22]=0 (always)  0x0F
; 0001 00C7                                         // (5:0)FREQ[21:16]
; 0001 00C8         write_Reg(FREQ1,0xBA);          // (7:0)FREQ[15:8]   0xBA
; 0001 00C9         write_Reg(FREQ0,0x56);          // (7:0)FREQ[7:0]      0x56                 // f(carrier)=(f(XOSC)/2^16)* FREQ = 433MHz
; 0001 00CA 
; 0001 00CB         write_Reg(MDMCFG4,0xF6);	// (7:6)CHANBW_E[1:0]=3    0xC6    0xF6
; 0001 00CC                                         // (5:4)CHANBW_M[1:0]=0                 // BW(channel)=f(XOSC)/(8*(4+ CHANBW_M)*2^CHANBW_E)
; 0001 00CD                                         // (3:0)DRATE_E[3:0]=6
; 0001 00CE 
; 0001 00CF         write_Reg(MDMCFG3,0x83);        // (7:0)DRATE_M[7:0]  0x83                   // R(data)= (256 + DRATE_M)*2^DRATE_E*f(XOSC)/2^28 = 2.4kBaud
; 0001 00D0 
; 0001 00D1         write_Reg(MDMCFG2,0x13);        // (7)DEM_DCFILT_OFF=0                  GFSK, 30/32 SYNC word bits detected
; 0001 00D2                                         // (6:4)MOD_FORMAT[2:0]=1 :             GFSK
; 0001 00D3                                         // (3)MANCHESTER_EN=0 :                 Disable Manchester encoding/decoding.
; 0001 00D4                                         // (2:0) SYNC_MODE[2:0]=3               30/32 sync word bits detected
; 0001 00D5 
; 0001 00D6         write_Reg(MDMCFG1,0x22);        // (7)FEC_EN =0:                        Forward Error Correction (FEC) with interleaving for packet payload (Only supported for fixed packet length mode, i.e. PKTCTRL0.LENGTH_CONFIG =0) 4 preamble bytes (1010..10)
; 0001 00D7                                         // (6:4)NUM_PREAMBLE[2:0]=2             4 preamble bytes
; 0001 00D8                                         //(3:2)Reserved
; 0001 00D9                                         // (1:0)CHANSPC_E[1:0] =2
; 0001 00DA         write_Reg(MDMCFG0,0xF8);        // (7:0)CHANSPC_M[7:0]=248               // DELTA(f_channel)=(f_XOSC/2^18)*(256+ CHANSPC_M)*2^CHANSPC_E
; 0001 00DB 
; 0001 00DC         write_Reg(DEVIATN,0x15);        // (7)Not used
; 0001 00DD                                         // (6:4)DEVIATION_E[2:0]=4
; 0001 00DE                                         // (3)Not used
; 0001 00DF                                         // (2:0)DEVIATION_M[2:0]=0
; 0001 00E0 
; 0001 00E1         write_Reg(MCSM2,0x07);          // (2:0)RX_TIME[2:0]=7                  Timeout SYNC word until end of packet
; 0001 00E2 
; 0001 00E3         write_Reg(MCSM1,0x30);          // (7:6)Not used 0x3F, After TX or RX, state -> stay, 0x30 -> IDLE    0x30
; 0001 00E4                                         // (5:4)CCA_MODE[1:0]=3                 If RSSI below threshold unless currently receiving a packet
; 0001 00E5                                         // (3:2)RXOFF_MODE[1:0]=0               IDLE                    after packet has been received.
; 0001 00E6                                         // (1:0)TXOFF_MODE[1:0]=0               IDLE                    after packet has been sent
; 0001 00E7 
; 0001 00E8         write_Reg(MCSM0,0x18);          // (7:6)Not used  0x18
; 0001 00E9                                         // (5:4)FS_AUTOCAL[1:0]=1               Automatically calibrate when going from IDLE to RX or TX (or FSTXON)
; 0001 00EA                                         // (3:2)PO_TIMEOUT=2
; 0001 00EB                                         // (1)PIN_CTRL_EN=0
; 0001 00EC                                         // (0)XOSC_FORCE_ON=0
; 0001 00ED 
; 0001 00EE 
; 0001 00EF         write_Reg(FOCCFG,0x16);         // Default
; 0001 00F0         write_Reg(BSCFG,0x6C);          // Default
; 0001 00F1 
; 0001 00F2         write_Reg(AGCCTRL2,0x03);           //0x43
; 0001 00F3         write_Reg(AGCCTRL1,0x40);       // Default
; 0001 00F4         write_Reg(AGCCTRL0,0x91);       // Default
; 0001 00F5 
; 0001 00F6         write_Reg(WOREVT1,0x87);        // Default
; 0001 00F7         write_Reg(WOREVT0,0x6B);        // Default
; 0001 00F8         write_Reg(WORCTRL,0xFB); 	// Default
; 0001 00F9 
; 0001 00FA         write_Reg(FREND1,0x56);         // Default
; 0001 00FB         write_Reg(FREND0,0x10);         // Default           (2:0) PA_POWER[2:0]=0  Selects PA power setting. This value is an index to the PATABLE
; 0001 00FC 
; 0001 00FD         write_Reg(FSCAL3,0xEF);         // Default   0xE9
; 0001 00FE         write_Reg(FSCAL2,0x0C);         // Default      0x2A
; 0001 00FF         write_Reg(FSCAL1,0x28);         // Default      0x00
; 0001 0100         write_Reg(FSCAL0,0x1F);         // Default
; 0001 0101 
; 0001 0102         write_Reg(RCCTRL1,0x41);        // Default
; 0001 0103         write_Reg(RCCTRL0,0x00);        // Default
; 0001 0104 
; 0001 0105         write_Reg(FSTEST,0x59);         // Default
; 0001 0106         write_Reg(PTEST,0x7F);          // Default
; 0001 0107         write_Reg(AGCTEST,0x3F);        // Default
; 0001 0108 
; 0001 0109         write_Reg(TEST2,0x81);          // Default      0x81
; 0001 010A         write_Reg(TEST1,0x35);          // Default      0x35
; 0001 010B         write_Reg(TEST0,0x0B);          // Default      0x09
; 0001 010C 
; 0001 010D 
; 0001 010E         // Set TX POWER
; 0001 010F         write_Reg(PA_TABLE0,0xC0);      // 10dBm -> 0xC0, 6dBm -> 0x60
; 0001 0110         */
; 0001 0111 
; 0001 0112 
; 0001 0113 
; 0001 0114         ///*
; 0001 0115         write_Reg(IOCFG2,0x07);         // Asserts when a packet has been received with CRC OK. De-asserts when the first byte is read from the RX FIFO.
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(7)
	CALL SUBOPT_0x39
; 0001 0116         write_Reg(IOCFG1,0x2E);         // MISO  // Default
; 0001 0117         write_Reg(IOCFG0,0x06);       //0x09  // Asserts when sync word has been sent / received, and de-asserts at the end of the packet.
; 0001 0118 
; 0001 0119         write_Reg(FIFOTHR,0x47);        // Default (not importance if length of package less than 64)
; 0001 011A         write_Reg(SYNC1,0xD3);          // SYNC bytes   // Default
	LDI  R30,LOW(211)
	ST   -Y,R30
	RCALL _write_Reg
; 0001 011B         write_Reg(SYNC0,0x91);          // SYNC bytes   // Default
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(145)
	CALL SUBOPT_0x3A
; 0001 011C 
; 0001 011D         write_Reg(PKTLEN,0xFF);         // Max 255 bytes payload
; 0001 011E         write_Reg(PKTCTRL1,0x64);       // (3)CRC_AUTOFLUSH =1: Enable automatic flush of RX FIFO when CRC is not OK;    0x0C
	LDI  R30,LOW(100)
	ST   -Y,R30
	RCALL _write_Reg
; 0001 011F                                         // (2)APPEND_STATUS=1: Add RSSI and LQI byte to the payload,
; 0001 0120                                         // (1:0) ADR_CHK[1:0]=0: No address check
; 0001 0121 
; 0001 0122         write_Reg(PKTCTRL0,0x45);       // (6)WHITE_DATA=0: Data whitening off,       0x05
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(69)
	CALL SUBOPT_0x3B
; 0001 0123                                         // (5:4)PKT_FORMAT[1:0]=0: Normal mode, use FIFOs for RX and TX
; 0001 0124                                         // (2)CRC_EN=1: CRC calculation in TX and CRC check in RX enabled
; 0001 0125                                         // (1:0)LENGTH_CONFIG[1:0]=1: Variable packet length mode. Packet length configured by the first byte after sync word
; 0001 0126 
; 0001 0127 
; 0001 0128         write_Reg(ADDR,0x00);           // Address used for packet filtration.
; 0001 0129         write_Reg(CHANNR,0x00);         // Channel number
	CALL SUBOPT_0x3C
; 0001 012A 
; 0001 012B         write_Reg(FSCTRL1,0x06);        // (4:0)FREQ_IF[4:0]=6: The desired IF frequency to employ in RX  f(IF)=(f(XOSC)/2^10)* FREQ_IF
	CALL SUBOPT_0x3D
; 0001 012C         write_Reg(FSCTRL0,0x00);        // (7:0)FREQOFF[7:0]=0: Frequency offset added to the base frequency before being used by the frequency synthesizer
; 0001 012D 
; 0001 012E         write_Reg(FREQ2,0x0F);	        // (7:6)FREQ[23:22]=0 (always)  0x0F
	CALL SUBOPT_0x3E
; 0001 012F                                         // (5:0)FREQ[21:16]
; 0001 0130         write_Reg(FREQ1,0xBA);          // (7:0)FREQ[15:8]   0xBA
	LDI  R30,LOW(186)
	ST   -Y,R30
	RCALL _write_Reg
; 0001 0131         write_Reg(FREQ0,0x56);          // (7:0)FREQ[7:0]      0x56                 // f(carrier)=(f(XOSC)/2^16)* FREQ = 433MHz
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(86)
	ST   -Y,R30
	RCALL _write_Reg
; 0001 0132 
; 0001 0133         write_Reg(MDMCFG4,0xD6);	// (7:6)CHANBW_E[1:0]=3    0xC6    0xF6
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R30,LOW(214)
	ST   -Y,R30
	RCALL _write_Reg
; 0001 0134                                         // (5:4)CHANBW_M[1:0]=0                 // BW(channel)=f(XOSC)/(8*(4+ CHANBW_M)*2^CHANBW_E)
; 0001 0135                                         // (3:0)DRATE_E[3:0]=6
; 0001 0136 
; 0001 0137         write_Reg(MDMCFG3,0x83);        // (7:0)DRATE_M[7:0]  0x83                   // R(data)= (256 + DRATE_M)*2^DRATE_E*f(XOSC)/2^28 = 2.4kBaud
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R30,LOW(131)
	CALL SUBOPT_0x3F
; 0001 0138 
; 0001 0139         write_Reg(MDMCFG2,0x13);        // (7)DEM_DCFILT_OFF=0                  GFSK, 30/32 SYNC word bits detected
; 0001 013A                                         // (6:4)MOD_FORMAT[2:0]=1 :             GFSK
; 0001 013B                                         // (3)MANCHESTER_EN=0 :                 Disable Manchester encoding/decoding.
; 0001 013C                                         // (2:0) SYNC_MODE[2:0]=3               30/32 sync word bits detected
; 0001 013D 
; 0001 013E         write_Reg(MDMCFG1,0x22);        // (7)FEC_EN =0:                        Forward Error Correction (FEC) with interleaving for packet payload (Only supported for fixed packet length mode, i.e. PKTCTRL0.LENGTH_CONFIG =0) 4 preamble bytes (1010..10)
	LDI  R30,LOW(34)
	CALL SUBOPT_0x40
; 0001 013F                                         // (6:4)NUM_PREAMBLE[2:0]=2             4 preamble bytes
; 0001 0140                                         //(3:2)Reserved
; 0001 0141                                         // (1:0)CHANSPC_E[1:0] =2
; 0001 0142         write_Reg(MDMCFG0,0xF8);        // (7:0)CHANSPC_M[7:0]=248               // DELTA(f_channel)=(f_XOSC/2^18)*(256+ CHANSPC_M)*2^CHANSPC_E
; 0001 0143 
; 0001 0144         write_Reg(DEVIATN,0x15);        // (7)Not used
	ST   -Y,R30
	LDI  R30,LOW(21)
	JMP  _0x20A0014
; 0001 0145                                         // (6:4)DEVIATION_E[2:0]=4
; 0001 0146                                         // (3)Not used
; 0001 0147                                         // (2:0)DEVIATION_M[2:0]=0
; 0001 0148 
; 0001 0149         write_Reg(MCSM2,0x07);          // (2:0)RX_TIME[2:0]=7                  Timeout SYNC word until end of packet
; 0001 014A 
; 0001 014B         write_Reg(MCSM1,0x30);          // (7:6)Not used 0x3F, After TX or RX, state -> stay, 0x30 -> IDLE    0x30
; 0001 014C                                         // (5:4)CCA_MODE[1:0]=3                 If RSSI below threshold unless currently receiving a packet
; 0001 014D                                         // (3:2)RXOFF_MODE[1:0]=0               IDLE                    after packet has been received.
; 0001 014E                                         // (1:0)TXOFF_MODE[1:0]=0               IDLE                    after packet has been sent
; 0001 014F 
; 0001 0150         write_Reg(MCSM0,0x18);          // (7:6)Not used  0x18
; 0001 0151                                         // (5:4)FS_AUTOCAL[1:0]=1               Automatically calibrate when going from IDLE to RX or TX (or FSTXON)
; 0001 0152                                         // (3:2)PO_TIMEOUT=2
; 0001 0153                                         // (1)PIN_CTRL_EN=0
; 0001 0154                                         // (0)XOSC_FORCE_ON=0
; 0001 0155 
; 0001 0156 
; 0001 0157         write_Reg(FOCCFG,0x16);         // Default
; 0001 0158         write_Reg(BSCFG,0x6C);          // Default
; 0001 0159 
; 0001 015A         write_Reg(AGCCTRL2,0x03);           //0x43
; 0001 015B         write_Reg(AGCCTRL1,0x40);       // Default
; 0001 015C         write_Reg(AGCCTRL0,0x91);       // Default
; 0001 015D 
; 0001 015E         write_Reg(WOREVT1,0x87);        // Default
; 0001 015F         write_Reg(WOREVT0,0x6B);        // Default
; 0001 0160         write_Reg(WORCTRL,0xFB); 	// Default
; 0001 0161 
; 0001 0162         write_Reg(FREND1,0x56);         // Default
; 0001 0163         write_Reg(FREND0,0x10);         //17  Default  17         (2:0) PA_POWER[2:0]=0  Selects PA power setting. This value is an index to the PATABLE
; 0001 0164 
; 0001 0165         write_Reg(FSCAL3,0xE9);         // Default   0xE9
; 0001 0166         write_Reg(FSCAL2,0x2A);         // 09 Default      0x2A
; 0001 0167         write_Reg(FSCAL1,0x00);         // 26 Default      0x00
; 0001 0168         write_Reg(FSCAL0,0x1F);         // Default
; 0001 0169 
; 0001 016A         write_Reg(RCCTRL1,0x41);        // Default
; 0001 016B         write_Reg(RCCTRL0,0x00);        // Default
; 0001 016C 
; 0001 016D         write_Reg(FSTEST,0x59);         // Default
; 0001 016E         write_Reg(PTEST,0x7F);          // Default
; 0001 016F         write_Reg(AGCTEST,0x3F);        // Default
; 0001 0170 
; 0001 0171         write_Reg(TEST2,0x81);          // Default      0x81
; 0001 0172         write_Reg(TEST1,0x35);          // Default      0x35
; 0001 0173         write_Reg(TEST0,0x0B);          // Default      0x09
; 0001 0174 
; 0001 0175 
; 0001 0176         // Set TX POWER
; 0001 0177         write_Reg(PA_TABLE0,0xC0);      // 10dBm -> 0xC0, 6dBm -> 0x60 	                  00 68 06 f8 2E 47 D3 91 FF 64 45
; 0001 0178         //*/
; 0001 0179 
; 0001 017A 
; 0001 017B 
; 0001 017C         /*
; 0001 017D         write_Reg(IOCFG2,0x07);         // Asserts when a packet has been received with CRC OK. De-asserts when the first byte is read from the RX FIFO.
; 0001 017E         write_Reg(IOCFG1,0x2E);         // MISO  // Default
; 0001 017F         write_Reg(IOCFG0,0x06);       //0x09  // Asserts when sync word has been sent / received, and de-asserts at the end of the packet.
; 0001 0180 
; 0001 0181         write_Reg(FIFOTHR,0x47);        // Default (not importance if length of package less than 64)
; 0001 0182         write_Reg(SYNC1,0xD3);          // 0x9B SYNC bytes   // Default    D3
; 0001 0183         write_Reg(SYNC0,0x91);          // 0xAD SYNC bytes   // Default      91
; 0001 0184 
; 0001 0185         write_Reg(PKTLEN,0x3E);         // Max 255 bytes payload
; 0001 0186         write_Reg(PKTCTRL1,0x64);       // (3)CRC_AUTOFLUSH =1: Enable automatic flush of RX FIFO when CRC is not OK;    0x0C
; 0001 0187                                         // (2)APPEND_STATUS=1: Add RSSI and LQI byte to the payload,
; 0001 0188                                         // (1:0) ADR_CHK[1:0]=0: No address check
; 0001 0189 
; 0001 018A         write_Reg(PKTCTRL0,0x45);       // (6)WHITE_DATA=0: Data whitening off,       0x05
; 0001 018B                                         // (5:4)PKT_FORMAT[1:0]=0: Normal mode, use FIFOs for RX and TX
; 0001 018C                                         // (2)CRC_EN=1: CRC calculation in TX and CRC check in RX enabled
; 0001 018D                                         // (1:0)LENGTH_CONFIG[1:0]=1: Variable packet length mode. Packet length configured by the first byte after sync word
; 0001 018E 
; 0001 018F 
; 0001 0190         write_Reg(ADDR,0x00);           // Address used for packet filtration.
; 0001 0191         write_Reg(CHANNR,0x00);         // Channel number
; 0001 0192 
; 0001 0193         write_Reg(FSCTRL1,0x06);        // (4:0)FREQ_IF[4:0]=6: The desired IF frequency to employ in RX  f(IF)=(f(XOSC)/2^10)* FREQ_IF
; 0001 0194         write_Reg(FSCTRL0,0x00);        // (7:0)FREQOFF[7:0]=0: Frequency offset added to the base frequency before being used by the frequency synthesizer
; 0001 0195 
; 0001 0196         write_Reg(FREQ2,0x0F);	        // (7:6)FREQ[23:22]=0 (always)  0x0F
; 0001 0197                                         // (5:0)FREQ[21:16]
; 0001 0198         write_Reg(FREQ1,0xBA);          // (7:0)FREQ[15:8]   0xBA
; 0001 0199         write_Reg(FREQ0,0x56);          // (7:0)FREQ[7:0]      0x56                 // f(carrier)=(f(XOSC)/2^16)* FREQ = 433MHz
; 0001 019A 
; 0001 019B         write_Reg(MDMCFG4,0x69);	// (7:6)CHANBW_E[1:0]=3    0xC6    0xF6
; 0001 019C                                         // (5:4)CHANBW_M[1:0]=0                 // BW(channel)=f(XOSC)/(8*(4+ CHANBW_M)*2^CHANBW_E)
; 0001 019D                                         // (3:0)DRATE_E[3:0]=6
; 0001 019E 
; 0001 019F         write_Reg(MDMCFG3,0x93);        // (7:0)DRATE_M[7:0]  0x83                   // R(data)= (256 + DRATE_M)*2^DRATE_E*f(XOSC)/2^28 = 2.4kBaud
; 0001 01A0 
; 0001 01A1         write_Reg(MDMCFG2,0x03);        // (7)DEM_DCFILT_OFF=0                  GFSK, 30/32 SYNC word bits detected
; 0001 01A2                                         // (6:4)MOD_FORMAT[2:0]=1 :             GFSK
; 0001 01A3                                         // (3)MANCHESTER_EN=0 :                 Disable Manchester encoding/decoding.
; 0001 01A4                                         // (2:0) SYNC_MODE[2:0]=3               30/32 sync word bits detected
; 0001 01A5 
; 0001 01A6         write_Reg(MDMCFG1,0xA2);        // (7)FEC_EN =0:                        Forward Error Correction (FEC) with interleaving for packet payload (Only supported for fixed packet length mode, i.e. PKTCTRL0.LENGTH_CONFIG =0) 4 preamble bytes (1010..10)
; 0001 01A7                                         // (6:4)NUM_PREAMBLE[2:0]=2             4 preamble bytes
; 0001 01A8                                         //(3:2)Reserved
; 0001 01A9                                         // (1:0)CHANSPC_E[1:0] =2
; 0001 01AA         write_Reg(MDMCFG0,0xF8);        // (7:0)CHANSPC_M[7:0]=248               // DELTA(f_channel)=(f_XOSC/2^18)*(256+ CHANSPC_M)*2^CHANSPC_E
; 0001 01AB 
; 0001 01AC         write_Reg(DEVIATN,0x35);        // (7)Not used
; 0001 01AD                                         // (6:4)DEVIATION_E[2:0]=4
; 0001 01AE                                         // (3)Not used
; 0001 01AF                                         // (2:0)DEVIATION_M[2:0]=0
; 0001 01B0 
; 0001 01B1         write_Reg(MCSM2,0x00);          // (2:0)RX_TIME[2:0]=7                  Timeout SYNC word until end of packet
; 0001 01B2 
; 0001 01B3         write_Reg(MCSM1,0x30);          // (7:6)Not used 0x3F, After TX or RX, state -> stay, 0x30 -> IDLE    0x30
; 0001 01B4                                         // (5:4)CCA_MODE[1:0]=3                 If RSSI below threshold unless currently receiving a packet
; 0001 01B5                                         // (3:2)RXOFF_MODE[1:0]=0               IDLE                    after packet has been received.
; 0001 01B6                                         // (1:0)TXOFF_MODE[1:0]=0               IDLE                    after packet has been sent
; 0001 01B7 
; 0001 01B8         write_Reg(MCSM0,0x18);          // (7:6)Not used  0x18
; 0001 01B9                                         // (5:4)FS_AUTOCAL[1:0]=1               Automatically calibrate when going from IDLE to RX or TX (or FSTXON)
; 0001 01BA                                         // (3:2)PO_TIMEOUT=2
; 0001 01BB                                         // (1)PIN_CTRL_EN=0
; 0001 01BC                                         // (0)XOSC_FORCE_ON=0
; 0001 01BD 
; 0001 01BE 
; 0001 01BF         write_Reg(FOCCFG,0x16);         // Default
; 0001 01C0         write_Reg(BSCFG,0x6C);          // Default
; 0001 01C1 
; 0001 01C2         write_Reg(AGCCTRL2,0x43);           //0x43
; 0001 01C3         write_Reg(AGCCTRL1,0x40);       // Default
; 0001 01C4         write_Reg(AGCCTRL0,0x91);       // Default
; 0001 01C5 
; 0001 01C6         write_Reg(WOREVT1,0x87);        // Default
; 0001 01C7         write_Reg(WOREVT0,0x6B);        // Default
; 0001 01C8         write_Reg(WORCTRL,0xFB); 	// Default
; 0001 01C9 
; 0001 01CA         write_Reg(FREND1,0x56);         // Default
; 0001 01CB         write_Reg(FREND0,0x17);         // Default           (2:0) PA_POWER[2:0]=0  Selects PA power setting. This value is an index to the PATABLE
; 0001 01CC 
; 0001 01CD         write_Reg(FSCAL3,0xEF);         // Default   0xE9
; 0001 01CE         write_Reg(FSCAL2,0x09);         // Default      0x2A
; 0001 01CF         write_Reg(FSCAL1,0x26);         // Default      0x00
; 0001 01D0         write_Reg(FSCAL0,0x1F);         // Default
; 0001 01D1 
; 0001 01D2         write_Reg(RCCTRL1,0x41);        // Default
; 0001 01D3         write_Reg(RCCTRL0,0x00);        // Default
; 0001 01D4 
; 0001 01D5         write_Reg(FSTEST,0x59);         // Default
; 0001 01D6         write_Reg(PTEST,0x7F);          // Default
; 0001 01D7         write_Reg(AGCTEST,0x3E);        // Default
; 0001 01D8 
; 0001 01D9         write_Reg(TEST2,0x81);          // Default      0x81
; 0001 01DA         write_Reg(TEST1,0x35);          // Default      0x35
; 0001 01DB         write_Reg(TEST0,0x0B);          // Default      0x09
; 0001 01DC 
; 0001 01DD 
; 0001 01DE         // Set TX POWER
; 0001 01DF         write_Reg(PA_TABLE0,0xC0);      // 10dBm -> 0xC0, 6dBm -> 0x60
; 0001 01E0         */
; 0001 01E1 }
;//--------------------------------------------------------------------------------------
;void read_BurstReg(uchar addr, uchar *buff, uchar size)
; 0001 01E4 {
_read_BurstReg:
; 0001 01E5         uchar i;
; 0001 01E6         nSEL=0;
	ST   -Y,R17
;	addr -> Y+4
;	*buff -> Y+2
;	size -> Y+1
;	i -> R17
	CBI  0x18,0
; 0001 01E7         while(MISO){}
_0x2006C:
	SBIC 0x16,3
	RJMP _0x2006C
; 0001 01E8         spi_put(addr|Burst_Read);
	LDD  R30,Y+4
	ORI  R30,LOW(0xC0)
	ST   -Y,R30
	RCALL _spi_put
; 0001 01E9         for(i=0;i<size;i++)
	LDI  R17,LOW(0)
_0x20070:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0x20071
; 0001 01EA         {
; 0001 01EB              buff[i]=spi_put(0);
	MOV  R30,R17
	CALL SUBOPT_0x41
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _spi_put
	POP  R26
	POP  R27
	ST   X,R30
; 0001 01EC         }
	SUBI R17,-1
	RJMP _0x20070
_0x20071:
; 0001 01ED         nSEL=1;
	SBI  0x18,0
; 0001 01EE }
	LDD  R17,Y+0
	JMP  _0x20A000F
;//--------------------------------------------------------------------------------------
;void write_BurstReg(uchar addr, uchar *buff, uchar size)
; 0001 01F1 {
_write_BurstReg:
; 0001 01F2         unsigned char i;
; 0001 01F3         nSEL=0;
	ST   -Y,R17
;	addr -> Y+4
;	*buff -> Y+2
;	size -> Y+1
;	i -> R17
	CBI  0x18,0
; 0001 01F4         while(MISO){}
_0x20076:
	SBIC 0x16,3
	RJMP _0x20076
; 0001 01F5         spi_put(addr|Burst_Write);
	LDD  R30,Y+4
	ORI  R30,0x40
	ST   -Y,R30
	RCALL _spi_put
; 0001 01F6         for(i=0;i<size;i++)
	LDI  R17,LOW(0)
_0x2007A:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0x2007B
; 0001 01F7         {
; 0001 01F8              spi_put(buff[i]);
	CALL SUBOPT_0x4
	RCALL _spi_put
; 0001 01F9         }
	SUBI R17,-1
	RJMP _0x2007A
_0x2007B:
; 0001 01FA         nSEL=1;
	SBI  0x18,0
; 0001 01FB }
	LDD  R17,Y+0
	JMP  _0x20A000F
;//--------------------------------------------------------------------------------------
;//  Khoi tao module RF
;void CC1101_Init(void)
; 0001 01FF {
_CC1101_Init:
; 0001 0200         power_on_Reset_cc1101();
	CALL SUBOPT_0xD
; 0001 0201         delay_ms(20);
; 0001 0202         CC1101_Setup();
; 0001 0203         delay_ms(100);
	JMP  _0x20A0013
; 0001 0204         Strobes_Comm(SIDLE);
; 0001 0205         Strobes_Comm(SFRX);
; 0001 0206         //Strobes_Comm(SFTX);
; 0001 0207         Strobes_Comm(SPWD);
; 0001 0208 
; 0001 0209 }
;//--------------------------------------------------------------------------------------
;void CC1101_ReInit(void)
; 0001 020C {
_CC1101_ReInit:
; 0001 020D         idle_mode_PA();
	RCALL _idle_mode_PA
; 0001 020E         Strobes_Comm(SIDLE);
	JMP  _0x20A0012
; 0001 020F         //Strobes_Comm(SFTX);
; 0001 0210         Strobes_Comm(SFRX);
; 0001 0211         Strobes_Comm(SPWD);
; 0001 0212 }
;//--------------------------------------------------------------------------------------
;void RF_Send(uchar *buff, uchar size)
; 0001 0215 {
_RF_Send:
; 0001 0216         transmit_mode_PA();
;	*buff -> Y+1
;	size -> Y+0
	RCALL _transmit_mode_PA
; 0001 0217         Strobes_Comm(SIDLE);
	CALL SUBOPT_0xE
; 0001 0218         Strobes_Comm(SFRX);
; 0001 0219         write_BurstReg(TXFIFO, buff,size);       // Write data to TXFIFO to send via RF
	CALL SUBOPT_0x42
; 0001 021A         Strobes_Comm(STX);                       // Enter TX mode
	CALL SUBOPT_0x43
; 0001 021B         delay_ms(100);   // min =98
	CALL SUBOPT_0xB
; 0001 021C 
; 0001 021D }
	RJMP _0x20A0018
;//--------------------------------------------------------------------------------------
;void RF_Send_Offline(uchar *buff, uchar size)
; 0001 0220 {
_RF_Send_Offline:
; 0001 0221         write_BurstReg(TXFIFO, buff,size);       // Write data to TXFIFO to send via RF
;	*buff -> Y+1
;	size -> Y+0
	CALL SUBOPT_0x42
; 0001 0222         //while(!GDO0){}                           // Wait sync word has been sent.
; 0001 0223         //while(GDO0){}                            // Wait end of the packet.
; 0001 0224 
; 0001 0225 }
_0x20A0018:
	ADIW R28,3
	RET
;//--------------------------------------------------------------------------------------
;void RF_Recieve(uchar *buff, uchar *size)
; 0001 0228 {
_RF_Recieve:
; 0001 0229         uchar length=64;
; 0001 022A         *size=length;
	ST   -Y,R17
;	*buff -> Y+3
;	*size -> Y+1
;	length -> R17
	LDI  R17,64
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R17
; 0001 022B         read_BurstReg(RXFIFO, buff, length);
	CALL SUBOPT_0x44
	ST   -Y,R17
	RCALL _read_BurstReg
; 0001 022C         Strobes_Comm(SIDLE);
	CALL SUBOPT_0x45
; 0001 022D         //Strobes_Comm(SFTX);
; 0001 022E         Strobes_Comm(SRX);
	LDI  R30,LOW(52)
	ST   -Y,R30
	RCALL _Strobes_Comm
; 0001 022F }
	LDD  R17,Y+0
	JMP  _0x20A000F
;//--------------------------------------------------------------------------------------
; void idle_mode_PA(void)
; 0001 0232  {
_idle_mode_PA:
; 0001 0233         TE_X6 =1;
	RJMP _0x20A0017
; 0001 0234         RE_X6 =0;
; 0001 0235 
; 0001 0236         TE_EKEMP =1;
; 0001 0237         RE_EKEMP =0;
; 0001 0238 
; 0001 0239         delay_us(iTimePA);
; 0001 023A  }
;//--------------------------------------------------------------------------------------
; void transmit_mode_PA(void)
; 0001 023D  {
_transmit_mode_PA:
; 0001 023E         TE_X6 =0;
	CBI  0x18,4
; 0001 023F         RE_X6 =1;
	SBI  0x18,5
; 0001 0240 
; 0001 0241         TE_EKEMP =0;
	CBI  0x1B,1
; 0001 0242         RE_EKEMP =1;
	SBI  0x1B,0
; 0001 0243 
; 0001 0244         delay_us(iTimePA);
	RJMP _0x20A0016
; 0001 0245  }
;//--------------------------------------------------------------------------------------
;void recieve_mode_PA(void)
; 0001 0248 {
_recieve_mode_PA:
; 0001 0249        TE_X6 =1;
_0x20A0017:
	SBI  0x18,4
; 0001 024A        RE_X6 =0;
	CBI  0x18,5
; 0001 024B 
; 0001 024C        TE_EKEMP =1;
	SBI  0x1B,1
; 0001 024D        RE_EKEMP =0;
	CBI  0x1B,0
; 0001 024E 
; 0001 024F        delay_us(iTimePA);
_0x20A0016:
	__DELAY_USB 213
; 0001 0250 }
	RET
;/*----------------------------------------------------------------------------------*-
;------------------------------- End of File ------------------------------------------
;-*----------------------------------------------------------------------------------*/
;/*----------------------------------------------------------------------------------*-
;------------------------------- usart.c -----------------------------------------------
;-*----------------------------------------------------------------------------------*/
;#include "Global.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include "rfcc1101.h"
;#include "serial.h"
;#include "Global.h"
;
;
;void usart_ProcessCommand()
; 0002 000B {

	.CSEG
_usart_ProcessCommand:
; 0002 000C         uchar i;
; 0002 000D         uchar ResultXOR = 0;
; 0002 000E 
; 0002 000F         for(i=1; i<16;i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	ResultXOR -> R16
	LDI  R16,0
	LDI  R17,LOW(1)
_0x40004:
	CPI  R17,16
	BRSH _0x40005
; 0002 0010         {
; 0002 0011            ResultXOR^= rx_buffer1[i];
	MOV  R30,R17
	CALL SUBOPT_0x5
	LD   R30,Z
	EOR  R16,R30
; 0002 0012         }
	SUBI R17,-1
	RJMP _0x40004
_0x40005:
; 0002 0013         if(rx_buffer1[16]!=ResultXOR)
	__GETB2MN _rx_buffer1,16
	CP   R16,R26
	BREQ _0x40006
; 0002 0014         {
; 0002 0015                 rx_wr_index1=0;
	CLR  R7
; 0002 0016                 rx_counter1=0;
	CLR  R6
; 0002 0017                 return;
	JMP  _0x20A0011
; 0002 0018         }
; 0002 0019 
; 0002 001A         LED_Red();
_0x40006:
	RCALL _LED_Red
; 0002 001B         ArraySerial[0]= rx_buffer1[5];
	CALL SUBOPT_0x46
; 0002 001C         ArraySerial[1]= rx_buffer1[6];
; 0002 001D         ArraySerial[2]= rx_buffer1[7];
; 0002 001E         ArraySerial[3]= rx_buffer1[8];
; 0002 001F 
; 0002 0020         RF_buffer[0]=0x12;
	LDI  R30,LOW(18)
	STS  _RF_buffer,R30
; 0002 0021         for(i=0;i<18;i++)
	LDI  R17,LOW(0)
_0x40008:
	CPI  R17,18
	BRSH _0x40009
; 0002 0022         {
; 0002 0023         	RF_buffer[i+1] = rx_buffer1[i];
	CALL SUBOPT_0x47
	MOVW R0,R30
	__ADDW1MN _RF_buffer,1
	MOVW R26,R30
	MOVW R30,R0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	LD   R30,Z
	ST   X,R30
; 0002 0024         }
	SUBI R17,-1
	RJMP _0x40008
_0x40009:
; 0002 0025 
; 0002 0026         transmit_mode_PA();
	RCALL _transmit_mode_PA
; 0002 0027         Strobes_Comm(SIDLE);
	CALL SUBOPT_0x45
; 0002 0028         Strobes_Comm(SFTX);
	LDI  R30,LOW(59)
	CALL SUBOPT_0x48
; 0002 0029         Strobes_Comm(SFRX);
; 0002 002A 
; 0002 002B         Command_ID=rx_buffer1[9];
	__GETBRMN 13,_rx_buffer1,9
; 0002 002C 
; 0002 002D         switch(Command_ID)
	CALL SUBOPT_0x23
; 0002 002E         {
; 0002 002F                 case CMD_KTon:
	BREQ _0x4000E
; 0002 0030                 case CMD_KToff:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4000F
_0x4000E:
; 0002 0031                         if(Command_ID!=CMD_KToff)
	LDI  R30,LOW(2)
	CP   R30,R13
	BREQ _0x40010
; 0002 0032                         {
; 0002 0033                                 // Online 1 tariff
; 0002 0034                                 RF_Send(RF_buffer, 19);
	CALL SUBOPT_0x49
; 0002 0035                                 To_Process_WaitRF();
; 0002 0036                                 rx_wr_index1=0;
; 0002 0037                                 rx_counter1=0;
; 0002 0038                                 iWait=100;
	RJMP _0x4008E
; 0002 0039                         }
; 0002 003A                         else
_0x40010:
; 0002 003B                         {
; 0002 003C                                 // Offline 1 tariff
; 0002 003D                                 SendRFOffline();
	RCALL _SendRFOffline
; 0002 003E                                 iWait=100;
_0x4008E:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	MOVW R10,R30
; 0002 003F                         }
; 0002 0040                 break;
	RJMP _0x4000C
; 0002 0041 
; 0002 0042                 case CMD_1_8_0:
_0x4000F:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BREQ _0x40013
; 0002 0043                 case CMD_1_8_1:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x40014
_0x40013:
; 0002 0044                 case CMD_1_8_2:
	RJMP _0x40015
_0x40014:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x40016
_0x40015:
; 0002 0045                 case CMD_1_8_3:
	RJMP _0x40017
_0x40016:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0x40018
_0x40017:
; 0002 0046                 case CMD_2_8_0:
	RJMP _0x40019
_0x40018:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0x4001A
_0x40019:
; 0002 0047                 case CMD_2_8_1:
	RJMP _0x4001B
_0x4001A:
	CPI  R30,LOW(0x26)
	LDI  R26,HIGH(0x26)
	CPC  R31,R26
	BRNE _0x4001C
_0x4001B:
; 0002 0048                 case CMD_2_8_2:
	RJMP _0x4001D
_0x4001C:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0x4001E
_0x4001D:
; 0002 0049                 case CMD_2_8_3:
	RJMP _0x4001F
_0x4001E:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0x40020
_0x4001F:
; 0002 004A                 case CMD_3_8_0:
	RJMP _0x40021
_0x40020:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x40022
_0x40021:
; 0002 004B                 case CMD_3_8_1:
	RJMP _0x40023
_0x40022:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0x40024
_0x40023:
; 0002 004C                 case CMD_3_8_2:
	RJMP _0x40025
_0x40024:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0x40026
_0x40025:
; 0002 004D                 case CMD_3_8_3:
	RJMP _0x40027
_0x40026:
	CPI  R30,LOW(0x24)
	LDI  R26,HIGH(0x24)
	CPC  R31,R26
	BRNE _0x40028
_0x40027:
; 0002 004E                 case CMD_4_8_0:
	RJMP _0x40029
_0x40028:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0x4002A
_0x40029:
; 0002 004F                 case CMD_4_8_1:
	RJMP _0x4002B
_0x4002A:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x4002C
_0x4002B:
; 0002 0050                 case CMD_4_8_2:
	RJMP _0x4002D
_0x4002C:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x4002E
_0x4002D:
; 0002 0051                 case CMD_4_8_3:
	RJMP _0x4002F
_0x4002E:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x40030
_0x4002F:
; 0002 0052                 case CMD_U:
	RJMP _0x40031
_0x40030:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0x40032
_0x40031:
; 0002 0053                 case CMD_I:
	RJMP _0x40033
_0x40032:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0x40034
_0x40033:
; 0002 0054                 case CMD_P:
	RJMP _0x40035
_0x40034:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x40036
_0x40035:
; 0002 0055                 case CMD_Q:
	RJMP _0x40037
_0x40036:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0x40038
_0x40037:
; 0002 0056                 case CMD_S:
	RJMP _0x40039
_0x40038:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x4003A
_0x40039:
; 0002 0057                 case CMD_COS:
	RJMP _0x4003B
_0x4003A:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0x4003D
_0x4003B:
; 0002 0058                         // Online 3 tariff
; 0002 0059                         RF_Send(RF_buffer, 19);
	CALL SUBOPT_0x49
; 0002 005A                         To_Process_WaitRF();
; 0002 005B                         rx_wr_index1=0;
; 0002 005C                         rx_counter1=0;
; 0002 005D                         iWait=300;
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP _0x4008F
; 0002 005E                 break;
; 0002 005F 
; 0002 0060                 default:
_0x4003D:
; 0002 0061                         // Online 1 tariff
; 0002 0062                         RF_Send(RF_buffer, 19);
	CALL SUBOPT_0x49
; 0002 0063                         To_Process_WaitRF();
; 0002 0064                         rx_wr_index1=0;
; 0002 0065                         rx_counter1=0;
; 0002 0066                         iWait=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
_0x4008F:
	MOVW R10,R30
; 0002 0067                 break;
; 0002 0068         }
_0x4000C:
; 0002 0069 }
	RJMP _0x20A0011
;
;void SendRFOffline(void)
; 0002 006C {
_SendRFOffline:
; 0002 006D         transmit_mode_PA();
	RCALL _transmit_mode_PA
; 0002 006E 
; 0002 006F         Strobes_Comm(SIDLE);
	CALL SUBOPT_0x45
; 0002 0070         Strobes_Comm(STX);
	CALL SUBOPT_0x43
; 0002 0071 
; 0002 0072         //delay_ms(3950);
; 0002 0073         delay_ms(3050);
	LDI  R30,LOW(3050)
	LDI  R31,HIGH(3050)
	CALL SUBOPT_0x34
; 0002 0074 
; 0002 0075 
; 0002 0076         RF_Send_Offline(RF_buffer, 19);
	CALL SUBOPT_0x4A
	LDI  R30,LOW(19)
	ST   -Y,R30
	RCALL _RF_Send_Offline
; 0002 0077         delay_ms(100);
	CALL SUBOPT_0xB
; 0002 0078 
; 0002 0079         To_Process_WaitRF();
	RCALL _To_Process_WaitRF
; 0002 007A         rx_wr_index1=0;
	CLR  R7
; 0002 007B         rx_counter1=0;
	CLR  R6
; 0002 007C }
	RET
;
;void ProcessRF(void)
; 0002 007F {
_ProcessRF:
; 0002 0080         uchar buf[66];
; 0002 0081         uchar length=66;
; 0002 0082         uchar i;
; 0002 0083 
; 0002 0084         uchar begin=0;
; 0002 0085         uchar end=0;
; 0002 0086         uchar index=0;
; 0002 0087 
; 0002 0088         uchar ResultXOR = 0;
; 0002 0089         uchar FormOK = 0;
; 0002 008A         uchar lenForm=18;
; 0002 008B 
; 0002 008C         LED_Green();// RF interrupt
	SBIW R28,63
	SBIW R28,5
	LDI  R30,LOW(18)
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
	CALL __SAVELOCR6
;	buf -> Y+8
;	length -> R17
;	i -> R16
;	begin -> R19
;	end -> R18
;	index -> R21
;	ResultXOR -> R20
;	FormOK -> Y+7
;	lenForm -> Y+6
	LDI  R17,66
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	LDI  R20,0
	RCALL _LED_Green
; 0002 008D 
; 0002 008E         RF_Recieve(buf,&length);
	CALL SUBOPT_0x4B
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _RF_Recieve
	POP  R17
; 0002 008F         Signal_RSSI_CE18G=read_Reg(0xF4);//
	CALL SUBOPT_0x4C
	STS  _Signal_RSSI_CE18G,R30
; 0002 0090 
; 0002 0091         idle_mode_PA();
	CALL SUBOPT_0x4D
; 0002 0092         Strobes_Comm(SIDLE);
; 0002 0093         //Strobes_Comm(SFTX);
; 0002 0094         Strobes_Comm(SFRX);
; 0002 0095         Strobes_Comm(SPWD);
	CALL SUBOPT_0xF
; 0002 0096 
; 0002 0097         index=0;
	LDI  R21,LOW(0)
; 0002 0098         for(i=0;i<length;i++)
	LDI  R16,LOW(0)
_0x4003F:
	CP   R16,R17
	BRLO PC+3
	JMP _0x40040
; 0002 0099         {
; 0002 009A              if((buf[i]==0x68)&&(index==0)) begin=1;
	CALL SUBOPT_0x4E
	CPI  R26,LOW(0x68)
	BRNE _0x40042
	CPI  R21,0
	BREQ _0x40043
_0x40042:
	RJMP _0x40041
_0x40043:
	LDI  R19,LOW(1)
; 0002 009B 
; 0002 009C              if((buf[i]==0x16)&&(index==lenForm-1)) end=1;
_0x40041:
	CALL SUBOPT_0x4E
	CPI  R26,LOW(0x16)
	BRNE _0x40045
	CALL SUBOPT_0x4F
	SBIW R30,1
	MOV  R26,R21
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x40046
_0x40045:
	RJMP _0x40044
_0x40046:
	LDI  R18,LOW(1)
; 0002 009D 
; 0002 009E              if(begin)
_0x40044:
	CPI  R19,0
	BREQ _0x40047
; 0002 009F              {
; 0002 00A0                  tx_buffer[index]= buf[i];
	CALL SUBOPT_0x50
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	MOVW R0,R30
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
; 0002 00A1                  if(index == 1) lenForm= tx_buffer[1];
	CPI  R21,1
	BRNE _0x40048
	__GETB1MN _tx_buffer,1
	STD  Y+6,R30
; 0002 00A2                  index++;
_0x40048:
	SUBI R21,-1
; 0002 00A3              }
; 0002 00A4              if(end)
_0x40047:
	CPI  R18,0
	BRNE PC+3
	JMP _0x40049
; 0002 00A5              {
; 0002 00A6                 for(i=1; i<lenForm-2;i++)
	LDI  R16,LOW(1)
_0x4004B:
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x53
	BRGE _0x4004C
; 0002 00A7                 {
; 0002 00A8                         ResultXOR^= tx_buffer[i];
	CALL SUBOPT_0x51
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	EOR  R20,R30
; 0002 00A9                 }
	SUBI R16,-1
	RJMP _0x4004B
_0x4004C:
; 0002 00AA                 if(tx_buffer[lenForm-2]==ResultXOR)
	CALL SUBOPT_0x4F
	SBIW R30,2
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Z
	CP   R20,R26
	BRNE _0x4004D
; 0002 00AB                 {
; 0002 00AC                         if((ArraySerial[0]== tx_buffer[5])&&(ArraySerial[1]== tx_buffer[6])&&(ArraySerial[2]== tx_buffer[7])&&(ArraySerial[3]== tx_buffer[8]))
	__GETB1MN _tx_buffer,5
	LDS  R26,_ArraySerial
	CP   R30,R26
	BRNE _0x4004F
	__GETB2MN _ArraySerial,1
	__GETB1MN _tx_buffer,6
	CP   R30,R26
	BRNE _0x4004F
	__GETB2MN _ArraySerial,2
	__GETB1MN _tx_buffer,7
	CP   R30,R26
	BRNE _0x4004F
	__GETB2MN _ArraySerial,3
	__GETB1MN _tx_buffer,8
	CP   R30,R26
	BREQ _0x40050
_0x4004F:
	RJMP _0x4004E
_0x40050:
; 0002 00AD                         {
; 0002 00AE                                 FormOK=1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0002 00AF                                 //add signal
; 0002 00B0 
; 0002 00B1                                 tx_buffer[2]=Signal_RSSI_CE18G;
	LDS  R30,_Signal_RSSI_CE18G
	__PUTB1MN _tx_buffer,2
; 0002 00B2                                 tx_buffer[lenForm-2]=0;
	CALL SUBOPT_0x4F
	SBIW R30,2
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0002 00B3                                 for(i=1; i<lenForm-2;i++)
	LDI  R16,LOW(1)
_0x40052:
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x53
	BRGE _0x40053
; 0002 00B4                                 {
; 0002 00B5                                     tx_buffer[lenForm-2]^= tx_buffer[i];
	CALL SUBOPT_0x4F
	SBIW R30,2
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	MOVW R0,R30
	LD   R26,Z
	CALL SUBOPT_0x51
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	EOR  R30,R26
	MOVW R26,R0
	ST   X,R30
; 0002 00B6                                 }
	SUBI R16,-1
	RJMP _0x40052
_0x40053:
; 0002 00B7                         }
; 0002 00B8                 }
_0x4004E:
; 0002 00B9 
; 0002 00BA                 begin=0;
_0x4004D:
	LDI  R19,LOW(0)
; 0002 00BB                 end=0;
	LDI  R18,LOW(0)
; 0002 00BC                 break;
	RJMP _0x40040
; 0002 00BD              }
; 0002 00BE         }
_0x40049:
	SUBI R16,-1
	RJMP _0x4003F
_0x40040:
; 0002 00BF 
; 0002 00C0 
; 0002 00C1         if(!FormOK)
	LDD  R30,Y+7
	CPI  R30,0
	BRNE _0x40054
; 0002 00C2         {
; 0002 00C3                 CC1101_ReInit();
	RCALL _CC1101_ReInit
; 0002 00C4                 tx_index=0;
	CLR  R5
; 0002 00C5                 LED_Off();
	RCALL _LED_Off
; 0002 00C6                 return;
	RJMP _0x20A0015
; 0002 00C7         }
; 0002 00C8 
; 0002 00C9         LED_Green();
_0x40054:
	RCALL _LED_Green
; 0002 00CA         ////////// Send package to RS232 ///////
; 0002 00CB         tx_counter= index;
	MOV  R4,R21
; 0002 00CC         tx_index=0;
	CLR  R5
; 0002 00CD         To_Process_SendRS232();
	RCALL _To_Process_SendRS232
; 0002 00CE }
_0x20A0015:
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,11
	RET
;
;void To_Process_SendRS232(void)
; 0002 00D1 {
_To_Process_SendRS232:
; 0002 00D2         uchar i=0;
; 0002 00D3         uchar length = 18;
; 0002 00D4         uchar start=15;
; 0002 00D5         uchar ResultXOR=0;
; 0002 00D6 
; 0002 00D7         switch(Command_ID)
	CALL __SAVELOCR4
;	i -> R17
;	length -> R16
;	start -> R19
;	ResultXOR -> R18
	LDI  R17,0
	LDI  R16,18
	LDI  R19,15
	LDI  R18,0
	MOV  R30,R13
	LDI  R31,0
; 0002 00D8         {
; 0002 00D9                 case CMD_1_8_0:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BREQ _0x40059
; 0002 00DA                 case CMD_1_8_1:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x4005A
_0x40059:
; 0002 00DB                 case CMD_1_8_2:
	RJMP _0x4005B
_0x4005A:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x4005C
_0x4005B:
; 0002 00DC                 case CMD_1_8_3:
	RJMP _0x4005D
_0x4005C:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0x4005E
_0x4005D:
; 0002 00DD                 case CMD_2_8_0:
	RJMP _0x4005F
_0x4005E:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0x40060
_0x4005F:
; 0002 00DE                 case CMD_2_8_1:
	RJMP _0x40061
_0x40060:
	CPI  R30,LOW(0x26)
	LDI  R26,HIGH(0x26)
	CPC  R31,R26
	BRNE _0x40062
_0x40061:
; 0002 00DF                 case CMD_2_8_2:
	RJMP _0x40063
_0x40062:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0x40064
_0x40063:
; 0002 00E0                 case CMD_2_8_3:
	RJMP _0x40065
_0x40064:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0x40066
_0x40065:
; 0002 00E1                 case CMD_3_8_0:
	RJMP _0x40067
_0x40066:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x40068
_0x40067:
; 0002 00E2                 case CMD_3_8_1:
	RJMP _0x40069
_0x40068:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0x4006A
_0x40069:
; 0002 00E3                 case CMD_3_8_2:
	RJMP _0x4006B
_0x4006A:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0x4006C
_0x4006B:
; 0002 00E4                 case CMD_3_8_3:
	RJMP _0x4006D
_0x4006C:
	CPI  R30,LOW(0x24)
	LDI  R26,HIGH(0x24)
	CPC  R31,R26
	BRNE _0x4006E
_0x4006D:
; 0002 00E5                 case CMD_4_8_0:
	RJMP _0x4006F
_0x4006E:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0x40070
_0x4006F:
; 0002 00E6                 case CMD_4_8_1:
	RJMP _0x40071
_0x40070:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x40072
_0x40071:
; 0002 00E7                 case CMD_4_8_2:
	RJMP _0x40073
_0x40072:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x40074
_0x40073:
; 0002 00E8                 case CMD_4_8_3:
	RJMP _0x40075
_0x40074:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x40076
_0x40075:
; 0002 00E9                 case CMD_U:
	RJMP _0x40077
_0x40076:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0x40078
_0x40077:
; 0002 00EA                 case CMD_I:
	RJMP _0x40079
_0x40078:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0x4007A
_0x40079:
; 0002 00EB                 case CMD_P:
	RJMP _0x4007B
_0x4007A:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x4007C
_0x4007B:
; 0002 00EC                 case CMD_Q:
	RJMP _0x4007D
_0x4007C:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0x4007E
_0x4007D:
; 0002 00ED                 case CMD_S:
	RJMP _0x4007F
_0x4007E:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x40080
_0x4007F:
; 0002 00EE                 case CMD_COS:
	RJMP _0x40081
_0x40080:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0x40082
_0x40081:
; 0002 00EF                         length = tx_buffer[1];
	__GETBRMN 16,_tx_buffer,1
; 0002 00F0                         start=length-2;
	CALL SUBOPT_0x51
	SBIW R30,2
	MOV  R19,R30
; 0002 00F1                         //ResultXOR=tx_buffer[start];
; 0002 00F2                         if(length <lengthForm3)
	CPI  R16,63
	BRSH _0x40083
; 0002 00F3                         {
; 0002 00F4                                 for(i=start;i<lengthForm3;i++)
	MOV  R17,R19
_0x40085:
	CPI  R17,63
	BRSH _0x40086
; 0002 00F5                                 {
; 0002 00F6                                         tx_buffer[i]=0x00;
	CALL SUBOPT_0x7
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0002 00F7                                 }
	SUBI R17,-1
	RJMP _0x40085
_0x40086:
; 0002 00F8 
; 0002 00F9                                 for(i=1; i<lengthForm3-2;i++)
	LDI  R17,LOW(1)
_0x40088:
	CPI  R17,61
	BRSH _0x40089
; 0002 00FA                                 {
; 0002 00FB                                         ResultXOR^= tx_buffer[i];
	CALL SUBOPT_0x7
	LD   R30,Z
	EOR  R18,R30
; 0002 00FC                                 }
	SUBI R17,-1
	RJMP _0x40088
_0x40089:
; 0002 00FD 
; 0002 00FE                                 tx_buffer[lengthForm3-2]=ResultXOR;
	__PUTBMRN _tx_buffer,61,18
; 0002 00FF                                 tx_buffer[lengthForm3-1]=0x16;
	LDI  R30,LOW(22)
	__PUTB1MN _tx_buffer,62
; 0002 0100 
; 0002 0101                                 tx_counter= lengthForm3;
	LDI  R30,LOW(63)
	MOV  R4,R30
; 0002 0102                                 tx_index=0;
	CLR  R5
; 0002 0103                         }
; 0002 0104 
; 0002 0105                 break;
_0x40083:
; 0002 0106 
; 0002 0107                 case CMD_KTon:
_0x40082:
; 0002 0108                 case CMD_KToff:
; 0002 0109                 default:
; 0002 010A                 break;
; 0002 010B         }
; 0002 010C 
; 0002 010D         //Process_ID = Process_SendRS232;
; 0002 010E }
	CALL __LOADLOCR4
	RJMP _0x20A0010
;
;void To_Process_WaitRF(void)
; 0002 0111 {
_To_Process_WaitRF:
; 0002 0112         recieve_mode_PA();
	RCALL _recieve_mode_PA
; 0002 0113         Strobes_Comm(SIDLE);
	CALL SUBOPT_0xE
; 0002 0114         //Strobes_Comm(SFTX);
; 0002 0115         Strobes_Comm(SFRX);
; 0002 0116         Strobes_Comm(SRX);
	LDI  R30,LOW(52)
	ST   -Y,R30
	RCALL _Strobes_Comm
; 0002 0117         LED_Off();
	RCALL _LED_Off
; 0002 0118 }
	RET
;/*----------------------------------------------------------------------------------*-
;------------------------------- End of File ------------------------------------------
;-*----------------------------------------------------------------------------------*/
;#include "Global.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include "rfcc1101.h"
;#include "delay.h"
;#include "serial.h"
;#include "Mesh_RF.h"
;#include "aes.h"
;//---------------------------------------------------------------------
;//Define ---------------------------------------------------------------------
;
;
;//---------------------------------------------------------------------
;uchar Meter_Type_ID=0x00;
;//variable
;unsigned char Current_Channel=0;
;unsigned char Frame_Seq_Num=1;// Frame Seq: 1-255, every frame add 1

	.DSEG
;unsigned char Mesh_RF_Retry_Flag=0,Mesh_RF_Retry_Count=0;
;unsigned char Payload_Buff[32];
;unsigned long Real_Data[3]; //Kwh, U, I
;unsigned char Last_RF_Config=NO_MESH_TYPE; //
;unsigned char Signal_RSSI=0;
;unsigned char HHU_ID1=0xAA,HHU_ID0=0xAA;
;
;#ifdef Send_Log_Option
;unsigned char TX_Data_Log_RF_Buff[49],TX_Data_Log_RF_After_Dec_Buff[49];// for log TX
;unsigned char Data_Log_RF_Buff[49],Data_Log_RF_After_Dec_Buff[49];// for log RX
;
;unsigned char TX_Data_Log_RF_Buff2[49],TX_Data_Log_RF_After_Dec_Buff2[49];// for log TX
;unsigned char Data_Log_RF_Buff2[49],Data_Log_RF_After_Dec_Buff2[49];// for log RX
;unsigned char Send_2log_Flag=FALSE;
;
;#endif
;
;//List funtion---------------------------------------------------------------------
;void CC1101_Mesh_Setup(void);
;unsigned int  culCalcCRC(unsigned char crcData, unsigned int crcReg);
;unsigned int CRC16CC1101_Buff(unsigned char *buff, unsigned char length);
;void CC1101_Init_Mesh(void);
;unsigned char Mesh_Get_Data232();
;void Frame_Scan_Data(unsigned char Sq_Num, unsigned char Channel_Num);
;void RF_Send_Scan(unsigned char Sq_Num, unsigned char Channel_num);
;unsigned char ProcessRF_Scan_Frame(void);
;void Make_Payload(unsigned char type);
;void Frame_Read_Data(unsigned char Sq_Num, unsigned char type);
;void RF_Send_Read_Mesh(unsigned char Sq_Num, unsigned char Channel_num, unsigned char type);
;void RF_Convert_Long_To_Byte(unsigned long Data_Long,unsigned char *Data_Byte, unsigned char Index, unsigned char Length);
;void Frame_RS232_Mesh(unsigned char CMD);
;void RF_Send_Close(unsigned char Sq_Num, unsigned char Channel_num);
;
;#ifdef Send_Log_Option
;    void Clear_Data_Log_Buff();
;    void Load_2nd_Log();
;#endif
;
;
;//---------------------------------------------------------------------
;
;
;void CC1101_Mesh_Setup(void)
; 0003 003B {

	.CSEG
_CC1101_Mesh_Setup:
; 0003 003C 
; 0003 003D 
; 0003 003E         write_Reg(IOCFG2,0x06);         // Asserts when a packet has been received with CRC OK. De-asserts when the first byte is read from the RX FIFO.
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(6)
	CALL SUBOPT_0x39
; 0003 003F         write_Reg(IOCFG1,0x2E);         // MISO  // Default
; 0003 0040         write_Reg(IOCFG0,0x06);       //0x09  // Asserts when sync word has been sent / received, and de-asserts at the end of the packet.
; 0003 0041 
; 0003 0042         write_Reg(FIFOTHR,0x47);        // Default (not importance if length of package less than 64)
; 0003 0043         write_Reg(SYNC1,0x64);     //R     // RE SYNC bytes
	LDI  R30,LOW(100)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0044         write_Reg(SYNC0,0x6E);     //R     // RE SYNC bytes
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(110)
	CALL SUBOPT_0x3A
; 0003 0045 
; 0003 0046         write_Reg(PKTLEN,0xFF);         // Max 255 bytes payload
; 0003 0047 
; 0003 0048         write_Reg(PKTCTRL1,0x00);
	CALL SUBOPT_0x3C
; 0003 0049         //write_Reg(PKTCTRL1,0x64);       // (3)CRC_AUTOFLUSH =1: Enable automatic flush of RX FIFO when CRC is not OK;    0x0C
; 0003 004A                                         // (2)APPEND_STATUS=1: Add RSSI and LQI byte to the payload,
; 0003 004B                                         // (1:0) ADR_CHK[1:0]=0: No address check
; 0003 004C         write_Reg(PKTCTRL0,0x00);//R       // (6)WHITE_DATA=0: Data whitening off,       0x05
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3B
; 0003 004D                                         // (5:4)PKT_FORMAT[1:0]=0: Normal mode, use FIFOs for RX and TX
; 0003 004E                                         // (2)CRC_EN=1: CRC calculation in TX and CRC check in RX enabled
; 0003 004F                                         // (1:0)LENGTH_CONFIG[1:0]=1: Variable packet length mode. Packet length configured by the first byte after sync word
; 0003 0050         write_Reg(ADDR,0x00);           // Address used for packet filtration.
; 0003 0051         //defaul channel 0
; 0003 0052         write_Reg(CHANNR,Current_Channel);         // Channel number
	LDS  R30,_Current_Channel
	ST   -Y,R30
	CALL _write_Reg
; 0003 0053 
; 0003 0054         write_Reg(FSCTRL1,0x06);        // (4:0)FREQ_IF[4:0]=6: The desired IF frequency to employ in RX  f(IF)=(f(XOSC)/2^10)* FREQ_IF
	CALL SUBOPT_0x3D
; 0003 0055         write_Reg(FSCTRL0,0x00);        // (7:0)FREQOFF[7:0]=0: Frequency offset added to the base frequency before being used by the frequency synthesizer
; 0003 0056         // F0=408.125MHz
; 0003 0057         write_Reg(FREQ2,0x0F);  //R          // (7:6)FREQ[23:22]=0 (always)  0x0F
	CALL SUBOPT_0x3E
; 0003 0058                                         // (5:0)FREQ[21:16]
; 0003 0059         write_Reg(FREQ1,0xB2);  //R        // (7:0)FREQ[15:8]   0xBA
	LDI  R30,LOW(178)
	ST   -Y,R30
	CALL _write_Reg
; 0003 005A         write_Reg(FREQ0,0x76);  //R        // (7:0)FREQ[7:0]      0x56                 // f(carrier)=(f(XOSC)/2^16)* FREQ = 433MHz
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(118)
	ST   -Y,R30
	CALL _write_Reg
; 0003 005B 
; 0003 005C         //baudrate
; 0003 005D         write_Reg(MDMCFG4,0xC9); //R      // (7:6)CHANBW_E[1:0]=3    0xC6    0xF6
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R30,LOW(201)
	ST   -Y,R30
	CALL _write_Reg
; 0003 005E                                         // (5:4)CHANBW_M[1:0]=0                 // BW(channel)=f(XOSC)/(8*(4+ CHANBW_M)*2^CHANBW_E)
; 0003 005F                                         // (3:0)DRATE_E[3:0]=6
; 0003 0060 
; 0003 0061         write_Reg(MDMCFG3,0x93);//R        // (7:0)DRATE_M[7:0]  0x83                   // R(data)= (256 + DRATE_M)*2^DRATE_E*f(XOSC)/2^28 = 2.4kBaud
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R30,LOW(147)
	CALL SUBOPT_0x3F
; 0003 0062 
; 0003 0063         write_Reg(MDMCFG2,0x13);        // (7)DEM_DCFILT_OFF=0                  GFSK, 30/32 SYNC word bits detected
; 0003 0064                                         // (6:4)MOD_FORMAT[2:0]=1 :             GFSK
; 0003 0065                                         // (3)MANCHESTER_EN=0 :                 Disable Manchester encoding/decoding.
; 0003 0066                                         // (2:0) SYNC_MODE[2:0]=3               30/32 sync word bits detected
; 0003 0067 
; 0003 0068         write_Reg(MDMCFG1,0x21);//R        // (7)FEC_EN =0:                        Forward Error Correction (FEC) with interleaving for packet payload (Only supported for fixed packet length mode, i.e. PKTCTRL0.LENGTH_CONFIG =0) 4 preamble bytes (1010..10)
	LDI  R30,LOW(33)
	CALL SUBOPT_0x40
; 0003 0069                                         // (6:4)NUM_PREAMBLE[2:0]=2             4 preamble bytes
; 0003 006A                                         //(3:2)Reserved
; 0003 006B                                         // (1:0)CHANSPC_E[1:0] =2
; 0003 006C         write_Reg(MDMCFG0,0xF8);        // (7:0)CHANSPC_M[7:0]=248               // DELTA(f_channel)=(f_XOSC/2^18)*(256+ CHANSPC_M)*2^CHANSPC_E
; 0003 006D 
; 0003 006E         write_Reg(DEVIATN,0x24);  //R      // (7)Not used
	ST   -Y,R30
	LDI  R30,LOW(36)
_0x20A0014:
	ST   -Y,R30
	CALL _write_Reg
; 0003 006F                                         // (6:4)DEVIATION_E[2:0]=4
; 0003 0070                                         // (3)Not used
; 0003 0071                                         // (2:0)DEVIATION_M[2:0]=0
; 0003 0072 
; 0003 0073         write_Reg(MCSM2,0x07);          // (2:0)RX_TIME[2:0]=7                  Timeout SYNC word until end of packet
	LDI  R30,LOW(22)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0074 
; 0003 0075         write_Reg(MCSM1,0x30);          // (7:6)Not used 0x3F, After TX or RX, state -> stay, 0x30 -> IDLE    0x30
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0076                                         // (5:4)CCA_MODE[1:0]=3                 If RSSI below threshold unless currently receiving a packet
; 0003 0077                                         // (3:2)RXOFF_MODE[1:0]=0               IDLE                    after packet has been received.
; 0003 0078                                         // (1:0)TXOFF_MODE[1:0]=0               IDLE                    after packet has been sent
; 0003 0079 
; 0003 007A         write_Reg(MCSM0,0x18);          // (7:6)Not used  0x18
	LDI  R30,LOW(24)
	ST   -Y,R30
	ST   -Y,R30
	CALL _write_Reg
; 0003 007B                                         // (5:4)FS_AUTOCAL[1:0]=1               Automatically calibrate when going from IDLE to RX or TX (or FSTXON)
; 0003 007C                                         // (3:2)PO_TIMEOUT=2
; 0003 007D                                         // (1)PIN_CTRL_EN=0
; 0003 007E                                         // (0)XOSC_FORCE_ON=0
; 0003 007F 
; 0003 0080 
; 0003 0081         write_Reg(FOCCFG,0x16);         // Default
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R30,LOW(22)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0082         write_Reg(BSCFG,0x6C);          // Default
	LDI  R30,LOW(26)
	ST   -Y,R30
	LDI  R30,LOW(108)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0083 
; 0003 0084         write_Reg(AGCCTRL2,0x03);           //0x43
	LDI  R30,LOW(27)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0085         write_Reg(AGCCTRL1,0x40);       // Default
	LDI  R30,LOW(28)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0086         write_Reg(AGCCTRL0,0x91);       // Default
	LDI  R30,LOW(29)
	ST   -Y,R30
	LDI  R30,LOW(145)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0087 
; 0003 0088         write_Reg(WOREVT1,0x87);        // Default
	LDI  R30,LOW(30)
	ST   -Y,R30
	LDI  R30,LOW(135)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0089         write_Reg(WOREVT0,0x6B);        // Default
	LDI  R30,LOW(31)
	ST   -Y,R30
	LDI  R30,LOW(107)
	ST   -Y,R30
	CALL _write_Reg
; 0003 008A         write_Reg(WORCTRL,0xFB);     // Default
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(251)
	ST   -Y,R30
	CALL _write_Reg
; 0003 008B 
; 0003 008C         write_Reg(FREND1,0x56);         // Default
	LDI  R30,LOW(33)
	ST   -Y,R30
	LDI  R30,LOW(86)
	ST   -Y,R30
	CALL _write_Reg
; 0003 008D         write_Reg(FREND0,0x10);         //17  Default  17         (2:0) PA_POWER[2:0]=0  Selects PA power setting. This value is an index to the PATABLE
	LDI  R30,LOW(34)
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _write_Reg
; 0003 008E 
; 0003 008F         write_Reg(FSCAL3,0xE9);         // Default   0xE9
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(233)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0090         write_Reg(FSCAL2,0x2A);         // 09 Default      0x2A
	LDI  R30,LOW(36)
	ST   -Y,R30
	LDI  R30,LOW(42)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0091         write_Reg(FSCAL1,0x00);         // 26 Default      0x00
	LDI  R30,LOW(37)
	ST   -Y,R30
	CALL SUBOPT_0x3C
; 0003 0092         write_Reg(FSCAL0,0x1F);         // Default
	LDI  R30,LOW(38)
	ST   -Y,R30
	LDI  R30,LOW(31)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0093 
; 0003 0094         write_Reg(RCCTRL1,0x41);        // Default
	LDI  R30,LOW(39)
	ST   -Y,R30
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0095         write_Reg(RCCTRL0,0x00);        // Default
	LDI  R30,LOW(40)
	ST   -Y,R30
	CALL SUBOPT_0x3C
; 0003 0096 
; 0003 0097         write_Reg(FSTEST,0x59);         // Default
	LDI  R30,LOW(41)
	ST   -Y,R30
	LDI  R30,LOW(89)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0098         write_Reg(PTEST,0x7F);          // Default
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(127)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0099         write_Reg(AGCTEST,0x3F);        // Default
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R30,LOW(63)
	ST   -Y,R30
	CALL _write_Reg
; 0003 009A 
; 0003 009B         write_Reg(TEST2,0x81);          // Default      0x81
	LDI  R30,LOW(44)
	ST   -Y,R30
	LDI  R30,LOW(129)
	ST   -Y,R30
	CALL _write_Reg
; 0003 009C         write_Reg(TEST1,0x35);          // Default      0x35
	LDI  R30,LOW(45)
	ST   -Y,R30
	LDI  R30,LOW(53)
	ST   -Y,R30
	CALL _write_Reg
; 0003 009D         write_Reg(TEST0,0x0B);          // Default      0x09
	LDI  R30,LOW(46)
	ST   -Y,R30
	LDI  R30,LOW(11)
	ST   -Y,R30
	CALL _write_Reg
; 0003 009E 
; 0003 009F 
; 0003 00A0         // Set TX POWER
; 0003 00A1         write_Reg(PA_TABLE0,0xC0);      // 10dBm -> 0xC0, 6dBm -> 0x60                       00 68 06 f8 2E 47 D3 91 FF 64 45
	LDI  R30,LOW(62)
	ST   -Y,R30
	LDI  R30,LOW(192)
	ST   -Y,R30
	CALL _write_Reg
; 0003 00A2 
; 0003 00A3 
; 0003 00A4 }
	RET
;
;
;//End ---------------------------------------------------------------------
;
;// CRC funtion --------------------------------------------------------------
;#define CRC16_POLY 0x8005
;#define CRC16_INIT 0x0000
;//#define CRC16_INIT 0xffff
;
;unsigned int  culCalcCRC(unsigned char crcData, unsigned int crcReg)
; 0003 00AF {
_culCalcCRC:
; 0003 00B0  unsigned char i;
; 0003 00B1  for (i = 0; i < 8; i++) {
	ST   -Y,R17
;	crcData -> Y+3
;	crcReg -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x60007:
	CPI  R17,8
	BRSH _0x60008
; 0003 00B2  if (((crcReg & 0x8000) >> 8) ^ (crcData & 0x80))
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ANDI R30,LOW(0x8000)
	ANDI R31,HIGH(0x8000)
	MOV  R30,R31
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+3
	ANDI R30,LOW(0x80)
	LDI  R31,0
	EOR  R30,R26
	EOR  R31,R27
	SBIW R30,0
	BREQ _0x60009
; 0003 00B3  crcReg = (crcReg << 1) ^ CRC16_POLY;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LSL  R30
	ROL  R31
	LDI  R26,LOW(32773)
	LDI  R27,HIGH(32773)
	EOR  R30,R26
	EOR  R31,R27
	RJMP _0x600A9
; 0003 00B4  else
_0x60009:
; 0003 00B5  crcReg = (crcReg << 1);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LSL  R30
	ROL  R31
_0x600A9:
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0003 00B6  crcData <<= 1;
	LDD  R30,Y+3
	LSL  R30
	STD  Y+3,R30
; 0003 00B7  }
	SUBI R17,-1
	RJMP _0x60007
_0x60008:
; 0003 00B8  return crcReg;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R17,Y+0
	RJMP _0x20A0010
; 0003 00B9 } // culCalcCRC
;//
;//----------------------------------------------------------------
;unsigned int CRC16CC1101_Buff(unsigned char *buff, unsigned char length)
; 0003 00BD {
_CRC16CC1101_Buff:
; 0003 00BE 
; 0003 00BF   unsigned int crcresult;
; 0003 00C0   unsigned char i;
; 0003 00C1   crcresult = CRC16_INIT; // Init value for CRC calculation
	CALL SUBOPT_0x54
;	*buff -> Y+5
;	length -> Y+4
;	crcresult -> R16,R17
;	i -> R19
; 0003 00C2 
; 0003 00C3   //crcresult = culCalcCRC(length, crcresult);     //???? Check lai khi test
; 0003 00C4   for (i = 0; i < length; i++)
	LDI  R19,LOW(0)
_0x6000C:
	LDD  R30,Y+4
	CP   R19,R30
	BRSH _0x6000D
; 0003 00C5     crcresult = culCalcCRC(buff[i], crcresult);
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CLR  R30
	ADD  R26,R19
	ADC  R27,R30
	LD   R30,X
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RCALL _culCalcCRC
	MOVW R16,R30
	SUBI R19,-1
	RJMP _0x6000C
_0x6000D:
; 0003 00C6 return crcresult;
	MOVW R30,R16
	RJMP _0x20A000D
; 0003 00C7 }
;
;// End CRC funtion --------------------------------------------------------------
;//--------------------------------------------------------------------------------------
;//  Khoi tao module RF
;void CC1101_Init_Mesh(void)
; 0003 00CD {
_CC1101_Init_Mesh:
; 0003 00CE         power_on_Reset_cc1101();
	CALL _power_on_Reset_cc1101
; 0003 00CF         delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x34
; 0003 00D0         CC1101_Mesh_Setup();
	RCALL _CC1101_Mesh_Setup
; 0003 00D1         delay_ms(100);
_0x20A0013:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x34
; 0003 00D2         Strobes_Comm(SIDLE);
_0x20A0012:
	LDI  R30,LOW(54)
	CALL SUBOPT_0x48
; 0003 00D3         Strobes_Comm(SFRX);
; 0003 00D4         //Strobes_Comm(SFTX);
; 0003 00D5         Strobes_Comm(SPWD);
	CALL SUBOPT_0xF
; 0003 00D6 
; 0003 00D7 }
	RET
;//--------------------------------------------------------------------------------------
;
;//--------------------------------------------------------------------------------------
;unsigned char Mesh_Get_Data232()
; 0003 00DC {
_Mesh_Get_Data232:
; 0003 00DD        uchar i;
; 0003 00DE         uchar ResultXOR = 0;
; 0003 00DF         //Serial
; 0003 00E0         ArraySerial[0]= rx_buffer1[5];
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	ResultXOR -> R16
	LDI  R16,0
	CALL SUBOPT_0x46
; 0003 00E1         ArraySerial[1]= rx_buffer1[6];
; 0003 00E2         ArraySerial[2]= rx_buffer1[7];
; 0003 00E3         ArraySerial[3]= rx_buffer1[8];
; 0003 00E4 
; 0003 00E5         Meter_Type_ID=rx_buffer1[4];
	__GETB1MN _rx_buffer1,4
	STS  _Meter_Type_ID,R30
; 0003 00E6         Command_ID=rx_buffer1[9];
	__GETBRMN 13,_rx_buffer1,9
; 0003 00E7 
; 0003 00E8         for(i=1; i<16;i++)
	LDI  R17,LOW(1)
_0x6000F:
	CPI  R17,16
	BRSH _0x60010
; 0003 00E9         {
; 0003 00EA            ResultXOR^= rx_buffer1[i];
	MOV  R30,R17
	CALL SUBOPT_0x5
	LD   R30,Z
	EOR  R16,R30
; 0003 00EB         }
	SUBI R17,-1
	RJMP _0x6000F
_0x60010:
; 0003 00EC         //if((rx_buffer1[16]!=ResultXOR)||((Command_ID!=Cmd_180_ID)&&(Command_ID!=Cmd_UI_ID)))
; 0003 00ED         if(rx_buffer1[16]!=ResultXOR)
	__GETB2MN _rx_buffer1,16
	CP   R16,R26
	BREQ _0x60011
; 0003 00EE         {
; 0003 00EF                 return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A0011
; 0003 00F0         }
; 0003 00F1         else
_0x60011:
; 0003 00F2         {
; 0003 00F3             return 1;
	LDI  R30,LOW(1)
; 0003 00F4         }
; 0003 00F5 
; 0003 00F6 }
_0x20A0011:
	LD   R16,Y+
	LD   R17,Y+
	RET
;//--------------------------------------------------------------------------------------
;void Frame_Scan_Data(unsigned char Sq_Num, unsigned char Channel_Num)
; 0003 00F9 {
_Frame_Scan_Data:
; 0003 00FA     unsigned int CRC_CC1101;
; 0003 00FB 
; 0003 00FC 
; 0003 00FD     //Frame
; 0003 00FE 
; 0003 00FF       RF_buffer[0]=17; //length byte
	ST   -Y,R17
	ST   -Y,R16
;	Sq_Num -> Y+3
;	Channel_Num -> Y+2
;	CRC_CC1101 -> R16,R17
	LDI  R30,LOW(17)
	STS  _RF_buffer,R30
; 0003 0100 
; 0003 0101       RF_buffer[1]=0x1A;
	LDI  R30,LOW(26)
	CALL SUBOPT_0x55
; 0003 0102       RF_buffer[2]=Sq_Num;
; 0003 0103       RF_buffer[3]=HHU_ID1;//HHU ID
; 0003 0104       RF_buffer[4]=HHU_ID0;//HHU ID
; 0003 0105       RF_buffer[5]=0xFF;
; 0003 0106       RF_buffer[6]=0xFA;
; 0003 0107       RF_buffer[7]=0xFF;
	LDI  R30,LOW(255)
	__PUTB1MN _RF_buffer,7
; 0003 0108       RF_buffer[8]=0xFF;
	CALL SUBOPT_0x56
; 0003 0109       //Serial NO
; 0003 010A       RF_buffer[9]=0x00;
; 0003 010B       RF_buffer[10]=0x00;
; 0003 010C       RF_buffer[11]=0x00;
; 0003 010D       RF_buffer[12]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _RF_buffer,12
; 0003 010E 
; 0003 010F       RF_buffer[13]=ArraySerial[0];
	LDS  R30,_ArraySerial
	__PUTB1MN _RF_buffer,13
; 0003 0110       RF_buffer[14]=ArraySerial[1];
	__GETB1MN _ArraySerial,1
	__PUTB1MN _RF_buffer,14
; 0003 0111       RF_buffer[15]=ArraySerial[2];
	__GETB1MN _ArraySerial,2
	__PUTB1MN _RF_buffer,15
; 0003 0112       RF_buffer[16]=ArraySerial[3];
	__GETB1MN _ArraySerial,3
	__PUTB1MN _RF_buffer,16
; 0003 0113 
; 0003 0114       if( (Meter_Type_ID==CE18_Mesh_1CH_NoIEC_Type)||(Meter_Type_ID==CE14_Mesh_1CH_NoIEC_Type)
; 0003 0115           ||(Meter_Type_ID==ME40_Mesh_1CH_NoIEC_Type)||(Meter_Type_ID==ME41_Mesh_1CH_NoIEC_Type)||(Meter_Type_ID==ME42_Mesh_1CH_NoIEC_Type))
	LDS  R26,_Meter_Type_ID
	CPI  R26,LOW(0x12)
	BREQ _0x60014
	CPI  R26,LOW(0x13)
	BREQ _0x60014
	CPI  R26,LOW(0x14)
	BREQ _0x60014
	CPI  R26,LOW(0x15)
	BREQ _0x60014
	CPI  R26,LOW(0x16)
	BRNE _0x60013
_0x60014:
; 0003 0116         RF_buffer[17]=0;     //module RF hieu CH0=408.925 cho code 1CH NPC
	LDI  R30,LOW(0)
	RJMP _0x600AA
; 0003 0117       else //16CH
_0x60013:
; 0003 0118         RF_buffer[17]=Fix_CH;  //module RF hieu CH8=408.925 cho code 16CH EVN HANOI
	LDI  R30,LOW(8)
_0x600AA:
	__PUTB1MN _RF_buffer,17
; 0003 0119 
; 0003 011A 
; 0003 011B 
; 0003 011C 
; 0003 011D        //2 byte crc
; 0003 011E        CRC_CC1101=CRC16CC1101_Buff(RF_buffer,RF_buffer[0]+1);
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x57
; 0003 011F        RF_buffer[18]=(unsigned char)(CRC_CC1101>>8);
	__PUTBMRN _RF_buffer,18,17
; 0003 0120        RF_buffer[19]=(unsigned char)(CRC_CC1101&0x00FF);
	MOV  R30,R16
	__PUTB1MN _RF_buffer,19
; 0003 0121 }
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0010:
	ADIW R28,4
	RET
;//---------------------------------------------------------------
;void Mesh_RF_Send(uchar *buff, uchar size)
; 0003 0124 {
_Mesh_RF_Send:
; 0003 0125     volatile unsigned int timeout = 0xffff;
; 0003 0126 
; 0003 0127         transmit_mode_PA();
	SBIW R28,2
	LDI  R30,LOW(255)
	ST   Y,R30
	STD  Y+1,R30
;	*buff -> Y+3
;	size -> Y+2
;	timeout -> Y+0
	CALL _transmit_mode_PA
; 0003 0128         Strobes_Comm(SIDLE);
	CALL SUBOPT_0xE
; 0003 0129         Strobes_Comm(SFRX);
; 0003 012A         write_BurstReg(TXFIFO, buff,size);       // Write data to TXFIFO to send via RF
	CALL SUBOPT_0x44
	LDD  R30,Y+5
	ST   -Y,R30
	CALL _write_BurstReg
; 0003 012B         Strobes_Comm(STX);                       // Enter TX mode
	CALL SUBOPT_0x43
; 0003 012C 
; 0003 012D         while(!(GDO0) && ((--timeout) > 0));        // Wait for TX complete
_0x60017:
	SBIC 0x10,1
	RJMP _0x6001A
	CALL SUBOPT_0x58
	BRLO _0x6001B
_0x6001A:
	RJMP _0x60019
_0x6001B:
	RJMP _0x60017
_0x60019:
; 0003 012E         while((GDO0) && ((--timeout) > 0));        // Wait for TX complete
_0x6001C:
	SBIS 0x10,1
	RJMP _0x6001F
	CALL SUBOPT_0x58
	BRLO _0x60020
_0x6001F:
	RJMP _0x6001E
_0x60020:
	RJMP _0x6001C
_0x6001E:
; 0003 012F 
; 0003 0130 }
_0x20A000F:
	ADIW R28,5
	RET
;//---------------------------------------------------------------
;void RF_Send_Scan(unsigned char Sq_Num, unsigned char Channel_num)
; 0003 0133 {
_RF_Send_Scan:
; 0003 0134 
; 0003 0135 
; 0003 0136 
; 0003 0137         LED_Red();
;	Sq_Num -> Y+1
;	Channel_num -> Y+0
	CALL _LED_Red
; 0003 0138         Frame_Scan_Data(Sq_Num, Channel_num);
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _Frame_Scan_Data
; 0003 0139         idle_mode_PA();
	CALL SUBOPT_0x59
; 0003 013A         Strobes_Comm(SIDLE);
; 0003 013B         write_Reg(PKTLEN,RF_buffer[0]+3);         // Datalength+1+2: 1 byte Leng, 2 byte CRC
	CALL SUBOPT_0x5A
; 0003 013C 
; 0003 013D         if( (Meter_Type_ID==CE18_Mesh_1CH_NoIEC_Type)||(Meter_Type_ID==CE14_Mesh_1CH_NoIEC_Type)
; 0003 013E           ||(Meter_Type_ID==ME40_Mesh_1CH_NoIEC_Type)||(Meter_Type_ID==ME41_Mesh_1CH_NoIEC_Type)||(Meter_Type_ID==ME42_Mesh_1CH_NoIEC_Type))
	LDS  R26,_Meter_Type_ID
	CPI  R26,LOW(0x12)
	BREQ _0x60022
	CPI  R26,LOW(0x13)
	BREQ _0x60022
	CPI  R26,LOW(0x14)
	BREQ _0x60022
	CPI  R26,LOW(0x15)
	BREQ _0x60022
	CPI  R26,LOW(0x16)
	BRNE _0x60021
_0x60022:
; 0003 013F             write_Reg(CHANNR,Fix_CH);         // 1Channel number
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(8)
	RJMP _0x600AB
; 0003 0140         else
_0x60021:
; 0003 0141             write_Reg(CHANNR,Channel_num);         // 16 Channel number
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDD  R30,Y+1
_0x600AB:
	ST   -Y,R30
	CALL _write_Reg
; 0003 0142 
; 0003 0143 
; 0003 0144 
; 0003 0145 
; 0003 0146         delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x34
; 0003 0147 
; 0003 0148         Mesh_RF_Send(RF_buffer, RF_buffer[0]+3);//send dat    //trong ham RF_Send co delay_ms(100)????
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x5B
; 0003 0149         Mesh_RF_Send(RF_buffer, RF_buffer[0]+3);//send dat    //trong ham RF_Send co delay_ms(100)????
	CALL SUBOPT_0x5B
; 0003 014A         Mesh_RF_Send(RF_buffer, RF_buffer[0]+3);//send dat    //trong ham RF_Send co delay_ms(100)????
	CALL SUBOPT_0x5C
; 0003 014B 
; 0003 014C 
; 0003 014D         write_Reg(CHANNR,Fix_CH);         // alway retrun to FixCH to wait data
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _write_Reg
; 0003 014E 
; 0003 014F 
; 0003 0150         To_Process_WaitRF();// goto RX mode
	CALL SUBOPT_0x35
; 0003 0151         write_Reg(PKTLEN,60);// for Recive data
	LDI  R30,LOW(60)
	ST   -Y,R30
	CALL _write_Reg
; 0003 0152 
; 0003 0153 
; 0003 0154 
; 0003 0155 
; 0003 0156 }
	ADIW R28,2
	RET
;
;//---------------------------------------------------------------
;
;unsigned char ProcessRF_Scan_Frame(void)
; 0003 015B {
_ProcessRF_Scan_Frame:
; 0003 015C         unsigned int crc_byte;
; 0003 015D         unsigned char crc_byte_hi,crc_byte_low;
; 0003 015E         uchar buf[64];
; 0003 015F         uchar length=64;
; 0003 0160         uchar FormOK = 0;
; 0003 0161 
; 0003 0162 
; 0003 0163 
; 0003 0164 
; 0003 0165 
; 0003 0166         RF_Recieve(buf,&length);
	SBIW R28,63
	SBIW R28,1
	CALL SUBOPT_0x5D
;	crc_byte -> R16,R17
;	crc_byte_hi -> R19
;	crc_byte_low -> R18
;	buf -> Y+6
;	length -> R21
;	FormOK -> R20
	CALL SUBOPT_0x5E
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL _RF_Recieve
	POP  R21
; 0003 0167 
; 0003 0168         idle_mode_PA();
	CALL SUBOPT_0x4D
; 0003 0169         Strobes_Comm(SIDLE);
; 0003 016A         //Strobes_Comm(SFTX);
; 0003 016B         Strobes_Comm(SFRX);
; 0003 016C         Strobes_Comm(SPWD);
	CALL SUBOPT_0xF
; 0003 016D 
; 0003 016E 
; 0003 016F 
; 0003 0170         if( (buf[0]==0x0B)&&(buf[1]==0x9B)) //Leng, start
	LDD  R26,Y+6
	CPI  R26,LOW(0xB)
	BRNE _0x60026
	LDD  R26,Y+7
	CPI  R26,LOW(0x9B)
	BREQ _0x60027
_0x60026:
	RJMP _0x60025
_0x60027:
; 0003 0171         {
; 0003 0172             if(buf[2]==1)   //SEQ ID
	LDD  R26,Y+8
	CPI  R26,LOW(0x1)
	BRNE _0x60028
; 0003 0173             {
; 0003 0174                 crc_byte=CRC16CC1101_Buff(buf,buf[0]+1);
	CALL SUBOPT_0x5E
	LDD  R30,Y+8
	CALL SUBOPT_0x5F
; 0003 0175                 crc_byte_hi=(unsigned char)(crc_byte>>8);
; 0003 0176                 crc_byte_low=(unsigned char)(crc_byte&0x00FF);
; 0003 0177                 if( (buf[12]==crc_byte_hi)&&(buf[13]==crc_byte_low)) //check CRC
	LDD  R26,Y+18
	CP   R19,R26
	BRNE _0x6002A
	LDD  R26,Y+19
	CP   R18,R26
	BREQ _0x6002B
_0x6002A:
	RJMP _0x60029
_0x6002B:
; 0003 0178                 {
; 0003 0179                     if((buf[3]==HHU_ID1) && (buf[4]==HHU_ID0)&&(buf[9]==HHU_ID1) && (buf[10]==HHU_ID0))   //check HHU ID
	LDS  R30,_HHU_ID1
	LDD  R26,Y+9
	CP   R30,R26
	BRNE _0x6002D
	LDS  R30,_HHU_ID0
	LDD  R26,Y+10
	CP   R30,R26
	BRNE _0x6002D
	LDS  R30,_HHU_ID1
	LDD  R26,Y+15
	CP   R30,R26
	BRNE _0x6002D
	LDS  R30,_HHU_ID0
	LDD  R26,Y+16
	CP   R30,R26
	BREQ _0x6002E
_0x6002D:
	RJMP _0x6002C
_0x6002E:
; 0003 017A 
; 0003 017B                     {
; 0003 017C                         if( (buf[5]==0xFF)&&(buf[6]==0xFA))
	LDD  R26,Y+11
	CPI  R26,LOW(0xFF)
	BRNE _0x60030
	LDD  R26,Y+12
	CPI  R26,LOW(0xFA)
	BREQ _0x60031
_0x60030:
	RJMP _0x6002F
_0x60031:
; 0003 017D                         {
; 0003 017E                             FormOK=1;
	LDI  R20,LOW(1)
; 0003 017F                         }
; 0003 0180 
; 0003 0181                     }
_0x6002F:
; 0003 0182 
; 0003 0183 
; 0003 0184                 }
_0x6002C:
; 0003 0185             }
_0x60029:
; 0003 0186 
; 0003 0187         }
_0x60028:
; 0003 0188 
; 0003 0189         LED_Off();
_0x60025:
	CALL _LED_Off
; 0003 018A 
; 0003 018B 
; 0003 018C         if(!FormOK)
	CPI  R20,0
	BRNE _0x60032
; 0003 018D         {
; 0003 018E 
; 0003 018F                 To_Process_WaitRF();// goto RX mode
	RCALL _To_Process_WaitRF
; 0003 0190                 return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A000E
; 0003 0191 
; 0003 0192         }
; 0003 0193         else
_0x60032:
; 0003 0194         {
; 0003 0195 
; 0003 0196             return 1;
	LDI  R30,LOW(1)
; 0003 0197         }
; 0003 0198 }
_0x20A000E:
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,7
	RET
;//-------------------------------------------------------------------------------------
;unsigned char Payload_Checksum1(unsigned char *dst, unsigned char iLengthBuff)
; 0003 019B {
_Payload_Checksum1:
; 0003 019C     int iSum = 0,j;
; 0003 019D 
; 0003 019E     for (j = 2; j < iLengthBuff; j++)
	CALL SUBOPT_0x54
;	*dst -> Y+5
;	iLengthBuff -> Y+4
;	iSum -> R16,R17
;	j -> R18,R19
	__GETWRN 18,19,2
_0x60035:
	CALL SUBOPT_0x60
	BRGE _0x60036
; 0003 019F     {
; 0003 01A0         iSum += dst[j];
	CALL SUBOPT_0x61
; 0003 01A1     }
	__ADDWRN 18,19,1
	RJMP _0x60035
_0x60036:
; 0003 01A2     return ((unsigned char)(iSum & 0xFF));
	RJMP _0x20A000C
; 0003 01A3 
; 0003 01A4 }
;//-------------------------------------------------------------------------------------
;void Make_Payload(unsigned char type)
; 0003 01A7 {
_Make_Payload:
; 0003 01A8 
; 0003 01A9      unsigned char kWh_Cmd[32]={0x00,0x16,0x00,0x01,0x00,0x11,0x00,0x01,0x00,0x0E,0xC0,0x01,0x81,0x00,0x03,0x01,0x00,0x01,0x08,0x00,0xFF,0x02,0x00,0x71};
; 0003 01AA    //unsigned char   U_Cmd[22]={0x00,0x01,0x00,0x11,0x00,0x01,0x00,0x0E,0xC0,0x01,0x81,0x00,0x03,0x01,0x00,0x20,0x07,0x00,0xFF,0x02,0x00,0x8F};
; 0003 01AB    //unsigned char   I_Cmd[22]={0x00,0x01,0x00,0x11,0x00,0x01,0x00,0x0E,0xC0,0x01,0x81,0x00,0x03,0x01,0x00,0x1F,0x07,0x00,0xFF,0x02,0x00,0x8E};
; 0003 01AC     // unsigned char PF_Cmd[22]={0x00,0x01,0x00,0x11,0x00,0x01,0x00,0x0E,0xC0,0x01,0x81,0x00,0x03,0x01,0x00,0x0D,0x07,0x00,0xFF,0x02,0x00,0x7C};
; 0003 01AD 
; 0003 01AE     unsigned char i;
; 0003 01AF     unsigned char kWh_Cmd_AES[32];
; 0003 01B0 
; 0003 01B1     //
; 0003 01B2       switch(type)
	SBIW R28,63
	SBIW R28,1
	LDI  R24,32
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	LDI  R30,LOW(_0x60037*2)
	LDI  R31,HIGH(_0x60037*2)
	CALL __INITLOCB
	ST   -Y,R17
;	type -> Y+65
;	kWh_Cmd -> Y+33
;	i -> R17
;	kWh_Cmd_AES -> Y+1
	__GETB1SX 65
	LDI  R31,0
; 0003 01B3     {
; 0003 01B4          //Energy Register
; 0003 01B5         case Cmd_180_ID:
	SBIW R30,0
	BRNE _0x6003B
; 0003 01B6         break;
	RJMP _0x6003A
; 0003 01B7         case Cmd_181_ID:
_0x6003B:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x6003C
; 0003 01B8             kWh_Cmd[19]=0x01;// thay byte so 15 trong payload
	CALL SUBOPT_0x62
; 0003 01B9             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 01BA 
; 0003 01BB         break;
	RJMP _0x6003A
; 0003 01BC 
; 0003 01BD         case Cmd_182_ID:
_0x6003C:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x6003D
; 0003 01BE             kWh_Cmd[19]=0x02;// thay byte so 15 trong payload
	CALL SUBOPT_0x63
; 0003 01BF             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 01C0         break;
	RJMP _0x6003A
; 0003 01C1         case Cmd_183_ID:
_0x6003D:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x6003E
; 0003 01C2 
; 0003 01C3             kWh_Cmd[19]=0x03;// thay byte so 16 trong payload
	CALL SUBOPT_0x64
; 0003 01C4             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 01C5         break;
	RJMP _0x6003A
; 0003 01C6         ////----------
; 0003 01C7         case Cmd_280_ID:
_0x6003E:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x6003F
; 0003 01C8             kWh_Cmd[17]=0x02;// thay byte so 15 trong payload
	LDI  R30,LOW(2)
	CALL SUBOPT_0x65
; 0003 01C9             kWh_Cmd[19]=0x00;// thay byte so 15 trong payload
; 0003 01CA             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 01CB 
; 0003 01CC         break;
	RJMP _0x6003A
; 0003 01CD 
; 0003 01CE         case Cmd_281_ID:
_0x6003F:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0x60040
; 0003 01CF            kWh_Cmd[17]=0x02;// thay byte so 15 trong payload
	LDI  R30,LOW(2)
	STD  Y+50,R30
; 0003 01D0            kWh_Cmd[19]=0x01;// thay byte so 15 trong payload
	CALL SUBOPT_0x62
; 0003 01D1            kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 01D2 
; 0003 01D3         break;
	RJMP _0x6003A
; 0003 01D4 
; 0003 01D5         case Cmd_282_ID:
_0x60040:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0x60041
; 0003 01D6             kWh_Cmd[17]=0x02;// thay byte so 15 trong payload
	LDI  R30,LOW(2)
	STD  Y+50,R30
; 0003 01D7             kWh_Cmd[19]=0x02;// thay byte so 15 trong payload
	CALL SUBOPT_0x63
; 0003 01D8             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 01D9         break;
	RJMP _0x6003A
; 0003 01DA         case Cmd_283_ID:
_0x60041:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0x60042
; 0003 01DB 
; 0003 01DC             kWh_Cmd[17]=0x02;// thay byte so 15 trong payload
	LDI  R30,LOW(2)
	STD  Y+50,R30
; 0003 01DD             kWh_Cmd[19]=0x03;// thay byte so 15 trong payload
	CALL SUBOPT_0x64
; 0003 01DE             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 01DF         break;
	RJMP _0x6003A
; 0003 01E0         //----------
; 0003 01E1         case Cmd_380_ID:
_0x60042:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x60043
; 0003 01E2             kWh_Cmd[17]=0x03;// thay byte so 15 trong payload
	LDI  R30,LOW(3)
	CALL SUBOPT_0x65
; 0003 01E3             kWh_Cmd[19]=0x00;// thay byte so 15 trong payload
; 0003 01E4             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 01E5         break;
	RJMP _0x6003A
; 0003 01E6         case Cmd_381_ID:
_0x60043:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x60044
; 0003 01E7             kWh_Cmd[17]=0x03;// thay byte so 15 trong payload
	LDI  R30,LOW(3)
	STD  Y+50,R30
; 0003 01E8             kWh_Cmd[19]=0x01;// thay byte so 15 trong payload
	CALL SUBOPT_0x62
; 0003 01E9             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 01EA         break;
	RJMP _0x6003A
; 0003 01EB         case Cmd_382_ID:
_0x60044:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x60045
; 0003 01EC             kWh_Cmd[17]=0x03;// thay byte so 15 trong payload
	LDI  R30,LOW(3)
	STD  Y+50,R30
; 0003 01ED             kWh_Cmd[19]=0x02;// thay byte so 15 trong payload
	CALL SUBOPT_0x63
; 0003 01EE             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 01EF         break;
	RJMP _0x6003A
; 0003 01F0         case Cmd_383_ID:
_0x60045:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x60046
; 0003 01F1             kWh_Cmd[17]=0x03;// thay byte so 15 trong payload
	LDI  R30,LOW(3)
	STD  Y+50,R30
; 0003 01F2             kWh_Cmd[19]=0x03;// thay byte so 15 trong payload
	CALL SUBOPT_0x64
; 0003 01F3             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 01F4         break;
	RJMP _0x6003A
; 0003 01F5         //-----------------
; 0003 01F6         //----------
; 0003 01F7         case Cmd_480_ID:
_0x60046:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x60047
; 0003 01F8             kWh_Cmd[17]=0x04;// thay byte so 15 trong payload
	LDI  R30,LOW(4)
	CALL SUBOPT_0x65
; 0003 01F9             kWh_Cmd[19]=0x00;// thay byte so 15 trong payload
; 0003 01FA             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 01FB         break;
	RJMP _0x6003A
; 0003 01FC         case Cmd_481_ID:
_0x60047:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0x60048
; 0003 01FD             kWh_Cmd[17]=0x04;// thay byte so 15 trong payload
	LDI  R30,LOW(4)
	STD  Y+50,R30
; 0003 01FE             kWh_Cmd[19]=0x01;// thay byte so 15 trong payload
	CALL SUBOPT_0x62
; 0003 01FF             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 0200         break;
	RJMP _0x6003A
; 0003 0201         case Cmd_482_ID:
_0x60048:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0x60049
; 0003 0202             kWh_Cmd[17]=0x04;// thay byte so 15 trong payload
	LDI  R30,LOW(4)
	STD  Y+50,R30
; 0003 0203             kWh_Cmd[19]=0x02;// thay byte so 15 trong payload
	CALL SUBOPT_0x63
; 0003 0204             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 0205         break;
	RJMP _0x6003A
; 0003 0206         case Cmd_483_ID:
_0x60049:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x6004A
; 0003 0207             kWh_Cmd[17]=0x04;// thay byte so 15 trong payload
	LDI  R30,LOW(4)
	STD  Y+50,R30
; 0003 0208             kWh_Cmd[19]=0x03;// thay byte so 15 trong payload
	CALL SUBOPT_0x64
; 0003 0209             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 020A         break;
	RJMP _0x6003A
; 0003 020B         //UI reg-----------------
; 0003 020C         case Cmd_UA_ID:
_0x6004A:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0x6004B
; 0003 020D 
; 0003 020E               kWh_Cmd[17]=0x20;// thay byte so 15 trong payload
	LDI  R30,LOW(32)
	CALL SUBOPT_0x66
; 0003 020F               kWh_Cmd[18]=0x07;// thay byte so 16 trong payload
; 0003 0210               kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 0211 
; 0003 0212 
; 0003 0213         break;
	RJMP _0x6003A
; 0003 0214         case Cmd_UB_ID:
_0x6004B:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x6004C
; 0003 0215 
; 0003 0216               kWh_Cmd[17]=0x34;// thay byte so 15 trong payload
	LDI  R30,LOW(52)
	CALL SUBOPT_0x66
; 0003 0217               kWh_Cmd[18]=0x07;// thay byte so 16 trong payload
; 0003 0218               kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 0219 
; 0003 021A 
; 0003 021B         break;
	RJMP _0x6003A
; 0003 021C         case Cmd_UC_ID:
_0x6004C:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0x6004D
; 0003 021D 
; 0003 021E               kWh_Cmd[17]=0x48;// thay byte so 15 trong payload
	LDI  R30,LOW(72)
	CALL SUBOPT_0x66
; 0003 021F               kWh_Cmd[18]=0x07;// thay byte so 16 trong payload
; 0003 0220               kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 0221 
; 0003 0222 
; 0003 0223         break;
	RJMP _0x6003A
; 0003 0224 
; 0003 0225         case Cmd_IA_ID:
_0x6004D:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0x6004E
; 0003 0226             kWh_Cmd[17]=0x1F;// thay byte so 15 trong payload
	LDI  R30,LOW(31)
	CALL SUBOPT_0x66
; 0003 0227             kWh_Cmd[18]=0x07;// thay byte so 16 trong payload
; 0003 0228             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 0229         break;
	RJMP _0x6003A
; 0003 022A         case Cmd_IB_ID:
_0x6004E:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0x6004F
; 0003 022B             kWh_Cmd[17]=0x33;// thay byte so 15 trong payload
	LDI  R30,LOW(51)
	CALL SUBOPT_0x66
; 0003 022C             kWh_Cmd[18]=0x07;// thay byte so 16 trong payload
; 0003 022D             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 022E         break;
	RJMP _0x6003A
; 0003 022F         case Cmd_IC_ID:
_0x6004F:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0x60050
; 0003 0230             kWh_Cmd[17]=0x47;// thay byte so 15 trong payload
	LDI  R30,LOW(71)
	CALL SUBOPT_0x66
; 0003 0231             kWh_Cmd[18]=0x07;// thay byte so 16 trong payload
; 0003 0232             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 0233         break;
	RJMP _0x6003A
; 0003 0234 
; 0003 0235         case PF_Cmd_ID:
_0x60050:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x60052
; 0003 0236             kWh_Cmd[17]=0x0D;// thay byte so 15 trong payload
	LDI  R30,LOW(13)
	CALL SUBOPT_0x66
; 0003 0237             kWh_Cmd[18]=0x07;// thay byte so 16 trong payload
; 0003 0238             kWh_Cmd[23]=Payload_Checksum1(kWh_Cmd,23);
; 0003 0239         break;
; 0003 023A 
; 0003 023B         default:
_0x60052:
; 0003 023C         break;
; 0003 023D 
; 0003 023E      }
_0x6003A:
; 0003 023F 
; 0003 0240     //
; 0003 0241 
; 0003 0242     aes_encrypt(kWh_Cmd_AES, kWh_Cmd, 24, 0, 0);
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,35
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL SUBOPT_0x67
	CALL SUBOPT_0x67
	ST   -Y,R31
	ST   -Y,R30
	RCALL _aes_encrypt
; 0003 0243 
; 0003 0244     for(i=0;i<32;i++)
	LDI  R17,LOW(0)
_0x60054:
	CPI  R17,32
	BRSH _0x60055
; 0003 0245     {
; 0003 0246         RF_buffer[15+i]=kWh_Cmd_AES[i];
	CALL SUBOPT_0x47
	MOVW R26,R30
	__ADDW1MN _RF_buffer,15
	MOVW R0,R30
	MOVW R30,R26
	CALL SUBOPT_0x68
; 0003 0247     }
	SUBI R17,-1
	RJMP _0x60054
_0x60055:
; 0003 0248 
; 0003 0249     #ifdef Send_Log_Option
; 0003 024A     //payload log
; 0003 024B     for(i=0;i<24;i++)      //chua ma hoa
; 0003 024C     {
; 0003 024D         TX_Data_Log_RF_After_Dec_Buff[15+i]=kWh_Cmd[i];
; 0003 024E     }
; 0003 024F 
; 0003 0250     #endif
; 0003 0251 
; 0003 0252 
; 0003 0253 }
	LDD  R17,Y+0
	ADIW R28,63
	ADIW R28,3
	RET
;//-------------------------------------------------------------------------------------
;void Frame_Read_Data(unsigned char Sq_Num, unsigned char type)
; 0003 0256 {
_Frame_Read_Data:
; 0003 0257     unsigned int CRC_CC1101;
; 0003 0258     #ifdef Send_Log_Option
; 0003 0259         unsigned char i;
; 0003 025A     #endif
; 0003 025B     //Frame
; 0003 025C 
; 0003 025D       RF_buffer[0]=46; //length byte
	ST   -Y,R17
	ST   -Y,R16
;	Sq_Num -> Y+3
;	type -> Y+2
;	CRC_CC1101 -> R16,R17
	LDI  R30,LOW(46)
	STS  _RF_buffer,R30
; 0003 025E 
; 0003 025F       RF_buffer[1]=0x6A;
	LDI  R30,LOW(106)
	CALL SUBOPT_0x55
; 0003 0260       RF_buffer[2]=Sq_Num;
; 0003 0261       RF_buffer[3]=HHU_ID1;//HHU ID
; 0003 0262       RF_buffer[4]=HHU_ID0;//HHU ID
; 0003 0263       RF_buffer[5]=0xFF;
; 0003 0264       RF_buffer[6]=0xFA;
; 0003 0265       RF_buffer[7]=HHU_ID1;
	CALL SUBOPT_0x69
; 0003 0266       RF_buffer[8]=HHU_ID0;
; 0003 0267 
; 0003 0268       RF_buffer[9]=0x00;
; 0003 0269       RF_buffer[10]=0x00;
; 0003 026A       RF_buffer[11]=0x00;
; 0003 026B 
; 0003 026C       RF_buffer[12]=32;//length of payload
	LDI  R30,LOW(32)
	__PUTB1MN _RF_buffer,12
; 0003 026D       RF_buffer[13]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _RF_buffer,13
; 0003 026E       RF_buffer[14]=32;//length of payload
	LDI  R30,LOW(32)
	__PUTB1MN _RF_buffer,14
; 0003 026F       //payload
; 0003 0270       Make_Payload(type);
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _Make_Payload
; 0003 0271        //2 byte crc
; 0003 0272        CRC_CC1101=CRC16CC1101_Buff(RF_buffer,RF_buffer[0]+1);
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x57
; 0003 0273        RF_buffer[47]=(unsigned char)(CRC_CC1101>>8);
	__PUTBMRN _RF_buffer,47,17
; 0003 0274        RF_buffer[48]=(unsigned char)(CRC_CC1101&0x00FF);
	MOV  R30,R16
	__PUTB1MN _RF_buffer,48
; 0003 0275 
; 0003 0276 
; 0003 0277       #ifdef Send_Log_Option
; 0003 0278     //load to 48x2 byte log TX
; 0003 0279    //payload log
; 0003 027A     for(i=0;i<15;i++)    //chua ma hoa   , ko bao gom 2 byte CRC RF
; 0003 027B     {
; 0003 027C         TX_Data_Log_RF_After_Dec_Buff[i]=RF_buffer[i];
; 0003 027D     }
; 0003 027E     for(i=0;i<49;i++)    //da ma hoa, co bao gom 2 byte CRC RF
; 0003 027F     {
; 0003 0280         TX_Data_Log_RF_Buff[i]=RF_buffer[i];
; 0003 0281     }
; 0003 0282     #endif
; 0003 0283 
; 0003 0284 
; 0003 0285 
; 0003 0286 
; 0003 0287 }
	RJMP _0x20A0009
;//-------------------------------------------------------------------------------------
;void RF_Send_Read_Mesh(unsigned char Sq_Num, unsigned char Channel_num, unsigned char type)
; 0003 028A {
_RF_Send_Read_Mesh:
; 0003 028B 
; 0003 028C 
; 0003 028D         LED_Red();
;	Sq_Num -> Y+2
;	Channel_num -> Y+1
;	type -> Y+0
	CALL SUBOPT_0x6A
; 0003 028E         Frame_Read_Data(Sq_Num, type);
	RCALL _Frame_Read_Data
; 0003 028F         idle_mode_PA();
	CALL SUBOPT_0x59
; 0003 0290         Strobes_Comm(SIDLE);
; 0003 0291         write_Reg(PKTLEN,RF_buffer[0]+3);         // Datalength+1+2: 1 byte Leng, 2 byte CRC
	CALL SUBOPT_0x5A
; 0003 0292 
; 0003 0293          delay_ms(50);
	CALL SUBOPT_0x6B
; 0003 0294 
; 0003 0295         Mesh_RF_Send(RF_buffer, RF_buffer[0]+3);//send data
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x5B
; 0003 0296         Mesh_RF_Send(RF_buffer, RF_buffer[0]+3);//send data
	CALL SUBOPT_0x5B
; 0003 0297         Mesh_RF_Send(RF_buffer, RF_buffer[0]+3);//send data
	CALL SUBOPT_0x5C
; 0003 0298 
; 0003 0299         To_Process_WaitRF();// goto RX mode
	CALL SUBOPT_0x35
; 0003 029A         write_Reg(PKTLEN,60);// for Recive data
	LDI  R30,LOW(60)
	ST   -Y,R30
	CALL _write_Reg
; 0003 029B 
; 0003 029C         rx_wr_index1=0;
	CLR  R7
; 0003 029D         rx_counter1=0;
	CLR  R6
; 0003 029E }
	RJMP _0x20A000A
;//-------------------------------------------------------------------------------------
;void Get_Payload(unsigned char *buff_source, unsigned char *buff_des)
; 0003 02A1 {
_Get_Payload:
; 0003 02A2     unsigned char Payload_Length;
; 0003 02A3     unsigned char i;
; 0003 02A4 
; 0003 02A5     Payload_Length=buff_source[14];
	ST   -Y,R17
	ST   -Y,R16
;	*buff_source -> Y+4
;	*buff_des -> Y+2
;	Payload_Length -> R17
;	i -> R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,14
	LD   R17,X
; 0003 02A6 
; 0003 02A7     for(i=0;i<Payload_Length;i++)
	LDI  R16,LOW(0)
_0x60057:
	CP   R16,R17
	BRSH _0x60058
; 0003 02A8     {
; 0003 02A9         buff_des[i]=buff_source[15+i];
	MOV  R30,R16
	CALL SUBOPT_0x41
	MOVW R0,R30
	CALL SUBOPT_0x51
	ADIW R30,15
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x6C
; 0003 02AA     }
	SUBI R16,-1
	RJMP _0x60057
_0x60058:
; 0003 02AB 
; 0003 02AC }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;//-------------------------------------------------------------------------------------
;void Payload_AES_Decrypt(unsigned char *buff_source, unsigned char *buff_Des, unsigned char lenght)
; 0003 02AF {
_Payload_AES_Decrypt:
; 0003 02B0     unsigned char data[32], i;
; 0003 02B1 
; 0003 02B2     aes_decrypt(data, buff_source, 32, 0, 0);
	SBIW R28,32
	ST   -Y,R17
;	*buff_source -> Y+36
;	*buff_Des -> Y+34
;	lenght -> Y+33
;	data -> Y+1
;	i -> R17
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+38
	LDD  R31,Y+38+1
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x67
	ST   -Y,R31
	ST   -Y,R30
	RCALL _aes_decrypt
; 0003 02B3 
; 0003 02B4     for(i=0;i<lenght;i++)
	LDI  R17,LOW(0)
_0x6005A:
	LDD  R30,Y+33
	CP   R17,R30
	BRSH _0x6005B
; 0003 02B5     {
; 0003 02B6        buff_Des[i]=data[i+2];   //loai bo 2 byte lenghy o dau
	MOV  R30,R17
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	CALL SUBOPT_0x6E
	MOVW R0,R30
	CALL SUBOPT_0x47
	ADIW R30,2
	CALL SUBOPT_0x68
; 0003 02B7     }
	SUBI R17,-1
	RJMP _0x6005A
_0x6005B:
; 0003 02B8     buff_Des[lenght-2]=0;
	LDD  R30,Y+33
	LDI  R31,0
	SBIW R30,2
	CALL SUBOPT_0x6F
; 0003 02B9     buff_Des[lenght-1]=0;
	LDD  R30,Y+33
	LDI  R31,0
	SBIW R30,1
	CALL SUBOPT_0x6F
; 0003 02BA }
	LDD  R17,Y+0
	ADIW R28,38
	RET
;//-------------------------------------------------------------------------------------
;unsigned char Payload_Checksum(unsigned char *dst, unsigned char iLengthBuff)
; 0003 02BD {
_Payload_Checksum:
; 0003 02BE     int iSum = 0,j;
; 0003 02BF 
; 0003 02C0     for (j = 0; j < iLengthBuff; j++)
	CALL SUBOPT_0x54
;	*dst -> Y+5
;	iLengthBuff -> Y+4
;	iSum -> R16,R17
;	j -> R18,R19
	__GETWRN 18,19,0
_0x6005D:
	CALL SUBOPT_0x60
	BRGE _0x6005E
; 0003 02C1     {
; 0003 02C2         iSum += dst[j];
	CALL SUBOPT_0x61
; 0003 02C3     }
	__ADDWRN 18,19,1
	RJMP _0x6005D
_0x6005E:
; 0003 02C4     return ((unsigned char)(iSum & 0xFF));
_0x20A000C:
	MOV  R30,R16
_0x20A000D:
	CALL __LOADLOCR4
	ADIW R28,7
	RET
; 0003 02C5 
; 0003 02C6 }
;//-------------------------------------------------------------------------------------
;unsigned char Check_SEQ()
; 0003 02C9 {
_Check_SEQ:
; 0003 02CA    if(Command_ID!=Cmd_UI_ID) //neu khong phai doc UI
	LDI  R30,LOW(6)
	CP   R30,R13
	BREQ _0x6005F
; 0003 02CB    {
; 0003 02CC     return 2;        //trong che do doc dien nang: chi nhan form dung khi SEQID=2;
	LDI  R30,LOW(2)
	RET
; 0003 02CD    }
; 0003 02CE    else //neu la lenh doc UI tra ve 2 hoac 3
_0x6005F:
; 0003 02CF    {
; 0003 02D0     return Frame_Seq_Num;
	LDS  R30,_Frame_Seq_Num
	RET
; 0003 02D1    }
; 0003 02D2 }
	RET
;
;//-------------------------------------------------------------------------------------
;unsigned char ProcessRF_Mesh(void)
; 0003 02D6 {
_ProcessRF_Mesh:
; 0003 02D7         unsigned int crc_byte;
; 0003 02D8         unsigned char crc_byte_hi,crc_byte_low;
; 0003 02D9         uchar buf[64];
; 0003 02DA         uchar length=64;
; 0003 02DB         uchar FormOK = 0;
; 0003 02DC         unsigned char AES_Payload_Buff[32];
; 0003 02DD         #ifdef Send_Log_Option
; 0003 02DE             unsigned char i;
; 0003 02DF         #endif
; 0003 02E0 
; 0003 02E1         RF_Recieve(buf,&length);
	SBIW R28,63
	SBIW R28,33
	CALL SUBOPT_0x5D
;	crc_byte -> R16,R17
;	crc_byte_hi -> R19
;	crc_byte_low -> R18
;	buf -> Y+38
;	length -> R21
;	FormOK -> R20
;	AES_Payload_Buff -> Y+6
	CALL SUBOPT_0x70
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL _RF_Recieve
	POP  R21
; 0003 02E2         Signal_RSSI=read_Reg(0xF4);//
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x71
; 0003 02E3 
; 0003 02E4         idle_mode_PA();
; 0003 02E5         Strobes_Comm(SIDLE);
; 0003 02E6         //Strobes_Comm(SFTX);
; 0003 02E7         Strobes_Comm(SFRX);
; 0003 02E8         Strobes_Comm(SPWD);
	CALL SUBOPT_0xF
; 0003 02E9 
; 0003 02EA 
; 0003 02EB         if( (buf[0]==46) &&(buf[1]==0xEA)&&(buf[5]==0xFF)&&(buf[6]==0xFA))    //leng, header
	LDD  R26,Y+38
	CPI  R26,LOW(0x2E)
	BRNE _0x60062
	LDD  R26,Y+39
	CPI  R26,LOW(0xEA)
	BRNE _0x60062
	LDD  R26,Y+43
	CPI  R26,LOW(0xFF)
	BRNE _0x60062
	LDD  R26,Y+44
	CPI  R26,LOW(0xFA)
	BREQ _0x60063
_0x60062:
	RJMP _0x60061
_0x60063:
; 0003 02EC         {
; 0003 02ED 
; 0003 02EE 
; 0003 02EF            if(buf[2]==Check_SEQ())
	RCALL _Check_SEQ
	LDD  R26,Y+40
	CP   R30,R26
	BREQ PC+3
	JMP _0x60064
; 0003 02F0            {
; 0003 02F1             crc_byte=CRC16CC1101_Buff(buf,buf[0]+1);
	CALL SUBOPT_0x70
	LDD  R30,Y+40
	CALL SUBOPT_0x5F
; 0003 02F2             crc_byte_hi=(unsigned char)(crc_byte>>8);
; 0003 02F3             crc_byte_low=(unsigned char)(crc_byte&0x00FF);
; 0003 02F4             if( (buf[47]==crc_byte_hi)&&(buf[48]==crc_byte_low)) //check CRC
	__GETB2SX 85
	CP   R19,R26
	BRNE _0x60066
	__GETB2SX 86
	CP   R18,R26
	BREQ _0x60067
_0x60066:
	RJMP _0x60065
_0x60067:
; 0003 02F5             {
; 0003 02F6                 if((buf[3]==HHU_ID1) && (buf[4]==HHU_ID0)&&(buf[9]==HHU_ID1) && (buf[10]==HHU_ID0))   //check HHU ID
	LDS  R30,_HHU_ID1
	LDD  R26,Y+41
	CP   R30,R26
	BRNE _0x60069
	LDS  R30,_HHU_ID0
	LDD  R26,Y+42
	CP   R30,R26
	BRNE _0x60069
	LDS  R30,_HHU_ID1
	LDD  R26,Y+47
	CP   R30,R26
	BRNE _0x60069
	LDS  R30,_HHU_ID0
	LDD  R26,Y+48
	CP   R30,R26
	BREQ _0x6006A
_0x60069:
	RJMP _0x60068
_0x6006A:
; 0003 02F7                 {
; 0003 02F8 
; 0003 02F9 
; 0003 02FA                     Get_Payload(buf,AES_Payload_Buff);//lay pay_load tu form RF RX
	CALL SUBOPT_0x70
	CALL SUBOPT_0x4B
	RCALL _Get_Payload
; 0003 02FB                     Payload_AES_Decrypt(AES_Payload_Buff,Payload_Buff,32);
	CALL SUBOPT_0x5E
	LDI  R30,LOW(_Payload_Buff)
	LDI  R31,HIGH(_Payload_Buff)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _Payload_AES_Decrypt
; 0003 02FC 
; 0003 02FD                     if(Payload_Checksum(Payload_Buff,Payload_Buff[7]+7)==Payload_Buff[Payload_Buff[7]+7]) //checksum
	LDI  R30,LOW(_Payload_Buff)
	LDI  R31,HIGH(_Payload_Buff)
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _Payload_Buff,7
	SUBI R30,-LOW(7)
	ST   -Y,R30
	RCALL _Payload_Checksum
	MOV  R26,R30
	__GETB1MN _Payload_Buff,7
	LDI  R31,0
	__ADDW1MN _Payload_Buff,7
	LD   R30,Z
	CP   R30,R26
	BRNE _0x6006B
; 0003 02FE                     {
; 0003 02FF 
; 0003 0300                         FormOK=1;
	LDI  R20,LOW(1)
; 0003 0301                         //---------------------
; 0003 0302                         #ifdef Send_Log_Option
; 0003 0303                                 //load to Datalog RF: du lieu tho bao gom ca 2 byte CRC RF
; 0003 0304                                 for(i=0;i<49;i++)
; 0003 0305                                 {
; 0003 0306                                    Data_Log_RF_Buff[i]=buf[i];
; 0003 0307                                 }
; 0003 0308                                 //Du lieu sau giai ma, ko bao gom 2 byte CRC RF
; 0003 0309 
; 0003 030A                                 for(i=0;i<15;i++)
; 0003 030B                                 {
; 0003 030C                                    Data_Log_RF_After_Dec_Buff[i]=buf[i];
; 0003 030D                                 }
; 0003 030E                                 for(i=0;i<32;i++)
; 0003 030F                                 {
; 0003 0310                                    Data_Log_RF_After_Dec_Buff[i+15]=Payload_Buff[i];
; 0003 0311                                 }
; 0003 0312                         #endif
; 0003 0313                         //---------------------
; 0003 0314 
; 0003 0315 
; 0003 0316                     }
; 0003 0317 
; 0003 0318                 }
_0x6006B:
; 0003 0319 
; 0003 031A             }
_0x60068:
; 0003 031B            }
_0x60065:
; 0003 031C         }
_0x60064:
; 0003 031D 
; 0003 031E 
; 0003 031F         //
; 0003 0320         LED_Off();
_0x60061:
	CALL _LED_Off
; 0003 0321 
; 0003 0322         if(!FormOK)
	CPI  R20,0
	BRNE _0x6006C
; 0003 0323         {
; 0003 0324 
; 0003 0325                 To_Process_WaitRF();// goto RX mode
	CALL _To_Process_WaitRF
; 0003 0326                 return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A000B
; 0003 0327 
; 0003 0328         }
; 0003 0329         else
_0x6006C:
; 0003 032A         {
; 0003 032B 
; 0003 032C             return 1;
	LDI  R30,LOW(1)
; 0003 032D         }
; 0003 032E 
; 0003 032F }
_0x20A000B:
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,39
	RET
;
;
;//-------------------------------------------------------------------------------------
;void RF_Convert_Long_To_Byte(unsigned long Data_Long,unsigned char *Data_Byte, unsigned char Index, unsigned char Length)
; 0003 0334 {
_RF_Convert_Long_To_Byte:
; 0003 0335 	Data_Byte[0+Index]=(((unsigned char)(Data_Long/1000000)/10)<<4)|(((unsigned char)(Data_Long/1000000)%10)&0x0F);
;	Data_Long -> Y+4
;	*Data_Byte -> Y+2
;	Index -> Y+1
;	Length -> Y+0
	CALL SUBOPT_0x72
	CALL SUBOPT_0x73
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x74
	CALL SUBOPT_0x75
	PUSH R30
	CALL SUBOPT_0x74
	CALL __MODW21
	ANDI R30,LOW(0xF)
	POP  R26
	OR   R30,R26
	POP  R26
	POP  R27
	ST   X,R30
; 0003 0336 	Data_Byte[1+Index]=(((unsigned char)((Data_Long/10000)%100)/10)<<4)|(((unsigned char)((Data_Long/10000)%100)%10)&0x0F);
	CALL SUBOPT_0x72
	ADIW R30,1
	CALL SUBOPT_0x76
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x77
	CALL SUBOPT_0x75
	PUSH R30
	CALL SUBOPT_0x77
	CALL __MODW21
	ANDI R30,LOW(0xF)
	POP  R26
	OR   R30,R26
	POP  R26
	POP  R27
	ST   X,R30
; 0003 0337 	Data_Byte[2+Index]=(((unsigned char)((Data_Long/100)%100)/10)<<4)|(((unsigned char)((Data_Long/100)%100)%10)&0x0F);
	CALL SUBOPT_0x72
	ADIW R30,2
	CALL SUBOPT_0x76
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x78
	CALL SUBOPT_0x75
	PUSH R30
	CALL SUBOPT_0x78
	CALL __MODW21
	ANDI R30,LOW(0xF)
	POP  R26
	OR   R30,R26
	POP  R26
	POP  R27
	ST   X,R30
; 0003 0338 	Data_Byte[3+Index]=(((unsigned char)(Data_Long%100)/10)<<4)|(((unsigned char)(Data_Long%100)%10)&0x0F);
	CALL SUBOPT_0x72
	ADIW R30,3
	CALL SUBOPT_0x76
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x79
	CALL SUBOPT_0x75
	PUSH R30
	CALL SUBOPT_0x79
	CALL __MODW21
	ANDI R30,LOW(0xF)
	POP  R26
	OR   R30,R26
	POP  R26
	POP  R27
	ST   X,R30
; 0003 0339 
; 0003 033A 	if(Length==3)
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x6006E
; 0003 033B 	{
; 0003 033C 		Data_Byte[0+Index]=Data_Byte[1+Index];
	CALL SUBOPT_0x72
	MOVW R22,R30
	CALL SUBOPT_0x73
	MOVW R0,R30
	MOVW R30,R22
	ADIW R30,1
	CALL SUBOPT_0x7A
; 0003 033D 		Data_Byte[1+Index]=Data_Byte[2+Index];
	CALL SUBOPT_0x72
	MOVW R22,R30
	ADIW R30,1
	CALL SUBOPT_0x76
	MOVW R0,R30
	MOVW R30,R22
	ADIW R30,2
	CALL SUBOPT_0x7A
; 0003 033E 		Data_Byte[2+Index]=Data_Byte[3+Index];
	CALL SUBOPT_0x72
	MOVW R22,R30
	ADIW R30,2
	RJMP _0x600AC
; 0003 033F 	}
; 0003 0340 	else if(Length==2)
_0x6006E:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x60070
; 0003 0341 	{
; 0003 0342 		Data_Byte[0+Index]=Data_Byte[2+Index];
	CALL SUBOPT_0x72
	MOVW R22,R30
	CALL SUBOPT_0x73
	MOVW R0,R30
	MOVW R30,R22
	ADIW R30,2
	CALL SUBOPT_0x7A
; 0003 0343 		Data_Byte[1+Index]=Data_Byte[3+Index];
	CALL SUBOPT_0x72
	MOVW R22,R30
	ADIW R30,1
	RJMP _0x600AC
; 0003 0344 	}
; 0003 0345 	else if(Length==1)
_0x60070:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x60072
; 0003 0346 	{
; 0003 0347 		Data_Byte[0+Index]=Data_Byte[3+Index];
	CALL SUBOPT_0x72
	MOVW R22,R30
	ADIW R30,0
_0x600AC:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL SUBOPT_0x7B
	ADIW R30,3
	CALL SUBOPT_0x7A
; 0003 0348 	}
; 0003 0349 }
_0x60072:
	ADIW R28,8
	RET
;
;//-------------------------------------------------------------------------------------
;void Frame_RS232_Mesh(unsigned char CMD)
; 0003 034D {
_Frame_RS232_Mesh:
; 0003 034E     unsigned char i, XOR_byte=0;
; 0003 034F     tx_buffer[0]=0x68;    //start form
	CALL SUBOPT_0x8
;	CMD -> Y+2
;	i -> R17
;	XOR_byte -> R16
; 0003 0350     tx_buffer[1]=0x12;
; 0003 0351     tx_buffer[2]=Signal_RSSI;
	CALL SUBOPT_0x7C
; 0003 0352     tx_buffer[3]=Current_Channel;
; 0003 0353     tx_buffer[4]=0x02;//type mesh
	LDI  R30,LOW(2)
	CALL SUBOPT_0x7D
; 0003 0354     tx_buffer[5]=ArraySerial[0];
; 0003 0355     tx_buffer[6]=ArraySerial[1];
; 0003 0356     tx_buffer[7]=ArraySerial[2];
; 0003 0357     tx_buffer[8]=ArraySerial[3];
; 0003 0358     tx_buffer[9]=CMD;
	LDD  R30,Y+2
	__PUTB1MN _tx_buffer,9
; 0003 0359     switch(CMD)
	LDI  R31,0
; 0003 035A     {
; 0003 035B         case Cmd_180_ID:
	SBIW R30,0
	BREQ _0x60077
; 0003 035C         case Cmd_181_ID:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x60078
_0x60077:
; 0003 035D         case Cmd_182_ID:
	RJMP _0x60079
_0x60078:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x6007A
_0x60079:
; 0003 035E         case Cmd_183_ID:
	RJMP _0x6007B
_0x6007A:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x6007C
_0x6007B:
; 0003 035F 
; 0003 0360         case Cmd_280_ID:
	RJMP _0x6007D
_0x6007C:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x6007E
_0x6007D:
; 0003 0361         case Cmd_281_ID:
	RJMP _0x6007F
_0x6007E:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0x60080
_0x6007F:
; 0003 0362         case Cmd_282_ID:
	RJMP _0x60081
_0x60080:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0x60082
_0x60081:
; 0003 0363         case Cmd_283_ID:
	RJMP _0x60083
_0x60082:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0x60084
_0x60083:
; 0003 0364 
; 0003 0365         case Cmd_380_ID:
	RJMP _0x60085
_0x60084:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x60086
_0x60085:
; 0003 0366         case Cmd_381_ID:
	RJMP _0x60087
_0x60086:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x60088
_0x60087:
; 0003 0367         case Cmd_382_ID:
	RJMP _0x60089
_0x60088:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x6008A
_0x60089:
; 0003 0368         case Cmd_383_ID:
	RJMP _0x6008B
_0x6008A:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x6008C
_0x6008B:
; 0003 0369 
; 0003 036A         case Cmd_480_ID:
	RJMP _0x6008D
_0x6008C:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x6008E
_0x6008D:
; 0003 036B         case Cmd_481_ID:
	RJMP _0x6008F
_0x6008E:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0x60090
_0x6008F:
; 0003 036C         case Cmd_482_ID:
	RJMP _0x60091
_0x60090:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0x60092
_0x60091:
; 0003 036D         case Cmd_483_ID:
	RJMP _0x60093
_0x60092:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x60094
_0x60093:
; 0003 036E 
; 0003 036F         case Cmd_UA_ID:
	RJMP _0x60095
_0x60094:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0x60096
_0x60095:
; 0003 0370         case Cmd_UB_ID:
	RJMP _0x60097
_0x60096:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x60098
_0x60097:
; 0003 0371         case Cmd_UC_ID:
	RJMP _0x60099
_0x60098:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0x6009A
_0x60099:
; 0003 0372         case Cmd_IA_ID:
	RJMP _0x6009B
_0x6009A:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0x6009C
_0x6009B:
; 0003 0373         case Cmd_IB_ID:
	RJMP _0x6009D
_0x6009C:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0x6009E
_0x6009D:
; 0003 0374         case Cmd_IC_ID:
	RJMP _0x6009F
_0x6009E:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0x600A0
_0x6009F:
; 0003 0375             RF_Convert_Long_To_Byte(Real_Data[0],tx_buffer,10,4); //buff[10]-buff[13]
	LDS  R30,_Real_Data
	LDS  R31,_Real_Data+1
	LDS  R22,_Real_Data+2
	LDS  R23,_Real_Data+3
	CALL SUBOPT_0x7E
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _RF_Convert_Long_To_Byte
; 0003 0376             tx_buffer[14]=0x00;
	CALL SUBOPT_0x9
; 0003 0377             tx_buffer[15]=0x00;
; 0003 0378              for(i=1; i<16;i++)
_0x600A2:
	CPI  R17,16
	BRSH _0x600A3
; 0003 0379             {
; 0003 037A                 XOR_byte^= tx_buffer[i];
	CALL SUBOPT_0x7
	LD   R30,Z
	EOR  R16,R30
; 0003 037B             }
	SUBI R17,-1
	RJMP _0x600A2
_0x600A3:
; 0003 037C         break;
	RJMP _0x60075
; 0003 037D 
; 0003 037E         case Cmd_UI_ID:
_0x600A0:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x600A8
; 0003 037F             RF_Convert_Long_To_Byte(Real_Data[1],tx_buffer,10,3); //buff[10]-buff[12]
	__GETD1MN _Real_Data,4
	CALL SUBOPT_0x7E
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _RF_Convert_Long_To_Byte
; 0003 0380             RF_Convert_Long_To_Byte(Real_Data[2],tx_buffer,13,3); //buff[13]-buff[15]
	__GETD1MN _Real_Data,8
	CALL SUBOPT_0x7E
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _RF_Convert_Long_To_Byte
; 0003 0381             for(i=1; i<16;i++)
	LDI  R17,LOW(1)
_0x600A6:
	CPI  R17,16
	BRSH _0x600A7
; 0003 0382             {
; 0003 0383                 XOR_byte^= tx_buffer[i];
	CALL SUBOPT_0x7
	LD   R30,Z
	EOR  R16,R30
; 0003 0384             }
	SUBI R17,-1
	RJMP _0x600A6
_0x600A7:
; 0003 0385 
; 0003 0386         break;
; 0003 0387 
; 0003 0388         default:
_0x600A8:
; 0003 0389         break;
; 0003 038A     }
_0x60075:
; 0003 038B 
; 0003 038C      tx_buffer[16]=XOR_byte;
	CALL SUBOPT_0xA
; 0003 038D      tx_buffer[17]=0x16;      //end form
; 0003 038E 
; 0003 038F }
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A000A:
	ADIW R28,3
	RET
;
;
;
;
;
;//-------------------------------------------------------------------------------------
;void RF_Send_Close(unsigned char Sq_Num, unsigned char Channel_num)
; 0003 0397 {
_RF_Send_Close:
; 0003 0398 
; 0003 0399         unsigned int CRC_CC1101;
; 0003 039A 
; 0003 039B      //   LED_Red();
; 0003 039C 
; 0003 039D         RF_buffer[0]=11; //length byte
	ST   -Y,R17
	ST   -Y,R16
;	Sq_Num -> Y+3
;	Channel_num -> Y+2
;	CRC_CC1101 -> R16,R17
	LDI  R30,LOW(11)
	STS  _RF_buffer,R30
; 0003 039E         RF_buffer[1]=0x06;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x55
; 0003 039F         RF_buffer[2]=Sq_Num;
; 0003 03A0         RF_buffer[3]=HHU_ID1;//HHU ID
; 0003 03A1         RF_buffer[4]=HHU_ID0;//HHU ID
; 0003 03A2         RF_buffer[5]=0xFF;
; 0003 03A3         RF_buffer[6]=0xFA;
; 0003 03A4         RF_buffer[7]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _RF_buffer,7
; 0003 03A5         RF_buffer[8]=0x00;
	__PUTB1MN _RF_buffer,8
; 0003 03A6 
; 0003 03A7         RF_buffer[9]=HHU_ID1;
	LDS  R30,_HHU_ID1
	__PUTB1MN _RF_buffer,9
; 0003 03A8         RF_buffer[10]=HHU_ID0;
	LDS  R30,_HHU_ID0
	__PUTB1MN _RF_buffer,10
; 0003 03A9         RF_buffer[11]=0x07;
	LDI  R30,LOW(7)
	__PUTB1MN _RF_buffer,11
; 0003 03AA 
; 0003 03AB         //2 byte crc
; 0003 03AC         CRC_CC1101=CRC16CC1101_Buff(RF_buffer,RF_buffer[0]+1);
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x57
; 0003 03AD         RF_buffer[12]=(unsigned char)(CRC_CC1101>>8);
	__PUTBMRN _RF_buffer,12,17
; 0003 03AE         RF_buffer[13]=(unsigned char)(CRC_CC1101&0x00FF);
	MOV  R30,R16
	__PUTB1MN _RF_buffer,13
; 0003 03AF 
; 0003 03B0         idle_mode_PA();
	CALL SUBOPT_0x59
; 0003 03B1         Strobes_Comm(SIDLE);
; 0003 03B2         write_Reg(PKTLEN,RF_buffer[0]+3);         // Datalength+1+2: 1 byte Leng, 2 byte CRC
	CALL SUBOPT_0x5A
; 0003 03B3         delay_ms(50);
	CALL SUBOPT_0x6B
; 0003 03B4 
; 0003 03B5         //RF_Send(RF_buffer, RF_buffer[0]+3);//send dat    //trong ham RF_Send co delay_ms(100)????
; 0003 03B6         Mesh_RF_Send(RF_buffer, RF_buffer[0]+3);//send dat    //trong ham RF_Send co delay_ms(100)????
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x5C
; 0003 03B7         LED_Off();
	CALL _LED_Off
; 0003 03B8 
; 0003 03B9 
; 0003 03BA }
_0x20A0009:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;//-------------------------------------------------------------------------------------
;
;#ifdef Send_Log_Option
;void Clear_Data_Log_Buff()
;{
;    unsigned char i;
;    for(i=0;i<49;i++)
;    {
;        Data_Log_RF_Buff[i]=0;
;        Data_Log_RF_After_Dec_Buff[i]=0;// for log
;        TX_Data_Log_RF_Buff[i]=0;
;        TX_Data_Log_RF_After_Dec_Buff[i]=0;// for log
;    }
;}
;
;void Load_2nd_Log()//luu tam vao 1 buff khac trong truong hop doc UI
;{
;
;    unsigned char i;
;    for(i=0;i<49;i++)
;    {
;        Data_Log_RF_Buff2[i]=Data_Log_RF_Buff[i];
;        Data_Log_RF_After_Dec_Buff2[i]=Data_Log_RF_After_Dec_Buff[i];// for log
;        TX_Data_Log_RF_Buff2[i]=TX_Data_Log_RF_Buff[i];
;        TX_Data_Log_RF_After_Dec_Buff2[i]=TX_Data_Log_RF_After_Dec_Buff[i];// for log
;    }
;}
;
;#endif
;
;
;
;//-------------------------------------------------------------------------------------
;
;#include "TI_aes_128.h"
;#include "aes.h"
;#include "string.h"
;
;
;#define BLOCK_SIZE      16
;
;
;const static uint8_t aes_key_default[16] =
;        {0x2c, 0x92, 0x1d, 0xa3, 0x90, 0xfa, 0xcc, 0xba,
;         0x86, 0xd4, 0xa0, 0xdf, 0x21, 0xde, 0xb0, 0xf5};

	.DSEG
;
;const static uint8_t aes_iv_default[16] =
;        {0xdd, 0x6b, 0x3b, 0xa7, 0x1d, 0x03, 0xc0, 0x8e,
;         0x71, 0x8b, 0xad, 0xf7, 0xa2, 0xc8, 0x10, 0x56};
;
;
;static void xor_iv(uint8_t *block, const uint8_t *iv)
; 0004 0014 {

	.CSEG
_xor_iv_G004:
; 0004 0015     uint8_t i;
; 0004 0016     for (i = 0; i < BLOCK_SIZE; i++) {
	ST   -Y,R17
;	*block -> Y+3
;	*iv -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x80006:
	CPI  R17,16
	BRSH _0x80007
; 0004 0017         block[i] ^= iv[i];
	MOV  R30,R17
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CALL SUBOPT_0x6E
	MOVW R22,R30
	LD   R0,Z
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	CALL SUBOPT_0x7F
; 0004 0018     }
	SUBI R17,-1
	RJMP _0x80006
_0x80007:
; 0004 0019 }
	LDD  R17,Y+0
	ADIW R28,5
	RET
;
;uint16_t aes_encrypt(uint8_t *output, const uint8_t *input, uint16_t length, const uint8_t *key, const uint8_t *iv)
; 0004 001C {
_aes_encrypt:
; 0004 001D     uint8_t akey[BLOCK_SIZE];
; 0004 001E     uint8_t remainders = length % BLOCK_SIZE;
; 0004 001F     uint16_t i = 0;
; 0004 0020 
; 0004 0021     if (key == 0) {
	SBIW R28,16
	CALL __SAVELOCR4
;	*output -> Y+28
;	*input -> Y+26
;	length -> Y+24
;	*key -> Y+22
;	*iv -> Y+20
;	akey -> Y+4
;	remainders -> R17
;	i -> R18,R19
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	MOV  R17,R30
	__GETWRN 18,19,0
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SBIW R30,0
	BRNE _0x80008
; 0004 0022         key = aes_key_default;
	LDI  R30,LOW(_aes_key_default_G004)
	LDI  R31,HIGH(_aes_key_default_G004)
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0004 0023     }
; 0004 0024 
; 0004 0025     if (iv == 0) {
_0x80008:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	SBIW R30,0
	BRNE _0x80009
; 0004 0026         iv = aes_iv_default;
	LDI  R30,LOW(_aes_iv_default_G004)
	LDI  R31,HIGH(_aes_iv_default_G004)
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0004 0027     }
; 0004 0028 
; 0004 0029     for (i = 0; i < length / BLOCK_SIZE; i++) {
_0x80009:
	__GETWRN 18,19,0
_0x8000B:
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	CALL __LSRW4
	CP   R18,R30
	CPC  R19,R31
	BRSH _0x8000C
; 0004 002A         memcpy(output, input, BLOCK_SIZE);
	CALL SUBOPT_0x80
	CALL SUBOPT_0x80
	CALL SUBOPT_0x81
; 0004 002B         xor_iv(output, iv);
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	CALL SUBOPT_0x82
; 0004 002C         memcpy(akey, key, BLOCK_SIZE);
	CALL SUBOPT_0x83
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x81
; 0004 002D         aes_enc_dec(output, akey, 0);
	CALL SUBOPT_0x5E
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _aes_enc_dec
; 0004 002E         iv = output;
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0004 002F         input += BLOCK_SIZE;
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	ADIW R30,16
	STD  Y+26,R30
	STD  Y+26+1,R31
; 0004 0030         output += BLOCK_SIZE;
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	ADIW R30,16
	STD  Y+28,R30
	STD  Y+28+1,R31
; 0004 0031     }
	__ADDWRN 18,19,1
	RJMP _0x8000B
_0x8000C:
; 0004 0032 
; 0004 0033     if (remainders > 0) {
	CPI  R17,1
	BRSH PC+3
	JMP _0x8000D
; 0004 0034         uint8_t padding_len = BLOCK_SIZE - remainders;
; 0004 0035         memcpy(output, input, remainders);
	SBIW R28,1
;	*output -> Y+29
;	*input -> Y+27
;	length -> Y+25
;	*key -> Y+23
;	*iv -> Y+21
;	akey -> Y+5
;	padding_len -> Y+0
	CALL SUBOPT_0x47
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	ST   Y,R30
	CALL SUBOPT_0x84
	CALL SUBOPT_0x84
	CALL SUBOPT_0x47
	CALL SUBOPT_0x85
; 0004 0036         memset(&output[remainders], 0, padding_len);
	MOV  R30,R17
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	CALL SUBOPT_0x6E
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+3
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0004 0037         xor_iv(output, iv);
	CALL SUBOPT_0x84
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	CALL SUBOPT_0x82
; 0004 0038         memcpy(akey, key, BLOCK_SIZE);
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+25
	LDD  R31,Y+25+1
	CALL SUBOPT_0x86
; 0004 0039         aes_enc_dec(output, akey, 0);
	CALL SUBOPT_0x84
	MOVW R30,R28
	ADIW R30,7
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _aes_enc_dec
; 0004 003A 
; 0004 003B         length += padding_len;
	CALL SUBOPT_0x87
	LDD  R26,Y+25
	LDD  R27,Y+25+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+25,R30
	STD  Y+25+1,R31
; 0004 003C     }
	ADIW R28,1
; 0004 003D 
; 0004 003E     return length;
_0x8000D:
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	CALL __LOADLOCR4
	ADIW R28,30
	RET
; 0004 003F }
;
;void aes_decrypt(uint8_t *output, const uint8_t *input, uint16_t length, const uint8_t *key, const uint8_t *iv)
; 0004 0042 {
_aes_decrypt:
; 0004 0043     uint8_t akey[BLOCK_SIZE];
; 0004 0044     uint16_t i = 0;
; 0004 0045 
; 0004 0046     if (key == 0) {
	SBIW R28,16
	ST   -Y,R17
	ST   -Y,R16
;	*output -> Y+26
;	*input -> Y+24
;	length -> Y+22
;	*key -> Y+20
;	*iv -> Y+18
;	akey -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	SBIW R30,0
	BRNE _0x8000E
; 0004 0047         memcpy(akey, aes_key_default, BLOCK_SIZE);
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_aes_key_default_G004)
	LDI  R31,HIGH(_aes_key_default_G004)
	RJMP _0x80014
; 0004 0048     } else {
_0x8000E:
; 0004 0049         memcpy(akey, key, BLOCK_SIZE);
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+22
	LDD  R31,Y+22+1
_0x80014:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x85
; 0004 004A     }
; 0004 004B 
; 0004 004C     if (iv == 0) {
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	SBIW R30,0
	BRNE _0x80010
; 0004 004D         iv = aes_iv_default;
	LDI  R30,LOW(_aes_iv_default_G004)
	LDI  R31,HIGH(_aes_iv_default_G004)
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0004 004E     }
; 0004 004F 
; 0004 0050     for ( i = 0; i < length / BLOCK_SIZE; i++) {
_0x80010:
	__GETWRN 16,17,0
_0x80012:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	CALL __LSRW4
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x80013
; 0004 0051         memcpy(output, input, BLOCK_SIZE);
	CALL SUBOPT_0x88
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	CALL SUBOPT_0x86
; 0004 0052         aes_enc_dec(output, akey, 1);
	CALL SUBOPT_0x88
	CALL SUBOPT_0x83
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _aes_enc_dec
; 0004 0053         xor_iv(output, iv);
	CALL SUBOPT_0x88
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	CALL SUBOPT_0x82
; 0004 0054         iv = input;
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0004 0055         input += BLOCK_SIZE;
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	ADIW R30,16
	STD  Y+24,R30
	STD  Y+24+1,R31
; 0004 0056         output += BLOCK_SIZE;
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	ADIW R30,16
	STD  Y+26,R30
	STD  Y+26+1,R31
; 0004 0057     }
	__ADDWRN 16,17,1
	RJMP _0x80012
_0x80013:
; 0004 0058 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,28
	RET
;/* --COPYRIGHT--,BSD
; * Copyright (c) 2011, Texas Instruments Incorporated
; * All rights reserved.
; *
; * Redistribution and use in source and binary forms, with or without
; * modification, are permitted provided that the following conditions
; * are met:
; *
; * *  Redistributions of source code must retain the above copyright
; *    notice, this list of conditions and the following disclaimer.
; *
; * *  Redistributions in binary form must reproduce the above copyright
; *    notice, this list of conditions and the following disclaimer in the
; *    documentation and/or other materials provided with the distribution.
; *
; * *  Neither the name of Texas Instruments Incorporated nor the names of
; *    its contributors may be used to endorse or promote products derived
; *    from this software without specific prior written permission.
; *
; * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
; * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
; * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
; * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
; * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
; * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
; * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
; * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
; * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
; * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
; * --/COPYRIGHT--*/
;/*
; * TI_aes_128.c
; *
; *  Created on: Nov 3, 2011
; *      Author: Eric Peeters
; *
; *  Description: Implementation of the AES-128 as defined by the FIPS PUB 197:
; *  the official AES standard
; */
;
;
;// foreward sbox
;const unsigned char sbox[256] =   {
;//0     1    2      3     4    5     6     7      8    9     A      B    C     D     E     F
;0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76, //0
;0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0, //1
;0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15, //2
;0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75, //3
;0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84, //4
;0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf, //5
;0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8, //6
;0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2, //7
;0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73, //8
;0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb, //9
;0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79, //A
;0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08, //B
;0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a, //C
;0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e, //D
;0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf, //E
;0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16 }; //F

	.DSEG
;
;// inverse sbox
;const unsigned char rsbox[256] =
;{ 0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb
;, 0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb
;, 0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e
;, 0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25
;, 0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92
;, 0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84
;, 0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06
;, 0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b
;, 0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73
;, 0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e
;, 0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b
;, 0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4
;, 0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f
;, 0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef
;, 0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61
;, 0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d };
;
;// round constant
;const unsigned char Rcon[10] = {
;    0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};
;
;
;// multiply by 2 in the galois field
;unsigned char galois_mul2(unsigned char value)
; 0005 0059 {

	.CSEG
_galois_mul2:
; 0005 005A   signed char temp;
; 0005 005B   // cast to signed value
; 0005 005C   temp = (signed char) value;
	ST   -Y,R17
;	value -> Y+1
;	temp -> R17
	LDD  R17,Y+1
; 0005 005D   // if MSB is 1, then this will signed extend and fill the temp variable with 1's
; 0005 005E   temp = temp >> 7;
	MOV  R26,R17
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(7)
	CALL __ASRW12
	MOV  R17,R30
; 0005 005F   // AND with the reduction variable
; 0005 0060   temp = temp & 0x1b;
	ANDI R17,LOW(27)
; 0005 0061   // finally shift and reduce the value
; 0005 0062   return ((value << 1)^temp);
	LDD  R30,Y+1
	LSL  R30
	EOR  R30,R17
	LDD  R17,Y+0
	ADIW R28,2
	RET
; 0005 0063 }
;
;// AES encryption and decryption function
;// The code was optimized for memory (flash and ram)
;// Combining both encryption and decryption resulted in a slower implementation
;// but much smaller than the 2 functions separated
;// This function only implements AES-128 encryption and decryption (AES-192 and
;// AES-256 are not supported by this code)
;void aes_enc_dec(unsigned char *state, unsigned char *key, unsigned char dir)
; 0005 006C {
_aes_enc_dec:
; 0005 006D   unsigned char buf1, buf2, buf3, buf4, round, i;
; 0005 006E 
; 0005 006F   // In case of decryption
; 0005 0070   if (dir) {
	CALL __SAVELOCR6
;	*state -> Y+9
;	*key -> Y+7
;	dir -> Y+6
;	buf1 -> R17
;	buf2 -> R16
;	buf3 -> R19
;	buf4 -> R18
;	round -> R21
;	i -> R20
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0xA0006
; 0005 0071     // compute the last key of encryption before starting the decryption
; 0005 0072     for (round = 0 ; round < 10; round++) {
	LDI  R21,LOW(0)
_0xA0008:
	CPI  R21,10
	BRSH _0xA0009
; 0005 0073       //key schedule
; 0005 0074       key[0] = sbox[key[13]]^key[0]^Rcon[round];
	CALL SUBOPT_0x89
	MOV  R26,R0
	EOR  R26,R30
	CALL SUBOPT_0x50
	CALL SUBOPT_0x8A
; 0005 0075       key[1] = sbox[key[14]]^key[1];
; 0005 0076       key[2] = sbox[key[15]]^key[2];
; 0005 0077       key[3] = sbox[key[12]]^key[3];
; 0005 0078       for (i=4; i<16; i++) {
_0xA000B:
	CPI  R20,16
	BRSH _0xA000C
; 0005 0079         key[i] = key[i] ^ key[i-4];
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x8C
; 0005 007A       }
	SUBI R20,-1
	RJMP _0xA000B
_0xA000C:
; 0005 007B     }
	SUBI R21,-1
	RJMP _0xA0008
_0xA0009:
; 0005 007C 
; 0005 007D     //first Addroundkey
; 0005 007E     for (i = 0; i <16; i++){
	LDI  R20,LOW(0)
_0xA000E:
	CPI  R20,16
	BRSH _0xA000F
; 0005 007F       state[i]=state[i] ^ key[i];
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x7F
; 0005 0080     }
	SUBI R20,-1
	RJMP _0xA000E
_0xA000F:
; 0005 0081   }
; 0005 0082 
; 0005 0083   // main loop
; 0005 0084   for (round = 0; round < 10; round++){
_0xA0006:
	LDI  R21,LOW(0)
_0xA0011:
	CPI  R21,10
	BRLO PC+3
	JMP _0xA0012
; 0005 0085     if (dir){
	LDD  R30,Y+6
	CPI  R30,0
	BRNE PC+3
	JMP _0xA0013
; 0005 0086       //Inverse key schedule
; 0005 0087       for (i=15; i>3; --i) {
	LDI  R20,LOW(15)
_0xA0015:
	CPI  R20,4
	BRLO _0xA0016
; 0005 0088   key[i] = key[i] ^ key[i-4];
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x8C
; 0005 0089       }
	SUBI R20,LOW(1)
	RJMP _0xA0015
_0xA0016:
; 0005 008A       key[0] = sbox[key[13]]^key[0]^Rcon[9-round];
	CALL SUBOPT_0x89
	EOR  R0,R30
	CALL SUBOPT_0x50
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,LOW(-_Rcon)
	SBCI R31,HIGH(-_Rcon)
	LD   R30,Z
	EOR  R30,R0
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ST   X,R30
; 0005 008B       key[1] = sbox[key[14]]^key[1];
	ADIW R26,14
	CALL SUBOPT_0x90
	ADIW R26,1
	LD   R30,X
	EOR  R30,R0
	__PUTB1SNS 7,1
; 0005 008C       key[2] = sbox[key[15]]^key[2];
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,15
	CALL SUBOPT_0x90
	ADIW R26,2
	LD   R30,X
	EOR  R30,R0
	__PUTB1SNS 7,2
; 0005 008D       key[3] = sbox[key[12]]^key[3];
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,12
	CALL SUBOPT_0x90
	ADIW R26,3
	LD   R30,X
	EOR  R30,R0
	__PUTB1SNS 7,3
; 0005 008E     } else {
	RJMP _0xA0017
_0xA0013:
; 0005 008F       for (i = 0; i <16; i++){
	LDI  R20,LOW(0)
_0xA0019:
	CPI  R20,16
	BRSH _0xA001A
; 0005 0090         // with shiftrow i+5 mod 16
; 0005 0091   state[i]=sbox[state[i] ^ key[i]];
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CLR  R1
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	EOR  R30,R0
	EOR  R31,R1
	SUBI R30,LOW(-_sbox)
	SBCI R31,HIGH(-_sbox)
	LD   R30,Z
	MOVW R26,R22
	ST   X,R30
; 0005 0092       }
	SUBI R20,-1
	RJMP _0xA0019
_0xA001A:
; 0005 0093       //shift rows
; 0005 0094       buf1 = state[1];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,1
	LD   R17,X
; 0005 0095       state[1] = state[5];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,5
	LD   R30,X
	__PUTB1SNS 9,1
; 0005 0096       state[5] = state[9];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,9
	LD   R30,X
	__PUTB1SNS 9,5
; 0005 0097       state[9] = state[13];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,13
	LD   R30,X
	__PUTB1SNS 9,9
; 0005 0098       state[13] = buf1;
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__PUTBZR 17,13
; 0005 0099 
; 0005 009A       buf1 = state[2];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,2
	LD   R17,X
; 0005 009B       buf2 = state[6];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,6
	LD   R16,X
; 0005 009C       state[2] = state[10];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,10
	LD   R30,X
	__PUTB1SNS 9,2
; 0005 009D       state[6] = state[14];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,14
	LD   R30,X
	__PUTB1SNS 9,6
; 0005 009E       state[10] = buf1;
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__PUTBZR 17,10
; 0005 009F       state[14] = buf2;
	__PUTBZR 16,14
; 0005 00A0 
; 0005 00A1       buf1 = state[15];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,15
	LD   R17,X
; 0005 00A2       state[15] = state[11];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,11
	LD   R30,X
	__PUTB1SNS 9,15
; 0005 00A3       state[11] = state[7];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,7
	LD   R30,X
	__PUTB1SNS 9,11
; 0005 00A4       state[7] = state[3];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,3
	LD   R30,X
	__PUTB1SNS 9,7
; 0005 00A5       state[3] = buf1;
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__PUTBZR 17,3
; 0005 00A6     }
_0xA0017:
; 0005 00A7     //mixcol - inv mix
; 0005 00A8     if ((round > 0 && dir) || (round < 9 && !dir)) {
	CPI  R21,1
	BRLO _0xA001C
	LDD  R30,Y+6
	CPI  R30,0
	BRNE _0xA001E
_0xA001C:
	CPI  R21,9
	BRSH _0xA001F
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0xA001E
_0xA001F:
	RJMP _0xA001B
_0xA001E:
; 0005 00A9       for (i=0; i <4; i++){
	LDI  R20,LOW(0)
_0xA0023:
	CPI  R20,4
	BRLO PC+3
	JMP _0xA0024
; 0005 00AA         buf4 = (i << 2);
	MOV  R30,R20
	LSL  R30
	LSL  R30
	MOV  R18,R30
; 0005 00AB         if (dir){
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0xA0025
; 0005 00AC           // precompute for decryption
; 0005 00AD           buf1 = galois_mul2(galois_mul2(state[buf4]^state[buf4+2]));
	CALL SUBOPT_0x92
	CALL SUBOPT_0x93
	CALL SUBOPT_0x94
	CALL SUBOPT_0x95
	MOV  R17,R30
; 0005 00AE           buf2 = galois_mul2(galois_mul2(state[buf4+1]^state[buf4+3]));
	CALL SUBOPT_0x96
	CALL SUBOPT_0x97
	CALL SUBOPT_0x98
	CALL SUBOPT_0x95
	MOV  R16,R30
; 0005 00AF           state[buf4] ^= buf1; state[buf4+1] ^= buf2; state[buf4+2] ^= buf1; state[buf4+3] ^= buf2;
	CALL SUBOPT_0x92
	LD   R30,X
	EOR  R30,R17
	ST   X,R30
	CALL SUBOPT_0x96
	CALL SUBOPT_0x99
	EOR  R30,R16
	ST   X,R30
	CALL SUBOPT_0x96
	CALL SUBOPT_0x94
	EOR  R30,R17
	ST   X,R30
	CALL SUBOPT_0x96
	CALL SUBOPT_0x98
	EOR  R30,R16
	ST   X,R30
; 0005 00B0         }
; 0005 00B1         // in all cases
; 0005 00B2         buf1 = state[buf4] ^ state[buf4+1] ^ state[buf4+2] ^ state[buf4+3];
_0xA0025:
	CALL SUBOPT_0x92
	CALL SUBOPT_0x93
	CALL SUBOPT_0x99
	EOR  R0,R30
	CALL SUBOPT_0x96
	CALL SUBOPT_0x94
	EOR  R0,R30
	CALL SUBOPT_0x96
	CALL SUBOPT_0x98
	EOR  R30,R0
	MOV  R17,R30
; 0005 00B3         buf2 = state[buf4];
	CALL SUBOPT_0x92
	LD   R16,X
; 0005 00B4         buf3 = state[buf4]^state[buf4+1]; buf3=galois_mul2(buf3); state[buf4] = state[buf4] ^ buf3 ^ buf1;
	CALL SUBOPT_0x92
	CALL SUBOPT_0x93
	CALL SUBOPT_0x99
	CALL SUBOPT_0x9A
	MOV  R30,R18
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL SUBOPT_0x6E
	MOVW R0,R30
	CALL SUBOPT_0x92
	CALL SUBOPT_0x9B
; 0005 00B5         buf3 = state[buf4+1]^state[buf4+2]; buf3=galois_mul2(buf3); state[buf4+1] = state[buf4+1] ^ buf3 ^ buf1;
	CALL SUBOPT_0x97
	CALL SUBOPT_0x94
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x96
	ADIW R30,1
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x9B
; 0005 00B6         buf3 = state[buf4+2]^state[buf4+3]; buf3=galois_mul2(buf3); state[buf4+2] = state[buf4+2] ^ buf3 ^ buf1;
	MOVW R22,R30
	ADIW R30,2
	CALL SUBOPT_0x9D
	LD   R0,X
	MOVW R30,R22
	CALL SUBOPT_0x98
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x96
	ADIW R30,2
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x9B
; 0005 00B7         buf3 = state[buf4+3]^buf2;     buf3=galois_mul2(buf3); state[buf4+3] = state[buf4+3] ^ buf3 ^ buf1;
	CALL SUBOPT_0x98
	EOR  R30,R16
	MOV  R19,R30
	ST   -Y,R19
	RCALL _galois_mul2
	MOV  R19,R30
	CALL SUBOPT_0x96
	ADIW R30,3
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9D
	LD   R30,X
	EOR  R30,R19
	EOR  R30,R17
	MOVW R26,R0
	ST   X,R30
; 0005 00B8       }
	SUBI R20,-1
	RJMP _0xA0023
_0xA0024:
; 0005 00B9     }
; 0005 00BA 
; 0005 00BB     if (dir) {
_0xA001B:
	LDD  R30,Y+6
	CPI  R30,0
	BRNE PC+3
	JMP _0xA0026
; 0005 00BC       //Inv shift rows
; 0005 00BD       // Row 1
; 0005 00BE       buf1 = state[13];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,13
	LD   R17,X
; 0005 00BF       state[13] = state[9];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,9
	LD   R30,X
	__PUTB1SNS 9,13
; 0005 00C0       state[9] = state[5];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,5
	LD   R30,X
	__PUTB1SNS 9,9
; 0005 00C1       state[5] = state[1];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,1
	LD   R30,X
	__PUTB1SNS 9,5
; 0005 00C2       state[1] = buf1;
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__PUTBZR 17,1
; 0005 00C3       //Row 2
; 0005 00C4       buf1 = state[10];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,10
	LD   R17,X
; 0005 00C5       buf2 = state[14];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,14
	LD   R16,X
; 0005 00C6       state[10] = state[2];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,2
	LD   R30,X
	__PUTB1SNS 9,10
; 0005 00C7       state[14] = state[6];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,6
	LD   R30,X
	__PUTB1SNS 9,14
; 0005 00C8       state[2] = buf1;
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__PUTBZR 17,2
; 0005 00C9       state[6] = buf2;
	__PUTBZR 16,6
; 0005 00CA       //Row 3
; 0005 00CB       buf1 = state[3];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,3
	LD   R17,X
; 0005 00CC       state[3] = state[7];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,7
	LD   R30,X
	__PUTB1SNS 9,3
; 0005 00CD       state[7] = state[11];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,11
	LD   R30,X
	__PUTB1SNS 9,7
; 0005 00CE       state[11] = state[15];
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,15
	LD   R30,X
	__PUTB1SNS 9,11
; 0005 00CF       state[15] = buf1;
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__PUTBZR 17,15
; 0005 00D0 
; 0005 00D1       for (i = 0; i <16; i++){
	LDI  R20,LOW(0)
_0xA0028:
	CPI  R20,16
	BRSH _0xA0029
; 0005 00D2         // with shiftrow i+5 mod 16
; 0005 00D3         state[i]=rsbox[state[i]] ^ key[i];
	CALL SUBOPT_0x8D
	MOVW R22,R30
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CLR  R30
	ADD  R26,R20
	ADC  R27,R30
	CALL SUBOPT_0x91
	SUBI R30,LOW(-_rsbox)
	SBCI R31,HIGH(-_rsbox)
	LD   R0,Z
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x7F
; 0005 00D4       }
	SUBI R20,-1
	RJMP _0xA0028
_0xA0029:
; 0005 00D5     } else {
	RJMP _0xA002A
_0xA0026:
; 0005 00D6       //key schedule
; 0005 00D7       key[0] = sbox[key[13]]^key[0]^Rcon[round];
	CALL SUBOPT_0x89
	MOV  R26,R0
	EOR  R26,R30
	CALL SUBOPT_0x50
	CALL SUBOPT_0x8A
; 0005 00D8       key[1] = sbox[key[14]]^key[1];
; 0005 00D9       key[2] = sbox[key[15]]^key[2];
; 0005 00DA       key[3] = sbox[key[12]]^key[3];
; 0005 00DB       for (i=4; i<16; i++) {
_0xA002C:
	CPI  R20,16
	BRSH _0xA002D
; 0005 00DC         key[i] = key[i] ^ key[i-4];
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x8C
; 0005 00DD       }
	SUBI R20,-1
	RJMP _0xA002C
_0xA002D:
; 0005 00DE     }
_0xA002A:
; 0005 00DF   }
	SUBI R21,-1
	RJMP _0xA0011
_0xA0012:
; 0005 00E0   if (!dir) {
	LDD  R30,Y+6
	CPI  R30,0
	BRNE _0xA002E
; 0005 00E1   //last Addroundkey
; 0005 00E2     for (i = 0; i <16; i++){
	LDI  R20,LOW(0)
_0xA0030:
	CPI  R20,16
	BRSH _0xA0031
; 0005 00E3       // with shiftrow i+5 mod 16
; 0005 00E4       state[i]=state[i] ^ key[i];
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x7F
; 0005 00E5     } // enf for
	SUBI R20,-1
	RJMP _0xA0030
_0xA0031:
; 0005 00E6   } // end if (!dir)
; 0005 00E7 } // end function
_0xA002E:
	CALL __LOADLOCR6
	ADIW R28,11
	RET
;#include "Mesh_RF.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include "ME41_42.h"
;#include "math.h"
;#include "aes.h"
;unsigned char Rec_Password[64], Old_Data[64],  payload_rec[32];
;unsigned char ME41_42_PQ[4], ME41_42_UI[2], password_len;
;
;void Convert_ME41_42_PQ(unsigned char *in, unsigned char *out)
; 0006 0009 {

	.CSEG
_Convert_ME41_42_PQ:
; 0006 000A unsigned char s1=0, s2=0;
; 0006 000B int i;
; 0006 000C float m,s,E;
; 0006 000D float KQ,x1;
; 0006 000E float n1;
; 0006 000F unsigned long n;
; 0006 0010 // Tinh s, E
; 0006 0011 
; 0006 0012 s1=in[0]>>7;
	SBIW R28,28
	CALL __SAVELOCR4
;	*in -> Y+34
;	*out -> Y+32
;	s1 -> R17
;	s2 -> R16
;	i -> R18,R19
;	m -> Y+28
;	s -> Y+24
;	E -> Y+20
;	KQ -> Y+16
;	x1 -> Y+12
;	n1 -> Y+8
;	n -> Y+4
	LDI  R17,0
	LDI  R16,0
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	CALL SUBOPT_0x91
	CALL __ASRW3
	CALL __ASRW4
	MOV  R17,R30
; 0006 0013 if (in[0]==0x01)
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0xC0003
; 0006 0014 {
; 0006 0015         s=-1;
	__GETD1N 0xBF800000
	RJMP _0xC0095
; 0006 0016 }
; 0006 0017 else s=1;
_0xC0003:
	CALL SUBOPT_0x9E
_0xC0095:
	__PUTD1S 24
; 0006 0018 s2=(in[0]<<1)|(in[1]>>7);
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	LD   R30,X
	LSL  R30
	MOV  R0,R30
	ADIW R26,1
	CALL SUBOPT_0x91
	CALL __ASRW3
	CALL __ASRW4
	OR   R30,R0
	MOV  R16,R30
; 0006 0019 E=s2-127;
	CALL SUBOPT_0x51
	SUBI R30,LOW(127)
	SBCI R31,HIGH(127)
	CALL SUBOPT_0x9F
	__PUTD1S 20
; 0006 001A 
; 0006 001B m=1;
	CALL SUBOPT_0x9E
	__PUTD1S 28
; 0006 001C 
; 0006 001D for( i=-1;i+7>=0;i--)
	__GETWRN 18,19,-1
_0xC0006:
	MOVW R26,R18
	ADIW R26,7
	TST  R27
	BRMI _0xC0007
; 0006 001E {
; 0006 001F   char k=(in[1]>>(7+i))&0x01;
; 0006 0020   m=m+k*pow(2,i);
	SBIW R28,1
;	*in -> Y+35
;	*out -> Y+33
;	m -> Y+29
;	s -> Y+25
;	E -> Y+21
;	KQ -> Y+17
;	x1 -> Y+13
;	n1 -> Y+9
;	n -> Y+5
;	k -> Y+0
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	ADIW R26,1
	LD   R26,X
	CLR  R27
	MOV  R30,R18
	SUBI R30,-LOW(7)
	CALL SUBOPT_0xA0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA1
	POP  R26
	POP  R27
	CALL SUBOPT_0xA2
; 0006 0021 }
	__SUBWRN 18,19,1
	RJMP _0xC0006
_0xC0007:
; 0006 0022 for(i=-8;i+15>=0;i--)
	__GETWRN 18,19,-8
_0xC0009:
	MOVW R26,R18
	ADIW R26,15
	TST  R27
	BRMI _0xC000A
; 0006 0023 {
; 0006 0024   char k=(in[2]>>(15+i))&0x01;
; 0006 0025   m=m+k*pow(2,i);
	SBIW R28,1
;	*in -> Y+35
;	*out -> Y+33
;	m -> Y+29
;	s -> Y+25
;	E -> Y+21
;	KQ -> Y+17
;	x1 -> Y+13
;	n1 -> Y+9
;	n -> Y+5
;	k -> Y+0
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	ADIW R26,2
	LD   R26,X
	CLR  R27
	MOV  R30,R18
	SUBI R30,-LOW(15)
	CALL SUBOPT_0xA0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA1
	POP  R26
	POP  R27
	CALL SUBOPT_0xA2
; 0006 0026 }
	__SUBWRN 18,19,1
	RJMP _0xC0009
_0xC000A:
; 0006 0027 for( i=-16;i+23>=0;i--)
	__GETWRN 18,19,-16
_0xC000C:
	MOVW R26,R18
	ADIW R26,23
	TST  R27
	BRMI _0xC000D
; 0006 0028 {
; 0006 0029   char k=(in[3]>>(23+i))&0x01;
; 0006 002A   m=m+k*pow(2,i);
	SBIW R28,1
;	*in -> Y+35
;	*out -> Y+33
;	m -> Y+29
;	s -> Y+25
;	E -> Y+21
;	KQ -> Y+17
;	x1 -> Y+13
;	n1 -> Y+9
;	n -> Y+5
;	k -> Y+0
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	ADIW R26,3
	LD   R26,X
	CLR  R27
	MOV  R30,R18
	SUBI R30,-LOW(23)
	CALL SUBOPT_0xA0
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA1
	POP  R26
	POP  R27
	CALL SUBOPT_0xA2
; 0006 002B }
	__SUBWRN 18,19,1
	RJMP _0xC000C
_0xC000D:
; 0006 002C KQ=s*pow(2,E)*m;                 // Tinh float
	__GETD1N 0x40000000
	CALL __PUTPARD1
	__GETD1S 24
	CALL __PUTPARD1
	CALL _pow
	__GETD2S 24
	CALL __MULF12
	__GETD2S 28
	CALL __MULF12
	__PUTD1S 16
; 0006 002D // Chuyen float sang 4 byte
; 0006 002E  x1=KQ/1000;
	__GETD2S 16
	__GETD1N 0x447A0000
	CALL __DIVF21
	__PUTD1S 12
; 0006 002F 
; 0006 0030 out[0]=(unsigned char)(x1/10000); out[0]=((out[0]/10)<<4) + out[0]%10;
	__GETD2S 12
	__GETD1N 0x461C4000
	CALL __DIVF21
	CALL __CFD1U
	LDD  R26,Y+32
	LDD  R27,Y+32+1
	ST   X,R30
	CALL SUBOPT_0x91
	CALL SUBOPT_0xA3
	MOV  R22,R30
	LDD  R26,Y+32
	LDD  R27,Y+32+1
	CALL SUBOPT_0xA4
	LDD  R26,Y+32
	LDD  R27,Y+32+1
	ST   X,R30
; 0006 0031 n=(unsigned char)(x1);
	__GETD1S 12
	CALL __CFD1U
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 4
; 0006 0032 out[1]=(n%10000)/100;       out[1]=((out[1]/10)<<4) + out[1]%10;
	CALL SUBOPT_0xA5
	__GETD1N 0x2710
	CALL __MODD21U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x64
	CALL __DIVD21U
	__PUTB1SNS 32,1
	LDD  R26,Y+32
	LDD  R27,Y+32+1
	ADIW R26,1
	CALL SUBOPT_0x91
	CALL SUBOPT_0xA3
	MOV  R22,R30
	LDD  R26,Y+32
	LDD  R27,Y+32+1
	ADIW R26,1
	CALL SUBOPT_0xA4
	__PUTB1SNS 32,1
; 0006 0033 out[2]=(n%100);             out[2]=((out[2]/10)<<4) + out[2]%10;
	CALL SUBOPT_0xA5
	__GETD1N 0x64
	CALL __MODD21U
	__PUTB1SNS 32,2
	LDD  R26,Y+32
	LDD  R27,Y+32+1
	ADIW R26,2
	CALL SUBOPT_0x91
	CALL SUBOPT_0xA3
	MOV  R22,R30
	LDD  R26,Y+32
	LDD  R27,Y+32+1
	ADIW R26,2
	CALL SUBOPT_0xA4
	__PUTB1SNS 32,2
; 0006 0034 n1=(x1-n)*100;
	CALL SUBOPT_0xA6
	__GETD2S 12
	CALL __CDF1U
	CALL SUBOPT_0xA7
	__GETD2N 0x42C80000
	CALL __MULF12
	__PUTD1S 8
; 0006 0035 out[3]=(unsigned char)(n1);       out[3]=((out[3]/10)<<4) + out[3]%10;
	CALL SUBOPT_0xA8
	CALL __CFD1U
	__PUTB1SNS 32,3
	LDD  R26,Y+32
	LDD  R27,Y+32+1
	ADIW R26,3
	CALL SUBOPT_0x91
	CALL SUBOPT_0xA3
	MOV  R22,R30
	LDD  R26,Y+32
	LDD  R27,Y+32+1
	ADIW R26,3
	CALL SUBOPT_0xA4
	__PUTB1SNS 32,3
; 0006 0036 
; 0006 0037 }
	CALL __LOADLOCR4
	ADIW R28,36
	RET
;
;void Convert_ME41_42_UI(unsigned char *in, unsigned char *out)
; 0006 003A {
_Convert_ME41_42_UI:
; 0006 003B unsigned int temp0=0, temp1=0, p ;
; 0006 003C p =in[0]*256 + in[1];
	CALL __SAVELOCR6
;	*in -> Y+8
;	*out -> Y+6
;	temp0 -> R16,R17
;	temp1 -> R18,R19
;	p -> R20,R21
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X
	MOV  R31,R30
	LDI  R30,0
	MOVW R0,R30
	ADIW R26,1
	CALL SUBOPT_0x91
	ADD  R30,R0
	ADC  R31,R1
	MOVW R20,R30
; 0006 003D 
; 0006 003E out[0]=0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
; 0006 003F out[1]=p/(10000); temp0=p%(10000);  out[1]=((out[1]/10)<<4) + out[1]%10;
	MOVW R26,R20
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL __DIVW21U
	__PUTB1SNS 6,1
	MOVW R26,R20
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL __MODW21U
	MOVW R16,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	CALL SUBOPT_0x91
	CALL SUBOPT_0xA3
	MOV  R22,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	CALL SUBOPT_0xA4
	__PUTB1SNS 6,1
; 0006 0040 out[2]=temp0/(100);   temp1=temp0%(100);    out[2]=((out[2]/10)<<4) + out[2]%10;
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	__PUTB1SNS 6,2
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,2
	CALL SUBOPT_0x91
	CALL SUBOPT_0xA3
	MOV  R22,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,2
	CALL SUBOPT_0xA4
	__PUTB1SNS 6,2
; 0006 0041 out[3]=temp1;                               out[3]=((out[3]/10)<<4) + out[3]%10;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__PUTBZR 18,3
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,3
	CALL SUBOPT_0x91
	CALL SUBOPT_0xA3
	MOV  R22,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,3
	CALL SUBOPT_0xA4
	__PUTB1SNS 6,3
; 0006 0042 
; 0006 0043 
; 0006 0044 }
	CALL __LOADLOCR6
	JMP  _0x20A0004
;
;
;unsigned char Compare_Buffer(unsigned char *in1, unsigned char *in2, unsigned char len)
; 0006 0048 {
_Compare_Buffer:
; 0006 0049 unsigned char i, k = 0;
; 0006 004A for(i=0; i<len; i++)
	ST   -Y,R17
	ST   -Y,R16
;	*in1 -> Y+5
;	*in2 -> Y+3
;	len -> Y+2
;	i -> R17
;	k -> R16
	LDI  R16,0
	LDI  R17,LOW(0)
_0xC000F:
	LDD  R30,Y+2
	CP   R17,R30
	BRSH _0xC0010
; 0006 004B {
; 0006 004C if(in1[i] == in2[i]) {k++;}
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R0,X
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CP   R30,R0
	BRNE _0xC0011
	SUBI R16,-1
; 0006 004D }
_0xC0011:
	SUBI R17,-1
	RJMP _0xC000F
_0xC0010:
; 0006 004E 
; 0006 004F if(k==len)
	LDD  R30,Y+2
	CP   R30,R16
	BRNE _0xC0012
; 0006 0050 {return 1;}
	LDI  R30,LOW(1)
	RJMP _0x20A0006
; 0006 0051 else
_0xC0012:
; 0006 0052 {return 0;}
	LDI  R30,LOW(0)
	RJMP _0x20A0006
; 0006 0053 }
;
;void Clear_Data(unsigned char *in, unsigned char len)
; 0006 0056 {
_Clear_Data:
; 0006 0057 unsigned char i;
; 0006 0058 for(i=0;i<len;i++)
	ST   -Y,R17
;	*in -> Y+2
;	len -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0xC0015:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0xC0016
; 0006 0059    {in[i] = 0x00;}
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	ST   X,R30
	SUBI R17,-1
	RJMP _0xC0015
_0xC0016:
; 0006 005A }
	LDD  R17,Y+0
	JMP  _0x20A0005
;
;
;void Frame_Send_Password(unsigned char Sq_Num, unsigned char type)
; 0006 005E {
_Frame_Send_Password:
; 0006 005F    unsigned int CRC_CC1101;
; 0006 0060 unsigned char tran_password1[46] = {
; 0006 0061 0x42, 0x0D, 0x29, 0xE0, 0x3E, 0x7A, 0x37, 0xEB, 0x98, 0xB1, 0x65, 0x07, 0x37, 0x8B, 0x2C, 0x7C,
; 0006 0062 0xFD, 0xD8, 0x56, 0x9E, 0x2C, 0xB8, 0x4F, 0x06, 0x9F, 0x24, 0xD0, 0xBF, 0xBC, 0x41, 0xE9, 0x1C,
; 0006 0063 0x91, 0xBF, 0x29, 0xB2, 0xED, 0x3F, 0x04, 0xEF, 0xC3, 0x6D, 0x4E, 0x10, 0x4E, 0xA0};
; 0006 0064 
; 0006 0065 unsigned char i, tran_password2[34] = {  0x92, 0xEB,
; 0006 0066 0x28, 0x18, 0x3D, 0x67, 0x4A, 0x15, 0x2F, 0x81, 0xB7, 0x3B, 0x16, 0x1C, 0x00, 0x63, 0x0B, 0xBE,
; 0006 0067 0x07, 0x19, 0xEA, 0x81, 0xFF, 0x1E, 0x66, 0x23, 0x52, 0x25, 0x9B, 0x6D, 0x39, 0x90, 0x59, 0x97};
; 0006 0068     if(type == 1)
	SBIW R28,63
	SBIW R28,17
	LDI  R24,80
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xC0017*2)
	LDI  R31,HIGH(_0xC0017*2)
	CALL __INITLOCB
	CALL __SAVELOCR4
;	Sq_Num -> Y+85
;	type -> Y+84
;	CRC_CC1101 -> R16,R17
;	tran_password1 -> Y+38
;	i -> R19
;	tran_password2 -> Y+4
	__GETB2SX 84
	CPI  R26,LOW(0x1)
	BRNE _0xC0018
; 0006 0069     {
; 0006 006A       RF_buffer[0]=60; //length byte
	LDI  R30,LOW(60)
	STS  _RF_buffer,R30
; 0006 006B 
; 0006 006C       RF_buffer[1]=0x6A;
	LDI  R30,LOW(106)
	CALL SUBOPT_0xA9
; 0006 006D       RF_buffer[2]=Sq_Num;
; 0006 006E       RF_buffer[3]=HHU_ID1;//HHU ID
; 0006 006F       RF_buffer[4]=HHU_ID0;//HHU ID
; 0006 0070       RF_buffer[5]=0xFF;
; 0006 0071       RF_buffer[6]=0xFA;
; 0006 0072       RF_buffer[7]=HHU_ID1;
	CALL SUBOPT_0x69
; 0006 0073       RF_buffer[8]=HHU_ID0;
; 0006 0074       RF_buffer[9]=0x00;
; 0006 0075       RF_buffer[10]=0x00;
; 0006 0076       RF_buffer[11]=0x00;
; 0006 0077       RF_buffer[12]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _RF_buffer,12
; 0006 0078       RF_buffer[13]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _RF_buffer,13
; 0006 0079       RF_buffer[14]=0x2e;
	LDI  R30,LOW(46)
	__PUTB1MN _RF_buffer,14
; 0006 007A 
; 0006 007B      for(i=0;i<0x2e;i++){RF_buffer[i+15] = tran_password1[i];}
	LDI  R19,LOW(0)
_0xC001A:
	CPI  R19,46
	BRSH _0xC001B
	MOV  R30,R19
	CALL SUBOPT_0xAA
	__ADDW1MN _RF_buffer,15
	MOVW R0,R30
	MOVW R30,R26
	MOVW R26,R28
	ADIW R26,38
	CALL SUBOPT_0x6C
	SUBI R19,-1
	RJMP _0xC001A
_0xC001B:
; 0006 007C        //2 byte crc
; 0006 007D        CRC_CC1101=CRC16CC1101_Buff(RF_buffer,RF_buffer[0]+1);
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x57
; 0006 007E        RF_buffer[61]=(unsigned char)(CRC_CC1101>>8);
	__PUTBMRN _RF_buffer,61,17
; 0006 007F        RF_buffer[62]=(unsigned char)(CRC_CC1101&0x00FF);
	MOV  R30,R16
	__PUTB1MN _RF_buffer,62
; 0006 0080     }
; 0006 0081 
; 0006 0082     if(type == 2)
_0xC0018:
	__GETB2SX 84
	CPI  R26,LOW(0x2)
	BRNE _0xC001C
; 0006 0083     {
; 0006 0084       RF_buffer[0]=46; //length byte
	LDI  R30,LOW(46)
	STS  _RF_buffer,R30
; 0006 0085 
; 0006 0086       RF_buffer[1]=0x4A;
	LDI  R30,LOW(74)
	CALL SUBOPT_0xA9
; 0006 0087       RF_buffer[2]=Sq_Num;
; 0006 0088       RF_buffer[3]=HHU_ID1;//HHU ID
; 0006 0089       RF_buffer[4]=HHU_ID0;//HHU ID
; 0006 008A       RF_buffer[5]=0xFF;
; 0006 008B       RF_buffer[6]=0xFA;
; 0006 008C       RF_buffer[7]=HHU_ID1;
	LDS  R30,_HHU_ID1
	__PUTB1MN _RF_buffer,7
; 0006 008D       RF_buffer[8]=HHU_ID0;
	LDS  R30,_HHU_ID0
	__PUTB1MN _RF_buffer,8
; 0006 008E       RF_buffer[9]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _RF_buffer,9
; 0006 008F       RF_buffer[10]=0x00;
	__PUTB1MN _RF_buffer,10
; 0006 0090       RF_buffer[11]=0x01;// gui form password laan 0x01(+1)
	LDI  R30,LOW(1)
	__PUTB1MN _RF_buffer,11
; 0006 0091       RF_buffer[12]=0x22;
	LDI  R30,LOW(34)
	__PUTB1MN _RF_buffer,12
; 0006 0092 
; 0006 0093 
; 0006 0094      for(i=0;i<0x22;i++){RF_buffer[i+13] = tran_password2[i];}
	LDI  R19,LOW(0)
_0xC001E:
	CPI  R19,34
	BRSH _0xC001F
	MOV  R30,R19
	CALL SUBOPT_0xAA
	__ADDW1MN _RF_buffer,13
	MOVW R0,R30
	MOVW R30,R26
	MOVW R26,R28
	ADIW R26,4
	CALL SUBOPT_0x6C
	SUBI R19,-1
	RJMP _0xC001E
_0xC001F:
; 0006 0095        //2 byte crc
; 0006 0096        CRC_CC1101=CRC16CC1101_Buff(RF_buffer,RF_buffer[0]+1);
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x57
; 0006 0097        RF_buffer[47]=(unsigned char)(CRC_CC1101>>8);
	__PUTBMRN _RF_buffer,47,17
; 0006 0098        RF_buffer[48]=(unsigned char)(CRC_CC1101&0x00FF);
	MOV  R30,R16
	__PUTB1MN _RF_buffer,48
; 0006 0099     }
; 0006 009A 
; 0006 009B }
_0xC001C:
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,23
	RET
;
;void RF_Send_Password(unsigned char Sq_Num, unsigned char Channel_num, unsigned char type)
; 0006 009E {
_RF_Send_Password:
; 0006 009F     LED_Red();
;	Sq_Num -> Y+2
;	Channel_num -> Y+1
;	type -> Y+0
	CALL SUBOPT_0x6A
; 0006 00A0     Frame_Send_Password(Sq_Num, type);
	RCALL _Frame_Send_Password
; 0006 00A1     idle_mode_PA();
	CALL SUBOPT_0x59
; 0006 00A2     Strobes_Comm(SIDLE);
; 0006 00A3     write_Reg(PKTLEN,RF_buffer[0]+3);         // Datalength+1+2: 1 byte Leng, 2 byte CRC
	CALL SUBOPT_0x5A
; 0006 00A4      delay_ms(50);
	CALL SUBOPT_0x6B
; 0006 00A5 
; 0006 00A6     Mesh_RF_Send(RF_buffer, RF_buffer[0]+3);//send data
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x5C
; 0006 00A7     delay_ms(50);
	CALL SUBOPT_0x6B
; 0006 00A8     Mesh_RF_Send(RF_buffer, RF_buffer[0]+3);//send data
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x5C
; 0006 00A9     delay_ms(50);
	CALL SUBOPT_0x6B
; 0006 00AA     Mesh_RF_Send(RF_buffer, RF_buffer[0]+3);//send data
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x5C
; 0006 00AB     delay_ms(50);
	CALL SUBOPT_0x6B
; 0006 00AC 
; 0006 00AD 
; 0006 00AE 
; 0006 00AF     rx_wr_index1=0;
	CLR  R7
; 0006 00B0     rx_counter1=0;
	CLR  R6
; 0006 00B1 
; 0006 00B2 }
	ADIW R28,3
	RET
;
;unsigned char ProcessRF_Password(void)
; 0006 00B5 {
_ProcessRF_Password:
; 0006 00B6 unsigned char check_longpassword[64] = {
; 0006 00B7 0xFB, 0x4D, 0x0E, 0xBE, 0x37, 0x0C, 0xDE, 0xA1, 0x88, 0x06, 0x5F, 0x92, 0x24, 0x5A, 0x74, 0x1B,
; 0006 00B8 0x07, 0xA5, 0xB4, 0x84, 0x74, 0xD7, 0x01, 0x42, 0xD4, 0x96, 0x09, 0xD7, 0x06, 0xDA, 0x08, 0xE3,
; 0006 00B9 0x9A, 0x24, 0xEA, 0x96, 0xD4, 0x25, 0x23, 0xAB, 0x77, 0x92, 0x5E, 0x3C, 0x1E, 0x02, 0xC9, 0x50,
; 0006 00BA 0x13, 0x3B, 0x75, 0x31, 0xBC, 0x9C, 0x7E, 0xD3, 0xEC, 0x66, 0x9A, 0x41, 0x9E, 0xAF, 0x39, 0x95};
; 0006 00BB 
; 0006 00BC 
; 0006 00BD unsigned char check_shortpassword[16] = {0x9E, 0x03, 0x63, 0xB3, 0x44, 0x40, 0xCA, 0x32, 0xA8, 0x6E, 0x47, 0x8F, 0x76, 0xFB, 0x11, 0x43};
; 0006 00BE 
; 0006 00BF unsigned int crc_byte ;
; 0006 00C0 unsigned char crc_byte_hi,crc_byte_low, seen=0, it;
; 0006 00C1 uchar buf[64];
; 0006 00C2 uchar length=64;
; 0006 00C3 uchar FormOK = 0;
; 0006 00C4 
; 0006 00C5 //#ifdef Send_Log_Option
; 0006 00C6 //    unsigned char i;
; 0006 00C7 //#endif
; 0006 00C8 
; 0006 00C9 RF_Recieve(buf,&length);
	SBIW R28,63
	SBIW R28,63
	SBIW R28,20
	LDI  R24,146
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xC0020*2)
	LDI  R31,HIGH(_0xC0020*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	check_longpassword -> Y+88
;	check_shortpassword -> Y+72
;	crc_byte -> R16,R17
;	crc_byte_hi -> R19
;	crc_byte_low -> R18
;	seen -> R21
;	it -> R20
;	buf -> Y+8
;	length -> Y+7
;	FormOK -> Y+6
	LDI  R21,0
	CALL SUBOPT_0x4B
	MOVW R30,R28
	ADIW R30,9
	ST   -Y,R31
	ST   -Y,R30
	CALL _RF_Recieve
; 0006 00CA 
; 0006 00CB if(Compare_Buffer(Old_Data, buf, buf[0])){seen=1;}
	LDI  R30,LOW(_Old_Data)
	LDI  R31,HIGH(_Old_Data)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+12
	CALL SUBOPT_0xAB
	BREQ _0xC0021
	LDI  R21,LOW(1)
; 0006 00CC 
; 0006 00CD password_len = 0;
_0xC0021:
	LDI  R30,LOW(0)
	STS  _password_len,R30
; 0006 00CE Signal_RSSI=read_Reg(0xF4);//
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x71
; 0006 00CF 
; 0006 00D0 idle_mode_PA();
; 0006 00D1 Strobes_Comm(SIDLE);
; 0006 00D2 //Strobes_Comm(SFTX);
; 0006 00D3 Strobes_Comm(SFRX);
; 0006 00D4 Strobes_Comm(SPWD);
	CALL SUBOPT_0xF
; 0006 00D5 
; 0006 00D6 
; 0006 00D7 if( (buf[0]==60) &&(buf[1]==0xEA)&&(buf[5]==0xFF)&&(buf[6]==0xFA)&&(buf[2]== 0x02)&&(seen==0))    //leng, header,seq
	LDD  R26,Y+8
	CPI  R26,LOW(0x3C)
	BRNE _0xC0023
	LDD  R26,Y+9
	CPI  R26,LOW(0xEA)
	BRNE _0xC0023
	LDD  R26,Y+13
	CPI  R26,LOW(0xFF)
	BRNE _0xC0023
	LDD  R26,Y+14
	CPI  R26,LOW(0xFA)
	BRNE _0xC0023
	LDD  R26,Y+10
	CPI  R26,LOW(0x2)
	BRNE _0xC0023
	CPI  R21,0
	BREQ _0xC0024
_0xC0023:
	RJMP _0xC0022
_0xC0024:
; 0006 00D8 {
; 0006 00D9     for(it=0;it<buf[0];it++){Old_Data[it] = buf[it];}
	LDI  R20,LOW(0)
_0xC0026:
	LDD  R30,Y+8
	CP   R20,R30
	BRSH _0xC0027
	MOV  R30,R20
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xAC
	SUBI R20,-1
	RJMP _0xC0026
_0xC0027:
; 0006 00DA     crc_byte=CRC16CC1101_Buff(buf,buf[0]+1);
	CALL SUBOPT_0x4B
	LDD  R30,Y+10
	CALL SUBOPT_0x5F
; 0006 00DB     crc_byte_hi=(unsigned char)(crc_byte>>8);
; 0006 00DC     crc_byte_low=(unsigned char)(crc_byte&0x00FF);
; 0006 00DD     if((buf[61]==crc_byte_hi)&&(buf[62]==crc_byte_low)) //check CRC
	__GETB2SX 69
	CP   R19,R26
	BRNE _0xC0029
	__GETB2SX 70
	CP   R18,R26
	BREQ _0xC002A
_0xC0029:
	RJMP _0xC0028
_0xC002A:
; 0006 00DE     {
; 0006 00DF         if((buf[3]==HHU_ID1) && (buf[4]==HHU_ID0)&&(buf[9]==HHU_ID1) && (buf[10]==HHU_ID0) && (buf[13]==0x00))   //check HHU ID
	CALL SUBOPT_0xAD
	BRNE _0xC002C
	CALL SUBOPT_0xAE
	BRNE _0xC002C
	CALL SUBOPT_0xAF
	BRNE _0xC002C
	CALL SUBOPT_0xB0
	BRNE _0xC002C
	LDD  R26,Y+21
	CPI  R26,LOW(0x0)
	BREQ _0xC002D
_0xC002C:
	RJMP _0xC002B
_0xC002D:
; 0006 00E0         {
; 0006 00E1 
; 0006 00E2             for(it=0;it<46;it++) {Rec_Password[it]=buf[it+15];}
	LDI  R20,LOW(0)
_0xC002F:
	CPI  R20,46
	BRSH _0xC0030
	MOV  R30,R20
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xB1
	SUBI R20,-1
	RJMP _0xC002F
_0xC0030:
; 0006 00E3 
; 0006 00E4             FormOK=1;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0006 00E5             //---------------------
; 0006 00E6 //            #ifdef Send_Log_Option
; 0006 00E7 //                    //load to Datalog RF: du lieu tho bao gom ca 2 byte CRC RF
; 0006 00E8 //                    for(i=0;i<49;i++)
; 0006 00E9 //                    {
; 0006 00EA //                       Data_Log_RF_Buff[i]=buf[i];
; 0006 00EB //                    }
; 0006 00EC //                    //Du lieu sau giai ma, ko bao gom 2 byte CRC RF
; 0006 00ED //
; 0006 00EE //                    for(i=0;i<15;i++)
; 0006 00EF //                    {
; 0006 00F0 //                       Data_Log_RF_After_Dec_Buff[i]=buf[i];
; 0006 00F1 //                    }
; 0006 00F2 //                    for(i=0;i<32;i++)
; 0006 00F3 //                    {
; 0006 00F4 //                       Data_Log_RF_After_Dec_Buff[i+15]=Payload_Buff[i];
; 0006 00F5 //                    }
; 0006 00F6 //            #endif
; 0006 00F7             //---------------------
; 0006 00F8 
; 0006 00F9         }
; 0006 00FA 
; 0006 00FB     }
_0xC002B:
; 0006 00FC 
; 0006 00FD }
_0xC0028:
; 0006 00FE 
; 0006 00FF 
; 0006 0100 
; 0006 0101 
; 0006 0102 if( (buf[0]==30) &&(buf[1]==0xCA)&&(buf[5]==0xFF)&&(buf[6]==0xFA)&&buf[2]== 0x03)    //leng, header,seq
_0xC0022:
	LDD  R26,Y+8
	CPI  R26,LOW(0x1E)
	BRNE _0xC0032
	LDD  R26,Y+9
	CPI  R26,LOW(0xCA)
	BRNE _0xC0032
	LDD  R26,Y+13
	CPI  R26,LOW(0xFF)
	BRNE _0xC0032
	LDD  R26,Y+14
	CPI  R26,LOW(0xFA)
	BRNE _0xC0032
	LDD  R26,Y+10
	CPI  R26,LOW(0x3)
	BREQ _0xC0033
_0xC0032:
	RJMP _0xC0031
_0xC0033:
; 0006 0103 {
; 0006 0104 
; 0006 0105     crc_byte=CRC16CC1101_Buff(buf,buf[0]+1);
	CALL SUBOPT_0x4B
	LDD  R30,Y+10
	CALL SUBOPT_0x5F
; 0006 0106     crc_byte_hi=(unsigned char)(crc_byte>>8);
; 0006 0107     crc_byte_low=(unsigned char)(crc_byte&0x00FF);
; 0006 0108     if( (buf[31]==crc_byte_hi)&&(buf[31]==crc_byte_low)) //check CRC
	LDD  R26,Y+39
	CP   R19,R26
	BRNE _0xC0035
	CP   R18,R26
	BREQ _0xC0036
_0xC0035:
	RJMP _0xC0034
_0xC0036:
; 0006 0109     {
; 0006 010A         if((buf[3]==HHU_ID1) && (buf[4]==HHU_ID0) && (buf[9]==HHU_ID1) && (buf[10]==HHU_ID0) && (buf[11]==0x01))   //check HHU ID
	CALL SUBOPT_0xAD
	BRNE _0xC0038
	CALL SUBOPT_0xAE
	BRNE _0xC0038
	CALL SUBOPT_0xAF
	BRNE _0xC0038
	CALL SUBOPT_0xB0
	BRNE _0xC0038
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BREQ _0xC0039
_0xC0038:
	RJMP _0xC0037
_0xC0039:
; 0006 010B         {
; 0006 010C             for(it=0;it<18;it++) {Rec_Password[46+it]=buf[13+it];}
	LDI  R20,LOW(0)
_0xC003B:
	CPI  R20,18
	BRSH _0xC003C
	MOV  R30,R20
	CALL SUBOPT_0xAA
	__ADDW1MN _Rec_Password,46
	MOVW R0,R30
	MOVW R30,R26
	ADIW R30,13
	CALL SUBOPT_0x52
	SUBI R20,-1
	RJMP _0xC003B
_0xC003C:
; 0006 010D             if(Compare_Buffer(Rec_Password, check_longpassword, 64))
	LDI  R30,LOW(_Rec_Password)
	LDI  R31,HIGH(_Rec_Password)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(90))
	SBCI R31,HIGH(-(90))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(64)
	CALL SUBOPT_0xAB
	BREQ _0xC003D
; 0006 010E              {
; 0006 010F                  password_len = LONG_PASSWORD;
	LDI  R30,LOW(3)
	CALL SUBOPT_0xB2
; 0006 0110                  FormOK=2;
; 0006 0111                  CC1101_ReInit();//goto sleep mode
; 0006 0112             }
; 0006 0113             //---------------------
; 0006 0114 //            #ifdef Send_Log_Option
; 0006 0115 //                    //load to Datalog RF: du lieu tho bao gom ca 2 byte CRC RF
; 0006 0116 //                    for(i=0;i<49;i++)
; 0006 0117 //                    {
; 0006 0118 //                       Data_Log_RF_Buff[i]=buf[i];
; 0006 0119 //                    }
; 0006 011A //                    //Du lieu sau giai ma, ko bao gom 2 byte CRC RF
; 0006 011B //
; 0006 011C //                    for(i=0;i<15;i++)
; 0006 011D //                    {
; 0006 011E //                       Data_Log_RF_After_Dec_Buff[i]=buf[i];
; 0006 011F //                    }
; 0006 0120 //                    for(i=0;i<32;i++)
; 0006 0121 //                    {
; 0006 0122 //                       Data_Log_RF_After_Dec_Buff[i+15]=Payload_Buff[i];
; 0006 0123 //                    }
; 0006 0124 //            #endif
; 0006 0125             //---------------------
; 0006 0126 
; 0006 0127         }
_0xC003D:
; 0006 0128 
; 0006 0129     }
_0xC0037:
; 0006 012A 
; 0006 012B }
_0xC0034:
; 0006 012C 
; 0006 012D if( (buf[0]==30) &&(buf[1]==0xEA)&&(buf[5]==0xFF)&&(buf[6]==0xFA)&&(buf[2]== 0x02)&&(seen==0))    //leng, header,seq
_0xC0031:
	LDD  R26,Y+8
	CPI  R26,LOW(0x1E)
	BRNE _0xC003F
	LDD  R26,Y+9
	CPI  R26,LOW(0xEA)
	BRNE _0xC003F
	LDD  R26,Y+13
	CPI  R26,LOW(0xFF)
	BRNE _0xC003F
	LDD  R26,Y+14
	CPI  R26,LOW(0xFA)
	BRNE _0xC003F
	LDD  R26,Y+10
	CPI  R26,LOW(0x2)
	BRNE _0xC003F
	CPI  R21,0
	BREQ _0xC0040
_0xC003F:
	RJMP _0xC003E
_0xC0040:
; 0006 012E {
; 0006 012F     for(it=0;it<buf[0];it++){Old_Data[it] = buf[it];}
	LDI  R20,LOW(0)
_0xC0042:
	LDD  R30,Y+8
	CP   R20,R30
	BRSH _0xC0043
	MOV  R30,R20
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xAC
	SUBI R20,-1
	RJMP _0xC0042
_0xC0043:
; 0006 0130     crc_byte=CRC16CC1101_Buff(buf,buf[0]+1);
	CALL SUBOPT_0x4B
	LDD  R30,Y+10
	CALL SUBOPT_0x5F
; 0006 0131     crc_byte_hi=(unsigned char)(crc_byte>>8);
; 0006 0132     crc_byte_low=(unsigned char)(crc_byte&0x00FF);
; 0006 0133     if( (buf[31]==crc_byte_hi)&&(buf[32]==crc_byte_low)) //check CRC
	LDD  R26,Y+39
	CP   R19,R26
	BRNE _0xC0045
	LDD  R26,Y+40
	CP   R18,R26
	BREQ _0xC0046
_0xC0045:
	RJMP _0xC0044
_0xC0046:
; 0006 0134     {
; 0006 0135         if((buf[3]==HHU_ID1) && (buf[4]==HHU_ID0)&&(buf[9]==HHU_ID1) && (buf[10]==HHU_ID0) && (buf[13]==0x00))   //check HHU ID
	CALL SUBOPT_0xAD
	BRNE _0xC0048
	CALL SUBOPT_0xAE
	BRNE _0xC0048
	CALL SUBOPT_0xAF
	BRNE _0xC0048
	CALL SUBOPT_0xB0
	BRNE _0xC0048
	LDD  R26,Y+21
	CPI  R26,LOW(0x0)
	BREQ _0xC0049
_0xC0048:
	RJMP _0xC0047
_0xC0049:
; 0006 0136         {
; 0006 0137 
; 0006 0138             for(it=0;it<16;it++) {Rec_Password[it]=buf[it+15];}
	LDI  R20,LOW(0)
_0xC004B:
	CPI  R20,16
	BRSH _0xC004C
	MOV  R30,R20
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xB1
	SUBI R20,-1
	RJMP _0xC004B
_0xC004C:
; 0006 0139 
; 0006 013A             if(Compare_Buffer(Rec_Password, check_shortpassword, 16))
	LDI  R30,LOW(_Rec_Password)
	LDI  R31,HIGH(_Rec_Password)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(74))
	SBCI R31,HIGH(-(74))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	CALL SUBOPT_0xAB
	BREQ _0xC004D
; 0006 013B              {
; 0006 013C                   password_len = SHORT_PASSWORD;
	LDI  R30,LOW(2)
	CALL SUBOPT_0xB2
; 0006 013D                  FormOK=2;
; 0006 013E                  CC1101_ReInit();//goto sleep mode
; 0006 013F              }
; 0006 0140             //---------------------
; 0006 0141 //            #ifdef Send_Log_Option
; 0006 0142 //                    //load to Datalog RF: du lieu tho bao gom ca 2 byte CRC RF
; 0006 0143 //                    for(i=0;i<49;i++)
; 0006 0144 //                    {
; 0006 0145 //                       Data_Log_RF_Buff[i]=buf[i];
; 0006 0146 //                    }
; 0006 0147 //                    //Du lieu sau giai ma, ko bao gom 2 byte CRC RF
; 0006 0148 //
; 0006 0149 //                    for(i=0;i<15;i++)
; 0006 014A //                    {
; 0006 014B //                       Data_Log_RF_After_Dec_Buff[i]=buf[i];
; 0006 014C //                    }
; 0006 014D //                    for(i=0;i<32;i++)
; 0006 014E //                    {
; 0006 014F //                       Data_Log_RF_After_Dec_Buff[i+15]=Payload_Buff[i];
; 0006 0150 //                    }
; 0006 0151 //            #endif
; 0006 0152             //---------------------
; 0006 0153 
; 0006 0154         }
_0xC004D:
; 0006 0155 
; 0006 0156     }
_0xC0047:
; 0006 0157 
; 0006 0158 }
_0xC0044:
; 0006 0159 
; 0006 015A 
; 0006 015B 
; 0006 015C     LED_Off();
_0xC003E:
	CALL _LED_Off
; 0006 015D 
; 0006 015E     if(FormOK !=2)
	LDD  R26,Y+6
	CPI  R26,LOW(0x2)
	BREQ _0xC004E
; 0006 015F     {
; 0006 0160         To_Process_WaitRF();// goto RX mode
	CALL _To_Process_WaitRF
; 0006 0161         return FormOK;
	LDD  R30,Y+6
	RJMP _0x20A0008
; 0006 0162     }
; 0006 0163     else return 0;
_0xC004E:
	LDI  R30,LOW(0)
; 0006 0164 
; 0006 0165 }
_0x20A0008:
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,63
	ADIW R28,26
	RET
;
;
;
;//-------------------------------------------------------------------------------------
;unsigned char ProcessRF_Read_ME41_42(void)
; 0006 016B {
_ProcessRF_Read_ME41_42:
; 0006 016C         unsigned int crc_byte;
; 0006 016D         unsigned char crc_byte_hi,crc_byte_low;
; 0006 016E         uchar buf[64];
; 0006 016F         uchar length=64;
; 0006 0170         uchar FormOK = 0;
; 0006 0171         unsigned char AES_Payload_Buff[32];
; 0006 0172         #ifdef Send_Log_Option
; 0006 0173             unsigned char i;
; 0006 0174         #endif
; 0006 0175 
; 0006 0176         RF_Recieve(buf,&length);
	SBIW R28,63
	SBIW R28,33
	CALL SUBOPT_0x5D
;	crc_byte -> R16,R17
;	crc_byte_hi -> R19
;	crc_byte_low -> R18
;	buf -> Y+38
;	length -> R21
;	FormOK -> R20
;	AES_Payload_Buff -> Y+6
	CALL SUBOPT_0x70
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL _RF_Recieve
	POP  R21
; 0006 0177         Signal_RSSI=read_Reg(0xF4);//
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x71
; 0006 0178 
; 0006 0179         idle_mode_PA();
; 0006 017A         Strobes_Comm(SIDLE);
; 0006 017B         //Strobes_Comm(SFTX);
; 0006 017C         Strobes_Comm(SFRX);
; 0006 017D         Strobes_Comm(SPWD);
	CALL SUBOPT_0xF
; 0006 017E 
; 0006 017F         if( (buf[0]==46) &&(buf[1]==0xEA)&&(buf[5]==0xFF)&&(buf[6]==0xFA)&&(buf[2]==0x04))    //leng, header
	LDD  R26,Y+38
	CPI  R26,LOW(0x2E)
	BRNE _0xC0051
	LDD  R26,Y+39
	CPI  R26,LOW(0xEA)
	BRNE _0xC0051
	LDD  R26,Y+43
	CPI  R26,LOW(0xFF)
	BRNE _0xC0051
	LDD  R26,Y+44
	CPI  R26,LOW(0xFA)
	BRNE _0xC0051
	LDD  R26,Y+40
	CPI  R26,LOW(0x4)
	BREQ _0xC0052
_0xC0051:
	RJMP _0xC0050
_0xC0052:
; 0006 0180         {
; 0006 0181 
; 0006 0182             crc_byte=CRC16CC1101_Buff(buf,buf[0]+1);
	CALL SUBOPT_0x70
	LDD  R30,Y+40
	CALL SUBOPT_0x5F
; 0006 0183             crc_byte_hi=(unsigned char)(crc_byte>>8);
; 0006 0184             crc_byte_low=(unsigned char)(crc_byte&0x00FF);
; 0006 0185             if( (buf[47]==crc_byte_hi)&&(buf[48]==crc_byte_low)) //check CRC
	__GETB2SX 85
	CP   R19,R26
	BRNE _0xC0054
	__GETB2SX 86
	CP   R18,R26
	BREQ _0xC0055
_0xC0054:
	RJMP _0xC0053
_0xC0055:
; 0006 0186             {
; 0006 0187                 if((buf[3]==HHU_ID1) && (buf[4]==HHU_ID0)&&(buf[9]==HHU_ID1) && (buf[10]==HHU_ID0))   //check HHU ID
	LDS  R30,_HHU_ID1
	LDD  R26,Y+41
	CP   R30,R26
	BRNE _0xC0057
	LDS  R30,_HHU_ID0
	LDD  R26,Y+42
	CP   R30,R26
	BRNE _0xC0057
	LDS  R30,_HHU_ID1
	LDD  R26,Y+47
	CP   R30,R26
	BRNE _0xC0057
	LDS  R30,_HHU_ID0
	LDD  R26,Y+48
	CP   R30,R26
	BREQ _0xC0058
_0xC0057:
	RJMP _0xC0056
_0xC0058:
; 0006 0188                 {
; 0006 0189 
; 0006 018A                     Get_Payload(buf,AES_Payload_Buff);//lay pay_load tu form RF RX
	CALL SUBOPT_0x70
	CALL SUBOPT_0x4B
	CALL _Get_Payload
; 0006 018B                     aes_decrypt(AES_Payload_Buff, payload_rec, 32, 0, 0);
	CALL SUBOPT_0x5E
	LDI  R30,LOW(_payload_rec)
	LDI  R31,HIGH(_payload_rec)
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x67
	ST   -Y,R31
	ST   -Y,R30
	CALL _aes_decrypt
; 0006 018C                     //Frame_RS232_ME41_42(Command_ID);
; 0006 018D                         FormOK=1;
	LDI  R20,LOW(1)
; 0006 018E                         //---------------------
; 0006 018F                         #ifdef Send_Log_Option
; 0006 0190                                 //load to Datalog RF: du lieu tho bao gom ca 2 byte CRC RF
; 0006 0191                                 for(i=0;i<49;i++)
; 0006 0192                                 {
; 0006 0193                                    Data_Log_RF_Buff[i]=buf[i];
; 0006 0194                                 }
; 0006 0195                                 //Du lieu sau giai ma, ko bao gom 2 byte CRC RF
; 0006 0196 
; 0006 0197                                 for(i=0;i<15;i++)
; 0006 0198                                 {
; 0006 0199                                    Data_Log_RF_After_Dec_Buff[i]=buf[i];
; 0006 019A                                 }
; 0006 019B                                 for(i=0;i<32;i++)
; 0006 019C                                 {
; 0006 019D                                    Data_Log_RF_After_Dec_Buff[i+15]=Payload_Buff[i];
; 0006 019E                                 }
; 0006 019F                         #endif
; 0006 01A0                         //---------------------
; 0006 01A1 
; 0006 01A2 
; 0006 01A3                 }
; 0006 01A4 
; 0006 01A5             }
_0xC0056:
; 0006 01A6         }
_0xC0053:
; 0006 01A7 
; 0006 01A8 
; 0006 01A9         //
; 0006 01AA         LED_Off();
_0xC0050:
	CALL _LED_Off
; 0006 01AB 
; 0006 01AC         if(!FormOK)
	CPI  R20,0
	BRNE _0xC0059
; 0006 01AD         {
; 0006 01AE 
; 0006 01AF                 To_Process_WaitRF();// goto RX mode
	CALL _To_Process_WaitRF
; 0006 01B0                 return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A0007
; 0006 01B1 
; 0006 01B2         }
; 0006 01B3         else
_0xC0059:
; 0006 01B4         {
; 0006 01B5 
; 0006 01B6             return 1;
	LDI  R30,LOW(1)
; 0006 01B7         }
; 0006 01B8 
; 0006 01B9 }
_0x20A0007:
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,39
	RET
;
;
;void Frame_RS232_ME41_42(unsigned char CMD)
; 0006 01BD {
_Frame_RS232_ME41_42:
; 0006 01BE     unsigned char i, XOR_byte=0, output[4];
; 0006 01BF     tx_buffer[0]=0x68;    //start form
	SBIW R28,4
	CALL SUBOPT_0x8
;	CMD -> Y+6
;	i -> R17
;	XOR_byte -> R16
;	output -> Y+2
; 0006 01C0     tx_buffer[1]=0x12;
; 0006 01C1     tx_buffer[2]=Signal_RSSI;
	CALL SUBOPT_0x7C
; 0006 01C2     tx_buffer[3]=Current_Channel;
; 0006 01C3     tx_buffer[4]=Meter_Type_ID;//type mesh
	LDS  R30,_Meter_Type_ID
	CALL SUBOPT_0x7D
; 0006 01C4     tx_buffer[5]=ArraySerial[0];
; 0006 01C5     tx_buffer[6]=ArraySerial[1];
; 0006 01C6     tx_buffer[7]=ArraySerial[2];
; 0006 01C7     tx_buffer[8]=ArraySerial[3];
; 0006 01C8     tx_buffer[9]=CMD;
	LDD  R30,Y+6
	__PUTB1MN _tx_buffer,9
; 0006 01C9     tx_buffer[14]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _tx_buffer,14
; 0006 01CA     tx_buffer[15]=0;
	__PUTB1MN _tx_buffer,15
; 0006 01CB     switch(CMD)
	CALL SUBOPT_0x4F
; 0006 01CC     {
; 0006 01CD         case Cmd_180_ID:
	SBIW R30,0
	BREQ _0xC005F
; 0006 01CE         case Cmd_181_ID:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xC0060
_0xC005F:
; 0006 01CF         case Cmd_182_ID:
	RJMP _0xC0061
_0xC0060:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xC0062
_0xC0061:
; 0006 01D0         case Cmd_183_ID:
	RJMP _0xC0063
_0xC0062:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xC0064
_0xC0063:
; 0006 01D1 
; 0006 01D2         case Cmd_280_ID:
	RJMP _0xC0065
_0xC0064:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xC0066
_0xC0065:
; 0006 01D3         case Cmd_281_ID:
	RJMP _0xC0067
_0xC0066:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xC0068
_0xC0067:
; 0006 01D4         case Cmd_282_ID:
	RJMP _0xC0069
_0xC0068:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0xC006A
_0xC0069:
; 0006 01D5         case Cmd_283_ID:
	RJMP _0xC006B
_0xC006A:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0xC006C
_0xC006B:
; 0006 01D6 
; 0006 01D7         case Cmd_380_ID:
	RJMP _0xC006D
_0xC006C:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xC006E
_0xC006D:
; 0006 01D8         case Cmd_381_ID:
	RJMP _0xC006F
_0xC006E:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xC0070
_0xC006F:
; 0006 01D9         case Cmd_382_ID:
	RJMP _0xC0071
_0xC0070:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0xC0072
_0xC0071:
; 0006 01DA         case Cmd_383_ID:
	RJMP _0xC0073
_0xC0072:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0xC0074
_0xC0073:
; 0006 01DB 
; 0006 01DC         case Cmd_480_ID:
	RJMP _0xC0075
_0xC0074:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xC0076
_0xC0075:
; 0006 01DD         case Cmd_481_ID:
	RJMP _0xC0077
_0xC0076:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0xC0078
_0xC0077:
; 0006 01DE         case Cmd_482_ID:
	RJMP _0xC0079
_0xC0078:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0xC007A
_0xC0079:
; 0006 01DF         case Cmd_483_ID:
	RJMP _0xC007B
_0xC007A:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xC007C
_0xC007B:
; 0006 01E0 
; 0006 01E1           if((payload_rec[1] = 0x12) && (payload_rec[14]==0x17))
	LDI  R30,LOW(18)
	__PUTB1MN _payload_rec,1
	CPI  R30,0
	BREQ _0xC007E
	__GETB2MN _payload_rec,14
	CPI  R26,LOW(0x17)
	BREQ _0xC007F
_0xC007E:
	RJMP _0xC007D
_0xC007F:
; 0006 01E2           {
; 0006 01E3             Convert_ME41_42_PQ(ME41_42_PQ, output);
	LDI  R30,LOW(_ME41_42_PQ)
	LDI  R31,HIGH(_ME41_42_PQ)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x83
	RCALL _Convert_ME41_42_PQ
; 0006 01E4             tx_buffer[10] = output[0];
	CALL SUBOPT_0xB3
; 0006 01E5             tx_buffer[11] = output[1];
; 0006 01E6             tx_buffer[12] = output[2];
; 0006 01E7             tx_buffer[13] = output[3];
; 0006 01E8              for(i=1; i<16;i++)
_0xC0081:
	CPI  R17,16
	BRSH _0xC0082
; 0006 01E9             {
; 0006 01EA                 XOR_byte^= tx_buffer[i];
	CALL SUBOPT_0x7
	LD   R30,Z
	EOR  R16,R30
; 0006 01EB             }
	SUBI R17,-1
	RJMP _0xC0081
_0xC0082:
; 0006 01EC           }
; 0006 01ED         break;
_0xC007D:
	RJMP _0xC005D
; 0006 01EE         case Cmd_UA_ID:
_0xC007C:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BREQ _0xC0084
; 0006 01EF         case Cmd_UB_ID:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xC0085
_0xC0084:
; 0006 01F0         case Cmd_UC_ID:
	RJMP _0xC0086
_0xC0085:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0xC0087
_0xC0086:
; 0006 01F1         case Cmd_IA_ID:
	RJMP _0xC0088
_0xC0087:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0xC0089
_0xC0088:
; 0006 01F2         case Cmd_IB_ID:
	RJMP _0xC008A
_0xC0089:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0xC008B
_0xC008A:
; 0006 01F3         case Cmd_IC_ID:
	RJMP _0xC008C
_0xC008B:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0xC0094
_0xC008C:
; 0006 01F4           if((payload_rec[1] = 0x10) && (payload_rec[14]==0x12))
	LDI  R30,LOW(16)
	__PUTB1MN _payload_rec,1
	CPI  R30,0
	BREQ _0xC008F
	__GETB2MN _payload_rec,14
	CPI  R26,LOW(0x12)
	BREQ _0xC0090
_0xC008F:
	RJMP _0xC008E
_0xC0090:
; 0006 01F5           {
; 0006 01F6             Convert_ME41_42_UI(ME41_42_UI, output);
	LDI  R30,LOW(_ME41_42_UI)
	LDI  R31,HIGH(_ME41_42_UI)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x83
	RCALL _Convert_ME41_42_UI
; 0006 01F7             tx_buffer[10] = output[0];
	CALL SUBOPT_0xB3
; 0006 01F8             tx_buffer[11] = output[1];
; 0006 01F9             tx_buffer[12] = output[2];
; 0006 01FA             tx_buffer[13] = output[3];
; 0006 01FB              for(i=1; i<16;i++)
_0xC0092:
	CPI  R17,16
	BRSH _0xC0093
; 0006 01FC             {
; 0006 01FD                 XOR_byte^= tx_buffer[i];
	CALL SUBOPT_0x7
	LD   R30,Z
	EOR  R16,R30
; 0006 01FE             }
	SUBI R17,-1
	RJMP _0xC0092
_0xC0093:
; 0006 01FF           }
; 0006 0200         break;
_0xC008E:
; 0006 0201 
; 0006 0202         default:
_0xC0094:
; 0006 0203         break;
; 0006 0204     }
_0xC005D:
; 0006 0205 
; 0006 0206      tx_buffer[16]=XOR_byte;
	CALL SUBOPT_0xA
; 0006 0207      tx_buffer[17]=0x16;      //end form
; 0006 0208 
; 0006 0209 }
_0x20A0006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
;
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.DSEG

	.CSEG
_srand:
	LD   R30,Y
	LDD  R31,Y+1
	CALL __CWD1
	CALL SUBOPT_0xB4
	ADIW R28,2
	RET
_rand:
	LDS  R30,__seed_G101
	LDS  R31,__seed_G101+1
	LDS  R22,__seed_G101+2
	LDS  R23,__seed_G101+3
	__GETD2N 0x41C64E6D
	CALL __MULD12U
	__ADDD1N 30562
	CALL SUBOPT_0xB4
	movw r30,r22
	andi r31,0x7F
	RET

	.CSEG
_memcpy:
    ldd  r25,y+1
    ld   r24,y
    adiw r24,0
    breq memcpy1
    ldd  r27,y+5
    ldd  r26,y+4
    ldd  r31,y+3
    ldd  r30,y+2
memcpy0:
    ld   r22,z+
    st   x+,r22
    sbiw r24,1
    brne memcpy0
memcpy1:
    ldd  r31,y+5
    ldd  r30,y+4
	ADIW R28,6
	RET
_memset:
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	ADIW R28,5
	RET

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0xB5
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0xB5
	RJMP _0x20A0005
__floor1:
    brtc __floor0
	CALL SUBOPT_0xB5
	CALL SUBOPT_0xB6
_0x20A0005:
	ADIW R28,4
	RET
_log:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0xB7
	CALL __CPD02
	BRLT _0x206000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20A0003
_0x206000C:
	CALL SUBOPT_0xB8
	CALL __PUTPARD1
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xB7
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x206000D
	CALL SUBOPT_0xBA
	CALL __ADDF12
	CALL SUBOPT_0xB9
	__SUBWRN 16,17,1
_0x206000D:
	CALL SUBOPT_0xB8
	CALL SUBOPT_0xB6
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB8
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xBB
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xB7
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xBC
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL SUBOPT_0x9F
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x20A0003:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0004:
	ADIW R28,10
	RET
_exp:
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0xBD
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x206000F
	CALL SUBOPT_0xBE
	RJMP _0x20A0002
_0x206000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x2060010
	CALL SUBOPT_0x9E
	RJMP _0x20A0002
_0x2060010:
	CALL SUBOPT_0xBD
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2060011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20A0002
_0x2060011:
	CALL SUBOPT_0xBD
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL __PUTPARD1
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	MOVW R30,R16
	CALL SUBOPT_0xBD
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xA7
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xBB
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0xB7
	CALL __MULF12
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBC
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0xB8
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB7
	CALL SUBOPT_0xBC
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	ST   -Y,R17
	ST   -Y,R16
	CALL _ldexp
_0x20A0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
_pow:
	SBIW R28,4
	CALL SUBOPT_0xA8
	CALL __CPD10
	BRNE _0x2060012
	CALL SUBOPT_0xBE
	RJMP _0x20A0001
_0x2060012:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x2060013
	CALL SUBOPT_0xA6
	CALL __CPD10
	BRNE _0x2060014
	CALL SUBOPT_0x9E
	RJMP _0x20A0001
_0x2060014:
	CALL SUBOPT_0xA8
	CALL SUBOPT_0xBF
	RJMP _0x20A0001
_0x2060013:
	CALL SUBOPT_0xA6
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0xB5
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0xA6
	CALL __CPD12
	BREQ _0x2060015
	CALL SUBOPT_0xBE
	RJMP _0x20A0001
_0x2060015:
	CALL SUBOPT_0xA8
	CALL __ANEGF1
	CALL SUBOPT_0xBF
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2060016
	CALL SUBOPT_0xA8
	RJMP _0x20A0001
_0x2060016:
	CALL SUBOPT_0xA8
	CALL __ANEGF1
_0x20A0001:
	ADIW R28,12
	RET

	.CSEG

	.DSEG
_tx_buffer:
	.BYTE 0x40
_rx_buffer1:
	.BYTE 0xFA
_ArraySerial:
	.BYTE 0x4
_RF_buffer:
	.BYTE 0x40
_Signal_RSSI_CE18G:
	.BYTE 0x1
_Signal_RSSI:
	.BYTE 0x1
_Meter_Type_ID:
	.BYTE 0x1
_Current_Channel:
	.BYTE 0x1
_Frame_Seq_Num:
	.BYTE 0x1
_Mesh_RF_Retry_Flag:
	.BYTE 0x1
_Mesh_RF_Retry_Count:
	.BYTE 0x1
_Payload_Buff:
	.BYTE 0x20
_Real_Data:
	.BYTE 0xC
_Last_RF_Config:
	.BYTE 0x1
_HHU_ID1:
	.BYTE 0x1
_HHU_ID0:
	.BYTE 0x1
_ME41_42_PQ:
	.BYTE 0x4
_ME41_42_UI:
	.BYTE 0x2
_payload_rec:
	.BYTE 0x20
_password_len:
	.BYTE 0x1
_Old_Data:
	.BYTE 0x40
_iTimeout:
	.BYTE 0x2
_rfFlag:
	.BYTE 0x1
_iCounter:
	.BYTE 0x2
_Speed_Random:
	.BYTE 0x4
_UART1_Byte_Timeout:
	.BYTE 0x1
_UART1_Form_Timeout:
	.BYTE 0x2
_Only_First_Time_Flag_S0000012000:
	.BYTE 0x1
_aes_key_default_G004:
	.BYTE 0x10
_aes_iv_default_G004:
	.BYTE 0x10
_sbox:
	.BYTE 0x100
_rsbox:
	.BYTE 0x100
_Rcon:
	.BYTE 0xA
_Rec_Password:
	.BYTE 0x40
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	STS  _UART1_Form_Timeout,R30
	STS  _UART1_Form_Timeout+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	CLR  R9
	CLR  R8
	CLR  R7
	LDI  R30,LOW(0)
	STS  _iTimeout,R30
	STS  _iTimeout+1,R30
	CLR  R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:84 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	STS  _iTimeout,R30
	STS  _iTimeout+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x7:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x8:
	ST   -Y,R17
	ST   -Y,R16
	LDI  R16,0
	LDI  R30,LOW(104)
	STS  _tx_buffer,R30
	LDI  R30,LOW(18)
	__PUTB1MN _tx_buffer,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	__PUTB1MN _tx_buffer,14
	__PUTB1MN _tx_buffer,15
	LDI  R17,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	__PUTBMRN _tx_buffer,16,16
	LDI  R30,LOW(22)
	__PUTB1MN _tx_buffer,17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	CALL _Reset_WDT
	CALL _LED_Red
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CALL _LED_Green
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	CALL _power_on_Reset_cc1101
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	JMP  _CC1101_Setup

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(54)
	ST   -Y,R30
	CALL _Strobes_Comm
	LDI  R30,LOW(58)
	ST   -Y,R30
	JMP  _Strobes_Comm

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(57)
	ST   -Y,R30
	JMP  _Strobes_Comm

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x10:
	MOV  R12,R30
	LDI  R30,LOW(0)
	STS  _rfFlag,R30
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x11:
	CALL _Reset_WDT
	LDS  R26,_rfFlag
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(_tx_buffer)
	LDI  R31,HIGH(_tx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	CALL _putBuffer1
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  _rfFlag,R30
	CLR  R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x15:
	LDS  R26,_iTimeout
	LDS  R27,_iTimeout+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x16:
	RCALL SUBOPT_0x15
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x17:
	CALL _Reset_WDT
	LDI  R30,LOW(1)
	STS  _Frame_Seq_Num,R30
	ST   -Y,R30
	LDS  R30,_Current_Channel
	ST   -Y,R30
	JMP  _RF_Send_Scan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CALL _Reset_WDT
	CALL _ProcessRF_Scan_Frame
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	MOV  R12,R30
	LDI  R30,LOW(0)
	STS  _Mesh_RF_Retry_Flag,R30
	STS  _Mesh_RF_Retry_Count,R30
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	STS  _rfFlag,R30
	JMP  _Reset_WDT

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x15
	CP   R26,R10
	CPC  R27,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(0)
	STS  _rfFlag,R30
	LDI  R30,LOW(1)
	STS  _Mesh_RF_Retry_Flag,R30
	JMP  _Reset_WDT

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(0)
	STS  _Mesh_RF_Retry_Flag,R30
	LDS  R30,_Mesh_RF_Retry_Count
	SUBI R30,-LOW(1)
	STS  _Mesh_RF_Retry_Count,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDS  R26,_Current_Channel
	SUBI R26,-LOW(1)
	STS  _Current_Channel,R26
	CPI  R26,LOW(0x10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(0)
	STS  _Mesh_RF_Retry_Count,R30
	LDI  R30,LOW(15)
	MOV  R12,R30
	CALL _CC1101_ReInit
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x20:
	LDS  R30,_Frame_Seq_Num
	ST   -Y,R30
	LDS  R30,_Current_Channel
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	MOVW R10,R30
	JMP  _Reset_WDT

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CALL _Reset_WDT
	CALL _ProcessRF_Mesh
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	MOV  R30,R13
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x24:
	__GETB1MN _Payload_Buff,13
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(24)
	CALL __LSLD12
	__ANDD1N 0xFF000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x25:
	STS  _Real_Data,R30
	STS  _Real_Data+1,R31
	STS  _Real_Data+2,R22
	STS  _Real_Data+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x26:
	__GETB1MN _Payload_Buff,14
	LDI  R31,0
	CALL __CWD1
	CALL __LSLD16
	__ANDD1N 0xFF0000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x27:
	LDS  R26,_Real_Data
	LDS  R27,_Real_Data+1
	LDS  R24,_Real_Data+2
	LDS  R25,_Real_Data+3
	CALL __ORD12
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x28:
	__GETB1MN _Payload_Buff,15
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	__ANDD1N 0xFF00
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x29:
	__GETB1MN _Payload_Buff,16
	LDI  R31,0
	CALL __CWD1
	__ANDD1N 0xFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2A:
	__PUTD1MN _Real_Data,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	__GETD2MN _Real_Data,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	CALL __ORD12
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2D:
	MOV  R12,R30
	LDS  R26,_Mesh_RF_Retry_Count
	SUBI R26,-LOW(1)
	STS  _Mesh_RF_Retry_Count,R26
	CPI  R26,LOW(0x4)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	STS  _Frame_Seq_Num,R30
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2F:
	__PUTD1MN _Real_Data,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x30:
	__GETD2MN _Real_Data,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	CALL __ORD12
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	CALL _LED_Green
	JMP  _Clear_Tx_Buff

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(0)
	STS  _Mesh_RF_Retry_Count,R30
	LDI  R30,LOW(24)
	MOV  R12,R30
	CALL _CC1101_ReInit
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x34:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	CALL _To_Process_WaitRF
	LDI  R30,LOW(6)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(21)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	ST   -Y,R30
	CALL _spi_put
	SBI  0x18,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x39:
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(71)
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(4)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3A:
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(7)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3B:
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3C:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _write_Reg

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3D:
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(12)
	ST   -Y,R30
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(14)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3F:
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(18)
	ST   -Y,R30
	LDI  R30,LOW(19)
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(19)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	ST   -Y,R30
	CALL _write_Reg
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R30,LOW(248)
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x42:
	LDI  R30,LOW(63)
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	JMP  _write_BurstReg

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	LDI  R30,LOW(53)
	ST   -Y,R30
	JMP  _Strobes_Comm

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	LDI  R30,LOW(63)
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x45:
	LDI  R30,LOW(54)
	ST   -Y,R30
	JMP  _Strobes_Comm

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x46:
	__GETB1MN _rx_buffer1,5
	STS  _ArraySerial,R30
	__GETB1MN _rx_buffer1,6
	__PUTB1MN _ArraySerial,1
	__GETB1MN _rx_buffer1,7
	__PUTB1MN _ArraySerial,2
	__GETB1MN _rx_buffer1,8
	__PUTB1MN _ArraySerial,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x47:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x48:
	ST   -Y,R30
	CALL _Strobes_Comm
	LDI  R30,LOW(58)
	ST   -Y,R30
	JMP  _Strobes_Comm

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(_RF_buffer)
	LDI  R31,HIGH(_RF_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(19)
	ST   -Y,R30
	CALL _RF_Send
	CALL _To_Process_WaitRF
	CLR  R7
	CLR  R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x4A:
	LDI  R30,LOW(_RF_buffer)
	LDI  R31,HIGH(_RF_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4B:
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	LDI  R30,LOW(244)
	ST   -Y,R30
	JMP  _read_Reg

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4D:
	CALL _idle_mode_PA
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4E:
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,8
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4F:
	LDD  R30,Y+6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	MOV  R30,R21
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x51:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x52:
	MOVW R26,R28
	ADIW R26,8
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x53:
	SBIW R30,2
	MOV  R26,R16
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	CALL __SAVELOCR4
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x55:
	__PUTB1MN _RF_buffer,1
	LDD  R30,Y+3
	__PUTB1MN _RF_buffer,2
	LDS  R30,_HHU_ID1
	__PUTB1MN _RF_buffer,3
	LDS  R30,_HHU_ID0
	__PUTB1MN _RF_buffer,4
	LDI  R30,LOW(255)
	__PUTB1MN _RF_buffer,5
	LDI  R30,LOW(250)
	__PUTB1MN _RF_buffer,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x56:
	__PUTB1MN _RF_buffer,8
	LDI  R30,LOW(0)
	__PUTB1MN _RF_buffer,9
	__PUTB1MN _RF_buffer,10
	__PUTB1MN _RF_buffer,11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x57:
	LDS  R30,_RF_buffer
	SUBI R30,-LOW(1)
	ST   -Y,R30
	CALL _CRC16CC1101_Buff
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x58:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	ST   Y,R26
	STD  Y+1,R27
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x59:
	CALL _idle_mode_PA
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5A:
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDS  R30,_RF_buffer
	SUBI R30,-LOW(3)
	ST   -Y,R30
	JMP  _write_Reg

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5B:
	LDS  R30,_RF_buffer
	SUBI R30,-LOW(3)
	ST   -Y,R30
	CALL _Mesh_RF_Send
	RJMP SUBOPT_0x4A

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5C:
	LDS  R30,_RF_buffer
	SUBI R30,-LOW(3)
	ST   -Y,R30
	JMP  _Mesh_RF_Send

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	CALL __SAVELOCR6
	LDI  R21,64
	LDI  R20,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5E:
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x5F:
	SUBI R30,-LOW(1)
	ST   -Y,R30
	CALL _CRC16CC1101_Buff
	MOVW R16,R30
	MOV  R19,R17
	MOV  R30,R16
	MOV  R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x60:
	LDD  R30,Y+4
	MOVW R26,R18
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x61:
	MOVW R30,R18
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
	__ADDWRR 16,17,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x62:
	LDI  R30,LOW(1)
	STD  Y+52,R30
	MOVW R30,R28
	ADIW R30,33
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	CALL _Payload_Checksum1
	STD  Y+56,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x63:
	LDI  R30,LOW(2)
	STD  Y+52,R30
	MOVW R30,R28
	ADIW R30,33
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	CALL _Payload_Checksum1
	STD  Y+56,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x64:
	LDI  R30,LOW(3)
	STD  Y+52,R30
	MOVW R30,R28
	ADIW R30,33
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	CALL _Payload_Checksum1
	STD  Y+56,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x65:
	STD  Y+50,R30
	LDI  R30,LOW(0)
	STD  Y+52,R30
	MOVW R30,R28
	ADIW R30,33
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	CALL _Payload_Checksum1
	STD  Y+56,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x66:
	STD  Y+50,R30
	LDI  R30,LOW(7)
	STD  Y+51,R30
	MOVW R30,R28
	ADIW R30,33
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	CALL _Payload_Checksum1
	STD  Y+56,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x67:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x68:
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x69:
	LDS  R30,_HHU_ID1
	__PUTB1MN _RF_buffer,7
	LDS  R30,_HHU_ID0
	RJMP SUBOPT_0x56

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6A:
	CALL _LED_Red
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6B:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6C:
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6D:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RJMP SUBOPT_0x67

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x6E:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6F:
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x70:
	MOVW R30,R28
	ADIW R30,38
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	STS  _Signal_RSSI,R30
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x72:
	LDD  R30,Y+1
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x73:
	ADIW R30,0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x74:
	__GETD2S 4
	__GETD1N 0xF4240
	CALL __DIVD21U
	CLR  R31
	CLR  R22
	CLR  R23
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x75:
	CALL __DIVW21
	SWAP R30
	ANDI R30,0xF0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x76:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x77:
	__GETD2S 4
	__GETD1N 0x2710
	CALL __DIVD21U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x64
	CALL __MODD21U
	CLR  R31
	CLR  R22
	CLR  R23
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x78:
	__GETD2S 4
	__GETD1N 0x64
	CALL __DIVD21U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x64
	CALL __MODD21U
	CLR  R31
	CLR  R22
	CLR  R23
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x79:
	__GETD2S 4
	__GETD1N 0x64
	CALL __MODD21U
	CLR  R31
	CLR  R22
	CLR  R23
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7A:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RJMP SUBOPT_0x6C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7B:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7C:
	LDS  R30,_Signal_RSSI
	__PUTB1MN _tx_buffer,2
	LDS  R30,_Current_Channel
	__PUTB1MN _tx_buffer,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7D:
	__PUTB1MN _tx_buffer,4
	LDS  R30,_ArraySerial
	__PUTB1MN _tx_buffer,5
	__GETB1MN _ArraySerial,1
	__PUTB1MN _tx_buffer,6
	__GETB1MN _ArraySerial,2
	__PUTB1MN _tx_buffer,7
	__GETB1MN _ArraySerial,3
	__PUTB1MN _tx_buffer,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7E:
	CALL __PUTPARD1
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7F:
	LD   R30,X
	EOR  R30,R0
	MOVW R26,R22
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x80:
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x81:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memcpy
	RJMP SUBOPT_0x80

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x82:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _xor_iv_G004

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x83:
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x84:
	LDD  R30,Y+29
	LDD  R31,Y+29+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x85:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _memcpy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x86:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x87:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x88:
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x89:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,13
	LD   R30,X
	LDI  R31,0
	SUBI R30,LOW(-_sbox)
	SBCI R31,HIGH(-_sbox)
	LD   R0,Z
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0x8A:
	SUBI R30,LOW(-_Rcon)
	SBCI R31,HIGH(-_Rcon)
	LD   R30,Z
	EOR  R30,R26
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ST   X,R30
	ADIW R26,14
	LD   R30,X
	LDI  R31,0
	SUBI R30,LOW(-_sbox)
	SBCI R31,HIGH(-_sbox)
	LD   R0,Z
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,1
	LD   R30,X
	EOR  R30,R0
	__PUTB1SNS 7,1
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,15
	LD   R30,X
	LDI  R31,0
	SUBI R30,LOW(-_sbox)
	SBCI R31,HIGH(-_sbox)
	LD   R0,Z
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,2
	LD   R30,X
	EOR  R30,R0
	__PUTB1SNS 7,2
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,12
	LD   R30,X
	LDI  R31,0
	SUBI R30,LOW(-_sbox)
	SBCI R31,HIGH(-_sbox)
	LD   R0,Z
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,3
	LD   R30,X
	EOR  R30,R0
	__PUTB1SNS 7,3
	LDI  R20,LOW(4)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8B:
	MOV  R30,R20
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	RJMP SUBOPT_0x6E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x8C:
	MOVW R22,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R30
	ADD  R26,R20
	ADC  R27,R30
	LD   R0,X
	MOV  R30,R20
	LDI  R31,0
	SBIW R30,4
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0x7F

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8D:
	MOV  R30,R20
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	RJMP SUBOPT_0x6E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8E:
	MOVW R22,R30
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CLR  R30
	ADD  R26,R20
	ADC  R27,R30
	LD   R0,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8F:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R30
	ADD  R26,R20
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x90:
	LD   R30,X
	LDI  R31,0
	SUBI R30,LOW(-_sbox)
	SBCI R31,HIGH(-_sbox)
	LD   R0,Z
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x91:
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x92:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CLR  R30
	ADD  R26,R18
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x93:
	LD   R0,X
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x94:
	ADIW R30,2
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x95:
	EOR  R30,R0
	ST   -Y,R30
	CALL _galois_mul2
	ST   -Y,R30
	JMP  _galois_mul2

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x96:
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x97:
	MOVW R22,R30
	ADIW R30,1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X
	MOVW R30,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x98:
	ADIW R30,3
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x99:
	ADIW R30,1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9A:
	EOR  R30,R0
	MOV  R19,R30
	ST   -Y,R19
	CALL _galois_mul2
	MOV  R19,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9B:
	LD   R30,X
	EOR  R30,R19
	EOR  R30,R17
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x96

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9C:
	MOVW R22,R30
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	RJMP SUBOPT_0x7B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9D:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9E:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9F:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA0:
	CALL __ASRW12
	ANDI R30,LOW(0x1)
	ST   Y,R30
	RJMP SUBOPT_0x87

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xA1:
	__GETD1N 0x40000000
	CALL __PUTPARD1
	MOVW R30,R18
	RCALL SUBOPT_0x9F
	CALL __PUTPARD1
	JMP  _pow

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xA2:
	CALL __CWD2
	CALL __CDF2
	CALL __MULF12
	__GETD2S 29
	CALL __ADDF12
	__PUTD1S 29
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA3:
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xA4:
	LD   R26,X
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	ADD  R30,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA5:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA6:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA7:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA8:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xA9:
	__PUTB1MN _RF_buffer,1
	__GETB1SX 85
	__PUTB1MN _RF_buffer,2
	LDS  R30,_HHU_ID1
	__PUTB1MN _RF_buffer,3
	LDS  R30,_HHU_ID0
	__PUTB1MN _RF_buffer,4
	LDI  R30,LOW(255)
	__PUTB1MN _RF_buffer,5
	LDI  R30,LOW(250)
	__PUTB1MN _RF_buffer,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xAA:
	LDI  R31,0
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAB:
	ST   -Y,R30
	CALL _Compare_Buffer
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAC:
	SUBI R30,LOW(-_Old_Data)
	SBCI R31,HIGH(-_Old_Data)
	MOVW R0,R30
	MOVW R30,R26
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAD:
	LDS  R30,_HHU_ID1
	LDD  R26,Y+11
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAE:
	LDS  R30,_HHU_ID0
	LDD  R26,Y+12
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAF:
	LDS  R30,_HHU_ID1
	LDD  R26,Y+17
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB0:
	LDS  R30,_HHU_ID0
	LDD  R26,Y+18
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB1:
	SUBI R30,LOW(-_Rec_Password)
	SBCI R31,HIGH(-_Rec_Password)
	MOVW R0,R30
	MOVW R30,R26
	ADIW R30,15
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB2:
	STS  _password_len,R30
	LDI  R30,LOW(2)
	STD  Y+6,R30
	JMP  _CC1101_ReInit

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xB3:
	LDD  R30,Y+2
	__PUTB1MN _tx_buffer,10
	LDD  R30,Y+3
	__PUTB1MN _tx_buffer,11
	LDD  R30,Y+4
	__PUTB1MN _tx_buffer,12
	LDD  R30,Y+5
	__PUTB1MN _tx_buffer,13
	LDI  R17,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB4:
	STS  __seed_G101,R30
	STS  __seed_G101+1,R31
	STS  __seed_G101+2,R22
	STS  __seed_G101+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB5:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB6:
	__GETD2N 0x3F800000
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB7:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB8:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB9:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBA:
	RCALL SUBOPT_0xB8
	RJMP SUBOPT_0xB7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBB:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBC:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBD:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBE:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xBF:
	CALL __PUTPARD1
	CALL _log
	RCALL SUBOPT_0xA5
	CALL __MULF12
	CALL __PUTPARD1
	JMP  _exp


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

_frexp:
	LD   R26,Y+
	LD   R27,Y+
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R26,Y+
	LD   R27,Y+
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
