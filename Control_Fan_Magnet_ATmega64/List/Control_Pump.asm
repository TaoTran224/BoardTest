
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _State=R5
	.DEF _iCounter=R6
	.DEF _iTimeout=R8
	.DEF _rando=R4
	.DEF _iCounterRun=R10

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

_0x3:
	.DB  0x78,0x56,0x34,0x12
_0x29:
	.DB  0x0
_0x0:
	.DB  0x4F,0x75,0x74,0x70,0x75,0x74,0x43,0x61
	.DB  0x6C,0x54,0x69,0x6D,0x65,0xA,0x0,0x4F
	.DB  0x75,0x74,0x70,0x75,0x74,0x3D,0x25,0x64
	.DB  0x2C,0x20,0x75,0x33,0x32,0x54,0x69,0x6D
	.DB  0x65,0x4F,0x6E,0x3D,0x25,0x64,0x2C,0x20
	.DB  0x0,0x75,0x33,0x32,0x54,0x69,0x6D,0x65
	.DB  0x43,0x79,0x63,0x6C,0x65,0x3D,0x25,0x64
	.DB  0xA,0x0,0x53,0x54,0x41,0x52,0x54,0x20
	.DB  0x55,0x50,0xA,0x0
_0x20003:
	.DB  0xAA
_0x20004:
	.DB  0xAA
_0x2000E:
	.DB  0x1
_0x40000:
	.DB  0xA,0x48,0x45,0x58,0x5B,0x20,0x0,0x20
	.DB  0x5D,0x45,0x4E,0x44,0x48,0x45,0x58,0xA
	.DB  0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _Speed_Random
	.DW  _0x3*2

	.DW  0x0F
	.DW  _0x16
	.DW  _0x0*2

	.DW  0x0A
	.DW  _0x17
	.DW  _0x0*2+58

	.DW  0x01
	.DW  0x05
	.DW  _0x29*2

	.DW  0x01
	.DW  _HHU_ID1
	.DW  _0x20003*2

	.DW  0x01
	.DW  _HHU_ID0
	.DW  _0x20004*2

	.DW  0x07
	.DW  _0x40031
	.DW  _0x40000*2

	.DW  0x0A
	.DW  _0x40031+7
	.DW  _0x40000*2+7

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
;#include "user_lib.h"
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
;#include "hardware_config.h"
;
;typedef enum {
;S_START_UP = 0,
;//S_TEST_OUT,
;S_WAIT_RUN,
;S_RUN,
;
;} StateType;
;
;StateType State = S_START_UP;
;volatile uint32_t Speed_Random=0x12345678;

	.DSEG
;uint16_t iCounter;
;uint16_t iTimeout;
;uint8_t rando;
;
;uint16_t iCounterRun;
;
;typedef struct
;{
;    uint32_t u32TimeOn;
;    uint32_t u32TimeOnRun;
;    uint32_t u32TimeCycle;
;    BOOL bFlagStart;
;    BOOL bFlagCalTime;
;} OutputType;
;
;OutputType Output[3];
;
;#ifdef SEND_LOG_RF
;unsigned char t1=0,t2=0;
;#endif
;
;void OutputDisplay(void)
; 0000 0026 {

	.CSEG
_OutputDisplay:
; 0000 0027     uint8_t i;
; 0000 0028     for (i = 0; i < 3; i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x5:
	CPI  R17,3
	BRLO PC+3
	JMP _0x6
; 0000 0029     {
; 0000 002A         if (TRUE == Output[i].bFlagStart)
	CALL SUBOPT_0x0
	LD   R30,Z
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x7
; 0000 002B         {
; 0000 002C             if (Output[i].u32TimeOn >= (Output[i].u32TimeOnRun++))
	CALL SUBOPT_0x1
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD21
	BRSH PC+3
	JMP _0x8
; 0000 002D             {
; 0000 002E                 OutputRun(i, 1);
	ST   -Y,R17
	CALL SUBOPT_0x4
; 0000 002F             }
; 0000 0030             else
	RJMP _0x9
_0x8:
; 0000 0031             {
; 0000 0032                 OutputRun(i, 0);
	ST   -Y,R17
	CALL SUBOPT_0x5
; 0000 0033             }
_0x9:
; 0000 0034             if (Output[i].u32TimeOnRun >= Output[i].u32TimeCycle)
	CALL SUBOPT_0x2
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6
	MOVW R26,R30
	CALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD21
	BRSH PC+3
	JMP _0xA
; 0000 0035             {
; 0000 0036                 Output[i].u32TimeOnRun = 0;
	LDI  R26,LOW(14)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _Output,4
	__GETD2N 0x0
	CALL SUBOPT_0x7
; 0000 0037                 Output[i].bFlagStart = FALSE;
	CALL SUBOPT_0x0
	LDI  R26,LOW(0)
	CALL SUBOPT_0x8
; 0000 0038                 Output[i].bFlagCalTime = TRUE;
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 0039             }
; 0000 003A         }
_0xA:
; 0000 003B     }
_0x7:
_0x4:
	SUBI R17,-1
	RJMP _0x5
_0x6:
; 0000 003C }
	LD   R17,Y+
	RET
;
;interrupt [TIM0_OVF] void timer0_ovf(void)
; 0000 003F {
_timer0_ovf:
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
; 0000 0040     TCNT0=131;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0041     if (S_WAIT_RUN == State)
	LDI  R26,LOW(1)
	CP   R5,R26
	BREQ PC+3
	JMP _0xB
; 0000 0042     {
; 0000 0043         if (10000 <= (iTimeout++))
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	SBIW R30,1
	CPI  R30,LOW(0x2710)
	LDI  R26,HIGH(0x2710)
	CPC  R31,R26
	BRSH PC+3
	JMP _0xC
; 0000 0044         {
; 0000 0045             State = S_RUN;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 0046         }
; 0000 0047     }
_0xC:
; 0000 0048     Speed_Random++;
_0xB:
	CALL SUBOPT_0x9
; 0000 0049     // NOTE: calculations are in *TICKS* (not milliseconds)
; 0000 004A     if(iCounter++>=100)
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	SBIW R30,1
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRSH PC+3
	JMP _0xD
; 0000 004B     {
; 0000 004C       LEDRedOn();
	CALL _LEDRedOn
; 0000 004D     }
; 0000 004E     if(iCounter>=2000)
_0xD:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CP   R6,R30
	CPC  R7,R31
	BRSH PC+3
	JMP _0xE
; 0000 004F     {
; 0000 0050         LEDRedOff();
	CALL _LEDRedOff
; 0000 0051         iCounter=0;
	CLR  R6
	CLR  R7
; 0000 0052     }
; 0000 0053     if (S_RUN == State)
_0xE:
	LDI  R26,LOW(2)
	CP   R5,R26
	BREQ PC+3
	JMP _0xF
; 0000 0054     {
; 0000 0055         if(iCounterRun++>=500)
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	SBIW R30,1
	CPI  R30,LOW(0x1F4)
	LDI  R26,HIGH(0x1F4)
	CPC  R31,R26
	BRSH PC+3
	JMP _0x10
; 0000 0056         {
; 0000 0057             LEDGreenOn();
	CALL _LEDGreenOn
; 0000 0058         }
; 0000 0059         if(iCounterRun>=1000)
_0x10:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R10,R30
	CPC  R11,R31
	BRSH PC+3
	JMP _0x11
; 0000 005A         {
; 0000 005B             LEDGreenOff();
	CALL _LEDGreenOff
; 0000 005C             iCounterRun=0;
	CLR  R10
	CLR  R11
; 0000 005D         }
; 0000 005E         OutputDisplay();
_0x11:
	CALL _OutputDisplay
; 0000 005F     }
; 0000 0060 
; 0000 0061 }
_0xF:
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
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0065 {
_usart0_rx_isr:
; 0000 0066 
; 0000 0067 }
	RETI
;
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 006C {
_usart1_rx_isr:
; 0000 006D }
	RETI
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0072 {
_ext_int0_isr:
	ST   -Y,R30
; 0000 0073     State = S_RUN;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 0074 }
	LD   R30,Y+
	RETI
;
;
;
;void OutputCalTime(void)
; 0000 0079 {
_OutputCalTime:
; 0000 007A     uint8_t i = 0;
; 0000 007B     for (i = 0; i < 3; i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x13:
	CPI  R17,3
	BRLO PC+3
	JMP _0x14
; 0000 007C     {
; 0000 007D         if (TRUE == Output[i].bFlagCalTime)
	LDI  R26,LOW(14)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _Output,13
	LD   R30,Z
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x15
; 0000 007E         {
; 0000 007F             rando =  Random(Speed_Random++);
	CALL SUBOPT_0x9
	ST   -Y,R30
	CALL _Random
	MOV  R4,R30
; 0000 0080             Output[i].u32TimeOn = (uint32_t)1987 + (uint32_t)rando*(uint32_t)357;
	CALL SUBOPT_0x1
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA
	__ADDD1N 1987
	POP  R26
	POP  R27
	CALL SUBOPT_0xB
; 0000 0081 #ifdef DBG_SEND
; 0000 0082             memset(log1, 0, sizeof(log1));
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 0000 0083             DBG_SendStr("OutputCalTime\n");
	__POINTW1MN _0x16,0
	CALL SUBOPT_0xC
; 0000 0084             logLen = sprintf(log1, "Output=%d, u32TimeOn=%d, ", i, rando);
	LDI  R30,LOW(_log1)
	LDI  R31,HIGH(_log1)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,15
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	CALL SUBOPT_0xD
	MOV  R30,R4
	CALL SUBOPT_0xD
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	CALL SUBOPT_0xE
; 0000 0085             DBG_SendStr(log1);
; 0000 0086 #endif
; 0000 0087             rando =  Random(Speed_Random++);
	CALL SUBOPT_0x9
	ST   -Y,R30
	CALL _Random
	MOV  R4,R30
; 0000 0088             Output[i].u32TimeCycle = Output[i].u32TimeOn + (uint32_t)rando*(uint32_t)357 + (uint32_t)2345;
	CALL SUBOPT_0x6
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	__ADDD1N 2345
	POP  R26
	POP  R27
	CALL SUBOPT_0xB
; 0000 0089 #ifdef DBG_SEND
; 0000 008A             logLen = sprintf(log1, "u32TimeCycle=%d\n", rando);
	__POINTW1FN _0x0,41
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R4
	CALL SUBOPT_0xD
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	CALL SUBOPT_0xE
; 0000 008B             DBG_SendStr(log1);
; 0000 008C #endif
; 0000 008D             Output[i].bFlagStart = TRUE;
	CALL SUBOPT_0x0
	LDI  R26,LOW(1)
	CALL SUBOPT_0x8
; 0000 008E             Output[i].bFlagCalTime = FALSE;
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 008F         }
; 0000 0090     }
_0x15:
_0x12:
	SUBI R17,-1
	RJMP _0x13
_0x14:
; 0000 0091 
; 0000 0092 }
	LD   R17,Y+
	RET

	.DSEG
_0x16:
	.BYTE 0xF
;void main(void)
; 0000 0094 {

	.CSEG
_main:
; 0000 0095     uint8_t i = 0;
; 0000 0096     HardwareInit();
;	i -> R17
	LDI  R17,0
	CALL _HardwareInit
; 0000 0097 
; 0000 0098     Reset_WDT();
	CALL _Reset_WDT
; 0000 0099     //=========================================
; 0000 009A #ifdef DBG_SEND
; 0000 009B     DBG_SendStr("START UP\n");
	__POINTW1MN _0x17,0
	CALL SUBOPT_0xC
; 0000 009C #endif
; 0000 009D     Reset_WDT();
	CALL _Reset_WDT
; 0000 009E     #asm("sei")
	sei
; 0000 009F 
; 0000 00A0     for (i = 0; i < 3; i++)
	LDI  R17,LOW(0)
_0x19:
	CPI  R17,3
	BRLO PC+3
	JMP _0x1A
; 0000 00A1     {
; 0000 00A2         Output[i].bFlagStart = TRUE;
	CALL SUBOPT_0x0
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 00A3         Output[i].u32TimeOn = 5123;
	CALL SUBOPT_0x1
	__GETD2N 0x1403
	CALL SUBOPT_0x7
; 0000 00A4         Output[i].u32TimeCycle = 10321;
	CALL SUBOPT_0x6
	__GETD2N 0x2851
	CALL SUBOPT_0x7
; 0000 00A5     }
_0x18:
	SUBI R17,-1
	RJMP _0x19
_0x1A:
; 0000 00A6     OutputRun(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x4
; 0000 00A7     for (i = 0; i < 10; i++)
	LDI  R17,LOW(0)
_0x1C:
	CPI  R17,10
	BRLO PC+3
	JMP _0x1D
; 0000 00A8     {
; 0000 00A9        Reset_WDT();
	CALL SUBOPT_0xF
; 0000 00AA        delay_ms(500);
; 0000 00AB     }
_0x1B:
	SUBI R17,-1
	RJMP _0x1C
_0x1D:
; 0000 00AC     OutputRun(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _OutputRun
; 0000 00AD     OutputRun(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	CALL _OutputRun
; 0000 00AE     for (i = 0; i < 10; i++)
	LDI  R17,LOW(0)
_0x1F:
	CPI  R17,10
	BRLO PC+3
	JMP _0x20
; 0000 00AF     {
; 0000 00B0        Reset_WDT();
	CALL SUBOPT_0xF
; 0000 00B1        delay_ms(500);
; 0000 00B2     }
_0x1E:
	SUBI R17,-1
	RJMP _0x1F
_0x20:
; 0000 00B3     OutputRun(1,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0x5
; 0000 00B4     OutputRun(2,1);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL SUBOPT_0x4
; 0000 00B5     for (i = 0; i < 10; i++)
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,10
	BRLO PC+3
	JMP _0x23
; 0000 00B6     {
; 0000 00B7        Reset_WDT();
	CALL SUBOPT_0xF
; 0000 00B8        delay_ms(500);
; 0000 00B9     }
_0x21:
	SUBI R17,-1
	RJMP _0x22
_0x23:
; 0000 00BA     OutputRun(2,0);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL SUBOPT_0x5
; 0000 00BB     State = S_WAIT_RUN;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 00BC     while (1)
_0x24:
; 0000 00BD     {
; 0000 00BE        Reset_WDT();
	CALL SUBOPT_0xF
; 0000 00BF        delay_ms(500);
; 0000 00C0        if (S_RUN == State)
	LDI  R26,LOW(2)
	CP   R5,R26
	BREQ PC+3
	JMP _0x27
; 0000 00C1        {
; 0000 00C2             OutputCalTime();
	CALL _OutputCalTime
; 0000 00C3        }
; 0000 00C4     }
_0x27:
	RJMP _0x24
_0x26:
; 0000 00C5 }
_0x28:
	RJMP _0x28

	.DSEG
_0x17:
	.BYTE 0xA
;
;#include "user_lib.h"
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
;volatile uint8_t HHU_ID1=0xAA,HHU_ID0=0xAA;

	.DSEG
;
;
;uint8_t CompareBuffer(uint8_t *Input1, uint8_t *Input2, uint16_t Len)
; 0001 0008 {

	.CSEG
; 0001 0009 uint16_t i, k = 0;
; 0001 000A for(i=0; i<Len; i++)
;	*Input1 -> Y+8
;	*Input2 -> Y+6
;	Len -> Y+4
;	i -> R16,R17
;	k -> R18,R19
; 0001 000B {if(Input1[i] == Input2[i]) k++;}
; 0001 000C 
; 0001 000D if(k==Len) return 1;
; 0001 000E else  return 0;
; 0001 000F }
;
;void ClearData(uint8_t *Input, uint16_t Len)
; 0001 0012 {
; 0001 0013 uint16_t i;
; 0001 0014 for(i=0;i<Len;i++) {Input[i] = 0x00;}
;	*Input -> Y+4
;	Len -> Y+2
;	i -> R16,R17
; 0001 0015 }
;
;uint8_t Random(uint8_t random)
; 0001 0018 {
_Random:
; 0001 0019     unsigned rvar=0;
; 0001 001A     srand(random);
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
; 0001 001B     rvar=(uint8_t)rand();
	CALL _rand
	MOV  R16,R30
	CLR  R17
; 0001 001C     return rvar;
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; 0001 001D }
;void Make_HHU_ID(uint8_t random)
; 0001 001F {
; 0001 0020     static uint8_t Only_First_Time_Flag=TRUE;

	.DSEG

	.CSEG
; 0001 0021      HHU_ID0=Random(random);
;	random -> Y+0
; 0001 0022      if(Only_First_Time_Flag)
; 0001 0023      {
; 0001 0024         HHU_ID1=HHU_ID0;
; 0001 0025         Only_First_Time_Flag=FALSE;
; 0001 0026      }
; 0001 0027      else
; 0001 0028      {
; 0001 0029         HHU_ID1++;
; 0001 002A      }
; 0001 002B }
;
;uint8_t Cal_XOR(uint8_t *Data, uint16_t Len)
; 0001 002E {
; 0001 002F    uint16_t i;
; 0001 0030    uint8_t crc=0;
; 0001 0031    for(i=0;i<Len;i++) {crc^=Data[i];}
;	*Data -> Y+6
;	Len -> Y+4
;	i -> R16,R17
;	crc -> R19
; 0001 0032    return crc;
; 0001 0033 }
;
;// input: bao gom ca byte XOR cuoi can check
;uint8_t Check_XOR(uint8_t *Data, uint16_t Len)
; 0001 0037 {
; 0001 0038     if(Data[Len-1]==Cal_XOR(Data, Len-1)) return 1;
;	*Data -> Y+2
;	Len -> Y+0
; 0001 0039     return 0;
; 0001 003A }
;
;uint8_t Cal_SUM(uint8_t *Data, uint16_t Len)
; 0001 003D {
; 0001 003E    uint16_t i;
; 0001 003F    uint8_t crc=0;
; 0001 0040    for(i=0;i<Len;i++) {crc+=Data[i];}
;	*Data -> Y+6
;	Len -> Y+4
;	i -> R16,R17
;	crc -> R19
; 0001 0041    return crc;
; 0001 0042 }
;
;// input: bao gom ca byte SUM cuoi can check
;uint8_t Check_SUM(uint8_t *Data, uint16_t Len)
; 0001 0046 {
; 0001 0047     if(Data[Len-1]==Cal_SUM(Data, Len-1)) return 1;
;	*Data -> Y+2
;	Len -> Y+0
; 0001 0048     return 0;
; 0001 0049 }
;
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
; 0002 0006 {

	.CSEG
_LEDInit_G002:
; 0002 0007 // LED1
; 0002 0008     DDRD.5=1;
	SBI  0x11,5
; 0002 0009 // LED2
; 0002 000A     DDRD.6=1;
	SBI  0x11,6
; 0002 000B }
	RET
;
;
;void LEDRedOn(void)
; 0002 000F {
_LEDRedOn:
; 0002 0010     PORTD.6=0;
	CBI  0x12,6
; 0002 0011 }
	RET
;void LEDRedOff(void)
; 0002 0013 {
_LEDRedOff:
; 0002 0014     PORTD.6=1;
	SBI  0x12,6
; 0002 0015 }
	RET
;
;void LEDGreenOn(void)
; 0002 0018 {
_LEDGreenOn:
; 0002 0019     PORTD.5=0;
	CBI  0x12,5
; 0002 001A }
	RET
;
;void LEDGreenOff(void)
; 0002 001D {
_LEDGreenOff:
; 0002 001E     PORTD.5=1;
	SBI  0x12,5
; 0002 001F }
	RET
;
;static void Timer0Init(void)
; 0002 0022 {
_Timer0Init_G002:
; 0002 0023     ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0002 0024     OCR0=0x00;
	OUT  0x31,R30
; 0002 0025     TCCR0=0x04;             // Prescaling = 64
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0002 0026     TCNT0=131;               // 56 <=>1.6ms;  131 <=>1 ms
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0002 0027     TIMSK |= (1<<TOIE0);    // TC0 overflow interrupt enable
	IN   R30,0x37
	ORI  R30,1
	OUT  0x37,R30
; 0002 0028 }
	RET
;
;void DisableInterrupt(void)
; 0002 002B {
; 0002 002C     EIMSK=0x00;
; 0002 002D }
;
;void EnableInterrupt(void)
; 0002 0030 {
_EnableInterrupt:
; 0002 0031     EIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0002 0032 }
	RET
;
;static void ConfigHardware(void)
; 0002 0035 {
_ConfigHardware_G002:
; 0002 0036     //SDN Si4432
; 0002 0037     DDRB.7=1;
	SBI  0x17,7
; 0002 0038 // SI4432
; 0002 0039     // External Interrupt(s) initialization
; 0002 003A     // INT0: On
; 0002 003B     // INT0 Mode: Failling Edge
; 0002 003C     EICRA=0x02;
	LDI  R30,LOW(2)
	STS  106,R30
; 0002 003D     EICRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3A,R30
; 0002 003E     EIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0002 003F     EIFR=0x01;
	OUT  0x38,R30
; 0002 0040 
; 0002 0041 //CC1101
; 0002 0042     // External Interrupt(s) initialization
; 0002 0043     // INT0: On
; 0002 0044 //    // INT0 Mode: Rising Edge
; 0002 0045 //    EICRA=0x03;
; 0002 0046 //    EICRB=0x00;
; 0002 0047 //    EIMSK=0x01;
; 0002 0048 //    EIFR=0x01;
; 0002 0049 
; 0002 004A     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0002 004B     TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x37,R30
; 0002 004C 
; 0002 004D     ETIMSK=0x00;
	STS  125,R30
; 0002 004E // USART0 initialization
; 0002 004F // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0002 0050 // USART0 Receiver: On
; 0002 0051 // USART0 Transmitter: On
; 0002 0052 // USART0 Mode: Asynchronous
; 0002 0053 // USART0 Baud Rate: 57600 (Double Speed Mode)
; 0002 0054     UCSR0A=0x02;
	LDI  R30,LOW(2)
	OUT  0xB,R30
; 0002 0055     UCSR0B=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0002 0056     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0002 0057     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0002 0058     UBRR0L=0x10;
	LDI  R30,LOW(16)
	OUT  0x9,R30
; 0002 0059 
; 0002 005A // USART1 initialization
; 0002 005B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0002 005C // USART1 Receiver: On
; 0002 005D // USART1 Transmitter: On
; 0002 005E // USART1 Mode: Asynchronous
; 0002 005F // USART1 Baud Rate: 57600 (Double Speed Mode)
; 0002 0060     UCSR1A=0x02;
	LDI  R30,LOW(2)
	STS  155,R30
; 0002 0061     UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  154,R30
; 0002 0062     UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0002 0063     UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0002 0064     UBRR1L=0x10;
	LDI  R30,LOW(16)
	STS  153,R30
; 0002 0065 }
	RET
;
;static void PullupRxTx(void)
; 0002 0068 {
_PullupRxTx_G002:
; 0002 0069     PORTE.0=1; //RXD0 pullup
	SBI  0x3,0
; 0002 006A     PORTD.2=1; //RXD1 pullup
	SBI  0x12,2
; 0002 006B }
	RET
;
;static void Internal_Watchdog_Init()//1s wdt
; 0002 006E {
_Internal_Watchdog_Init_G002:
; 0002 006F     WDTCR=0x1E;
	LDI  R30,LOW(30)
	OUT  0x21,R30
; 0002 0070     WDTCR=0x0E;//disable change WDE
	LDI  R30,LOW(14)
	OUT  0x21,R30
; 0002 0071 }
	RET
;
;
;void HardwareInit(void)
; 0002 0075 {
_HardwareInit:
; 0002 0076     LEDInit();
	CALL _LEDInit_G002
; 0002 0077     ConfigHardware();
	CALL _ConfigHardware_G002
; 0002 0078     Output_Init();
	CALL _Output_Init
; 0002 0079     PullupRxTx();
	CALL _PullupRxTx_G002
; 0002 007A     Timer0Init();
	CALL _Timer0Init_G002
; 0002 007B     Internal_Watchdog_Init();
	CALL _Internal_Watchdog_Init_G002
; 0002 007C     EnableInterrupt();
	CALL _EnableInterrupt
; 0002 007D }
	RET
;
;
;void Reset_WDT(void)
; 0002 0081 {
_Reset_WDT:
; 0002 0082     //internal WDT
; 0002 0083     #asm("WDR") ;//clear WDT
	WDR
; 0002 0084 }
	RET
;
;
;
;
;void putchar0(char c)
; 0002 008A {
; 0002 008B     while(!(UCSR0A & DATA_REGISTER_EMPTY)) {}
;	c -> Y+0
; 0002 008C     UDR0=c;
; 0002 008D }
;
;void putBuffer0(unsigned char *buffer, unsigned char len)
; 0002 0090 {
; 0002 0091     unsigned char i=0;
; 0002 0092     #asm("cli")
;	*buffer -> Y+2
;	len -> Y+1
;	i -> R17
; 0002 0093     for(i=0; i<len;i++)
; 0002 0094     {
; 0002 0095         putchar0(buffer[i]);
; 0002 0096     }
; 0002 0097     #asm("sei")
; 0002 0098 }
;
;
;void putchar1(unsigned char c)
; 0002 009C {
; 0002 009D     while(!(UCSR1A & DATA_REGISTER_EMPTY)) {}
;	c -> Y+0
; 0002 009E     UDR1=c;
; 0002 009F }
;
;void putBuffer1(unsigned char *buffer, unsigned char len)
; 0002 00A2 {
; 0002 00A3     unsigned char i=0;
; 0002 00A4     #asm("cli")
;	*buffer -> Y+2
;	len -> Y+1
;	i -> R17
; 0002 00A5     for(i=0; i<len;i++)
; 0002 00A6     {
; 0002 00A7         putchar1(buffer[i]);
; 0002 00A8     }
; 0002 00A9     #asm("sei")
; 0002 00AA }
;
;
;
;void UART1SendChar(uint8_t c)
; 0002 00AF {
; 0002 00B0     while(!(UCSR1A & DATA_REGISTER_EMPTY)) {}
;	c -> Y+0
; 0002 00B1     UDR1=c;
; 0002 00B2 }
;
;void UART1SendBuffer(uint8_t *buffer, uint16_t len)
; 0002 00B5 {
; 0002 00B6     uint16_t i=0;
; 0002 00B7     #asm("cli")
;	*buffer -> Y+4
;	len -> Y+2
;	i -> R16,R17
; 0002 00B8     for(i=0; i<len;i++)
; 0002 00B9     {
; 0002 00BA         UART1SendChar(buffer[i]);
; 0002 00BB     }
; 0002 00BC     #asm("sei")
; 0002 00BD }
;
;
;void UART0SendChar(uint8_t c)
; 0002 00C1 {
_UART0SendChar:
; 0002 00C2     while(!(UCSR0A & DATA_REGISTER_EMPTY)) {}
;	c -> Y+0
_0x40027:
	SBIC 0xB,5
	RJMP _0x40029
	RJMP _0x40027
_0x40029:
; 0002 00C3     UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0002 00C4 }
	ADIW R28,1
	RET
;
;void UART0SendBuffer(uint8_t *buffer, uint16_t len)
; 0002 00C7 {
_UART0SendBuffer:
; 0002 00C8     uint16_t i=0;
; 0002 00C9     #asm("cli")
	ST   -Y,R17
	ST   -Y,R16
;	*buffer -> Y+4
;	len -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
	cli
; 0002 00CA     for(i=0; i<len;i++)
	__GETWRN 16,17,0
_0x4002B:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRLO PC+3
	JMP _0x4002C
; 0002 00CB     {
; 0002 00CC         UART0SendChar(buffer[i]);
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	CALL _UART0SendChar
; 0002 00CD     }
_0x4002A:
	__ADDWRN 16,17,1
	RJMP _0x4002B
_0x4002C:
; 0002 00CE     #asm("sei")
	sei
; 0002 00CF }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;
;
;
;#ifdef DBG_SEND
;char log1[LOG_MAX_SIZE];
;uint8_t logLen;
;uint16_t logTime;
;
;void DBG_SendStr(const char* str)
; 0002 00D9 {
_DBG_SendStr:
; 0002 00DA 	UART0SendBuffer(str, strlen(str));
;	*str -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	ST   -Y,R31
	ST   -Y,R30
	CALL _UART0SendBuffer
; 0002 00DB }
	ADIW R28,2
	RET
;
;void DBG_SendBuffer(const uint8_t *buf, const uint16_t len)
; 0002 00DE {
; 0002 00DF     UART0SendBuffer(buf, len);
;	*buf -> Y+2
;	len -> Y+0
; 0002 00E0 }
;
;void ConvertHexToStr(uint8_t* ch, uint8_t hex)
; 0002 00E3 {
; 0002 00E4 	if (9 >= (hex>>4))
;	*ch -> Y+1
;	hex -> Y+0
; 0002 00E5 	{
; 0002 00E6 		ch[0] = (hex>>4) + 0x30;
; 0002 00E7 	}
; 0002 00E8 	else
; 0002 00E9 	{
; 0002 00EA 		ch[0] = (hex>>4) + 0x37;
; 0002 00EB 	}
; 0002 00EC 	if (9 >= (0x0F & hex))
; 0002 00ED 	{
; 0002 00EE 		ch[1] = (0x0F & hex) + 0x30;
; 0002 00EF 	}
; 0002 00F0 	else
; 0002 00F1 	{
; 0002 00F2 		ch[1] = (0x0F & hex) + 0x37;
; 0002 00F3 	}
; 0002 00F4 }
;
;static void UART_SendStr(const char* str)
; 0002 00F7 {
; 0002 00F8     UART0SendBuffer(str, strlen(str));
;	*str -> Y+0
; 0002 00F9 }
;
;static void UART_SendBuf(const uint8_t* buf, const uint16_t len)
; 0002 00FC {
; 0002 00FD     UART0SendBuffer(buf, len);
;	*buf -> Y+2
;	len -> Y+0
; 0002 00FE }
;void DBG_SendHexToStr(const uint8_t* buf, const uint16_t len)
; 0002 0100 {
; 0002 0101     uint16_t i;
; 0002 0102 	uint8_t str[3] = {0,0,0x20};//0x20:space
; 0002 0103 	UART_SendStr("\nHEX[ ");
;	*buf -> Y+7
;	len -> Y+5
;	i -> R16,R17
;	str -> Y+2
; 0002 0104 
; 0002 0105 	for (i = 0; i < len; i++)
; 0002 0106 	{
; 0002 0107 		ConvertHexToStr(str, buf[i]);
; 0002 0108 		if ((len - 1) == i)
; 0002 0109 		{
; 0002 010A 			UART_SendBuf(str, sizeof(str) - 1);
; 0002 010B 			break;
; 0002 010C 		}
; 0002 010D 		UART_SendBuf(str, sizeof(str));
; 0002 010E 	}
; 0002 010F 	UART_SendStr(" ]ENDHEX\n");
; 0002 0110 }

	.DSEG
_0x40031:
	.BYTE 0x11
;#endif
;
;void Output_Init(void)
; 0002 0114 {

	.CSEG
_Output_Init:
; 0002 0115     DDRB.3 = 1;//SDO/6/out0
	SBI  0x17,3
; 0002 0116     DDRB.2 = 1;//SDI/7/out1
	SBI  0x17,2
; 0002 0117     DDRB.1 = 1;//SCLK/8/out2
	SBI  0x17,1
; 0002 0118     DDRB.0 = 1;//NSEL/9/out0
	SBI  0x17,0
; 0002 0119     PORTB.3 = 1;
	SBI  0x18,3
; 0002 011A     PORTB.2 = 1;
	SBI  0x18,2
; 0002 011B     PORTB.1 = 1;
	SBI  0x18,1
; 0002 011C     PORTB.0 = 1;
	SBI  0x18,0
; 0002 011D }
	RET
;
;void OutputRun(uint8_t seq, BOOL on_off)
; 0002 0120 {
_OutputRun:
; 0002 0121     if (0 == seq)
;	seq -> Y+1
;	on_off -> Y+0
	LDD  R30,Y+1
	CPI  R30,0
	BREQ PC+3
	JMP _0x40046
; 0002 0122     {
; 0002 0123         if (TRUE == on_off)
	LD   R30,Y
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x40047
; 0002 0124         {
; 0002 0125             PORTB.3 = 0;
	CBI  0x18,3
; 0002 0126         }
; 0002 0127         else
	RJMP _0x4004A
_0x40047:
; 0002 0128         {
; 0002 0129             PORTB.3 = 1;
	SBI  0x18,3
; 0002 012A         }
_0x4004A:
; 0002 012B     }
; 0002 012C     else if (1 == seq)
	RJMP _0x4004D
_0x40046:
	LDD  R30,Y+1
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x4004E
; 0002 012D     {
; 0002 012E         if (TRUE == on_off)
	LD   R30,Y
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x4004F
; 0002 012F         {
; 0002 0130             PORTB.2 = 0;
	CBI  0x18,2
; 0002 0131         }
; 0002 0132         else
	RJMP _0x40052
_0x4004F:
; 0002 0133         {
; 0002 0134             PORTB.2 = 1;
	SBI  0x18,2
; 0002 0135         }
_0x40052:
; 0002 0136     }
; 0002 0137     else if (2 == seq)
	RJMP _0x40055
_0x4004E:
	LDD  R30,Y+1
	CPI  R30,LOW(0x2)
	BREQ PC+3
	JMP _0x40056
; 0002 0138     {
; 0002 0139         if (TRUE == on_off)
	LD   R30,Y
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x40057
; 0002 013A         {
; 0002 013B             PORTB.1 = 0;
	CBI  0x18,1
; 0002 013C         }
; 0002 013D         else
	RJMP _0x4005A
_0x40057:
; 0002 013E         {
; 0002 013F             PORTB.1 = 1;
	SBI  0x18,1
; 0002 0140         }
_0x4005A:
; 0002 0141     }
; 0002 0142 }
_0x40056:
_0x40055:
_0x4004D:
	ADIW R28,2
	RET
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
_put_buff_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BRNE PC+3
	JMP _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ PC+3
	JMP _0x2000011
	RJMP _0x2000012
_0x2000011:
	__CPWRN 16,17,2
	BRSH PC+3
	JMP _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRPL PC+3
	JMP _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__print_G100:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BREQ PC+3
	JMP _0x200001C
	CPI  R18,37
	BREQ PC+3
	JMP _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x10
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x200001F
	CPI  R18,37
	BREQ PC+3
	JMP _0x2000020
	CALL SUBOPT_0x10
	LDI  R17,LOW(0)
	RJMP _0x200001B
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BREQ PC+3
	JMP _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BREQ PC+3
	JMP _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BREQ PC+3
	JMP _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BREQ PC+3
	JMP _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BREQ PC+3
	JMP _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRSH PC+3
	JMP _0x200002A
	CPI  R18,58
	BRLO PC+3
	JMP _0x200002A
	RJMP _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BREQ PC+3
	JMP _0x200002F
	CALL SUBOPT_0x11
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x12
	RJMP _0x2000030
	RJMP _0x2000031
_0x200002F:
	CPI  R30,LOW(0x73)
	BREQ PC+3
	JMP _0x2000032
_0x2000031:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
	RJMP _0x2000034
_0x2000032:
	CPI  R30,LOW(0x70)
	BREQ PC+3
	JMP _0x2000035
_0x2000034:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
	RJMP _0x2000037
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ PC+3
	JMP _0x2000038
_0x2000037:
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x69)
	BREQ PC+3
	JMP _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BREQ PC+3
	JMP _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
	RJMP _0x200003E
_0x200003C:
	CPI  R30,LOW(0x58)
	BREQ PC+3
	JMP _0x200003F
_0x200003E:
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	LDD  R26,Y+11
	TST  R26
	BRMI PC+3
	JMP _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BRNE PC+3
	JMP _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRLO PC+3
	JMP _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x10
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BRNE PC+3
	JMP _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x10
	CPI  R21,0
	BRNE PC+3
	JMP _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRSH PC+3
	JMP _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRSH PC+3
	JMP _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRS R16,4
	RJMP _0x2000060
	RJMP _0x2000061
_0x2000060:
	CPI  R18,49
	BRLO PC+3
	JMP _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE PC+3
	JMP _0x2000063
	RJMP _0x2000062
_0x2000063:
	ORI  R16,LOW(16)
	RJMP _0x2000065
_0x2000062:
	CP   R21,R19
	BRSH PC+3
	JMP _0x2000067
	SBRC R16,0
	RJMP _0x2000067
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
	ORI  R16,LOW(16)
_0x2000065:
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x12
	CPI  R21,0
	BRNE PC+3
	JMP _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x10
	CPI  R21,0
	BRNE PC+3
	JMP _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
_0x2000057:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRSH PC+3
	JMP _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BRNE PC+3
	JMP _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x12
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
	LDI  R17,LOW(0)
_0x200002E:
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x15
	SBIW R30,0
	BREQ PC+3
	JMP _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x15
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	CALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

	.DSEG

	.CSEG
_srand:
	LD   R30,Y
	LDD  R31,Y+1
	CALL __CWD1
	CALL SUBOPT_0x16
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
	CALL SUBOPT_0x16
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
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG
_log1:
	.BYTE 0xC8
_logLen:
	.BYTE 0x1
_HHU_ID1:
	.BYTE 0x1
_HHU_ID0:
	.BYTE 0x1
_Speed_Random:
	.BYTE 0x4
_Output:
	.BYTE 0x2A
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(14)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _Output,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(14)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_Output)
	SBCI R31,HIGH(-_Output)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(14)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _Output,4
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x3:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _OutputRun

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _OutputRun

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(14)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _Output,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL __PUTDZ20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	STD  Z+0,R26
	LDI  R26,LOW(14)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _Output,13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_Speed_Random)
	LDI  R27,HIGH(_Speed_Random)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	MOV  R30,R4
	LDI  R31,0
	CALL __CWD1
	__GETD2N 0x165
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	CALL __PUTDP1
	LDI  R30,LOW(_log1)
	LDI  R31,HIGH(_log1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _DBG_SendStr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	STS  _logLen,R30
	LDI  R30,LOW(_log1)
	LDI  R31,HIGH(_log1)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xF:
	CALL _Reset_WDT
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x10:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
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

;END OF CODE MARKER
__END_OF_CODE:
