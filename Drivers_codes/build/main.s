	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.rodata.main.str1.1,"aMS",@progbits,1
.LC0:
	.string	"F:%3d%% C:%3dC"
.LC1:
	.string	"Bat:%umV Oil:%u"
.LC2:
	.string	"ERR: Oil Press  "
.LC3:
	.string	"ERR: Battery    "
.LC4:
	.string	"ERR: Overheat!  "
.LC5:
	.string	"Check Engine!   "
.LC6:
	.string	"Warn: Low Fuel  "
.LC7:
	.string	"Warn: Overspeed "
.LC8:
	.string	"Fasten Seatbelt "
.LC9:
	.string	"Door is Open!   "
.LC10:
	.string	"Handbrake ON!   "
.LC11:
	.string	"System Normal   "
.LC12:
	.string	"                "
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
	in r28,__SP_L__
	in r29,__SP_H__
	subi r28,83
	sbci r29,0
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 83 */
/* stack size = 83 */
.L__stack_usage = 83
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
	ldi r24,lo8(159999)
	ldi r25,hi8(159999)
	ldi r18,hlo8(159999)
1:	subi r24,1
	sbci r25,0
	sbci r18,0
	brne 1b
	rjmp .
	nop
	mov r12,r16
	mov r11,r17
	ldi r24,lo8(17)
	mov r13,r24
	movw r16,r28
	subi r16,-67
	sbci r17,-1
	movw r14,r28
	ldi r24,50
	add r14,r24
	adc r15,__zero_reg__
.L15:
	mov r24,r12
	mov r25,r11
	call GAU_Update
	ldd r24,Y+7
	push r24
	ldd r24,Y+6
	push r24
	ldd r24,Y+5
	push __zero_reg__
	push r24
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	push r25
	push r24
	push __zero_reg__
	push r13
	push r17
	push r16
	call snprintf
	ldd r24,Y+10
	push __zero_reg__
	push r24
	ldd r24,Y+9
	push r24
	ldd r24,Y+8
	push r24
	ldi r24,lo8(.LC1)
	ldi r25,hi8(.LC1)
	push r25
	push r24
	push __zero_reg__
	push r13
	push r15
	push r14
	call snprintf
	movw r20,r14
	movw r22,r16
	ldi r24,0
	call DSP_Render
	ldi r24,lo8(-12)
	ldi r25,lo8(1)
	call TIMER0_DelayMS
	mov r24,r12
	mov r25,r11
	call WRN_Update
	mov r24,r12
	mov r25,r11
	call WRN_Highest
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	ldi r22,lo8(.LC12)
	ldi r23,hi8(.LC12)
	cpi r24,10
	cpc r25,__zero_reg__
	brsh .L16
	subi r24,lo8(-(gs(.L4)))
	sbci r25,hi8(-(gs(.L4)))
	movw r30,r24
	jmp __tablejump2__
	.section	.jumptables.gcc.main,"a",@progbits
	.p2align	1
	.type	.L4, @object
.L4:
	.word gs(.L13)
	.word gs(.L12)
	.word gs(.L11)
	.word gs(.L10)
	.word gs(.L9)
	.word gs(.L8)
	.word gs(.L7)
	.word gs(.L6)
	.word gs(.L5)
	.word gs(.L3)
	.section	.text.startup.main
.L12:
	ldi r22,lo8(.LC2)
	ldi r23,hi8(.LC2)
.L16:
	movw r24,r28
	adiw r24,33
	call strcpy
	ldi r22,lo8(1)
	ldi r24,0
	call LCD_SetCursor
	movw r24,r28
	adiw r24,33
	call LCD_WriteString
	ldi r24,lo8(-12)
	ldi r25,lo8(1)
	call TIMER0_DelayMS
	rjmp .L15
.L11:
	ldi r22,lo8(.LC3)
	ldi r23,hi8(.LC3)
	rjmp .L16
.L10:
	ldi r22,lo8(.LC4)
	ldi r23,hi8(.LC4)
	rjmp .L16
.L9:
	ldi r22,lo8(.LC5)
	ldi r23,hi8(.LC5)
	rjmp .L16
.L8:
	ldi r22,lo8(.LC6)
	ldi r23,hi8(.LC6)
	rjmp .L16
.L7:
	ldi r22,lo8(.LC7)
	ldi r23,hi8(.LC7)
	rjmp .L16
.L6:
	ldi r22,lo8(.LC8)
	ldi r23,hi8(.LC8)
	rjmp .L16
.L5:
	ldi r22,lo8(.LC9)
	ldi r23,hi8(.LC9)
	rjmp .L16
.L3:
	ldi r22,lo8(.LC10)
	ldi r23,hi8(.LC10)
	rjmp .L16
.L13:
	ldi r22,lo8(.LC11)
	ldi r23,hi8(.LC11)
	rjmp .L16
	.size	main, .-main
	.ident	"GCC: (GNU) 16.1.0"
.global __do_copy_data
