*
*DISABLE BLACKPAL
*A14 DESTROYED
*
BLACKOFF .macro
	CLR	A14
	MOVE	A14,@BLACKOUT,W
	.endm

