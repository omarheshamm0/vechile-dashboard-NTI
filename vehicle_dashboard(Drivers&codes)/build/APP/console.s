	.file	"console.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Console_Init,"ax",@progbits
.global	Console_Init
	.type	Console_Init, @function
Console_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r22,lo8(-128)
	ldi r23,lo8(37)
	ldi r24,0
	ldi r25,0
	jmp UART_Init
	.size	Console_Init, .-Console_Init
	.section	.rodata.Console_SendTelemetry.str1.1,"aMS",@progbits,1
.LC0:
	.string	"TEL|SPD:%u|RPM:%u|FL:%u|CLT:%d|BAT:%u|OIL:%u|ODO:%lu|WARN:0x%04X\r\n"
	.section	.text.Console_SendTelemetry,"ax",@progbits
.global	Console_SendTelemetry
	.type	Console_SendTelemetry, @function
Console_SendTelemetry:
	push r16
	push r17
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	subi r28,-128
	sbc r29,__zero_reg__
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 128 */
/* stack size = 132 */
.L__stack_usage = 132
	call Cluster_GetCarData
	movw r30,r24
	or r24,r25
	breq .L2
	ldd r24,Z+23
	push r24
	ldd r24,Z+22
	push r24
	ldd r24,Z+13
	push r24
	ldd r24,Z+12
	push r24
	ldd r24,Z+11
	push r24
	ldd r24,Z+10
	push r24
	ldd r24,Z+9
	push __zero_reg__
	push r24
	ldd r24,Z+8
	push r24
	ldd r24,Z+7
	push r24
	ldd r24,Z+6
	push r24
	ldd r24,Z+5
	push r24
	ldd r24,Z+4
	push __zero_reg__
	push r24
	ldd r24,Z+3
	push r24
	ldd r24,Z+2
	push r24
	ldd r24,Z+1
	push r24
	ld r24,Z
	push r24
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	push r25
	push r24
	push __zero_reg__
	ldi r24,lo8(-128)
	push r24
	movw r16,r28
	subi r16,-1
	sbci r17,-1
	push r17
	push r16
	call snprintf
	movw r24,r16
	call UART_SendString
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
.L2:
/* epilogue start */
	subi r28,-128
	sbci r29,-1
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	pop r17
	pop r16
	ret
	.size	Console_SendTelemetry, .-Console_SendTelemetry
	.section	.rodata.Console_ProcessCommand.str1.1,"aMS",@progbits,1
.LC1:
	.string	"CMD: TEST_LAMPS_ON\r\n"
.LC2:
	.string	"CMD: PAGE_CHANGED_TO_TRIP\r\n"
.LC3:
	.string	"CMD: PAGE_CHANGED_TO_MAIN\r\n"
	.section	.text.Console_ProcessCommand,"ax",@progbits
.global	Console_ProcessCommand
	.type	Console_ProcessCommand, @function
Console_ProcessCommand:
	push r28
	push r29
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 3 */
.L__stack_usage = 3
	std Y+1,__zero_reg__
	call UART_IsDataReady
	or r24,r25
	brne .L7
	movw r24,r28
	adiw r24,1
	call UART_ReceiveByte
	or r24,r25
	brne .L7
	ldd r24,Y+1
	cpi r24,lo8(80)
	breq .L11
	brsh .L12
	cpi r24,lo8(49)
	breq .L13
	cpi r24,lo8(77)
	breq .L14
.L7:
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	ret
.L12:
	cpi r24,lo8(109)
	breq .L14
	cpi r24,lo8(112)
	brne .L7
.L11:
	ldi r24,lo8(1)
	ldi r25,0
	call Cluster_SetPage
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	rjmp .L27
.L13:
	ldi r24,lo8(.LC1)
	ldi r25,hi8(.LC1)
.L27:
	call UART_SendString
	rjmp .L7
.L14:
	ldi r24,0
	ldi r25,0
	call Cluster_SetPage
	ldi r24,lo8(.LC3)
	ldi r25,hi8(.LC3)
	rjmp .L27
	.size	Console_ProcessCommand, .-Console_ProcessCommand
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
