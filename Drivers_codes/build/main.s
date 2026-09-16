	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 1 */
.L__stack_usage = 1
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
	call LCD_Init
	call GAU_Init
	ldi r24,lo8(100)
	ldi r25,0
	call TIMER0_DelayMS
	call CHM_Init
	ldi r16,0
	ldi r17,0
	clr r15
	inc r15
.L6:
	movw r24,r28
	adiw r24,1
	movw r20,r24
	ldi r22,lo8(5)
	ldi r24,lo8(3)
	call GPIO_GetPinValue
	ldd r18,Y+1
	movw r24,r16
	adiw r24,1
	mov r19,r15
	cpi r19,lo8(1)
	brne .L3
	cpse r18,__zero_reg__
	rjmp .L3
	movw r16,r24
	sbiw r24,4
	brlo .L5
	ldi r16,0
	ldi r17,0
.L5:
	movw r24,r16
	call CHM_Play
.L3:
	ldd r15,Y+1
	call CHM_Update
	ldi r22,0
	ldi r24,0
	call LCD_SetCursor
	movw r30,r16
	lsl r30
	rol r31
	subi r30,lo8(-(PatternNames))
	sbci r31,hi8(-(PatternNames))
	ld r24,Z
	ldd r25,Z+1
	call LCD_WriteString
	ldi r24,lo8(100)
	ldi r25,0
	call TIMER0_DelayMS
	rjmp .L6
	.size	main, .-main
.global	PatternNames
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Chime: OFF      "
.LC1:
	.string	"Chime: OVERSPEED"
.LC2:
	.string	"Chime: LIMP_HOME"
.LC3:
	.string	"Chime: TURN_TICK"
	.section	.data.PatternNames,"aw"
	.type	PatternNames, @object
	.size	PatternNames, 8
PatternNames:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	.LC3
	.ident	"GCC: (GNU) 16.1.0"
.global __do_copy_data
