	.file	"UART.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.UART_Init,"ax",@progbits
.global	UART_Init
	.type	UART_Init, @function
UART_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbiw r24,0
	sbci r23,hi8(0)
	sbci r22,lo8(0)
	breq .L4
	movw r18,r22
	movw r20,r24
	ldi r22,4
	1:
	lsl r18
	rol r19
	rol r20
	rol r21
	dec r22
	brne 1b
	ldi r22,0
	ldi r23,lo8(18)
	ldi r24,lo8(122)
	ldi r25,0
	call __udivmodsi4
	movw r24,r18
	movw r26,r20
	sbiw r24,1
	sbc r26,__zero_reg__
	sbc r27,__zero_reg__
	cpi r25,16
	cpc r26,__zero_reg__
	cpc r27,__zero_reg__
	brsh .L4
	out 0x20,r25
	out 0x9,r24
	ldi r24,lo8(-122)
	out 0x20,r24
	ldi r24,lo8(24)
	out 0xa,r24
	ldi r24,0
	ldi r25,0
	ret
.L4:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	UART_Init, .-UART_Init
	.section	.text.UART_SendByte,"ax",@progbits
.global	UART_SendByte
	.type	UART_SendByte, @function
UART_SendByte:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
.L6:
	sbis 0xb,5
	rjmp .L6
	out 0xc,r24
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	UART_SendByte, .-UART_SendByte
	.section	.text.UART_ReceiveByte,"ax",@progbits
.global	UART_ReceiveByte
	.type	UART_ReceiveByte, @function
UART_ReceiveByte:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbiw r24,0
	breq .L12
.L11:
	sbis 0xb,7
	rjmp .L11
	in r18,0xc
	movw r30,r24
	st Z,r18
	ldi r24,0
	ldi r25,0
	ret
.L12:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	UART_ReceiveByte, .-UART_ReceiveByte
	.section	.text.UART_SendString,"ax",@progbits
.global	UART_SendString
	.type	UART_SendString, @function
UART_SendString:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
	or r24,r25
	brne .L16
	ldi r24,lo8(1)
	ldi r25,0
	rjmp .L14
.L17:
	adiw r28,1
	call UART_SendByte
.L16:
	ld r24,Y
	cpse r24,__zero_reg__
	rjmp .L17
	ldi r24,0
	ldi r25,0
.L14:
/* epilogue start */
	pop r29
	pop r28
	ret
	.size	UART_SendString, .-UART_SendString
	.section	.text.UART_IsDataReady,"ax",@progbits
.global	UART_IsDataReady
	.type	UART_IsDataReady, @function
UART_IsDataReady:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r24,0xb
	lsl r24
	sbc r25,r25
	com r25
	bst r25,7
	clr r24
	bld r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	UART_IsDataReady, .-UART_IsDataReady
	.section	.text.UART_SetRxInterrupt,"ax",@progbits
.global	UART_SetRxInterrupt
	.type	UART_SetRxInterrupt, @function
UART_SetRxInterrupt:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(1)
	brlo .L22
	brne .L24
	sbi 0xa,7
.L23:
	ldi r24,0
	ldi r25,0
	ret
.L22:
	cbi 0xa,7
	rjmp .L23
.L24:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	UART_SetRxInterrupt, .-UART_SetRxInterrupt
	.section	.text.UART_SetTxInterrupt,"ax",@progbits
.global	UART_SetTxInterrupt
	.type	UART_SetTxInterrupt, @function
UART_SetTxInterrupt:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(1)
	brlo .L27
	brne .L29
	sbi 0xa,5
.L28:
	ldi r24,0
	ldi r25,0
	ret
.L27:
	cbi 0xa,5
	rjmp .L28
.L29:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	UART_SetTxInterrupt, .-UART_SetTxInterrupt
	.ident	"GCC: (GNU) 15.2.0"
