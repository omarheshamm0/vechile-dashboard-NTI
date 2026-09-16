	.file	"speedo.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SPD_Init,"ax",@progbits
.global	SPD_Init
	.type	SPD_Init, @function
SPD_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cbi 0x11,5
	sbi 0x12,5
	out 0x2f,__zero_reg__
	ldi r24,lo8(7)
	out 0x2e,r24
	out 0x2c+1,__zero_reg__
	out 0x2c,__zero_reg__
/* epilogue start */
	ret
	.size	SPD_Init, .-SPD_Init
	.section	.text.SPD_Task100ms,"ax",@progbits
.global	SPD_Task100ms
	.type	SPD_Task100ms, @function
SPD_Task100ms:
	push r6
	push r7
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,16
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 16 */
/* stack size = 29 */
.L__stack_usage = 29
	movw r6,r24
	or r24,r25
	brne .+2
	rjmp .L2
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	brne .+2
	rjmp .L2
	movw r30,r22
	ldd r9,Z+22
	cp r9, __zero_reg__
	brne .+2
	rjmp .L2
	in r14,0x2c
	in r15,0x2c+1
	out 0x2c+1,__zero_reg__
	out 0x2c,__zero_reg__
	ldd r26,Z+23
	ldd r27,Z+24
	movw r18,r26
	ldi r20,0
	ldi r21,0
	std Y+9,r18
	std Y+10,r19
	std Y+11,__zero_reg__
	std Y+12,__zero_reg__
	std Y+13,__zero_reg__
	std Y+14,__zero_reg__
	std Y+15,__zero_reg__
	std Y+16,__zero_reg__
	movw r16,r20
	ldd r22,Y+9
	ldd r23,Y+10
	ldd r24,Y+11
	ldd r25,Y+12
	movw r18,r14
	call __umulsidi3
	ldi r31,lo8(-96)
	mov r10,r31
	ldi r31,lo8(-116)
	mov r11,r31
	movw r12,r16
	movw r14,r16
	call __muldi3
	std Y+1,r18
	std Y+2,r19
	std Y+3,r20
	std Y+4,r21
	std Y+5,r22
	std Y+6,r23
	std Y+7,r24
	std Y+8,r25
	mov r16,r9
	movw r22,r16
	movw r24,r12
	ldi r18,lo8(64)
	ldi r19,lo8(66)
	ldi r20,lo8(15)
	ldi r21,0
	call __umulsidi3
	movw r10,r18
	movw r12,r20
	movw r14,r22
	movw r16,r24
	ldd r18,Y+1
	ldd r19,Y+2
	ldd r20,Y+3
	ldd r21,Y+4
	ldd r22,Y+5
	ldd r23,Y+6
	ldd r24,Y+7
	ldd r25,Y+8
	call __udivdi3
	movw r30,r6
	st Z,r18
	std Z+1,r19
.L2:
/* epilogue start */
	adiw r28,16
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r7
	pop r6
	ret
	.size	SPD_Task100ms, .-SPD_Task100ms
.global	__udivdi3
.global	__muldi3
	.ident	"GCC: (GNU) 15.2.0"
