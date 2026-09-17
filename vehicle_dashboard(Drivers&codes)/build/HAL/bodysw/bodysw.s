	.file	"bodysw.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.BSW_Init,"ax",@progbits
.global	BSW_Init
	.type	BSW_Init, @function
BSW_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	cpi r24,1
	cpc r25,__zero_reg__
	breq .L1
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	ldi r18,lo8(1)
	sbiw r24,1
	breq .L3
	ldi r18,0
.L3:
	mov r24,r18
	ldi r25,0
.L1:
/* epilogue start */
	ret
	.size	BSW_Init, .-BSW_Init
	.section	.text.BSW_Read,"ax",@progbits
.global	BSW_Read
	.type	BSW_Read, @function
BSW_Read:
	push r16
	push r17
	push r28
	push r29
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 5 */
.L__stack_usage = 5
	movw r16,r24
	or r24,r25
	breq .L12
	ldi r24,0
	call SPI_Acquire
	sbiw r24,1
	breq .L12
	ldi r20,0
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	sbiw r24,1
	brne .L14
.L16:
	call SPI_Release
.L12:
	ldi r24,lo8(1)
	ldi r25,0
.L10:
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	ret
.L14:
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	sbiw r24,1
	breq .L16
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	ldi r24,lo8(-1)
	call SPI_Transceive
	sbiw r24,1
	breq .L16
	call SPI_Release
	ldd r24,Y+1
	com r24
	movw r30,r16
	st Z,r24
	ldi r24,0
	ldi r25,0
	rjmp .L10
	.size	BSW_Read, .-BSW_Read
	.ident	"GCC: (GNU) 15.2.0"
