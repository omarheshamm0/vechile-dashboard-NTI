	.file	"lcd_i2c.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Local_WriteByteDirect,"ax",@progbits
	.type	Local_WriteByteDirect, @function
Local_WriteByteDirect:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	mov r29,r24
	mov r28,r22
	call I2C_SendStart
	or r24,r25
	breq .L2
.L4:
	call I2C_SendStop
	ldi r28,lo8(1)
	ldi r29,0
.L1:
	movw r24,r28
/* epilogue start */
	pop r29
	pop r28
	ret
.L2:
	ldi r24,lo8(62)
	call I2C_SendSlaveAddressWithWrite
	or r24,r25
	brne .L4
	mov r24,r29
	call I2C_SendByte
	or r24,r25
	brne .L4
	mov r24,r28
	call I2C_SendByte
	movw r28,r24
	or r24,r25
	brne .L4
	call I2C_SendStop
	rjmp .L1
	.size	Local_WriteByteDirect, .-Local_WriteByteDirect
	.section	.text.Local_SendCommand,"ax",@progbits
	.type	Local_SendCommand, @function
Local_SendCommand:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r25,lo8(1)
	lds r18,Local_u8Backlight
	cpse r18,__zero_reg__
	rjmp .L6
	ldi r25,0
.L6:
	mov r22,r24
	mov r24,r25
	lsl r24
	lsl r24
	lsl r24
	jmp Local_WriteByteDirect
	.size	Local_SendCommand, .-Local_SendCommand
	.section	.text.Local_SendData,"ax",@progbits
	.type	Local_SendData, @function
Local_SendData:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	mov r22,r24
	lds r24,Local_u8Backlight
	cp r24, __zero_reg__
	breq .L9
	ldi r24,lo8(72)
.L8:
	jmp Local_WriteByteDirect
.L9:
	ldi r24,lo8(64)
	rjmp .L8
	.size	Local_SendData, .-Local_SendData
	.section	.text.LCD_Init,"ax",@progbits
.global	LCD_Init
	.type	LCD_Init, @function
LCD_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts Local_u8CurrentPage,__zero_reg__
	ldi r24,lo8(1)
	sts Local_u8Backlight,r24
	ldi r22,lo8(-96)
	ldi r23,lo8(-122)
	ldi r25,0
	call I2C_InitMaster
	sbiw r24,1
	brne .L11
.L13:
	ldi r24,lo8(1)
	ldi r25,0
	ret
.L11:
	ldi r18,lo8(79999)
	ldi r24,hi8(79999)
	ldi r25,hlo8(79999)
1:	subi r18,1
	sbci r24,0
	sbci r25,0
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(48)
	call Local_SendCommand
	or r24,r25
	brne .L13
	ldi r24,lo8(48)
	call Local_SendCommand
	or r24,r25
	brne .L13
	ldi r24,lo8(48)
	call Local_SendCommand
	or r24,r25
	brne .L13
	ldi r24,lo8(56)
	call Local_SendCommand
	or r24,r25
	brne .L13
	ldi r24,lo8(12)
	call Local_SendCommand
	or r24,r25
	brne .L13
	ldi r24,lo8(6)
	call Local_SendCommand
	or r24,r25
	brne .L13
	ldi r24,lo8(1)
	call Local_SendCommand
	or r24,r25
	brne .L13
	ldi r30,lo8(3999)
	ldi r31,hi8(3999)
1:	sbiw r30,1
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(2)
	call Local_SendCommand
	sbiw r24,0
	brne .L13
	ldi r30,lo8(3999)
	ldi r31,hi8(3999)
1:	sbiw r30,1
	brne 1b
	rjmp .
	nop
/* epilogue start */
	ret
	.size	LCD_Init, .-LCD_Init
	.section	.text.LCD_Clear,"ax",@progbits
.global	LCD_Clear
	.type	LCD_Clear, @function
LCD_Clear:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(1)
	call Local_SendCommand
	sbiw r24,0
	brne .L14
	ldi r30,lo8(3999)
	ldi r31,hi8(3999)
1:	sbiw r30,1
	brne 1b
	rjmp .
	nop
.L14:
/* epilogue start */
	ret
	.size	LCD_Clear, .-LCD_Clear
	.section	.text.LCD_SetCursor,"ax",@progbits
.global	LCD_SetCursor
	.type	LCD_SetCursor, @function
LCD_SetCursor:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(2)
	brsh .L16
	cpi r22,lo8(16)
	brsh .L16
	cpi r24,lo8(1)
	brne .L18
	subi r22,lo8(-(64))
.L18:
	mov r24,r22
	ori r24,lo8(-128)
	jmp Local_SendCommand
.L16:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	LCD_SetCursor, .-LCD_SetCursor
	.section	.text.LCD_WriteChar,"ax",@progbits
.global	LCD_WriteChar
	.type	LCD_WriteChar, @function
LCD_WriteChar:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	jmp Local_SendData
	.size	LCD_WriteChar, .-LCD_WriteChar
	.section	.text.LCD_WriteString,"ax",@progbits
.global	LCD_WriteString
	.type	LCD_WriteString, @function
LCD_WriteString:
	push r16
	push r17
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 3 */
.L__stack_usage = 3
	movw r16,r24
	ldi r28,0
	or r24,r25
	brne .L23
.L25:
	ldi r24,lo8(1)
	ldi r25,0
.L22:
/* epilogue start */
	pop r28
	pop r17
	pop r16
	ret
.L26:
	call Local_SendData
	or r24,r25
	brne .L25
	subi r28,lo8(-(1))
.L23:
	movw r30,r16
	add r30,r28
	adc r31,__zero_reg__
	ld r24,Z
	cpse r24,__zero_reg__
	rjmp .L26
	ldi r24,0
	ldi r25,0
	rjmp .L22
	.size	LCD_WriteString, .-LCD_WriteString
	.section	.text.LCD_SetBacklight,"ax",@progbits
.global	LCD_SetBacklight
	.type	LCD_SetBacklight, @function
LCD_SetBacklight:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(2)
	brsh .L30
	sts Local_u8Backlight,r24
	ldi r24,0
	ldi r25,0
	ret
.L30:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	LCD_SetBacklight, .-LCD_SetBacklight
	.section	.text.LCD_WriteNumber,"ax",@progbits
.global	LCD_WriteNumber
	.type	LCD_WriteNumber, @function
LCD_WriteNumber:
	push r12
	push r13
	push r14
	push r15
	push r17
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,11
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 11 */
/* stack size = 18 */
.L__stack_usage = 18
	movw r12,r22
	movw r14,r24
	ldi r17,0
	cp r12,__zero_reg__
	cpc r13,__zero_reg__
	cpc r14,__zero_reg__
	cpc r15,__zero_reg__
	brne .L32
	ldi r24,lo8(48)
/* epilogue start */
	adiw r28,11
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	pop r17
	pop r15
	pop r14
	pop r13
	pop r12
	jmp Local_SendData
.L32:
	movw r22,r12
	movw r24,r14
	ldi r18,lo8(10)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	movw r30,r28
	adiw r30,1
	add r30,r17
	adc r31,__zero_reg__
	subi r22,lo8(-(48))
	st Z,r22
	movw r24,r12
	movw r26,r14
	movw r12,r18
	movw r14,r20
	subi r17,lo8(-(1))
	sbiw r24,10
	cpc r26,__zero_reg__
	cpc r27,__zero_reg__
	brsh .L32
.L33:
	cpse r17,__zero_reg__
	rjmp .L35
	ldi r24,0
	ldi r25,0
	rjmp .L31
.L35:
	subi r17,lo8(-(-1))
	movw r30,r28
	adiw r30,1
	add r30,r17
	adc r31,__zero_reg__
	ld r24,Z
	call Local_SendData
	sbiw r24,0
	breq .L33
.L31:
/* epilogue start */
	adiw r28,11
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	pop r17
	pop r15
	pop r14
	pop r13
	pop r12
	ret
	.size	LCD_WriteNumber, .-LCD_WriteNumber
	.section	.text.DSP_Next,"ax",@progbits
.global	DSP_Next
	.type	DSP_Next, @function
DSP_Next:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,Local_u8CurrentPage
	ldi r25,0
	adiw r24,1
	ldi r22,lo8(5)
	ldi r23,0
	call __udivmodhi4
	sts Local_u8CurrentPage,r24
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	DSP_Next, .-DSP_Next
	.section	.text.DSP_Render,"ax",@progbits
.global	DSP_Render
	.type	DSP_Render, @function
DSP_Render:
	push r14
	push r15
	push r16
	push r17
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 5 */
.L__stack_usage = 5
	mov r28,r24
	movw r14,r22
	movw r16,r20
	cpi r24,lo8(5)
	brlo .L40
.L42:
	ldi r24,lo8(1)
	ldi r25,0
.L39:
/* epilogue start */
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret
.L40:
	or r22,r23
	breq .L42
	or r20,r21
	breq .L42
	call LCD_Clear
	or r24,r25
	brne .L42
	ldi r24,lo8(-128)
	call Local_SendCommand
	or r24,r25
	brne .L42
	movw r24,r14
	call LCD_WriteString
	or r24,r25
	brne .L42
	ldi r24,lo8(-64)
	call Local_SendCommand
	or r24,r25
	brne .L42
	movw r24,r16
	call LCD_WriteString
	sbiw r24,0
	brne .L42
	sts Local_u8CurrentPage,r28
	rjmp .L39
	.size	DSP_Render, .-DSP_Render
	.section	.bss.Local_u8Backlight,"aw",@nobits
	.type	Local_u8Backlight, @object
	.size	Local_u8Backlight, 1
Local_u8Backlight:
	.zero	1
	.section	.bss.Local_u8CurrentPage,"aw",@nobits
	.type	Local_u8CurrentPage, @object
	.size	Local_u8CurrentPage, 1
Local_u8CurrentPage:
	.zero	1
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
