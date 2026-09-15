	.file	"lcd_i2c.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Local_WriteNibble,"ax",@progbits
	.type	Local_WriteNibble, @function
Local_WriteNibble:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	mov r29,r24
	swap r29
	andi r29,lo8(-16)
	cpse r22,__zero_reg__
	rjmp .L2
	ori r29,lo8(1)
.L2:
	lds r28,Local_u8Backlight
	call I2C_SendStart
	or r24,r25
	breq .L3
.L5:
	call I2C_SendStop
	ldi r28,lo8(1)
	ldi r29,0
.L1:
	movw r24,r28
/* epilogue start */
	pop r29
	pop r28
	ret
.L3:
	ldi r24,lo8(39)
	call I2C_SendSlaveAddressWithWrite
	or r24,r25
	brne .L5
	lsl r28
	lsl r28
	lsl r28
	or r28,r29
	mov r24,r28
	ori r24,lo8(4)
	call I2C_SendByte
	or r24,r25
	brne .L5
	call I2C_SendStop
	ldi r24,lo8(2)
1:	dec r24
	brne 1b
	rjmp .
	call I2C_SendStart
	or r24,r25
	brne .L5
	ldi r24,lo8(39)
	call I2C_SendSlaveAddressWithWrite
	or r24,r25
	brne .L5
	mov r24,r28
	call I2C_SendByte
	movw r28,r24
	or r24,r25
	brne .L5
	call I2C_SendStop
	ldi r24,lo8(106)
1:	dec r24
	brne 1b
	rjmp .
	rjmp .L1
	.size	Local_WriteNibble, .-Local_WriteNibble
	.section	.text.Local_WriteByte,"ax",@progbits
	.type	Local_WriteByte, @function
Local_WriteByte:
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 4 */
.L__stack_usage = 4
	std Y+2,r24
	std Y+1,r22
	swap r24
	andi r24,lo8(15)
	call Local_WriteNibble
	sbiw r24,0
	brne .L6
	ldd r22,Y+1
	ldd r24,Y+2
	andi r24,lo8(15)
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	jmp Local_WriteNibble
.L6:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	ret
	.size	Local_WriteByte, .-Local_WriteByte
	.section	.text.Local_SendCommand,"ax",@progbits
	.type	Local_SendCommand, @function
Local_SendCommand:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r22,lo8(1)
	jmp Local_WriteByte
	.size	Local_SendCommand, .-Local_SendCommand
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
	brne .L10
.L12:
	ldi r24,lo8(1)
	ldi r25,0
	ret
.L10:
	ldi r18,lo8(79999)
	ldi r24,hi8(79999)
	ldi r25,hlo8(79999)
1:	subi r18,1
	sbci r24,0
	sbci r25,0
	brne 1b
	rjmp .
	nop
	ldi r22,lo8(1)
	ldi r24,lo8(3)
	call Local_WriteNibble
	or r24,r25
	brne .L12
	ldi r30,lo8(9999)
	ldi r31,hi8(9999)
1:	sbiw r30,1
	brne 1b
	rjmp .
	nop
	ldi r22,lo8(1)
	ldi r24,lo8(3)
	call Local_WriteNibble
	or r24,r25
	brne .L12
	ldi r24,lo8(299)
	ldi r25,hi8(299)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
	ldi r22,lo8(1)
	ldi r24,lo8(3)
	call Local_WriteNibble
	or r24,r25
	brne .L12
	ldi r22,lo8(1)
	ldi r24,lo8(2)
	call Local_WriteNibble
	or r24,r25
	brne .L12
	ldi r24,lo8(40)
	call Local_SendCommand
	or r24,r25
	brne .L12
	ldi r24,lo8(12)
	call Local_SendCommand
	or r24,r25
	brne .L12
	ldi r24,lo8(6)
	call Local_SendCommand
	or r24,r25
	brne .L12
	ldi r24,lo8(1)
	call Local_SendCommand
	or r24,r25
	breq .+2
	rjmp .L12
	ldi r30,lo8(3999)
	ldi r31,hi8(3999)
1:	sbiw r30,1
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(2)
	call Local_SendCommand
	sbiw r24,0
	breq .+2
	rjmp .L12
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
	brne .L13
	ldi r30,lo8(3999)
	ldi r31,hi8(3999)
1:	sbiw r30,1
	brne 1b
	rjmp .
	nop
.L13:
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
	brsh .L15
	cpi r22,lo8(16)
	brsh .L15
	cpi r24,lo8(1)
	brne .L17
	subi r22,lo8(-(64))
.L17:
	mov r24,r22
	ori r24,lo8(-128)
	jmp Local_SendCommand
.L15:
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
	ldi r22,0
	jmp Local_WriteByte
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
	brne .L22
.L24:
	ldi r24,lo8(1)
	ldi r25,0
.L21:
/* epilogue start */
	pop r28
	pop r17
	pop r16
	ret
.L25:
	ldi r22,0
	call Local_WriteByte
	or r24,r25
	brne .L24
	subi r28,lo8(-(1))
.L22:
	movw r30,r16
	add r30,r28
	adc r31,__zero_reg__
	ld r24,Z
	cpse r24,__zero_reg__
	rjmp .L25
	ldi r24,0
	ldi r25,0
	rjmp .L21
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
	brsh .L29
	sts Local_u8Backlight,r24
	ldi r24,0
	ldi r25,0
	ret
.L29:
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
	brne .L31
	ldi r22,0
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
	jmp Local_WriteByte
.L31:
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
	brsh .L31
.L32:
	cpse r17,__zero_reg__
	rjmp .L34
	ldi r24,0
	ldi r25,0
	rjmp .L30
.L34:
	subi r17,lo8(-(-1))
	movw r30,r28
	adiw r30,1
	add r30,r17
	adc r31,__zero_reg__
	ldi r22,0
	ld r24,Z
	call Local_WriteByte
	sbiw r24,0
	breq .L32
.L30:
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
	brlo .L39
.L41:
	ldi r24,lo8(1)
	ldi r25,0
.L38:
/* epilogue start */
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret
.L39:
	or r22,r23
	breq .L41
	or r20,r21
	breq .L41
	call LCD_Clear
	or r24,r25
	brne .L41
	ldi r24,lo8(-128)
	call Local_SendCommand
	or r24,r25
	brne .L41
	movw r24,r14
	call LCD_WriteString
	or r24,r25
	brne .L41
	ldi r24,lo8(-64)
	call Local_SendCommand
	or r24,r25
	brne .L41
	movw r24,r16
	call LCD_WriteString
	sbiw r24,0
	brne .L41
	sts Local_u8CurrentPage,r28
	rjmp .L38
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
