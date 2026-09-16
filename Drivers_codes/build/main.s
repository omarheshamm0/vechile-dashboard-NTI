	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Lmp_Shift,"ax",@progbits
	.type	Lmp_Shift, @function
Lmp_Shift:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	mov r28,r24
	ldi r24,lo8(1)
	call SPI_Acquire
	or r24,r25
	brne .L1
	mov r24,r28
	call SPI_TransmitByte
	call SPI_Release
	ldi r20,lo8(1)
	ldi r22,lo8(2)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r24,lo8(5)
1:	dec r24
	brne 1b
	nop
	ldi r20,0
	ldi r22,lo8(2)
	ldi r24,lo8(2)
/* epilogue start */
	pop r28
	jmp GPIO_SetPinValue
.L1:
/* epilogue start */
	pop r28
	ret
	.size	Lmp_Shift, .-Lmp_Shift
	.section	.text.__vector_10,"ax",@progbits
.global	__vector_10
	.type	__vector_10, @function
__vector_10:
	__gcc_isr 1
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 0...4 */
.L__stack_usage = 0 + __gcc_isr.n_pushed
	ldi r24,lo8(1)
	sts g_tick10ms,r24
/* epilogue start */
	__gcc_isr 2
	reti
	__gcc_isr 0,r24
	.size	__vector_10, .-__vector_10
	.section	.rodata.main.str1.1,"aMS",@progbits,1
.LC1:
	.string	"BULB CHECK"
.LC2:
	.string	"ALL LAMPS ON"
.LC3:
	.string	"!! STOP ENGINE !!"
.LC4:
	.string	"SPD:%u RPM:%u"
.LC5:
	.string	"TRIP:%lu m"
.LC6:
	.string	"AVG:%u MAX:%u"
.LC7:
	.string	"RPM:%u C:%dC"
.LC8:
	.string	"OIL:%u.%ubar"
.LC9:
	.string	"BAT:%u mV"
.LC10:
	.string	"ODO:%lu m"
.LC11:
	.string	"WARN:0x%04X"
.LC12:
	.string	"SPD:%3u KM/H"
.LC13:
	.string	"RPM:%u F:%u%%"
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
	in r28,__SP_L__
	in r29,__SP_H__
	subi r28,91
	sbci r29,0
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 91 */
/* stack size = 91 */
.L__stack_usage = 91
	ldi r24,lo8(67)
	ldi r25,lo8(68)
	std Y+1,r24
	std Y+2,r25
	ldi r24,lo8(1)
	std Y+3,r24
	std Y+4,__zero_reg__
	std Y+5,__zero_reg__
	std Y+6,__zero_reg__
	std Y+7,__zero_reg__
	std Y+8,__zero_reg__
	std Y+9,__zero_reg__
	std Y+10,__zero_reg__
	std Y+11,__zero_reg__
	std Y+12,__zero_reg__
	std Y+13,__zero_reg__
	ldi r24,lo8(120)
	std Y+14,r24
	std Y+15,__zero_reg__
	ldi r24,lo8(10)
	std Y+16,r24
	ldi r25,lo8(110)
	std Y+17,r25
	std Y+18,r24
	ldi r24,lo8(-32)
	ldi r25,lo8(46)
	std Y+19,r24
	std Y+20,r25
	ldi r24,lo8(-104)
	ldi r25,lo8(58)
	std Y+21,r24
	std Y+22,r25
	ldi r24,lo8(4)
	std Y+23,r24
	ldi r24,lo8(-48)
	ldi r25,lo8(7)
	std Y+24,r24
	std Y+25,r25
	ldi r24,lo8(2)
	std Y+26,r24
	std Y+27,__zero_reg__
	std Y+28,__zero_reg__
	std Y+29,__zero_reg__
	std Y+30,__zero_reg__
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
	ldi r20,0
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
	ldi r24,lo8(8)
	out 0x33,r24
	ldi r24,lo8(77)
	out 0x3c,r24
	out 0x32,__zero_reg__
	in r24,0x39
	ori r24,lo8(2)
	out 0x39,r24
	in r24,0x33
	ori r24,lo8(5)
	out 0x33,r24
	ldi r24,lo8(1)
	call SPI_InitMaster
	call LCD_Init
	ldi r24,lo8(1)
	call LCD_SetBacklight
	call BSW_Init
	ldi r24,0
	call Lmp_Shift
	call GAU_Init
	call Console_Init
	call CHM_Init
	call SPD_Init
	call TAC_Init
	call INTERRUPT_EnableGlobal
	call Cluster_GetCarData
	movw r16,r24
	call FSM_Init
	movw r30,r16
	std Z+27,__zero_reg__
	adiw r28,75-63
	std Y+63,__zero_reg__
	sbiw r28,75-63
	ldi r24,lo8(1)
	adiw r28,88-63
	std Y+63,r24
	sbiw r28,88-63
	adiw r28,76-63
	std Y+63,__zero_reg__
	sbiw r28,76-63
	adiw r28,87-63
	std Y+63,r24
	sbiw r28,87-63
	adiw r28,77-63
	std Y+63,__zero_reg__
	sbiw r28,77-63
	adiw r28,85-63
	std Y+63,r24
	sbiw r28,85-63
	adiw r28,91-63
	std Y+63,r24
	sbiw r28,91-63
	adiw r28,78-63
	std Y+63,__zero_reg__
	sbiw r28,78-63
	adiw r28,86-63
	std Y+63,r24
	sbiw r28,86-63
	adiw r28,71-60
	std Y+60,__zero_reg__
	std Y+61,__zero_reg__
	std Y+62,__zero_reg__
	std Y+63,__zero_reg__
	sbiw r28,71-60
	mov r11,__zero_reg__
	adiw r28,89-63
	std Y+63,__zero_reg__
	sbiw r28,89-63
	mov r8,__zero_reg__
	mov r9,__zero_reg__
	adiw r28,69-62
	std Y+63,__zero_reg__
	std Y+62,__zero_reg__
	sbiw r28,69-62
	mov r6,r24
	adiw r28,81-63
	std Y+63,r24
	sbiw r28,81-63
	mov r7,r24
	movw r12,r8
	movw r14,r8
	movw r4,r28
	ldi r24,31
	add r4,r24
	adc r5,__zero_reg__
	movw r2,r28
	ldi r24,48
	add r2,r24
	adc r3,__zero_reg__
.L5:
	lds r24,g_tick10ms
	cpi r24,lo8(0)
	breq .L5
	sts g_tick10ms,__zero_reg__
	ldi r20,lo8(1)
	ldi r22,lo8(6)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	movw r24,r28
	subi r24,-68
	sbci r25,-1
	movw r20,r24
	ldi r22,lo8(3)
	ldi r24,lo8(3)
	call GPIO_GetPinValue
	movw r24,r28
	subi r24,-67
	sbci r25,-1
	movw r20,r24
	ldi r22,lo8(4)
	ldi r24,lo8(3)
	call GPIO_GetPinValue
	movw r24,r28
	subi r24,-66
	sbci r25,-1
	movw r20,r24
	ldi r22,lo8(5)
	ldi r24,lo8(3)
	call GPIO_GetPinValue
	movw r24,r28
	subi r24,-65
	sbci r25,-1
	movw r20,r24
	ldi r22,lo8(3)
	ldi r24,lo8(1)
	call GPIO_GetPinValue
	adiw r28,68-63
	ldd r24,Y+63
	sbiw r28,68-63
	adiw r28,86-63
	ldd r25,Y+63
	sbiw r28,86-63
	cpse r24,r25
	rjmp .L73
	adiw r28,78-63
	ldd r24,Y+63
	sbiw r28,78-63
	cpi r24,lo8(3)
	breq .L75
	subi r24,lo8(-(1))
	adiw r28,78-63
	std Y+63,r24
	sbiw r28,78-63
	mov r10,r7
	cpi r24,lo8(3)
	brne .L6
.L75:
	adiw r28,86-63
	ldd r10,Y+63
	sbiw r28,86-63
	rjmp .L6
.L73:
	adiw r28,86-63
	std Y+63,r24
	sbiw r28,86-63
	mov r10,r7
	adiw r28,78-63
	std Y+63,__zero_reg__
	sbiw r28,78-63
.L6:
	adiw r28,67-63
	ldd r24,Y+63
	sbiw r28,67-63
	adiw r28,85-63
	ldd r25,Y+63
	sbiw r28,85-63
	cpse r24,r25
	rjmp .L76
	adiw r28,77-63
	ldd r24,Y+63
	sbiw r28,77-63
	cpi r24,lo8(3)
	breq .L78
	subi r24,lo8(-(1))
	adiw r28,77-63
	std Y+63,r24
	sbiw r28,77-63
	cpi r24,lo8(3)
	breq .L78
.L7:
	adiw r28,66-63
	ldd r24,Y+63
	sbiw r28,66-63
	adiw r28,87-63
	ldd r25,Y+63
	sbiw r28,87-63
	cpse r24,r25
	rjmp .L79
	adiw r28,76-63
	ldd r24,Y+63
	sbiw r28,76-63
	cpi r24,lo8(3)
	brne .+2
	rjmp .L81
	subi r24,lo8(-(1))
	adiw r28,76-63
	std Y+63,r24
	sbiw r28,76-63
	cpi r24,lo8(3)
	brne .+2
	rjmp .L81
	adiw r28,81-63
	ldd r24,Y+63
	sbiw r28,81-63
.L174:
	adiw r28,79-63
	std Y+63,r24
	sbiw r28,79-63
	rjmp .L8
.L76:
	adiw r28,85-63
	std Y+63,r24
	sbiw r28,85-63
	adiw r28,77-63
	std Y+63,__zero_reg__
	sbiw r28,77-63
	rjmp .L7
.L78:
	adiw r28,85-63
	ldd r24,Y+63
	sbiw r28,85-63
	adiw r28,91-63
	std Y+63,r24
	sbiw r28,91-63
	rjmp .L7
.L79:
	adiw r28,87-63
	std Y+63,r24
	sbiw r28,87-63
	adiw r28,81-63
	ldd r24,Y+63
	sbiw r28,81-63
	adiw r28,79-63
	std Y+63,r24
	sbiw r28,79-63
	adiw r28,76-63
	std Y+63,__zero_reg__
	sbiw r28,76-63
.L8:
	adiw r28,65-63
	ldd r24,Y+63
	sbiw r28,65-63
	adiw r28,88-63
	ldd r25,Y+63
	sbiw r28,88-63
	cpse r24,r25
	rjmp .L82
	adiw r28,75-63
	ldd r24,Y+63
	sbiw r28,75-63
	cpi r24,lo8(3)
	brne .+2
	rjmp .L84
	subi r24,lo8(-(1))
	adiw r28,75-63
	std Y+63,r24
	sbiw r28,75-63
	cpi r24,lo8(3)
	breq .L84
	adiw r28,80-63
	std Y+63,r6
	sbiw r28,80-63
.L9:
	cpse r10,__zero_reg__
	rjmp .L85
	ldi r24,lo8(1)
	adiw r28,90-63
	std Y+63,r24
	sbiw r28,90-63
	mov r24,r7
	cpi r24,lo8(1)
	breq .L11
	adiw r28,90-63
	std Y+63,__zero_reg__
	sbiw r28,90-63
.L11:
	adiw r28,69-62
	ldd r18,Y+62
	ldd r19,Y+63
	sbiw r28,69-62
	cpi r18,-1
	cpc r19,r18
	breq .L12
	movw r24,r18
	adiw r24,1
	adiw r28,69-62
	std Y+63,r25
	std Y+62,r24
	sbiw r28,69-62
.L12:
	adiw r28,89-63
	ldd r24,Y+63
	sbiw r28,89-63
	cpse r24,__zero_reg__
	rjmp .L86
	adiw r28,69-62
	ldd r24,Y+62
	ldd r25,Y+63
	sbiw r28,69-62
	cpi r24,-56
	sbci r25,0
	brlo .+2
	rjmp .L87
.L86:
	mov r7,__zero_reg__
	rjmp .L10
.L81:
	adiw r28,87-63
	ldd r24,Y+63
	sbiw r28,87-63
	rjmp .L174
.L82:
	adiw r28,88-63
	std Y+63,r24
	sbiw r28,88-63
	adiw r28,80-63
	std Y+63,r6
	sbiw r28,80-63
	adiw r28,75-63
	std Y+63,__zero_reg__
	sbiw r28,75-63
	rjmp .L9
.L84:
	adiw r28,88-63
	ldd r24,Y+63
	sbiw r28,88-63
	adiw r28,80-63
	std Y+63,r24
	sbiw r28,80-63
	rjmp .L9
.L85:
	adiw r28,90-63
	std Y+63,__zero_reg__
	sbiw r28,90-63
	mov r7,__zero_reg__
	adiw r28,89-63
	std Y+63,__zero_reg__
	sbiw r28,89-63
	adiw r28,69-62
	std Y+63,__zero_reg__
	std Y+62,__zero_reg__
	sbiw r28,69-62
.L10:
	ldi r24,lo8(1)
	adiw r28,81-63
	ldd r25,Y+63
	sbiw r28,81-63
	cpi r25,lo8(1)
	breq .L13
	ldi r24,0
.L13:
	ldi r25,lo8(1)
	adiw r28,79-63
	ldd r18,Y+63
	sbiw r28,79-63
	cpse r18,__zero_reg__
	ldi r25,0
.L14:
	and r24,r25
	adiw r28,80-63
	ldd r25,Y+63
	sbiw r28,80-63
	cpse r25,__zero_reg__
	rjmp .L15
	ldi r25,-1
	cp r8,r25
	cpc r9,r8
	brne .+2
	rjmp .L16
	ldi r25,-1
	sub r8,r25
	sbc r9,r25
	cpse r11,__zero_reg__
	rjmp .L18
	ldi r25,-56
	cp r8,r25
	cpc r9,__zero_reg__
	brlo .L18
.L72:
	movw r30,r16
	std Z+14,__zero_reg__
	std Z+15,__zero_reg__
	std Z+16,__zero_reg__
	std Z+17,__zero_reg__
	adiw r28,71-60
	std Y+60,__zero_reg__
	std Y+61,__zero_reg__
	std Y+62,__zero_reg__
	std Y+63,__zero_reg__
	sbiw r28,71-60
	clr r11
	inc r11
.L18:
	cpse r24,__zero_reg__
	rjmp .L71
	rjmp .L19
.L87:
	clr r7
	inc r7
	ldi r24,lo8(1)
	adiw r28,89-63
	std Y+63,r24
	sbiw r28,89-63
	rjmp .L10
.L15:
	cpse r6,__zero_reg__
	rjmp .L88
	ldi r25,lo8(1)
	eor r25,r11
	or r25,r24
	mov r11,r25
	mov r8,__zero_reg__
	mov r9,__zero_reg__
	cpi r25,lo8(0)
	breq .L19
	mov r11,__zero_reg__
	mov r8,__zero_reg__
	mov r9,__zero_reg__
.L71:
	movw r30,r16
	ldd r24,Z+27
	ldi r25,0
	adiw r24,1
	ldi r22,lo8(5)
	ldi r23,0
	call __udivmodhi4
	std Z+27,r24
.L19:
	ldi r24,-1
	sub r12,r24
	sbc r13,r24
	sbc r14,r24
	sbc r15,r24
	clr r6
	inc r6
	adiw r28,91-63
	ldd r24,Y+63
	sbiw r28,91-63
	cpse r24,__zero_reg__
	mov r6,__zero_reg__
.L20:
	std Y+31,__zero_reg__
	movw r24,r4
	call BSW_Read
	or r24,r25
	brne .L21
	ldd r24,Y+31
	andi r24,lo8(63)
	movw r30,r16
	ldd r25,Z+25
	andi r25,lo8(-64)
	or r24,r25
	std Z+25,r24
.L21:
	movw r24,r16
	call WRN_Update
	movw r30,r16
	ldd r20,Z+25
	ld r18,Z
	ldd r19,Z+1
	ldd r24,Z+22
	ldd r25,Z+23
	sbrs r20,4
	rjmp .L22
	cpi r18,11
	cpc r19,__zero_reg__
	brsh .+2
	rjmp .L22
	ori r24,lo8(-128)
.L23:
	sbrs r20,5
	rjmp .L24
	cpi r18,6
	cpc r19,__zero_reg__
	brsh .+2
	rjmp .L24
	ori r25,lo8(1)
.L25:
	sbrs r20,3
	rjmp .L26
	cpi r18,6
	cpc r19,__zero_reg__
	brsh .+2
	rjmp .L26
	ori r25,lo8(2)
.L27:
	movw r30,r16
	std Z+22,r24
	std Z+23,r25
	ldd r20,Y+14
	ldd r21,Y+15
	lds r22,s_overspeedActive
	cpse r22,__zero_reg__
	rjmp .L28
	cp r20,r18
	cpc r21,r19
	brlo .+2
	rjmp .L29
	ldi r18,lo8(1)
	sts s_overspeedActive,r18
.L30:
	ori r24,lo8(64)
.L70:
	movw r30,r16
	std Z+22,r24
	std Z+23,r25
	mov r18,r6
	mov r20,r7
	adiw r28,90-63
	ldd r22,Y+63
	sbiw r28,90-63
	movw r24,r16
	call FSM_Run
	movw r30,r16
	ldd r24,Z+26
	lds r25,prevFsmState.0
	cp r24,r25
	breq .L31
	cpi r24,lo8(1)
	brne .L32
	std Z+18,__zero_reg__
	std Z+19,__zero_reg__
.L32:
	sts prevFsmState.0,r24
.L31:
	lds r24,s_blinkTickCount
	lds r25,s_blinkTickCount+1
	adiw r24,1
	cpi r24,45
	cpc r25,__zero_reg__
	brlo .+2
	rjmp .L33
	sts s_blinkTickCount,r24
	sts s_blinkTickCount+1,r25
.L34:
	sbrc r12,0
	call Console_ProcessCommand
.L36:
	movw r22,r12
	movw r24,r14
	ldi r18,lo8(5)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	sbiw r24,0
	sbci r23,hi8(1)
	sbci r22,lo8(1)
	brne .L37
	movw r30,r16
	ldd r24,Z+26
	cpi r24,lo8(3)
	brne .+2
	rjmp .L90
	brlo .+2
	rjmp .L39
	cpi r24,lo8(2)
	brne .+2
	rjmp .L40
	ldi r24,0
.L38:
	movw r30,r16
	std Z+24,r24
	call Lmp_Shift
.L37:
	movw r22,r12
	movw r24,r14
	ldi r18,lo8(10)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	sbiw r24,0
	sbci r23,hi8(2)
	sbci r22,lo8(2)
	brne .L47
	movw r24,r28
	adiw r24,1
	movw r22,r24
	movw r24,r16
	call SPD_Task100ms
	movw r30,r16
	ld r24,Z
	ldd r25,Z+1
	cpi r24,-5
	cpc r25,__zero_reg__
	brsh .L48
	ldd r18,Y+12
	ldd r19,Y+13
	cp r18,r24
	cpc r19,r25
	brsh .L48
	std Y+12,r24
	std Y+13,r25
.L48:
	movw r30,r16
	ldd r24,Z+25
	andi r24,lo8(3)
	breq .L49
	ldi r24,lo8(1)
	lds r25,s_blinkOn
	cpse r25,__zero_reg__
	rjmp .L49
	ldi r24,0
.L49:
	movw r30,r16
	ldd r25,Z+26
	cpi r25,lo8(6)
	breq .+2
	rjmp .L51
	ldi r24,lo8(2)
	ldi r25,0
.L175:
	call CHM_Play
	call CHM_Update
.L47:
	movw r22,r12
	movw r24,r14
	ldi r18,lo8(25)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	cpi r22,3
	cpc r23,__zero_reg__
	cpc r24,r23
	cpc r25,r23
	breq .+2
	rjmp .L55
	movw r24,r28
	adiw r24,1
	movw r22,r24
	movw r24,r16
	call TAC_Task250ms
.L56:
	movw r22,r12
	movw r24,r14
	ldi r18,lo8(50)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	sbiw r24,0
	sbci r23,hi8(4)
	sbci r22,lo8(4)
	brne .L64
	movw r24,r16
	call GAU_Update
.L64:
	movw r22,r12
	movw r24,r14
	ldi r18,lo8(100)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	sbiw r24,0
	sbci r23,hi8(6)
	sbci r22,lo8(6)
	breq .+2
	rjmp .L65
	movw r30,r16
	ldd r24,Z+26
	cpi r24,lo8(0)
	breq .L66
	ldd r24,Z+28
	ldd r25,Z+29
	ldd r26,Z+30
	ldd r27,Z+31
	adiw r24,1
	adc r26,__zero_reg__
	adc r27,__zero_reg__
	std Z+28,r24
	std Z+29,r25
	std Z+30,r26
	std Z+31,r27
	adiw r28,71-60
	ldd r24,Y+60
	ldd r25,Y+61
	ldd r26,Y+62
	ldd r27,Y+63
	sbiw r28,71-60
	adiw r24,1
	adc r26,__zero_reg__
	adc r27,__zero_reg__
	adiw r28,71-60
	std Y+60,r24
	std Y+61,r25
	std Y+62,r26
	std Y+63,r27
	sbiw r28,71-60
.L66:
	adiw r28,71-60
	ldd r24,Y+60
	ldd r25,Y+61
	ldd r26,Y+62
	ldd r27,Y+63
	sbiw r28,71-60
	ldi r18,0
	ldi r19,0
	or r24,r25
	or r24,r26
	or r24,r27
	breq .L67
	movw r30,r16
	ldd r18,Z+14
	ldd r19,Z+15
	ldd r20,Z+16
	ldd r21,Z+17
	ldi r26,lo8(36)
	ldi r27,0
	call __muluhisi3
	adiw r28,81-60
	std Y+60,r22
	std Y+61,r23
	std Y+62,r24
	std Y+63,r25
	sbiw r28,81-60
	ldi r26,lo8(10)
	adiw r28,71-60
	ldd r18,Y+60
	ldd r19,Y+61
	ldd r20,Y+62
	ldd r21,Y+63
	sbiw r28,71-60
	call __muluhisi3
	movw r18,r22
	movw r20,r24
	adiw r28,81-60
	ldd r22,Y+60
	ldd r23,Y+61
	ldd r24,Y+62
	ldd r25,Y+63
	sbiw r28,81-60
	call __udivmodsi4
.L67:
	movw r30,r16
	std Z+20,r18
	std Z+21,r19
.L65:
	movw r22,r12
	movw r24,r14
	ldi r18,lo8(-12)
	ldi r19,lo8(1)
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	sbiw r24,0
	sbci r23,hi8(8)
	sbci r22,lo8(8)
	brne .L68
	call Console_SendTelemetry
.L68:
	ldi r20,0
	ldi r22,lo8(6)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	adiw r28,80-63
	ldd r6,Y+63
	sbiw r28,80-63
	adiw r28,79-63
	ldd r24,Y+63
	sbiw r28,79-63
	adiw r28,81-63
	std Y+63,r24
	sbiw r28,81-63
	mov r7,r10
	rjmp .L5
.L22:
	andi r24,lo8(127)
	rjmp .L23
.L24:
	andi r25,lo8(-2)
	rjmp .L25
.L26:
	andi r25,lo8(-3)
	rjmp .L27
.L28:
	subi r20,5
	sbci r21,0
	cp r18,r20
	cpc r19,r21
	brlo .+2
	rjmp .L30
	sts s_overspeedActive,__zero_reg__
.L29:
	andi r24,lo8(-65)
	rjmp .L70
.L33:
	sts s_blinkTickCount,__zero_reg__
	sts s_blinkTickCount+1,__zero_reg__
	ldi r24,lo8(1)
	lds r25,s_blinkOn
	cpse r25,__zero_reg__
	ldi r24,0
.L35:
	sts s_blinkOn,r24
	rjmp .L34
.L39:
	cpi r24,lo8(4)
	breq .L41
	cpi r24,lo8(7)
	brne .L40
.L41:
	ldi r24,lo8(6)
	rjmp .L38
.L40:
	lds r20,s_blinkOn
	movw r30,r16
	ldd r18,Z+22
	ldd r19,Z+23
	bst r18,5
	clr r24
	bld r24,0
	sbrc r18,1
	ori r24,lo8(2)
.L42:
	sbrc r18,2
	ori r24,lo8(4)
.L43:
	sbrc r18,3
	ori r24,lo8(8)
.L44:
	sbrc r18,4
	ori r24,lo8(16)
.L45:
	movw r30,r16
	ldd r25,Z+25
	sbrc r25,2
	ori r24,lo8(-128)
.L46:
	cpi r20,lo8(0)
	brne .+2
	rjmp .L38
	bst r25,0
	clr r18
	bld r18,5
	or r24,r18
	sbrs r25,1
	rjmp .L38
	ori r24,lo8(64)
	rjmp .L38
.L90:
	ldi r24,lo8(-1)
	rjmp .L38
.L51:
	lds r25,s_overspeedActive
	cpi r25,lo8(0)
	breq .L53
	ldi r24,lo8(1)
	ldi r25,0
	rjmp .L175
.L53:
	cpi r24,lo8(0)
	breq .L54
	ldi r24,lo8(3)
	ldi r25,0
	rjmp .L175
.L54:
	ldi r24,0
	ldi r25,0
	rjmp .L175
.L55:
	sbiw r24,0
	sbci r23,hi8(5)
	sbci r22,lo8(5)
	breq .+2
	rjmp .L56
	ldi r24,lo8(17)
	mov r7,r24
	movw r30,r2
	mov r24,r7
	0:
	st Z+,__zero_reg__
	dec r24
	brne 0b
	movw r30,r4
	mov r24,r7
	0:
	st Z+,__zero_reg__
	dec r24
	brne 0b
	movw r30,r16
	ldd r24,Z+26
	cpi r24,lo8(3)
	brne .L57
	ldi r22,lo8(.LC1)
	ldi r23,hi8(.LC1)
	movw r24,r2
	call strcpy
	ldi r22,lo8(.LC2)
	ldi r23,hi8(.LC2)
	movw r24,r4
	call strcpy
.L58:
	movw r20,r4
	movw r22,r2
	movw r30,r16
	ldd r24,Z+27
	call DSP_Render
	rjmp .L56
.L57:
	cpi r24,lo8(6)
	brne .L59
	ldi r24,lo8(.LC3)
	ldi r25,hi8(.LC3)
	push r25
	push r24
	push __zero_reg__
	push r7
	push r3
	push r2
	call snprintf
	movw r30,r16
	ldd r24,Z+3
	push r24
	ldd r24,Z+2
	push r24
	ldd r24,Z+1
	push r24
	ld r24,Z
	push r24
	ldi r24,lo8(.LC4)
	ldi r25,hi8(.LC4)
	push r25
	push r24
	push __zero_reg__
	push r7
	push r5
	push r4
.L176:
	call snprintf
	rjmp .L177
.L59:
	ldd r24,Z+27
	cpi r24,lo8(1)
	brne .L60
	ldd r24,Z+17
	push r24
	ldd r24,Z+16
	push r24
	ldd r24,Z+15
	push r24
	ldd r24,Z+14
	push r24
	ldi r24,lo8(.LC5)
	ldi r25,hi8(.LC5)
	push r25
	push r24
	push __zero_reg__
	push r7
	push r3
	push r2
	call snprintf
	movw r30,r16
	ldd r24,Z+19
	push r24
	ldd r24,Z+18
	push r24
	ldd r24,Z+21
	push r24
	ldd r24,Z+20
	push r24
	ldi r24,lo8(.LC6)
	ldi r25,hi8(.LC6)
.L179:
	push r25
	push r24
	push __zero_reg__
	push r7
	push r5
	push r4
	rjmp .L176
.L60:
	cpi r24,lo8(2)
	brne .L61
	ldd r24,Z+6
	push r24
	ldd r24,Z+5
	push r24
	ldd r24,Z+3
	push r24
	ldd r24,Z+2
	push r24
	ldi r24,lo8(.LC7)
	ldi r25,hi8(.LC7)
	push r25
	push r24
	push __zero_reg__
	push r7
	push r3
	push r2
	call snprintf
	movw r30,r16
	ldd r24,Z+9
	ldi r22,lo8(10)
	call __udivmodqi4
	push __zero_reg__
	push r25
	push __zero_reg__
	push r24
	ldi r24,lo8(.LC8)
	ldi r25,hi8(.LC8)
	rjmp .L179
.L61:
	cpi r24,lo8(3)
	brne .L62
	ldd r24,Z+8
	push r24
	ldd r24,Z+7
	push r24
	ldi r24,lo8(.LC9)
	ldi r25,hi8(.LC9)
	push r25
	push r24
	push __zero_reg__
	push r7
	push r3
	push r2
	call snprintf
	movw r30,r16
	ldd r24,Z+13
	push r24
	ldd r24,Z+12
	push r24
	ldd r24,Z+11
	push r24
	ldd r24,Z+10
	push r24
	ldi r24,lo8(.LC10)
	ldi r25,hi8(.LC10)
.L178:
	push r25
	push r24
	push __zero_reg__
	push r7
	push r5
	push r4
	rjmp .L176
.L62:
	ld r25,Z
	ldd r18,Z+1
	cpi r24,lo8(4)
	brne .L63
	ldd r24,Z+3
	push r24
	ldd r24,Z+2
	push r24
	push r18
	push r25
	ldi r24,lo8(.LC4)
	ldi r25,hi8(.LC4)
	push r25
	push r24
	push __zero_reg__
	push r7
	push r3
	push r2
	call snprintf
	movw r30,r16
	ldd r24,Z+23
	push r24
	ldd r24,Z+22
	push r24
	ldi r24,lo8(.LC11)
	ldi r25,hi8(.LC11)
	push r25
	push r24
	push __zero_reg__
	push r7
	push r5
	push r4
	call snprintf
.L177:
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	rjmp .L58
.L63:
	push r18
	push r25
	ldi r24,lo8(.LC12)
	ldi r25,hi8(.LC12)
	push r25
	push r24
	push __zero_reg__
	push r7
	push r3
	push r2
	call snprintf
	movw r30,r16
	ldd r24,Z+4
	push __zero_reg__
	push r24
	ldd r24,Z+3
	push r24
	ldd r24,Z+2
	push r24
	ldi r24,lo8(.LC13)
	ldi r25,hi8(.LC13)
	rjmp .L178
.L88:
	mov r11,__zero_reg__
	mov r8,__zero_reg__
	mov r9,__zero_reg__
	rjmp .L18
.L16:
	cp r11,__zero_reg__
	brne .+2
	rjmp .L72
	rjmp .L18
	.size	main, .-main
	.section	.data.prevFsmState.0,"aw"
	.type	prevFsmState.0, @object
	.size	prevFsmState.0, 1
prevFsmState.0:
	.byte	-1
	.section	.bss.s_blinkTickCount,"aw",@nobits
	.type	s_blinkTickCount, @object
	.size	s_blinkTickCount, 2
s_blinkTickCount:
	.zero	2
	.section	.bss.s_blinkOn,"aw",@nobits
	.type	s_blinkOn, @object
	.size	s_blinkOn, 1
s_blinkOn:
	.zero	1
	.section	.bss.s_overspeedActive,"aw",@nobits
	.type	s_overspeedActive, @object
	.size	s_overspeedActive, 1
s_overspeedActive:
	.zero	1
	.section	.bss.g_tick10ms,"aw",@nobits
	.type	g_tick10ms, @object
	.size	g_tick10ms, 1
g_tick10ms:
	.zero	1
	.ident	"GCC: (GNU) 16.1.0"
.global __do_copy_data
.global __do_clear_bss
