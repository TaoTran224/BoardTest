
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega64
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

	#pragma AVRPART ADMIN PART_NAME ATmega64
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

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
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

_0x40003:
	.DB  0x78,0x56,0x34,0x12
_0x40004:
	.DB  0x10,0x27
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _Speed_Random
	.DW  _0x40003*2

	.DW  0x02
	.DW  _u32PulseTimeWait
	.DW  _0x40004*2

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
;#include "Global.h"
;#include "calculator.h"
;#include "hardware_config.h"
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
;#include "interrupt.h"
;#include "app.h"
;
;#include "log.h"
;
;
;void main(void)
; 0000 000C {

	.CSEG
_main:
; 0000 000D     HardwareInit();
	CALL _HardwareInit
; 0000 000E 
; 0000 000F     Reset_WDT();
	CALL _Reset_WDT
; 0000 0010     //=========================================
; 0000 0011 #ifdef DBG_SEND
; 0000 0012     DBG_SendStr("START UP\n");
; 0000 0013 #endif
; 0000 0014     Reset_WDT();
	CALL _Reset_WDT
; 0000 0015     #asm("sei")
	sei
; 0000 0016     BoardState = S_RUN;
	LDI  R30,LOW(1)
	STS  _BoardState,R30
; 0000 0017     while (1)
_0x3:
; 0000 0018     {
; 0000 0019          Reset_WDT();
	CALL _Reset_WDT
; 0000 001A //		switch (BoardState)
; 0000 001B //		{
; 0000 001C //		case S_UART_PROCESS:
; 0000 001D //			Board_UARTProcessRec();
; 0000 001E //			break;
; 0000 001F //		case S_RUN:
; 0000 0020 //            if (true == Motor.bFlagCalTime)
; 0000 0021 //            {
; 0000 0022 //                MotorCalRandom();
; 0000 0023 //            }
; 0000 0024 //			break;
; 0000 0025 //
; 0000 0026 //		default:
; 0000 0027 //			break;
; 0000 0028 //		}
; 0000 0029 
; 0000 002A         Pulse_Ouput();
	CALL _Pulse_Ouput
; 0000 002B         if (true == Motor.bFlagCalTime)
	__GETB1MN _Motor,1
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x6
; 0000 002C         {
; 0000 002D             MotorCalRandom();
	CALL _MotorCalRandom
; 0000 002E         }
; 0000 002F 
; 0000 0030     }
_0x6:
	RJMP _0x3
_0x5:
; 0000 0031 }
_0x7:
	RJMP _0x7
;
;#include "hardware_config.h"
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
;
;
;static void LEDInit(void)
; 0001 0006 {

	.CSEG
_LEDInit_G001:
; 0001 0007 // LED1
; 0001 0008     DDRD.5=1;
	SBI  0x11,5
; 0001 0009 // LED2
; 0001 000A     DDRD.6=1;
	SBI  0x11,6
; 0001 000B }
	RET
;
;
;//void LEDRedOn(void)
;//{
;//    PORTD.6=0;
;//}
;//void LEDRedOff(void)
;//{
;//    PORTD.6=1;
;//}
;
;void LEDGreenOn(void)
; 0001 0018 {
_LEDGreenOn:
; 0001 0019     PORTD.5=0;
	CBI  0x12,5
; 0001 001A }
	RET
;
;void LEDGreenOff(void)
; 0001 001D {
_LEDGreenOff:
; 0001 001E     PORTD.5=1;
	SBI  0x12,5
; 0001 001F }
	RET
;
;static void Timer0Init(void)
; 0001 0022 {
_Timer0Init_G001:
; 0001 0023     ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0001 0024     OCR0=0x00;
	OUT  0x31,R30
; 0001 0025     TCCR0=0x04;             // Prescaling = 64
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0001 0026     TCNT0=131;               // 56 <=>1.6ms;  131 <=>1 ms
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0001 0027     TIMSK |= (1<<TOIE0);    // TC0 overflow interrupt enable
	IN   R30,0x37
	ORI  R30,1
	OUT  0x37,R30
; 0001 0028 }
	RET
;
;//void DisableInterrupt(void)
;//{
;//    EIMSK=0x00;
;//}
;
;void EnableInterrupt(void)
; 0001 0030 {
_EnableInterrupt:
; 0001 0031     EIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0001 0032 }
	RET
;
;static void ConfigHardware(void)
; 0001 0035 {
_ConfigHardware_G001:
; 0001 0036     //SDN Si4432
; 0001 0037     DDRB.7=1;
	SBI  0x17,7
; 0001 0038 // SI4432
; 0001 0039     // External Interrupt(s) initialization
; 0001 003A     // INT0: On
; 0001 003B     // INT0 Mode: Failling Edge
; 0001 003C     EICRA=0x02;
	LDI  R30,LOW(2)
	STS  106,R30
; 0001 003D     EICRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3A,R30
; 0001 003E     EIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0001 003F     EIFR=0x01;
	OUT  0x38,R30
; 0001 0040 
; 0001 0041 //CC1101
; 0001 0042     // External Interrupt(s) initialization
; 0001 0043     // INT0: On
; 0001 0044 //    // INT0 Mode: Rising Edge
; 0001 0045 //    EICRA=0x03;
; 0001 0046 //    EICRB=0x00;
; 0001 0047 //    EIMSK=0x01;
; 0001 0048 //    EIFR=0x01;
; 0001 0049 
; 0001 004A     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0001 004B     TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x37,R30
; 0001 004C 
; 0001 004D     ETIMSK=0x00;
	STS  125,R30
; 0001 004E // USART0 initialization
; 0001 004F // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 0050 // USART0 Receiver: On
; 0001 0051 // USART0 Transmitter: On
; 0001 0052 // USART0 Mode: Asynchronous
; 0001 0053 // USART0 Baud Rate: 57600 (Double Speed Mode)
; 0001 0054     UCSR0A=0x02;
	LDI  R30,LOW(2)
	OUT  0xB,R30
; 0001 0055     UCSR0B=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0001 0056     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0001 0057     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0001 0058     UBRR0L=0x10;
	LDI  R30,LOW(16)
	OUT  0x9,R30
; 0001 0059 
; 0001 005A // USART1 initialization
; 0001 005B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 005C // USART1 Receiver: On
; 0001 005D // USART1 Transmitter: On
; 0001 005E // USART1 Mode: Asynchronous
; 0001 005F // USART1 Baud Rate: 57600 (Double Speed Mode)
; 0001 0060     UCSR1A=0x02;
	LDI  R30,LOW(2)
	STS  155,R30
; 0001 0061     UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  154,R30
; 0001 0062     UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0001 0063     UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0001 0064     UBRR1L=0x10;
	LDI  R30,LOW(16)
	STS  153,R30
; 0001 0065 }
	RET
;
;static void PullupRxTx(void)
; 0001 0068 {
_PullupRxTx_G001:
; 0001 0069     PORTE.0=1; //RXD0 pullup
	SBI  0x3,0
; 0001 006A     PORTD.2=1; //RXD1 pullup
	SBI  0x12,2
; 0001 006B }
	RET
;
;static void Internal_Watchdog_Init()//1s wdt
; 0001 006E {
_Internal_Watchdog_Init_G001:
; 0001 006F     WDTCR=0x1E;
	LDI  R30,LOW(30)
	OUT  0x21,R30
; 0001 0070     WDTCR=0x0E;//disable change WDE
	LDI  R30,LOW(14)
	OUT  0x21,R30
; 0001 0071 }
	RET
;
;
;void HardwareInit(void)
; 0001 0075 {
_HardwareInit:
; 0001 0076     LEDInit();
	CALL _LEDInit_G001
; 0001 0077     ConfigHardware();
	CALL _ConfigHardware_G001
; 0001 0078     Output_Init();
	CALL _Output_Init
; 0001 0079     PullupRxTx();
	CALL _PullupRxTx_G001
; 0001 007A     Timer0Init();
	CALL _Timer0Init_G001
; 0001 007B     Internal_Watchdog_Init();
	CALL _Internal_Watchdog_Init_G001
; 0001 007C     EnableInterrupt();
	CALL _EnableInterrupt
; 0001 007D }
	RET
;
;
;void Reset_WDT(void)
; 0001 0081 {
_Reset_WDT:
; 0001 0082     //internal WDT
; 0001 0083     #asm("WDR") ;//clear WDT
	WDR
; 0001 0084 }
	RET
;
;
;
;//void UART1SendChar(uint8_t c)
;//{
;//    while(!(UCSR1A & DATA_REGISTER_EMPTY)) {}
;//    UDR1=c;
;//}
;//
;//void UART1SendBuffer(uint8_t *buffer, uint16_t len)
;//{
;//    uint16_t i=0;
;//    #asm("cli")
;//    for(i=0; i<len;i++)
;//    {
;//        UART1SendChar(buffer[i]);
;//    }
;//    #asm("sei")
;//}
;//
;//void UART1SendString(char *str)
;//{
;//    uint16_t i=0;
;//    #asm("cli")
;//    for(i=0; i<strlen(str);i++)
;//    {
;//        UART1SendChar(str[i]);
;//    }
;//    #asm("sei")
;//}
;
;void UART0SendChar(uint8_t c)
; 0001 00A5 {
; 0001 00A6     while(!(UCSR0A & DATA_REGISTER_EMPTY)) {}
;	c -> Y+0
; 0001 00A7     UDR0=c;
; 0001 00A8 }
;
;void UART0SendBuffer(uint8_t *buffer, uint16_t len)
; 0001 00AB {
; 0001 00AC     uint16_t i=0;
; 0001 00AD     #asm("cli")
;	*buffer -> Y+4
;	len -> Y+2
;	i -> R16,R17
; 0001 00AE     for(i=0; i<len;i++)
; 0001 00AF     {
; 0001 00B0         UART0SendChar(buffer[i]);
; 0001 00B1     }
; 0001 00B2     #asm("sei")
; 0001 00B3 }
;
;//void UART0SendString(char *str)
;//{
;//    uint16_t i=0;
;//    #asm("cli")
;//    for(i=0; i<strlen(str);i++)
;//    {
;//        UART0SendChar(str[i]);
;//    }
;//    #asm("sei")
;//}
;
;
;
;
;void Output_Init(void)
; 0001 00C4 {
_Output_Init:
; 0001 00C5     DDRB.3 = 1;//MISO/out2
	SBI  0x17,3
; 0001 00C6     DDRB.2 = 1;//MOSI/out0
	SBI  0x17,2
; 0001 00C7     DDRB.1 = 1;//SCK/out1
	SBI  0x17,1
; 0001 00C8     DDRB.0 = 1;//CSN/out3
	SBI  0x17,0
; 0001 00C9     PORTB.3 = 1;
	SBI  0x18,3
; 0001 00CA     PORTB.2 = 1;
	SBI  0x18,2
; 0001 00CB     PORTB.1 = 1;
	SBI  0x18,1
; 0001 00CC     PORTB.0 = 1;
	SBI  0x18,0
; 0001 00CD 
; 0001 00CE     DDRB.5 = 1;//PWM1
	SBI  0x17,5
; 0001 00CF     PORTB.5 = 1;
	SBI  0x18,5
; 0001 00D0 }
	RET
;
;//void OutputRun(uint8_t seq, BOOL on_off)
;//{
;//    if (0 == seq)
;//    {
;//        if (TRUE == on_off)
;//        {
;//            PORTB.3 = 0;
;//        }
;//        else
;//        {
;//            PORTB.3 = 1;
;//        }
;//    }
;//    else if (1 == seq)
;//    {
;//        if (TRUE == on_off)
;//        {
;//            PORTB.2 = 0;
;//        }
;//        else
;//        {
;//            PORTB.2 = 1;
;//        }
;//    }
;//    else if (2 == seq)
;//    {
;//        if (TRUE == on_off)
;//        {
;//            PORTB.1 = 0;
;//        }
;//        else
;//        {
;//            PORTB.1 = 1;
;//        }
;//    }
;//}
;
;
;void PWM1_Init(uint32_t freq, uint8_t duty)
; 0001 00F9 {
_PWM1_Init:
; 0001 00FA     uint16_t top;
; 0001 00FB     // Set OC1A (PD5) output
; 0001 00FC     DDRB.5 = 1;
	ST   -Y,R17
	ST   -Y,R16
;	freq -> Y+3
;	duty -> Y+2
;	top -> R16,R17
	SBI  0x17,5
; 0001 00FD     PORTB.5 = 0;
	CBI  0x18,5
; 0001 00FE     TCCR1A = (1 << COM1A1) | (1 << WGM11);
	LDI  R30,LOW(130)
	OUT  0x2F,R30
; 0001 00FF     TCCR1B = (1 << WGM13) | (1 << WGM12); // ? chua set prescaler
	LDI  R30,LOW(24)
	OUT  0x2E,R30
; 0001 0100 
; 0001 0101     top = (uint16_t)(1000000 / freq) - 1;
	__GETD1S 3
	__GETD2N 0xF4240
	CALL __DIVD21U
	CLR  R22
	CLR  R23
	SBIW R30,1
	MOVW R16,R30
; 0001 0102     ICR1 = top;
	__OUTWR 16,17,38
; 0001 0103 
; 0001 0104     // Set duty
; 0001 0105     OCR1A = (uint16_t)((uint32_t)duty * (uint32_t)top / (uint32_t)100);
	LDD  R30,Y+2
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x64
	CALL __DIVD21U
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0001 0106 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
;
;void PWM1_Start(void)
; 0001 0109 {
_PWM1_Start:
; 0001 010A     TCCR1B |= (1 << CS11); // b?t d?u ch?y t?i dây
	IN   R30,0x2E
	ORI  R30,2
	OUT  0x2E,R30
; 0001 010B }
	RET
;
;void PWM1_Stop(void)
; 0001 010E {
_PWM1_Stop:
; 0001 010F 
; 0001 0110     // Clear prescaler bits ? d?ng Timer
; 0001 0111     TCCR1B &= ~((1 << CS12) | (1 << CS11) | (1 << CS10));
	IN   R30,0x2E
	ANDI R30,LOW(0xF8)
	OUT  0x2E,R30
; 0001 0112 }
	RET
;//
;//void PWM1_SetDuty(uint8_t duty)
;//{
;//    OCR1A = (uint16_t)(duty * ICR1 / 100);
;//}
;//
;//void PWM1_SetFreq(uint32_t freq)
;//{
;//    uint16_t top = (uint16_t)(1000000 / freq) - 1;
;//    ICR1 = top;
;//}
;
;void PWM1_DeInit(void)
; 0001 0120 {
_PWM1_DeInit:
; 0001 0121     // 1. Ng?t k?t n?i PWM kh?i chân OC1A
; 0001 0122     TCCR1A &= ~((1 << COM1A1) | (1 << COM1A0));
	IN   R30,0x2F
	ANDI R30,LOW(0x3F)
	OUT  0x2F,R30
; 0001 0123 
; 0001 0124     // 2. D?ng Timer (clear prescaler)
; 0001 0125     TCCR1B &= ~((1 << CS12) | (1 << CS11) | (1 << CS10));
	IN   R30,0x2E
	ANDI R30,LOW(0xF8)
	OUT  0x2E,R30
; 0001 0126 
; 0001 0127     // 3. Reset toàn b? thanh ghi Timer1 v? m?c d?nh
; 0001 0128     TCCR1A = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0001 0129     TCCR1B = 0x00;
	OUT  0x2E,R30
; 0001 012A     TCCR1C = 0x00;
	STS  122,R30
; 0001 012B 
; 0001 012C     // 4. Reset counter và compare
; 0001 012D     TCNT1 = 0x0000;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0001 012E     ICR1  = 0x0000;
	OUT  0x26+1,R31
	OUT  0x26,R30
; 0001 012F     OCR1A = 0x0000;
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0001 0130     OCR1B = 0x0000;
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0001 0131 
; 0001 0132     // 5. Clear interrupt flags (n?u có)
; 0001 0133     TIFR  |= (1 << TOV1) | (1 << OCF1A) | (1 << OCF1B) | (1 << ICF1);
	IN   R30,0x36
	ORI  R30,LOW(0x3C)
	OUT  0x36,R30
; 0001 0134 
; 0001 0135     // 6. Disable interrupt Timer1 (n?u b?n có dùng)
; 0001 0136     TIMSK &= ~((1 << TOIE1) | (1 << OCIE1A) | (1 << OCIE1B) | (1 << TICIE1));
	IN   R30,0x37
	ANDI R30,LOW(0xC3)
	OUT  0x37,R30
; 0001 0137 }
	RET
;
;#include "interrupt.h"
;#include "main.h"
;#include "hardware_config.h"
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
;#include "app.h"
;
;volatile uint32_t Speed_Random=0x12345678;

	.DSEG
;
;uint8_t UART_au8Rec[UART_RX_SIZE];
;uint16_t UART_u16Len;
;
;static bool UART_enableRec;
;static uint16_t UART_timeout;
;
;
;//static uint16_t iCounter;
;//static uint16_t iTimeout;
;uint8_t rando;
;
;static uint16_t iCounterRun;
;
;volatile uint32_t u32PulseTimeCount = 0;
;volatile uint32_t u32PulseTimeWait = 10000;
;
;interrupt [TIM0_OVF] void timer0_ovf(void)
; 0002 001A {

	.CSEG
_timer0_ovf:
	CALL SUBOPT_0x0
; 0002 001B     TCNT0=131;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0002 001C     Speed_Random++;
	CALL SUBOPT_0x1
; 0002 001D     MotorRandom();
	CALL _MotorRandom
; 0002 001E     // NOTE: calculations are in *TICKS* (not milliseconds)
; 0002 001F     if (S_RUN == BoardState)
	LDS  R30,_BoardState
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x40005
; 0002 0020     {
; 0002 0021         if(iCounterRun++>=900)
	LDI  R26,LOW(_iCounterRun_G002)
	LDI  R27,HIGH(_iCounterRun_G002)
	CALL SUBOPT_0x2
	CPI  R30,LOW(0x384)
	LDI  R26,HIGH(0x384)
	CPC  R31,R26
	BRSH PC+3
	JMP _0x40006
; 0002 0022         {
; 0002 0023             LEDGreenOn();
	CALL _LEDGreenOn
; 0002 0024         }
; 0002 0025         if(iCounterRun>=1000)
_0x40006:
	LDS  R26,_iCounterRun_G002
	LDS  R27,_iCounterRun_G002+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x40007
; 0002 0026         {
; 0002 0027             LEDGreenOff();
	CALL _LEDGreenOff
; 0002 0028             iCounterRun=0;
	LDI  R30,LOW(0)
	STS  _iCounterRun_G002,R30
	STS  _iCounterRun_G002+1,R30
; 0002 0029         }
; 0002 002A     }
_0x40007:
; 0002 002B 
; 0002 002C     if (true == UART_enableRec)
_0x40005:
	LDS  R30,_UART_enableRec_G002
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x40008
; 0002 002D     {
; 0002 002E         if ((200 <= (UART_timeout++)) || (136 <= UART_u16Len)) // len frame update fw
	LDI  R26,LOW(_UART_timeout_G002)
	LDI  R27,HIGH(_UART_timeout_G002)
	CALL SUBOPT_0x2
	CPI  R30,LOW(0xC8)
	LDI  R26,HIGH(0xC8)
	CPC  R31,R26
	BRLO PC+3
	JMP _0x4000A
	LDS  R30,_UART_u16Len
	LDS  R31,_UART_u16Len+1
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRLO PC+3
	JMP _0x4000A
	RJMP _0x40009
_0x4000A:
; 0002 002F         {
; 0002 0030             UART_enableRec = false;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0002 0031             UART_timeout = 0;
; 0002 0032             if (S_RUN == BoardState)
	BREQ PC+3
	JMP _0x4000C
; 0002 0033             {
; 0002 0034                 BoardState = S_UART_PROCESS;
	LDI  R30,LOW(0)
	STS  _BoardState,R30
; 0002 0035             }
; 0002 0036         }
_0x4000C:
; 0002 0037     }
_0x40009:
; 0002 0038     MagnetRun();
_0x40008:
	CALL _MagnetRun
; 0002 0039     MotorRun();
	CALL _MotorRun
; 0002 003A }
	CALL SUBOPT_0x4
	RETI
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0002 003E {
_usart0_rx_isr:
	CALL SUBOPT_0x0
; 0002 003F     uint8_t status = 0;
; 0002 0040     uint8_t data = 0;
; 0002 0041     status = UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDI  R17,0
	LDI  R16,0
	IN   R17,11
; 0002 0042     data = UDR0;
	IN   R16,12
; 0002 0043     UART_enableRec = true;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x3
; 0002 0044     UART_timeout = 0;
; 0002 0045     if ((S_RUN == BoardState) && ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN)) == 0))
	BREQ PC+3
	JMP _0x4000E
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BREQ PC+3
	JMP _0x4000E
	RJMP _0x4000F
_0x4000E:
	RJMP _0x4000D
_0x4000F:
; 0002 0046     {
; 0002 0047         UART_au8Rec[UART_u16Len++] = data;
	LDI  R26,LOW(_UART_u16Len)
	LDI  R27,HIGH(_UART_u16Len)
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_UART_au8Rec)
	SBCI R31,HIGH(-_UART_au8Rec)
	ST   Z,R16
; 0002 0048 
; 0002 0049         if ((UART_RX_SIZE - (uint16_t)1) <= UART_u16Len)
	LDS  R30,_UART_u16Len
	LDS  R31,_UART_u16Len+1
	CPI  R30,LOW(0x87)
	LDI  R26,HIGH(0x87)
	CPC  R31,R26
	BRSH PC+3
	JMP _0x40010
; 0002 004A         {
; 0002 004B             memset(&UART_au8Rec, 0, sizeof(UART_au8Rec));
	LDI  R30,LOW(_UART_au8Rec)
	LDI  R31,HIGH(_UART_au8Rec)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0002 004C             UART_u16Len = 0;
	LDI  R30,LOW(0)
	STS  _UART_u16Len,R30
	STS  _UART_u16Len+1,R30
; 0002 004D         }
; 0002 004E     }
_0x40010:
; 0002 004F }
_0x4000D:
	LD   R16,Y+
	LD   R17,Y+
	CALL SUBOPT_0x4
	RETI
;
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0002 0054 {
_usart1_rx_isr:
; 0002 0055 }
	RETI
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0002 005A {
_ext_int0_isr:
	ST   -Y,R30
; 0002 005B     BoardState = S_RUN;
	LDI  R30,LOW(1)
	STS  _BoardState,R30
; 0002 005C }
	LD   R30,Y+
	RETI
;
;#include "app.h"
;#include "main.h"
;#include "hardware_config.h"
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
;#include "interrupt.h"
;#include "crc16.h"
;#include "log.h"
;
;OutputType Magnet;
;StateType BoardState;
;MotorType Motor;
;
;static CmdType Cmd;
;static CmdResultType CmdRes;
;
;void MagnetRun(void)//out0
; 0003 0011 {

	.CSEG
_MagnetRun:
; 0003 0012     if (MODE_ON == Magnet.eu8Mode)
	__GETB1MN _Magnet,4
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x60003
; 0003 0013     {
; 0003 0014         PORTB.2 = 0;
	CBI  0x18,2
; 0003 0015     }
; 0003 0016     else
	RJMP _0x60006
_0x60003:
; 0003 0017     {
; 0003 0018         PORTB.2 = 1;
	SBI  0x18,2
; 0003 0019     }
_0x60006:
; 0003 001A }
	RET
;
;void MotorRun(void)
; 0003 001D {
_MotorRun:
; 0003 001E     if (MODE_ON == Motor.eu8Mode)
	__GETB1MN _Motor,11
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x60009
; 0003 001F     {
; 0003 0020         PORTB.5 = 1;
	SBI  0x18,5
; 0003 0021     }
; 0003 0022     else if (MODE_OFF == Motor.eu8Mode)
	RJMP _0x6000C
_0x60009:
	__GETB1MN _Motor,11
	CPI  R30,0
	BREQ PC+3
	JMP _0x6000D
; 0003 0023     {
; 0003 0024         PORTB.5 = 0;
	CBI  0x18,5
; 0003 0025     }
; 0003 0026 }
_0x6000D:
_0x6000C:
	RET
;
;void MotorRandom(void)
; 0003 0029 {
_MotorRandom:
; 0003 002A     if (true == Motor.bRandom)
	LDS  R30,_Motor
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x60010
; 0003 002B     {
; 0003 002C         if (Motor.u32TimeCycle <= (Motor.u32TimeRun++))
	__POINTW2MN _Motor,2
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	__GETD2MN _Motor,7
	CALL __CPD12
	BRSH PC+3
	JMP _0x60011
; 0003 002D         {
; 0003 002E             Motor.bRandom = false;
	LDI  R30,LOW(0)
	STS  _Motor,R30
; 0003 002F             Motor.bFlagCalTime = true;
	LDI  R30,LOW(1)
	__PUTB1MN _Motor,1
; 0003 0030             Motor.u32TimeRun = 0;
	CALL SUBOPT_0x5
; 0003 0031         }
; 0003 0032     }
_0x60011:
; 0003 0033 }
_0x60010:
	RET
;
;uint8_t Random(uint8_t random)
; 0003 0036 {
_Random:
; 0003 0037     unsigned rvar=0;
; 0003 0038     srand(random);
	ST   -Y,R17
	ST   -Y,R16
;	random -> Y+2
;	rvar -> R16,R17
	__GETWRN 16,17,0
	LDD  R30,Y+2
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _srand
; 0003 0039     rvar=(uint8_t)rand();
	CALL _rand
	MOV  R16,R30
	CLR  R17
; 0003 003A     return rvar;
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; 0003 003B }
;
;void MotorCalRandom(void)
; 0003 003E {
_MotorCalRandom:
; 0003 003F     uint8_t duty;
; 0003 0040     rando = Random(Speed_Random++)%100;
	ST   -Y,R17
;	duty -> R17
	CALL SUBOPT_0x1
	CALL SUBOPT_0x6
; 0003 0041 #ifdef DBG_SEND
; 0003 0042     DBG_SendStr("MotorCalRandom\n");
; 0003 0043     logLen = sprintf(log1, "rando = %d", rando);
; 0003 0044     DBG_SendStr(log1);
; 0003 0045 #endif
; 0003 0046     if (20 > rando)
	CPI  R30,LOW(0x14)
	BRLO PC+3
	JMP _0x60012
; 0003 0047     {
; 0003 0048         PWM1_Stop();
	CALL _PWM1_Stop
; 0003 0049         PWM1_DeInit();
	CALL _PWM1_DeInit
; 0003 004A     }
; 0003 004B     else if (70 < rando)
	RJMP _0x60013
_0x60012:
	LDS  R30,_rando
	CPI  R30,LOW(0x47)
	BRSH PC+3
	JMP _0x60014
; 0003 004C     {
; 0003 004D         duty = 50;
	LDI  R17,LOW(50)
; 0003 004E     }
; 0003 004F     else
	RJMP _0x60015
_0x60014:
; 0003 0050     {
; 0003 0051         duty = rando;
	LDS  R17,_rando
; 0003 0052     }
_0x60015:
_0x60013:
; 0003 0053     Motor.eu8Mode = MODE_PWM;
	LDI  R30,LOW(2)
	__PUTB1MN _Motor,11
; 0003 0054     PWM1_Stop();
	CALL _PWM1_Stop
; 0003 0055     PWM1_DeInit();
	CALL _PWM1_DeInit
; 0003 0056     delay_ms(2);
	CALL SUBOPT_0x7
; 0003 0057     PWM1_Init(1000, duty);
	__GETD1N 0x3E8
	CALL __PUTPARD1
	ST   -Y,R17
	CALL _PWM1_Init
; 0003 0058     delay_ms(2);
	CALL SUBOPT_0x7
; 0003 0059     PWM1_Start();
	CALL _PWM1_Start
; 0003 005A     rando = Random(Speed_Random++)%100;
	CALL SUBOPT_0x1
	CALL SUBOPT_0x6
; 0003 005B     if (5 > rando)
	CPI  R30,LOW(0x5)
	BRLO PC+3
	JMP _0x60016
; 0003 005C     {
; 0003 005D         rando = 5;
	LDI  R30,LOW(5)
	STS  _rando,R30
; 0003 005E     }
; 0003 005F     Motor.u32TimeCycle = (uint32_t)rando*(uint32_t)987;
_0x60016:
	LDS  R30,_rando
	LDI  R31,0
	CALL __CWD1
	__GETD2N 0x3DB
	CALL __MULD12U
	__PUTD1MN _Motor,7
; 0003 0060     Motor.u32TimeRun = 0;
	CALL SUBOPT_0x5
; 0003 0061     Motor.bRandom = true;
	LDI  R30,LOW(1)
	STS  _Motor,R30
; 0003 0062     Motor.bFlagCalTime = false;
	LDI  R30,LOW(0)
	__PUTB1MN _Motor,1
; 0003 0063 #ifdef DBG_SEND
; 0003 0064     logLen = sprintf(log1, "rando = %d", rando);
; 0003 0065     DBG_SendStr(log1);
; 0003 0066 #endif
; 0003 0067 }
	LD   R17,Y+
	RET
;
;static CmdType UART_GetCmd(uint8_t cmd)
; 0003 006A {
; 0003 006B     if (((uint8_t)CMD_CONTROL_MAGNET == cmd) || ((uint8_t)CMD_CONTROL_MOTOR == cmd))
;	cmd -> Y+0
; 0003 006C     {
; 0003 006D         return (CmdType)cmd;
; 0003 006E     }
; 0003 006F 
; 0003 0070     return CMD_UNKNOWN;
; 0003 0071 }
;
;static CmdType Board_UARTCheckFrameValid(CmdResultType* cmd_res, const uint8_t* src, const uint16_t src_len)
; 0003 0074 {
; 0003 0075     uint16_t crc16_cal = 0;
; 0003 0076     uint16_t crc16_rec = 0;
; 0003 0077 
; 0003 0078     CmdType cmd = CMD_UNKNOWN;
; 0003 0079 #ifdef DBG_SEND
; 0003 007A     DBG_SendStr("Board_BLECheckFrameValid\n");
; 0003 007B     DBG_SendBuffer(src, src_len);
; 0003 007C     DBG_SendHexToStr(src, src_len);
; 0003 007D #endif
; 0003 007E     *cmd_res = CMD_RES_ERROR;
;	*cmd_res -> Y+10
;	*src -> Y+8
;	src_len -> Y+6
;	crc16_cal -> R16,R17
;	crc16_rec -> R18,R19
;	cmd -> R21
; 0003 007F     if (6 > src_len)
; 0003 0080     {
; 0003 0081         *cmd_res = CMD_RES_ERROR;
; 0003 0082         return CMD_UNKNOWN;
; 0003 0083     }
; 0003 0084     crc16_cal = crc16(src, src_len - 3);
; 0003 0085     memcpy(&crc16_rec, src + (uint16_t)(src_len - 3), 2);
; 0003 0086     if (crc16_cal != crc16_rec)
; 0003 0087     {
; 0003 0088         *cmd_res = CMD_RES_CRC16_FAIL;
; 0003 0089     }
; 0003 008A     if (((7 <= src_len) && (src[2] != (src_len - 6))) || ((6 == src_len) && (0 != src[2])))
; 0003 008B     {
; 0003 008C         *cmd_res = CMD_RES_INVALID_PAYLOAD;
; 0003 008D     }
; 0003 008E     if ((SOH == src[0]) && (ETX == src[src_len - 1]))
; 0003 008F     {
; 0003 0090         cmd = UART_GetCmd(src[1]);
; 0003 0091     }
; 0003 0092 	switch (cmd)
; 0003 0093 	{
; 0003 0094         case CMD_CONTROL_MAGNET:
; 0003 0095             if (8 == src_len)
; 0003 0096             {
; 0003 0097                 if (0 == src[4])
; 0003 0098                 {
; 0003 0099 #ifdef DBG_SEND
; 0003 009A                     DBG_SendStr("Magnet OFF\n");
; 0003 009B #endif
; 0003 009C                     Magnet.eu8Mode = MODE_OFF;
; 0003 009D                     return CMD_RES_SUCCESS;
; 0003 009E                 }
; 0003 009F                 else
; 0003 00A0                 {
; 0003 00A1 #ifdef DBG_SEND
; 0003 00A2                     DBG_SendStr("Magnet ON\n");
; 0003 00A3 #endif
; 0003 00A4                     Magnet.eu8Mode = MODE_ON;
; 0003 00A5                     return CMD_RES_SUCCESS;
; 0003 00A6                 }
; 0003 00A7             }
; 0003 00A8             return CMD_RES_INVALID_PAYLOAD;
; 0003 00A9             break;
; 0003 00AA 
; 0003 00AB         case CMD_CONTROL_MOTOR:
; 0003 00AC             if ( 100 < src[4])
; 0003 00AD             {
; 0003 00AE #ifdef DBG_SEND
; 0003 00AF                 DBG_SendStr("CMD_CONTROL_MOTOR FAIL\n");
; 0003 00B0 #endif
; 0003 00B1                 MotorCalRandom();
; 0003 00B2             }
; 0003 00B3             else if (0 == src[4])
; 0003 00B4             {
; 0003 00B5 #ifdef DBG_SEND
; 0003 00B6                 DBG_SendStr("MOTOR OFF\n");
; 0003 00B7 #endif
; 0003 00B8                 Motor.eu8Mode = MODE_OFF;
; 0003 00B9                 Motor.bRandom = false;
; 0003 00BA                 PWM1_DeInit();
; 0003 00BB             }
; 0003 00BC             else if (100 == src[4])
; 0003 00BD             {
; 0003 00BE #ifdef DBG_SEND
; 0003 00BF                 DBG_SendStr("MOTOR ON\n");
; 0003 00C0 #endif
; 0003 00C1                 Motor.bRandom = false;
; 0003 00C2                 Motor.eu8Mode = MODE_ON;
; 0003 00C3                 PWM1_DeInit();
; 0003 00C4             }
; 0003 00C5             else
; 0003 00C6             {
; 0003 00C7 #ifdef DBG_SEND
; 0003 00C8                 DBG_SendStr("MOTOR PWM");
; 0003 00C9                 logLen = sprintf(log1, " = %d\n", src[4]);
; 0003 00CA                 DBG_SendStr(log1);
; 0003 00CB #endif
; 0003 00CC                 Motor.bRandom = false;
; 0003 00CD                 Motor.eu8Mode = MODE_PWM;
; 0003 00CE                 PWM1_Stop();
; 0003 00CF                 PWM1_DeInit();
; 0003 00D0                 delay_ms(2);
; 0003 00D1                 PWM1_Init(1000, src[4]);
; 0003 00D2                 delay_ms(2);
; 0003 00D3                 PWM1_Start();
; 0003 00D4             }
; 0003 00D5             return CMD_RES_SUCCESS;
; 0003 00D6             break;
; 0003 00D7     }
; 0003 00D8 
; 0003 00D9 }
;
;
;static void Board_SendFrameToApp(CmdType cmd, CmdResultType cmd_res, uint8_t* payload, uint16_t len)
; 0003 00DD {
; 0003 00DE 
; 0003 00DF     uint8_t buf[64];
; 0003 00E0 	uint8_t buf_len = len + 7;
; 0003 00E1 	uint16_t crc;
; 0003 00E2 #ifdef DBG_SEND
; 0003 00E3     DBG_SendStr("Board_SendFrameToApp\n");
; 0003 00E4 #endif
; 0003 00E5 
; 0003 00E6 	buf[0] = STX;
;	cmd -> Y+73
;	cmd_res -> Y+72
;	*payload -> Y+70
;	len -> Y+68
;	buf -> Y+4
;	buf_len -> R17
;	crc -> R18,R19
; 0003 00E7 	buf[1] = cmd;
; 0003 00E8 	buf[2] = cmd_res;
; 0003 00E9 	buf[3] = len;
; 0003 00EA 	memcpy(buf + 4, payload, len);
; 0003 00EB 	crc = crc16(buf, buf_len - 3);
; 0003 00EC 	memcpy(buf + buf_len - 3, &crc, 2);
; 0003 00ED 	buf[buf_len - 1] = ETX;
; 0003 00EE #ifdef DBG_SEND
; 0003 00EF     DBG_SendHexToStr(buf, buf_len);
; 0003 00F0 #endif
; 0003 00F1     UART0SendBuffer(buf, buf_len);
; 0003 00F2 }
;
;void Board_UARTProcessRec(void)
; 0003 00F5 {
; 0003 00F6     CmdRes = CMD_RES_INVALID_COMMAND;
; 0003 00F7     Cmd = Board_UARTCheckFrameValid(&CmdRes, UART_au8Rec, UART_u16Len);
; 0003 00F8     Board_SendFrameToApp(Cmd, CmdRes, 0, 0);
; 0003 00F9 	memset(UART_au8Rec, 0, sizeof(UART_au8Rec));
; 0003 00FA 	UART_u16Len = 0;
; 0003 00FB     BoardState = S_RUN;
; 0003 00FC }
;
;
;void Pulse_Ouput(void)
; 0003 0100 {
_Pulse_Ouput:
; 0003 0101     if (S_RUN == BoardState)
	LDS  R30,_BoardState
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x60034
; 0003 0102     {
; 0003 0103 #ifdef DBG_SEND
; 0003 0104         DBG_SendStr("Pulse_Ouput\n");
; 0003 0105 #endif
; 0003 0106         Motor.bFlagCalTime = false;
	LDI  R30,LOW(0)
	__PUTB1MN _Motor,1
; 0003 0107         Motor.bRandom = false;
	STS  _Motor,R30
; 0003 0108         Motor.eu8Mode = MODE_OFF;
	__PUTB1MN _Motor,11
; 0003 0109         delay_ms(10000);
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0003 010A         PORTB.1 = 0;
	CBI  0x18,1
; 0003 010B         delay_us(100);
	__DELAY_USW 200
; 0003 010C         PORTB.1 = 1;
	SBI  0x18,1
; 0003 010D         u32PulseTimeWait = 21000 + Speed_Random%5000;
	LDS  R26,_Speed_Random
	LDS  R27,_Speed_Random+1
	LDS  R24,_Speed_Random+2
	LDS  R25,_Speed_Random+3
	__GETD1N 0x1388
	CALL __MODD21U
	__ADDD1N 21000
	STS  _u32PulseTimeWait,R30
	STS  _u32PulseTimeWait+1,R31
	STS  _u32PulseTimeWait+2,R22
	STS  _u32PulseTimeWait+3,R23
; 0003 010E         Motor.bRandom = true;
	LDI  R30,LOW(1)
	STS  _Motor,R30
; 0003 010F         BoardState = S_START_UP;
	LDI  R30,LOW(0)
	STS  _BoardState,R30
; 0003 0110     }
; 0003 0111 }
_0x60034:
	RET
;
;#include "calculator.h"
;#include "inc_def.h"
;#include <string.h>
;#include <stdbool.h>
;#include <stdint.h>
;#include <stdio.h>
;/*
;bool CompareBuffer(uint8_t* array1, uint16_t offset1, uint8_t* array2, uint16_t offset2, uint16_t len)
;{
;    uint16_t i, k = 0;
;    for (i = 0; i < len; i++)
;    {
;        if (array1[offset1 + i] == array2[offset2 + i]) k++;
;    }
;    if (k == len) return true;
;    else return false;
;}
;
;void ClearBuffer(uint8_t* input, uint16_t len)
;{
;    uint16_t i;
;    for (i = 0; i < len; i++) { input[i] = 0x00; }
;}
;*/
;
;//void SwapByte(uint8_t* dst, uint8_t* src, uint8_t len)
;//{
;//	uint8_t i = 0;
;//	for (i = 0; i < len; i++)
;//	{
;//		dst[i] = src[len - 1 - i];
;//	}
;//}
;
;
;//uint8_t XOR_Cal(const uint8_t* buf, const uint16_t offset, const uint16_t len)
;//{
;//    uint8_t crc = 0;
;//    uint16_t i = 0;
;//    for (i = 0; i < len; i++)
;//    {
;//        crc ^= buf[i + offset];
;//    }
;//    return crc;
;//}
;//
;//bool XOR_Check(const uint8_t* buf, const uint16_t offset, const uint16_t len, const uint8_t byteCheck)
;//{
;//    if (XOR_Cal(buf, offset, len) == byteCheck)
;//    {
;//        return true;
;//    }
;//    return false;
;//}
;//
;//uint8_t SUM_Cal(const uint8_t* buf, const uint16_t offset, const uint16_t len)
;//{
;//    uint8_t crc = 0;
;//    uint16_t i = 0;
;//    for (i = 0; i < len; i++)
;//    {
;//        crc += buf[i + offset];
;//    }
;//    return crc;
;//}
;//
;//bool SUM_Check(const uint8_t* buf, const uint16_t offset, const uint16_t len, const uint8_t byteCheck)
;//{
;//    if (SUM_Cal(buf, offset, len) == byteCheck)
;//    {
;//        return true;
;//    }
;//    return false;
;//}
;
;//uint16_t HexBufToStr(char* dst, uint8_t* src, uint16_t src_len)
;//{
;//   uint8_t i;
;//    for (i = 0; i < src_len; i++)
;//	{
;//		if (9 >= (src[i]>>4))
;//		{
;//			dst[i<<1] = (src[i]>>4) + 0x30;
;//		}
;//		else
;//		{
;//			dst[i<<1] = (src[i]>>4) + 0x37;
;//		}
;//		if (9 >= (0x0F & src[i]))
;//		{
;//			dst[(i<<1) + 1] = (0x0F & src[i]) + 0x30;
;//		}
;//		else
;//		{
;//			dst[(i<<1) + 1] = (0x0F & src[i]) + 0x37;
;//		}
;//	}
;//	return (src_len<<1);
;//}
;#include "crc16.h"
;
;uint16_t crc16(const uint8_t *buf, const uint16_t len)
; 0005 0004 {

	.CSEG
; 0005 0005 	uint16_t crc = 0xFFFF;
; 0005 0006     uint16_t pos = 0;
; 0005 0007     int i = 0;
; 0005 0008 	for (pos = 0; pos < len; pos++)
;	*buf -> Y+8
;	len -> Y+6
;	crc -> R16,R17
;	pos -> R18,R19
;	i -> R20,R21
; 0005 0009     {
; 0005 000A 		crc ^= (uint16_t) buf[pos];  // XOR byte into least sig. byte of crc
; 0005 000B 		for (i = 8; i != 0; i--) // Loop over each bit
; 0005 000C         {
; 0005 000D 			if ((crc & 0x0001) != 0) // If the LSB is set
; 0005 000E             {
; 0005 000F 				crc >>= 1; // Shift right and XOR 0xA001
; 0005 0010 				crc ^= 0xA001;
; 0005 0011 			}
; 0005 0012             else
; 0005 0013 			{	// Else LSB is not set
; 0005 0014 				crc >>= 1;
; 0005 0015             }                    // Just shift right
; 0005 0016 		}
; 0005 0017 	}
; 0005 0018 	return crc;
; 0005 0019 }
;//unsigned int CRC16(unsigned char *buf, int len)
;//{
;//static const unsigned int wCRCTable[] = {
;//0X0000, 0XC0C1, 0XC181, 0X0140, 0XC301, 0X03C0, 0X0280, 0XC241,
;//0XC601, 0X06C0, 0X0780, 0XC741, 0X0500, 0XC5C1, 0XC481, 0X0440,
;//0XCC01, 0X0CC0, 0X0D80, 0XCD41, 0X0F00, 0XCFC1, 0XCE81, 0X0E40,
;//0X0A00, 0XCAC1, 0XCB81, 0X0B40, 0XC901, 0X09C0, 0X0880, 0XC841,
;//0XD801, 0X18C0, 0X1980, 0XD941, 0X1B00, 0XDBC1, 0XDA81, 0X1A40,
;//0X1E00, 0XDEC1, 0XDF81, 0X1F40, 0XDD01, 0X1DC0, 0X1C80, 0XDC41,
;//0X1400, 0XD4C1, 0XD581, 0X1540, 0XD701, 0X17C0, 0X1680, 0XD641,
;//0XD201, 0X12C0, 0X1380, 0XD341, 0X1100, 0XD1C1, 0XD081, 0X1040,
;//0XF001, 0X30C0, 0X3180, 0XF141, 0X3300, 0XF3C1, 0XF281, 0X3240,
;//0X3600, 0XF6C1, 0XF781, 0X3740, 0XF501, 0X35C0, 0X3480, 0XF441,
;//0X3C00, 0XFCC1, 0XFD81, 0X3D40, 0XFF01, 0X3FC0, 0X3E80, 0XFE41,
;//0XFA01, 0X3AC0, 0X3B80, 0XFB41, 0X3900, 0XF9C1, 0XF881, 0X3840,
;//0X2800, 0XE8C1, 0XE981, 0X2940, 0XEB01, 0X2BC0, 0X2A80, 0XEA41,
;//0XEE01, 0X2EC0, 0X2F80, 0XEF41, 0X2D00, 0XEDC1, 0XEC81, 0X2C40,
;//0XE401, 0X24C0, 0X2580, 0XE541, 0X2700, 0XE7C1, 0XE681, 0X2640,
;//0X2200, 0XE2C1, 0XE381, 0X2340, 0XE101, 0X21C0, 0X2080, 0XE041,
;//0XA001, 0X60C0, 0X6180, 0XA141, 0X6300, 0XA3C1, 0XA281, 0X6240,
;//0X6600, 0XA6C1, 0XA781, 0X6740, 0XA501, 0X65C0, 0X6480, 0XA441,
;//0X6C00, 0XACC1, 0XAD81, 0X6D40, 0XAF01, 0X6FC0, 0X6E80, 0XAE41,
;//0XAA01, 0X6AC0, 0X6B80, 0XAB41, 0X6900, 0XA9C1, 0XA881, 0X6840,
;//0X7800, 0XB8C1, 0XB981, 0X7940, 0XBB01, 0X7BC0, 0X7A80, 0XBA41,
;//0XBE01, 0X7EC0, 0X7F80, 0XBF41, 0X7D00, 0XBDC1, 0XBC81, 0X7C40,
;//0XB401, 0X74C0, 0X7580, 0XB541, 0X7700, 0XB7C1, 0XB681, 0X7640,
;//0X7200, 0XB2C1, 0XB381, 0X7340, 0XB101, 0X71C0, 0X7080, 0XB041,
;//0X5000, 0X90C1, 0X9181, 0X5140, 0X9301, 0X53C0, 0X5280, 0X9241,
;//0X9601, 0X56C0, 0X5780, 0X9741, 0X5500, 0X95C1, 0X9481, 0X5440,
;//0X9C01, 0X5CC0, 0X5D80, 0X9D41, 0X5F00, 0X9FC1, 0X9E81, 0X5E40,
;//0X5A00, 0X9AC1, 0X9B81, 0X5B40, 0X9901, 0X59C0, 0X5880, 0X9841,
;//0X8801, 0X48C0, 0X4980, 0X8941, 0X4B00, 0X8BC1, 0X8A81, 0X4A40,
;//0X4E00, 0X8EC1, 0X8F81, 0X4F40, 0X8D01, 0X4DC0, 0X4C80, 0X8C41,
;//0X4400, 0X84C1, 0X8581, 0X4540, 0X8701, 0X47C0, 0X4680, 0X8641,
;//0X8201, 0X42C0, 0X4380, 0X8341, 0X4100, 0X81C1, 0X8081, 0X4040 };
;//
;//unsigned char nTemp;
;//unsigned int wCRCWord = 0xFFFF;
;//
;//   while (len--)
;//   {
;//      nTemp = *buf++ ^ wCRCWord;
;//      wCRCWord >>= 8;
;//      wCRCWord ^= wCRCTable[nTemp];
;//   }
;//   return wCRCWord;
;//
;//}
;
;#include "log.h"
;#include "hardware_config.h"
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
;#include <string.h>
;
;#ifdef DBG_SEND
;char log1[LOG_MAX_SIZE];
;uint8_t logLen;
;//uint16_t logTime;
;
;void DBG_SendStr(const char* str)
;{
;    UART0SendBuffer(str, strlen(str));
;}
;
;void DBG_SendBuffer(const uint8_t *buf, const uint16_t len)
;{
;    UART0SendBuffer(buf, len);
;}
;
;void ConvertHexToStr(uint8_t* ch, uint8_t hex)
;{
;    if (9 >= (hex>>4))
;    {
;        ch[0] = (hex>>4) + 0x30;
;    }
;    else
;    {
;        ch[0] = (hex>>4) + 0x37;
;    }
;    if (9 >= (0x0F & hex))
;    {
;        ch[1] = (0x0F & hex) + 0x30;
;    }
;    else
;    {
;        ch[1] = (0x0F & hex) + 0x37;
;    }
;}
;
;static void UART_SendStr(const char* str)
;{
;    UART0SendBuffer(str, strlen(str));
;}
;
;static void UART_SendBuf(const uint8_t* buf, const uint16_t len)
;{
;    UART0SendBuffer(buf, len);
;}
;void DBG_SendHexToStr(const uint8_t* buf, const uint16_t len)
;{
;    uint16_t i;
;    uint8_t str[3] = {0,0,0x20};//0x20:space
;    UART_SendStr("\nHEX[ ");
;
;    for (i = 0; i < len; i++)
;    {
;        ConvertHexToStr(str, buf[i]);
;        if ((len - 1) == i)
;        {
;            UART_SendBuf(str, sizeof(str) - 1);
;            break;
;        }
;        UART_SendBuf(str, sizeof(str));
;	}
;	UART_SendStr(" ]ENDHEX\n");
;}
;#endif
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
	CALL SUBOPT_0x8
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
	CALL SUBOPT_0x8
	movw r30,r22
	andi r31,0x7F
	RET

	.CSEG

	.CSEG
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

	.DSEG
_Speed_Random:
	.BYTE 0x4
_rando:
	.BYTE 0x1
_UART_au8Rec:
	.BYTE 0x88
_UART_u16Len:
	.BYTE 0x2
_u32PulseTimeWait:
	.BYTE 0x4
_BoardState:
	.BYTE 0x1
_Magnet:
	.BYTE 0x5
_Motor:
	.BYTE 0xC
_UART_enableRec_G002:
	.BYTE 0x1
_UART_timeout_G002:
	.BYTE 0x2
_iCounterRun_G002:
	.BYTE 0x2
_Cmd_G003:
	.BYTE 0x1
_CmdRes_G003:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_Speed_Random)
	LDI  R27,HIGH(_Speed_Random)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	STS  _UART_enableRec_G002,R30
	LDI  R30,LOW(0)
	STS  _UART_timeout_G002,R30
	STS  _UART_timeout_G002+1,R30
	LDS  R30,_BoardState
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x4:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	__GETD1N 0x0
	__PUTD1MN _Motor,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	ST   -Y,R30
	CALL _Random
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	STS  _rando,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	STS  __seed_G101,R30
	STS  __seed_G101+1,R31
	STS  __seed_G101+2,R22
	STS  __seed_G101+3,R23
	RET


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

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

;END OF CODE MARKER
__END_OF_CODE:
