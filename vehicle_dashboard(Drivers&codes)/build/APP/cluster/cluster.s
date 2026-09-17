	.file	"cluster.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Cluster_GetCarData,"ax",@progbits
.global	Cluster_GetCarData
	.type	Cluster_GetCarData, @function
Cluster_GetCarData:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(Cluster_Data)
	ldi r25,hi8(Cluster_Data)
/* epilogue start */
	ret
	.size	Cluster_GetCarData, .-Cluster_GetCarData
	.section	.text.Cluster_SetPage,"ax",@progbits
.global	Cluster_SetPage
	.type	Cluster_SetPage, @function
Cluster_SetPage:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts Cluster_Data+27,r24
/* epilogue start */
	ret
	.size	Cluster_SetPage, .-Cluster_SetPage
	.section	.text.FSM_Init,"ax",@progbits
.global	FSM_Init
	.type	FSM_Init, @function
FSM_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	ldd r24,Z+25
	andi r24,lo8(63)
	std Z+25,r24
	std Z+26,__zero_reg__
	sts State_Timer,__zero_reg__
	sts State_Timer+1,__zero_reg__
	sts RPM_Timer,__zero_reg__
	sts RPM_Timer+1,__zero_reg__
/* epilogue start */
	ret
	.size	FSM_Init, .-FSM_Init
	.section	.text.FSM_Run,"ax",@progbits
.global	FSM_Run
	.type	FSM_Run, @function
FSM_Run:
	push r17
	push r28
	push r29
	rcall .
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 3 */
/* stack size = 6 */
.L__stack_usage = 6
	std Y+2,r24
	std Y+3,r25
	mov r17,r22
	std Y+1,r18
	movw r26,r24
	adiw r26,26
	ld r24,X
	sbiw r26,26
	cp r20, __zero_reg__
	breq .L5
	cp r24, __zero_reg__
	breq .L6
	adiw r26,26
	st X,__zero_reg__
.L4:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	ret
.L5:
	cpi r24,lo8(5)
	brne .L8
	ldd r24,Y+2
	ldd r25,Y+3
	call WRN_Highest
	sbiw r24,1
	sbiw r24,3
	brsh .L8
	ldi r24,lo8(6)
	ldd r30,Y+2
	ldd r31,Y+3
	std Z+26,r24
	ldd r24,Z+25
	ori r24,lo8(1<<7)
	std Z+25,r24
	rjmp .L4
.L8:
	ldd r26,Y+2
	ldd r27,Y+3
	adiw r26,26
	ld r30,X
	cpi r30,lo8(8)
	brlo .+2
	rjmp .L9
	ldi r31,0
	subi r30,lo8(-(gs(.L11)))
	sbci r31,hi8(-(gs(.L11)))
	jmp __tablejump2__
	.section	.jumptables.gcc.FSM_Run,"a",@progbits
	.p2align	1
	.type	.L11, @object
.L11:
	.word gs(.L6)
	.word gs(.L15)
	.word gs(.L10)
	.word gs(.L14)
	.word gs(.L13)
	.word gs(.L12)
	.word gs(.L4)
	.word gs(.L10)
	.section	.text.FSM_Run
.L6:
	ldd r30,Y+2
	ldd r31,Y+3
	ldd r24,Z+25
	andi r24,lo8(~(1<<6))
	std Z+25,r24
	ldi r24,lo8(1)
	cp r17, __zero_reg__
	breq .L4
.L32:
	std Z+26,r24
	rjmp .L4
.L15:
	cp r17, __zero_reg__
	breq .L4
	ldi r24,lo8(3)
	ldd r26,Y+2
	ldd r27,Y+3
	adiw r26,26
	st X,r24
	sts State_Timer,__zero_reg__
	sts State_Timer+1,__zero_reg__
	rjmp .L4
.L14:
	lds r24,State_Timer
	lds r25,State_Timer+1
	adiw r24,1
	sts State_Timer,r24
	sts State_Timer+1,r25
	cpi r24,44
	sbci r25,1
.L31:
	brsh .+2
	rjmp .L4
	ldi r24,lo8(2)
	ldd r30,Y+2
	ldd r31,Y+3
	rjmp .L32
.L10:
	ldd r31,Y+1
	cp r31, __zero_reg__
	brne .+2
	rjmp .L4
	ldi r24,lo8(4)
	ldd r26,Y+2
	ldd r27,Y+3
	adiw r26,26
	st X,r24
	sts State_Timer,__zero_reg__
	sts State_Timer+1,__zero_reg__
.L20:
	sts RPM_Timer,__zero_reg__
	sts RPM_Timer+1,__zero_reg__
	rjmp .L4
.L13:
	lds r24,State_Timer
	lds r25,State_Timer+1
	adiw r24,1
	sts State_Timer,r24
	sts State_Timer+1,r25
	ldd r30,Y+2
	ldd r31,Y+3
	ldd r18,Z+2
	ldd r19,Z+3
	cpi r18,-11
	sbci r19,1
	brlo .L18
	lds r18,RPM_Timer
	lds r19,RPM_Timer+1
	subi r18,-1
	sbci r19,-1
	sts RPM_Timer,r18
	sts RPM_Timer+1,r19
	cpi r18,50
	cpc r19,__zero_reg__
	brlo .L19
	ldi r24,lo8(5)
	ldd r26,Y+2
	ldd r27,Y+3
	adiw r26,26
	st X,r24
	ld r24,-X
	sbiw r26,25
	ori r24,lo8(1<<6)
.L33:
	adiw r26,25
	st X,r24
	rjmp .L4
.L18:
	sts RPM_Timer,__zero_reg__
	sts RPM_Timer+1,__zero_reg__
.L19:
	cpi r24,-12
	sbci r25,1
	rjmp .L31
.L12:
	ldd r30,Y+2
	ldd r31,Y+3
	ldd r24,Z+2
	ldd r25,Z+3
	cpi r24,44
	sbci r25,1
	brsh .L20
	lds r24,RPM_Timer
	lds r25,RPM_Timer+1
	adiw r24,1
	sts RPM_Timer,r24
	sts RPM_Timer+1,r25
	cpi r24,100
	cpc r25,__zero_reg__
	brsh .+2
	rjmp .L4
	ldi r24,lo8(7)
	ldd r26,Y+2
	ldd r27,Y+3
	adiw r26,26
	st X,r24
	ld r24,-X
	sbiw r26,25
	andi r24,lo8(~(1<<6))
	rjmp .L33
.L9:
	ldd r30,Y+2
	ldd r31,Y+3
	std Z+26,__zero_reg__
	rjmp .L4
	.size	FSM_Run, .-FSM_Run
	.section	.bss.Cluster_Data,"aw",@nobits
	.type	Cluster_Data, @object
	.size	Cluster_Data, 32
Cluster_Data:
	.zero	32
	.section	.bss.RPM_Timer,"aw",@nobits
	.type	RPM_Timer, @object
	.size	RPM_Timer, 2
RPM_Timer:
	.zero	2
	.section	.bss.State_Timer,"aw",@nobits
	.type	State_Timer, @object
	.size	State_Timer, 2
State_Timer:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
