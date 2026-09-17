	.file	"INTERRUPT.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.INTERRUPT_EnableGlobal,"ax",@progbits
.global	INTERRUPT_EnableGlobal
	.type	INTERRUPT_EnableGlobal, @function
INTERRUPT_EnableGlobal:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
/* #APP */
 ;  25 "MCAL/INTERRUPT/INTERRUPT.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	INTERRUPT_EnableGlobal, .-INTERRUPT_EnableGlobal
	.section	.text.INTERRUPT_DisableGlobal,"ax",@progbits
.global	INTERRUPT_DisableGlobal
	.type	INTERRUPT_DisableGlobal, @function
INTERRUPT_DisableGlobal:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
/* #APP */
 ;  31 "MCAL/INTERRUPT/INTERRUPT.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	INTERRUPT_DisableGlobal, .-INTERRUPT_DisableGlobal
	.section	.text.EXTI_SetSense,"ax",@progbits
.global	EXTI_SetSense
	.type	EXTI_SetSense, @function
EXTI_SetSense:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(3)
	brsh .L11
	cpi r22,lo8(4)
	brsh .L11
	cpi r24,lo8(1)
	brsh .L5
	in r24,0x35
	andi r24,lo8(-4)
	or r24,r22
	out 0x35,r24
.L6:
	ldi r24,0
	ldi r25,0
	ret
.L5:
	brne .L7
	in r24,0x35
	lsl r22
	lsl r22
	andi r24,lo8(-13)
	or r22,r24
	out 0x35,r22
	rjmp .L6
.L7:
	ldi r24,lo8(-2)
	add r24,r22
	cpi r24,lo8(2)
	brsh .L11
	in r24,0x34
	cpi r22,lo8(3)
	brne .L8
	ori r24,lo8(64)
.L12:
	out 0x34,r24
	rjmp .L6
.L8:
	andi r24,lo8(-65)
	rjmp .L12
.L11:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	EXTI_SetSense, .-EXTI_SetSense
	.section	.text.EXTI_ClearFlag,"ax",@progbits
.global	EXTI_ClearFlag
	.type	EXTI_ClearFlag, @function
EXTI_ClearFlag:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(3)
	brsh .L16
	cpi r24,lo8(1)
	brlo .L17
	brne .L18
	ldi r24,lo8(-128)
.L15:
	out 0x3a,r24
	ldi r24,0
	ldi r25,0
	ret
.L17:
	ldi r24,lo8(64)
	rjmp .L15
.L18:
	ldi r24,lo8(32)
	rjmp .L15
.L16:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	EXTI_ClearFlag, .-EXTI_ClearFlag
	.section	.text.EXTI_Enable,"ax",@progbits
.global	EXTI_Enable
	.type	EXTI_Enable, @function
EXTI_Enable:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(3)
	brsh .L22
	cpi r24,lo8(1)
	brlo .L23
	brne .L24
	ldi r24,lo8(-128)
.L21:
	out 0x3a,r24
	in r25,0x3b
	or r24,r25
	out 0x3b,r24
	ldi r24,0
	ldi r25,0
	ret
.L23:
	ldi r24,lo8(64)
	rjmp .L21
.L24:
	ldi r24,lo8(32)
	rjmp .L21
.L22:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	EXTI_Enable, .-EXTI_Enable
	.section	.text.EXTI_Disable,"ax",@progbits
.global	EXTI_Disable
	.type	EXTI_Disable, @function
EXTI_Disable:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(3)
	brsh .L28
	cpi r24,lo8(1)
	brlo .L29
	brne .L30
	ldi r24,lo8(-128)
.L27:
	in r25,0x3b
	com r24
	and r24,r25
	out 0x3b,r24
	ldi r24,0
	ldi r25,0
	ret
.L29:
	ldi r24,lo8(64)
	rjmp .L27
.L30:
	ldi r24,lo8(32)
	rjmp .L27
.L28:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	EXTI_Disable, .-EXTI_Disable
	.section	.text.EXTI_SetCallback,"ax",@progbits
.global	EXTI_SetCallback
	.type	EXTI_SetCallback, @function
EXTI_SetCallback:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r25,lo8(1)
	or r22,r23
	breq .L32
	ldi r25,0
.L32:
	ldi r18,lo8(1)
	cpi r24,lo8(3)
	brsh .L33
	ldi r18,0
.L33:
	mov r24,r25
	or r24,r18
	ldi r25,0
/* epilogue start */
	ret
	.size	EXTI_SetCallback, .-EXTI_SetCallback
	.ident	"GCC: (GNU) 15.2.0"
