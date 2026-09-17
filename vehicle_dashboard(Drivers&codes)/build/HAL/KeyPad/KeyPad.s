	.file	"KeyPad.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.KeyPad_Init,"ax",@progbits
.global	KeyPad_Init
	.type	KeyPad_Init, @function
KeyPad_Init:
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 4 */
.L__stack_usage = 4
	std Y+1,r24
	cpi r24,lo8(4)
	brlo .L7
.L4:
	ldi r24,lo8(1)
.L6:
	ldi r25,0
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	ret
.L7:
	std Y+2,__zero_reg__
.L2:
	ldi r20,lo8(1)
	ldd r22,Y+2
	ldd r24,Y+1
	call GPIO_SetPinDirection
	or r24,r25
	brne .L4
	ldi r20,lo8(1)
	ldd r22,Y+2
	ldd r24,Y+1
	call GPIO_SetPinValue
	or r24,r25
	brne .L4
	ldd r24,Y+2
	subi r24,lo8(-(1))
	std Y+2,r24
	cpi r24,lo8(4)
	brne .L2
.L5:
	ldi r20,lo8(2)
	ldd r22,Y+2
	ldd r24,Y+1
	call GPIO_SetPinDirection
	or r24,r25
	brne .L4
	ldd r24,Y+2
	subi r24,lo8(-(1))
	std Y+2,r24
	cpi r24,lo8(7)
	brne .L5
	ldi r20,0
	ldi r22,lo8(7)
	ldd r24,Y+1
	call GPIO_SetPinDirection
	movw r18,r24
	ldi r24,lo8(1)
	or r18,r19
	brne .L6
	ldi r24,0
	rjmp .L6
	.size	KeyPad_Init, .-KeyPad_Init
	.section	.text.KeyPad_GetPressedKey,"ax",@progbits
.global	KeyPad_GetPressedKey
	.type	KeyPad_GetPressedKey, @function
KeyPad_GetPressedKey:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 8 */
.L__stack_usage = 8
	std Y+2,r24
	movw r14,r22
	cpi r24,lo8(4)
	brsh .L11
	or r22,r23
	breq .L11
	ldi r17,0
.L15:
	ldi r22,lo8(-1)
	ldd r24,Y+2
	call GPIO_SetPortValue
	or r24,r25
	brne .L11
	ldi r20,0
	mov r22,r17
	ldd r24,Y+2
	call GPIO_SetPinValue
	or r24,r25
	brne .L11
	ldi r16,lo8(4)
.L14:
	movw r20,r28
	subi r20,-1
	sbci r21,-1
	mov r22,r16
	ldd r24,Y+2
	call GPIO_GetPinValue
	movw r18,r24
	or r24,r25
	brne .L11
	ldd r24,Y+1
	cpse r24,__zero_reg__
	rjmp .L12
	subi r17,lo8(-(-1))
	mov r25,r17
	lsl r25
	add r25,r17
	add r25,r16
	movw r30,r14
	st Z,r25
.L10:
	movw r24,r18
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret
.L12:
	subi r16,lo8(-(1))
	cpi r16,lo8(7)
	brne .L14
	subi r17,lo8(-(1))
	cpi r17,lo8(4)
	brne .L15
.L11:
	ldi r18,lo8(1)
	ldi r19,0
	rjmp .L10
	.size	KeyPad_GetPressedKey, .-KeyPad_GetPressedKey
	.ident	"GCC: (GNU) 15.2.0"
