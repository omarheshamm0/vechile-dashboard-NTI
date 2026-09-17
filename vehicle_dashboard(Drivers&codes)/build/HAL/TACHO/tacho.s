	.file	"tacho.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.__vector_1,"ax",@progbits
.global	__vector_1
	.type	__vector_1, @function
__vector_1:
	__gcc_isr 1
	push r25
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 1...5 */
.L__stack_usage = 1 + __gcc_isr.n_pushed
	lds r24,s_tachoPulseCount
	lds r25,s_tachoPulseCount+1
	adiw r24,1
	sts s_tachoPulseCount+1,r25
	sts s_tachoPulseCount,r24
/* epilogue start */
	pop r25
	__gcc_isr 2
	reti
	__gcc_isr 0,r24
	.size	__vector_1, .-__vector_1
	.section	.text.TAC_Init,"ax",@progbits
.global	TAC_Init
	.type	TAC_Init, @function
TAC_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cbi 0x11,2
	sbi 0x12,2
	in r24,0x35
	andi r24,lo8(-4)
	out 0x35,r24
	in r24,0x35
	ori r24,lo8(3)
	out 0x35,r24
	in r24,0x3b
	ori r24,lo8(64)
	out 0x3b,r24
/* epilogue start */
	ret
	.size	TAC_Init, .-TAC_Init
	.section	.text.TAC_Task250ms,"ax",@progbits
.global	TAC_Task250ms
	.type	TAC_Task250ms, @function
TAC_Task250ms:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
	movw r30,r22
	or r24,r25
	breq .L3
	sbiw r30,0
	breq .L3
	ldd r24,Z+25
	cp r24, __zero_reg__
	breq .L3
	in r24,__SREG__
/* #APP */
 ;  38 "HAL/TACHO/tacho.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r18,s_tachoPulseCount
	lds r19,s_tachoPulseCount+1
	sts s_tachoPulseCount+1,__zero_reg__
	sts s_tachoPulseCount,__zero_reg__
	out __SREG__,r24
	ldi r26,lo8(-16)
	ldi r27,0
	call __umulhisi3
	ldd r18,Z+25
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	std Y+2,r18
	std Y+3,r19
.L3:
/* epilogue start */
	pop r29
	pop r28
	ret
	.size	TAC_Task250ms, .-TAC_Task250ms
	.section	.bss.s_tachoPulseCount,"aw",@nobits
	.type	s_tachoPulseCount, @object
	.size	s_tachoPulseCount, 2
s_tachoPulseCount:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
