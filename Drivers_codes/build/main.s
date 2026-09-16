	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.rodata.main.str1.1,"aMS",@progbits,1
.LC0:
	.string	"State: OFF      "
.LC1:
	.string	"State: ACC      "
.LC2:
	.string	"State: BULBCHK  "
.LC3:
	.string	"State: IGNITION "
.LC4:
	.string	"State: CRANKING "
.LC5:
	.string	"State: RUNNING  "
.LC6:
	.string	"State: STALLED  "
.LC7:
	.string	"State: LIMP_HOME"
	.section	.rodata
.LC9:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	.LC3
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,50
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 50 */
/* stack size = 50 */
.L__stack_usage = 50
	ldi r20,0
	ldi r22,0
	ldi r24,0
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,lo8(1)
	ldi r24,0
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,lo8(2)
	ldi r24,0
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,lo8(3)
	ldi r24,0
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,0
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(1)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(2)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(3)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(5)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,lo8(6)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(7)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,0
	ldi r24,lo8(2)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(1)
	ldi r24,lo8(2)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(2)
	ldi r24,lo8(2)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(3)
	ldi r24,lo8(2)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(4)
	ldi r24,lo8(2)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(5)
	ldi r24,lo8(2)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(6)
	ldi r24,lo8(2)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(7)
	ldi r24,lo8(2)
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,0
	ldi r24,lo8(3)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(1)
	ldi r24,lo8(3)
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,lo8(2)
	ldi r24,lo8(3)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(3)
	ldi r24,lo8(3)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(4)
	ldi r24,lo8(3)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(5)
	ldi r24,lo8(3)
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,lo8(6)
	ldi r24,lo8(3)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(7)
	ldi r24,lo8(3)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	ldi r20,0
	ldi r22,lo8(2)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r20,0
	ldi r22,lo8(6)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r20,0
	ldi r22,lo8(7)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r20,0
	ldi r22,lo8(7)
	ldi r24,lo8(3)
	call GPIO_SetPinValue
	movw r16,r28
	subi r16,-1
	sbci r17,-1
	movw r30,r16
	ldi r24,lo8(32)
	0:
	st Z+,__zero_reg__
	dec r24
	brne 0b
	call LCD_Init
	call GAU_Init
	ldi r24,lo8(100)
	ldi r25,0
	call TIMER0_DelayMS
	movw r24,r16
	call FSM_Init
	ldi r24,lo8(16)
	ldi r30,lo8(.LC9)
	ldi r31,hi8(.LC9)
	movw r26,r28
	adiw r26,33
	0:
	ld r0,Z+
	st X+,r0
	dec r24
	brne 0b
	mov r14,__zero_reg__
	mov r15,__zero_reg__
	clr r12
	inc r12
.L9:
	movw r24,r28
	adiw r24,50
	movw r20,r24
	ldi r22,lo8(3)
	ldi r24,lo8(3)
	call GPIO_GetPinValue
	movw r24,r28
	adiw r24,49
	movw r20,r24
	ldi r22,lo8(4)
	ldi r24,lo8(3)
	call GPIO_GetPinValue
	ldd r19,Y+49
	ldd r13,Y+50
	ldi r22,lo8(1)
	mov r24,r12
	cpi r24,lo8(1)
	breq .L2
	ldi r22,0
.L2:
	ldi r24,lo8(1)
	cpse r13,__zero_reg__
	ldi r24,0
.L3:
	and r22,r24
	cpse r13,__zero_reg__
	rjmp .L10
	ldi r24,-1
	sub r14,r24
	sbc r15,r24
	ldi r20,lo8(1)
	ldi r24,-56
	cp r14,r24
	cpc r15,__zero_reg__
	brsh .L4
	ldi r20,0
.L4:
	ldd r24,Y+27
	cpi r24,lo8(4)
	brne .L6
	cpi r19,lo8(0)
.L25:
	breq .L12
	ldi r24,0
	ldi r25,0
.L7:
	std Y+3,r25
	std Y+4,r24
	ldi r18,lo8(1)
	cpse r19,__zero_reg__
	ldi r18,0
.L8:
	movw r24,r16
	call FSM_Run
	ldi r22,0
	ldi r24,0
	call LCD_SetCursor
	ldd r30,Y+27
	movw r24,r16
	add r24,r30
	adc r25,__zero_reg__
	add r24,r30
	adc r25,__zero_reg__
	movw r30,r24
	ldd r24,Z+32
	ldd r25,Z+33
	call LCD_WriteString
	ldi r24,lo8(10)
	ldi r25,0
	call TIMER0_DelayMS
	mov r12,r13
	rjmp .L9
.L10:
	ldi r20,0
	mov r14,__zero_reg__
	mov r15,__zero_reg__
	rjmp .L4
.L6:
	cpi r24,lo8(5)
	rjmp .L25
.L12:
	ldi r24,lo8(3)
	ldi r25,lo8(32)
	rjmp .L7
	.size	main, .-main
	.ident	"GCC: (GNU) 16.1.0"
.global __do_copy_data
