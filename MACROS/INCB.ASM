*
*INCREMENT BYTE SIZED MEMORY
*	INCM	ADDR
*A14 DESTROYED
**
INCB	.macro	P1
	MOVB	:P1:,A14
	INC	A14
	MOVB	A14,:P1:
	.endm


