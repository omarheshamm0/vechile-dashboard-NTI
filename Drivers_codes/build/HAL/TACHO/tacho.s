	.file	"tacho.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.TAC_OnPulse,"ax",@progbits
.global	TAC_OnPulse
	.type	TAC_OnPulse, @function
TAC_OnPulse:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_pulseCount
	lds r25,g_pulseCount+1
	adiw r24,1
	sts g_pulseCount+1,r25
	sts g_pulseCount,r24
/* epilogue start */
	ret
	.size	TAC_OnPulse, .-TAC_OnPulse
	.section	.text.TAC_Init,"ax",@progbits
.global	TAC_Init
	.type	TAC_Init, @function
TAC_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r22,lo8(3)
	ldi r24,0
	call EXTI_SetSense
	ldi r22,lo8(gs(TAC_OnPulse))
	ldi r23,hi8(gs(TAC_OnPulse))
	ldi r24,0
	call EXTI_SetCallback
	ldi r24,0
	jmp EXTI_Enable
	.size	TAC_Init, .-TAC_Init
	.section	.text.TAC_Task250ms,"ax",@progbits
.global	TAC_Task250ms
	.type	TAC_Task250ms, @function
TAC_Task250ms:
	push r16
	push r17
	push r28
	push r29
	rcall .
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 4 */
/* stack size = 8 */
.L__stack_usage = 8
	std Y+3,r24
	std Y+4,r25
	std Y+1,r22
	std Y+2,r23
	call INTERRUPT_DisableGlobal
	lds r16,g_pulseCount
	lds r17,g_pulseCount+1
	sts g_pulseCount+1,__zero_reg__
	sts g_pulseCount,__zero_reg__
	call INTERRUPT_EnableGlobal
	ldd r30,Y+1
	ldd r31,Y+2
	ldd r20,Z+25
	cp r20, __zero_reg__
	breq .L4
	movw r18,r16
	ldi r26,lo8(-16)
	ldi r27,0
	call __umulhisi3
	mov r18,r20
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
.L5:
	ldd r30,Y+3
	ldd r31,Y+4
	std Z+2,r18
	std Z+3,r19
	cpi r18,-11
	ldi r31,1
	cpc r19,r31
	brlo .L6
	ldd r30,Y+3
	ldd r31,Y+4
	ldd r24,Z+25
	ori r24,lo8(1<<6)
.L8:
	std Z+25,r24
.L3:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	ret
.L4:
	ldi r24,lo8(120)
	mul r24,r16
	movw r18,r0
	mul r24,r17
	add r19,r0
	clr __zero_reg__
	rjmp .L5
.L6:
	cpi r18,44
	sbci r19,1
	brsh .L3
	ldd r30,Y+3
	ldd r31,Y+4
	ldd r24,Z+25
	andi r24,lo8(~(1<<6))
	rjmp .L8
	.size	TAC_Task250ms, .-TAC_Task250ms
	.section	.bss.g_pulseCount,"aw",@nobits
	.type	g_pulseCount, @object
	.size	g_pulseCount, 2
g_pulseCount:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
