	.MLIB	"HHMACS.LIB"
	.FILE	"HHAFUNC.ASM"
	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST

**************************************************************************
*								         *
* 	COPYRIGHT (C) 1994 MIDWAY MANUFACTURING COMPANY.		 *
* 		       ALL RIGHTS RESERVED.				 *
*								         *
**************************************************************************

	.INCLUDE	"HH.INC"
	.include	"hhafunc.e"
	.include	"hhsnd.g"
	.include	"hhutil.g"
	.include	"hhd.g"
	.include	"hhproc.g"
	.include	"hhram.g"
	.include	"hhpall.g"

; end of include files


	.TEXT

**************************************************************************
*								         *
* A_nFUNCS - CALL n ANIMATION SUBROUTINES				 *
* 									 *
* PASS:									 *
* A8 = OBJECT								 *
* AARG+,L    = 1ST SUBROUTINE ADDRESS					 *
* AARG+,W(L) = 1ST SUBROUTINE PARAMETERS				 *
* .									 *
* .									 *
* .									 *
* AARG+,L    = nTH SUBROUTINE ADDRESS					 *
* AARG+,W(L) = nTH SUBROUTINE PARAMETERS				 *
*								         *
**************************************************************************

A_5FUNCS
	CALLA	GETAFARG_LONG
	CALL	A0
A_4FUNCS
	CALLA	GETAFARG_LONG
	CALL	A0
A_3FUNCS
	CALLA	GETAFARG_LONG
	CALL	A0
A_2FUNCS
	CALLA	GETAFARG_LONG
	CALL	A0
	CALLA	GETAFARG_LONG
	JUMP	A0

**************************************************************************
*								         *
* A_DO_SOUND - CALL do_sound						 *
* 									 *
* PASS:									 *
* A8 = OBJECT								 *
* AARG+,W = SOUND INDEX							 *
*								         *
**************************************************************************

A_DO_SOUND
	CALLA	GETAFARG_WORD
	MOVE	A0,A4
	JAUC	do_sound

**************************************************************************
*								         *
* A_RAND_BRANCH - BRANCH TO FRAME ON RANDOM EVENT			 *
*								         *
* A8 = OBJECT								 *
* AARG+,W = PROBABILITY (0-1023)					 *
* AARG+,L = BRANCH ADDRESS						 *
*								         *
**************************************************************************
A_RAND_BRANCH
	CALLA	GETAFARG_WORD
	CALLA	RANDPER
	JRNC	A_RB_NOPE			;BR=DON'T BRANCH

	CALLA	GETAFARG_LONG			;BRANCH
	MOVE	A0,*A8(ANIMFRM),L
A_RB_NOPE
	RETS

**************************************************************************
*								         *
* A_RAND_JUMP - JUMP TO ANIMATION ON RANDOM EVENT			 *
*								         *
* A8 = OBJECT								 *
* AARG+,W = PROBABILITY (0-1023)					 *
* AARG+,L = JUMP ADDRESS						 *
*								         *
**************************************************************************
A_RAND_JUMP
	CALLA	GETAFARG_WORD
	CALLA	RANDPER
	JRNC	A_RJ_NOPE			;BR=DON'T JUMP

	CALLA	GETAFARG_LONG			;JUMP
	MOVE	A0,*A8(ANIMSCR),L
	MOVE	A0,*A8(ANIMFRM),L
A_RJ_NOPE
	RETS

**************************************************************************
*								         *
* A_GOSUB - JUMP TO SUBROUTINE						 *
*	    NOTE: SUBROUTINES CANNOT BE NESTED!				 *
*								         *
* A8 = Ptr to object							 *
* AARG+,L = SUBROUTINE ADDRESS						 *
*								         *
**************************************************************************

A_GOSUB
	MOVE	*A8(ANIMSCR),*A8(ANIMRETSCR),L
	MOVE	*A8(ANIMFRM),*A8(ANIMRETFRM),L
	JAUC	A_ANIMGO

**************************************************************************
*								         *
* A_RETURN - RETURN FROM SUBROUTINE					 *
*								         *
* A8 = Ptr to object							 *
*								         *
**************************************************************************

A_RETURN
	MOVE	*A8(ANIMRETSCR),*A8(ANIMSCR),L
	MOVE	*A8(ANIMRETFRM),*A8(ANIMFRM),L
	RETS

**************************************************************************
*								         *
* 	A_CREATEP							 *
* 									 *
* 	Anim func to Create a process.					 *
* 									 *
* 	AARG+,W = Process I.D.						 *
* 	AARG+,L = Process Address					 *
* 	A8 - A11 are passed to the process				 *
*								         *
**************************************************************************
A_CREATEP
	CALLA	GETAFARG_WORD
	MOVE	A0,A1
	CALLA	GETAFARG_LONG
	MOVE	A0,A7
	JAUC	GETPRC

**************************************************************************
*								         *
* A_SET_ANIMLOOP - Anim func to initialize the Animation Loop count.	 *
* A8 = Ptr to object							 *
* AARG+,W = Initial value						 *
*								         *
**************************************************************************
A_SET_ANIMLOOP
	calla	GETAFARG_WORD
	movb	A0,*A8(ANIMLOOP)
	rets

**************************************************************************
*								         *
* A_Anim_DSJ - Anim func to decrement ANIMLOOP count and branch		 *
* 		if not 0.						 *
* A8 = Ptr to object							 *
* AARG+,L = Branch if ANIMLOOP <> 0					 *
*								         *
**************************************************************************
A_Anim_DSJ
	movb	*A8(ANIMLOOP),A14
	dec	A14
	movb	A14,*A8(ANIMLOOP)
	jrz	AAD_X
	calla	GETAFARG_LONG
;	move	A0,A1
;	jruc	SetAnim
	MOVE	A0,*A8(ANIMFRM),L
AAD_X
	rets

**************************************************************************
*								         *
* 	A_Anim_Rel_DSJ							 *
* 									 *
* 	Anim func to decrement a byte sized variable relative to the	 *
* 	beginning of the object, and branches the animation if not 0.	 *
* 									 *
* 	A8 = Ptr to object						 *
* 	AARG+,W = Relative offset of byte loop counter			 *
* 	AARG+,L = Branch if loop counter <> 0				 *
*								         *
**************************************************************************
A_Anim_Rel_DSJ
	CALLA	GETAFARG_WORD		;Get the offset
	MOVE	A8,A1
	ADD	A0,A1			;And index into the object

	MOVB	*A1,A14
	DEC	A14   			;Decrement the loop counter
	MOVB	A14,*A1
	JRZ	AARD_X			;BR = loop counter = 0

	CALLA	GETAFARG_LONG		;Grab the branch address
	MOVE	A0,A1
	JRUC	SetAnim			;And stuff it
AARD_X
	RETS

**************************************************************************
*								         *
* A_Set_Rel_Byte - Anim func to set a given byte relative to the current *
* 		object to a given value.				 *
* 									 *
* AARG+,W = Offset in to object						 *
* AARG+,W = Value to store						 *
*								         *
**************************************************************************
A_Set_Rel_Byte
	CALLA	GETAFARG_WORD		;Get the offset
	MOVE	A8,A1
	ADD	A0,A1			;And index into the object
	CALLA	GETAFARG_WORD		;Get the value
	MOVB	A0,*A1			;And store it
	RETS

**************************************************************************
*								         *
* 	A_Set_Rel_Byte_Head						 *
* 									 *
* 	Anim func to set a given byte in the head object of a		 *
* 	multi-parter that is relative to the beginning of the		 *
* 	object block.							 *
* 									 *
* 	A8 = Ptr to any object in a multi-parter			 *
* 	AARG+,W = Offset in to object					 *
* 	AARG+,W = Value to store					 *
*								         *
**************************************************************************
A_Set_Rel_Byte_Head
	CALLA	GETAFARG_WORD		;Get the offset
	MOVE	A0,A1			;Save it here
	CALLA	GETAFARG_WORD		;Get the value to store
	CALLA	GET_HEAD_PART		;Grab the head part
	ADD	A8,A1			;Offset into object block
	MOVB	A0,*A1			;And store value
	RETS

**************************************************************************
*								         *
* 	A_RAND_REL_BYTE							 *
* 									 *
* 	Anim func to set a given byte relative to the current object	 *
* 	to a random value in the given range.				 *
* 									 *
* 	A8 = Ptr to object						 *
* 	AARG+,W = Lower bound of random value				 *
* 	AARG+,W = Upper bound of random value				 *
* 	AARG+,W = Offset into object					 *
*								         *
**************************************************************************
A_RAND_REL_BYTE
	CALLA	GETAFARG_LONG		;Get the random values
	MOVY	A0,A1
	SRA	16,A1			;Split 'em up
	ZEXT	A0
	CALLA	RANGERND		;And make it into something
	MOVE	A0,A2
	CALLA	GETAFARG_WORD		;Get the offset
	ADD	A8,A0
	MOVB	A2,*A0
	RETS

**************************************************************************
*								         *
* A_Set_Rel_Word - Anim func to set a given word relative to the current *
* 		object to a given value.				 *
* 									 *
* AARG+,W = Offset in to object						 *
* AARG+,W = Value to store						 *
*								         *
**************************************************************************
A_Set_Rel_Word
	CALLA	GETAFARG_WORD		;Get the offset
	MOVE	A8,A1
	ADD	A0,A1			;And index into the object
	CALLA	GETAFARG_WORD		;Get the value
	MOVE	A0,*A1,W		;And store it
	RETS

**************************************************************************
*								         *
* 	A_Set_Rel_Word_Head						 *
* 									 *
* 	Anim func to set a given Word in the head object of a		 *
* 	multi-parter that is relative to the beginning of the		 *
* 	object block.							 *
* 									 *
* 	A8 = Ptr to any object in a multi-parter			 *
* 	AARG+,W = Offset in to object					 *
* 	AARG+,W = Value to store					 *
*								         *
**************************************************************************
A_Set_Rel_Word_Head
	CALLA	GETAFARG_WORD		;Get the offset
	MOVE	A0,A1			;Save it here
	CALLA	GETAFARG_WORD		;Get the value to store
	CALLA	GET_HEAD_PART		;Grab the head part
	ADD	A8,A1			;Offset into object block
	MOVE	A0,*A1,W		;And store value
	RETS

**************************************************************************
*								         *
* A_Set_Rel_Long - Anim func to set a given long word relative to the    *
* 		current object to a given value.			 *
* 									 *
* AARG+,W = Offset in to object						 *
* AARG+,L = Value to store						 *
*								         *
**************************************************************************
A_Set_Rel_Long
	CALLA	GETAFARG_WORD		;Get the offset
	MOVE	A8,A1
	ADD	A0,A1			;And index into the object
	CALLA	GETAFARG_LONG		;Get the value
	MOVE	A0,*A1,L		;And store it
	RETS

**************************************************************************
*								         *
* A_Set_Var_Byte - Anim func to set a given variable of byte length	 *
* 		to a given value.					 *
* AARG+,L = Address of variable						 *
* AARG+,W = Value to store						 *
*								         *
**************************************************************************
A_Set_Var_Byte
	calla	GETAFARG_LONG
	move	A0,A1
	calla	GETAFARG_WORD
	movb	A0,*A1
	rets

**************************************************************************
*								         *
* A_Set_Var_Word - Anim func to set a given variable of word length	 *
* 		to a given value.					 *
* AARG+,L = Address of variable						 *
* AARG+,W = Value to store						 *
*								         *
**************************************************************************
A_Set_Var_Word
	calla	GETAFARG_LONG
	move	A0,A1
	calla	GETAFARG_WORD
	move	A0,*A1,W
	rets

**************************************************************************
*								         *
* A_SET_OYACCEL - ANIM FUNC TO SET THE OYACCEL FIELD OF AN OBJECT.	 *
* A8 = OBJECT								 *
* AARG+,W = NEW YACCEL							 *
*								         *
**************************************************************************
A_SET_OYACCEL
	CALLA	GETAFARG_WORD
	MOVE	A0,*A8(OYACCEL),W
	RETS

**************************************************************************
*								         *
* A_OBJ_ON_CHANGE_PAL - ANIM FUNC THAT DOES JUST WHAT IT SAYS.		 *
* A8 = OBJECT								 *
* AARG+,L = NEW PALETTE							 *
*								         *
**************************************************************************
A_OBJ_ON_CHANGE_PAL
	CALLA	OBJ_ON
	JAUC	A_CHANGE_PAL

SetAnim_AFARG
	CALLA	GETAFARG_LONG
	MOVE	A0,A1
SetAnim
	MOVE	A1,*A8(ANIMFRM),L
	MOVE	A1,*A8(ANIMSCR),L
AFB_X
	RETS

**************************************************************************
*								         *
* A_RAND_ANIMSLP - ANIM FUNC TO SET A RANDOM AnimSLP VALUE IN THE	 *
* 		GIVEN RANGE						 *
* A8 = OBJECT TO SET							 *
* AARG+,W = LOWEST SLEEP						 *
* AARG+,W = HIGHEST SLEEP						 *
*								         *
**************************************************************************
A_RAND_ANIMSLP
	CALLA	GETAFARG_LONG
	MOVY	A0,A1
	SRA	16,A1
	ZEXT	A0
	CALLA	RANGERND
	MOVB	A0,*A8(ANIMSLP)
	RETS

**************************************************************************
*								         *
* A_SET_OXZVEL - ANIM FUNC TO SET THE X AND Z VELOCITIES OF AN OBJECT.	 *
* 		 IF OBJECT IS H-FLIPPED, THE X VALUE IS NEGATED.	 *
* A8 = PTR TO OBJECT							 *
* AARG+,L = OXVEL							 *
* AARG+,L = OZVEL							 *
*								         *
**************************************************************************

A_SET_OXZVEL
	CALLA	GETAFARG_LONG
	MOVE	A0,*A8(OXVEL),L
	CALLA	GETAFARG_LONG
	MOVE	A0,*A8(OZVEL),L
	RETS

A_CLR_OXZVEL
	CLR	A14
	MOVE	A14,*A8(OXVEL),L
	MOVE	A14,*A8(OZVEL),L
	RETS

**************************************************************************
*								         *
* A_SET_OXVEL - ANIM FUNC TO SET THE X VELOCITY OF AN OBJECT. IF	 *
* 		OBJECT IS FLIPPED, THE VALUE IS NEGATED.		 *
* A8 = PTR TO OBJECT							 *
* AARG+,L = OXVEL							 *
*								         *
**************************************************************************
A_SET_OXVEL
	CALLA	GETAFARG_LONG
	MOVE	*A8(OCTRL),A14,W
	BTST	B_FLIPH,A14
	JRZ	ASO_NOW
	NEG	A0
ASO_NOW
	MOVE	A0,*A8(OXVEL),L
	RETS

**************************************************************************
*								         *
* A_SET_OYVEL - ANIM FUNC TO SET THE Y VELOCITY OF AN OBJECT	         *
* A8 = PTR TO OBJECT							 *
* AARG+,L = OYVEL							 *
*								         *
**************************************************************************
A_SET_OYVEL
	CALLA	GETAFARG_LONG
	MOVE	A0,*A8(OYVEL),L
	RETS

**************************************************************************
*								         *
* A_STRT_ANIM - ANIM FUNC TO START ANOTHER ANIMATION.			 *
* A8 = PTR TO OBJECT TO START						 *
* AARG+,L = PTR TO ANIM SCRIPT						 *
*								         *
**************************************************************************
A_STRT_ANIM
	CALLA	GETAFARG_LONG
	MOVE	A0,A1
	JAUC	STRT_ANIM

**************************************************************************
*								         *
* A_SET_OZVEL - ANIM FUNC TO SET THE OZVEL FIELD OF AN OBJECT.		 *
* A8 = PTR TO OBJECT							 *
* AARG+,L = NEW OZVEL							 *
*								         *
**************************************************************************
A_SET_OZVEL
	CALLA	GETAFARG_LONG
;	MOVE	A8,A7
;	CALLA	GET_HEAD_PART
	MOVE	A0,*A8(OZVEL),L
	RETS


**************************************************************************
*								         *
* A_CLR_OXVEL - ANIM FUNC TO CLR THE OXVEL FIELD OF AN OBJECT.		 *
* A8 = PTR TO OBJECT							 *
*								         *
**************************************************************************
A_CLR_OXVEL
;	CALLA	GET_HEAD_PART
	CLRM	*A8(OXVEL),L
	RETS

**************************************************************************
*								         *
* A_INIT_ANIMSLP - Anim Func to initialize the AnimSLP field of		 *
* 		a given object.						 *
* A8 = Ptr to Object							 *
* AARG+,W = Initial Value						 *
*								         *
**************************************************************************
A_INIT_ANIMSLP
	CALLA	GETAFARG_WORD
	MOVB	A0,*A8(ANIMSLP)
	RETS

**************************************************************************
*								         *
* A_INC_ANIMSLP - ANIM FUNC TO INCREMENT THE AnimSLP FIELD OF		 *
* 		A GIVEN OBJECT BY 1.					 *
* A8 = PTR TO OBJECT							 *
* AARG+,W = MAX ANIMSLP VALUE						 *
*								         *
**************************************************************************
A_INC_ANIMSLP
	CALLA	GETAFARG_WORD
	MOVB	*A8(ANIMSLP),A14
	INC	A14
	CMP	A0,A14
	JRLS	AIA_STUFF
	MOVE	A0,A14
AIA_STUFF
	MOVB	A14,*A8(ANIMSLP)
	RETS
