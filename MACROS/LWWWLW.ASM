LWWWLW	.macro	a1,a2,a3,a4,a5,a6
	.long	:a1:
	.word	:a2:,:a3:,:a4:
	.long	:a5:
	.WORD	:a6:
	.endm
