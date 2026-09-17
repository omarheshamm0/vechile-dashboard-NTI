	.file	"main.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Debounce_Sample,"ax",@progbits
	.type	Debounce_Sample, @function
Debounce_Sample:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	ldd r24,Z+1
	cp r24,r22
	breq .L2
	std Z+1,r22
	std Z+2,__zero_reg__
.L3:
	ld r24,Z
/* epilogue start */
	ret
.L2:
	ldd r24,Z+2
	cpi r24,lo8(3)
	brsh .L4
	subi r24,lo8(-(1))
	std Z+2,r24
	cpi r24,lo8(3)
	brne .L3
.L4:
	st Z,r22
	rjmp .L3
	.size	Debounce_Sample, .-Debounce_Sample
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
	brne .L5
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
.L5:
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
.LC0:
	.string	"ODO:%lu m"
.LC1:
	.string	"KEY OFF"
.LC2:
	.string	"TRIP:%lu m"
.LC3:
	.string	"BULB CHECK"
.LC4:
	.string	"ALL LAMPS ON"
.LC5:
	.string	"CRANKING..."
.LC6:
	.string	"RPM:%u"
.LC7:
	.string	"ENGINE STOPPED"
.LC8:
	.string	"PRESS START"
.LC9:
	.string	"!! STOP ENGINE !!"
.LC10:
	.string	"SPD:%u RPM:%u"
.LC11:
	.string	"AVG:%u MAX:%u"
.LC12:
	.string	"RPM:%u C:%dC"
.LC13:
	.string	"OIL:%u.%ubar"
.LC14:
	.string	"BAT:%u mV"
.LC15:
	.string	"WARN:0x%04X"
.LC16:
	.string	"SPD:%3u KM/H"
.LC17:
	.string	"RPM:%u F:%u%%"
	.section	.text.startup.main,"ax",@progbits
.global	main
	.type	main, @function
main:
	in r28,__SP_L__
	in r29,__SP_H__
	subi r28,71
	sbci r29,0
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 71 */
/* stack size = 71 */
.L__stack_usage = 71
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
	ldi r24,0
	call LCD_SetBacklight
	call LCD_Clear
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
	std Z+10,__zero_reg__
	std Z+11,__zero_reg__
	std Z+12,__zero_reg__
	std Z+13,__zero_reg__
	std Z+14,__zero_reg__
	std Z+15,__zero_reg__
	std Z+16,__zero_reg__
	std Z+17,__zero_reg__
	mov r10,__zero_reg__
	mov r11,__zero_reg__
	movw r8,r10
	movw r14,r28
	ldi r24,48
	add r14,r24
	adc r15,__zero_reg__
	movw r12,r28
	ldi r24,31
	add r12,r24
	adc r13,__zero_reg__
.L9:
	lds r24,g_tick10ms
	cpi r24,lo8(0)
	breq .L9
	sts g_tick10ms,__zero_reg__
	ldi r20,lo8(1)
	ldi r22,lo8(6)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	movw r24,r28
	subi r24,-67
	sbci r25,-1
	movw r20,r24
	ldi r22,lo8(3)
	ldi r24,lo8(3)
	call GPIO_GetPinValue
	movw r24,r28
	subi r24,-66
	sbci r25,-1
	movw r20,r24
	ldi r22,lo8(4)
	ldi r24,lo8(3)
	call GPIO_GetPinValue
	movw r24,r28
	subi r24,-65
	sbci r25,-1
	movw r20,r24
	ldi r22,lo8(5)
	ldi r24,lo8(3)
	call GPIO_GetPinValue
	movw r20,r14
	ldi r22,lo8(3)
	ldi r24,lo8(1)
	call GPIO_GetPinValue
	adiw r28,67-63
	ldd r22,Y+63
	sbiw r28,67-63
	ldi r24,lo8(s_dbKey)
	ldi r25,hi8(s_dbKey)
	call Debounce_Sample
	mov r6,r24
	adiw r28,66-63
	ldd r22,Y+63
	sbiw r28,66-63
	ldi r24,lo8(s_dbStart)
	ldi r25,hi8(s_dbStart)
	call Debounce_Sample
	mov r5,r24
	adiw r28,65-63
	ldd r22,Y+63
	sbiw r28,65-63
	ldi r24,lo8(s_dbDisp)
	ldi r25,hi8(s_dbDisp)
	call Debounce_Sample
	mov r7,r24
	ldd r22,Y+48
	ldi r24,lo8(s_dbTrip)
	ldi r25,hi8(s_dbTrip)
	call Debounce_Sample
	ldi r25,lo8(1)
	lds r18,s_prevKeyStable
	cpi r18,lo8(1)
	breq .L10
	ldi r25,0
.L10:
	ldi r18,lo8(1)
	cpse r6,__zero_reg__
	ldi r18,0
.L11:
	and r25,r18
	sts s_ignitionPress,r25
	sts s_ignitionHeld,__zero_reg__
	cpse r6,__zero_reg__
	rjmp .L12
	lds r18,s_keyHoldTicks
	lds r19,s_keyHoldTicks+1
	cpi r18,-1
	cpc r19,r18
	breq .L13
	subi r18,-1
	sbci r19,-1
	sts s_keyHoldTicks,r18
	sts s_keyHoldTicks+1,r19
.L13:
	lds r25,s_keyHeldFired
	cpse r25,__zero_reg__
	rjmp .L14
	lds r18,s_keyHoldTicks
	lds r19,s_keyHoldTicks+1
	cpi r18,-56
	sbci r19,0
	brlo .L14
	ldi r25,lo8(1)
	sts s_ignitionHeld,r25
	sts s_keyHeldFired,r25
.L14:
	sts s_prevKeyStable,r6
	ldi r25,lo8(1)
	cpse r5,__zero_reg__
	ldi r25,0
.L15:
	sts s_startPressed,r25
	lds r20,s_prevDispStable
	sts s_prevDispStable,r7
	lds r25,s_tripHeldFired
	cpse r24,__zero_reg__
	rjmp .L16
	lds r18,s_tripHoldTicks
	lds r19,s_tripHoldTicks+1
	cpi r18,-1
	cpc r19,r18
	brne .+2
	rjmp .L17
	subi r18,-1
	sbci r19,-1
	sts s_tripHoldTicks,r18
	sts s_tripHoldTicks+1,r19
	cpse r25,__zero_reg__
	rjmp .L18
	cpi r18,-56
	sbci r19,0
	brlo .L19
.L96:
	ldi r25,lo8(1)
	sts s_tripHeldFired,r25
	movw r30,r16
	std Z+14,__zero_reg__
	std Z+15,__zero_reg__
	std Z+16,__zero_reg__
	std Z+17,__zero_reg__
	sts s_tripSeconds,__zero_reg__
	sts s_tripSeconds+1,__zero_reg__
	sts s_tripSeconds+2,__zero_reg__
	sts s_tripSeconds+3,__zero_reg__
.L18:
	ldi r25,0
.L19:
	ldi r18,-1
	sub r8,r18
	sbc r9,r18
	sbc r10,r18
	sbc r11,r18
	sts s_prevTripStable,r24
	ldi r24,lo8(1)
	cpi r20,lo8(1)
	breq .L22
	ldi r24,0
.L22:
	ldi r18,lo8(1)
	cpse r7,__zero_reg__
	ldi r18,0
.L23:
	and r24,r18
	or r24,r25
	breq .L21
	movw r30,r16
	ldd r24,Z+27
	ldi r25,0
	adiw r24,1
	ldi r22,lo8(5)
	ldi r23,0
	call __udivmodhi4
	std Z+27,r24
.L21:
	std Y+31,__zero_reg__
	movw r24,r12
	call BSW_Read
	or r24,r25
	brne .L24
	ldd r24,Y+31
	andi r24,lo8(63)
	movw r30,r16
	ldd r25,Z+25
	andi r25,lo8(-64)
	or r24,r25
	std Z+25,r24
.L24:
	lds r18,s_startPressed
	lds r20,s_ignitionHeld
	lds r22,s_ignitionPress
	movw r24,r16
	call FSM_Run
	movw r30,r16
	ldd r24,Z+26
	lds r25,s_prevState.0
	cp r24,r25
	breq .L25
	cpi r24,lo8(1)
	brne .L26
	std Z+18,__zero_reg__
	std Z+19,__zero_reg__
.L26:
	sts s_prevState.0,r24
.L25:
	sbrc r8,0
	call Console_ProcessCommand
.L27:
	movw r22,r8
	movw r24,r10
	ldi r18,lo8(5)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	sbiw r24,0
	sbci r23,hi8(1)
	sbci r22,lo8(1)
	breq .+2
	rjmp .L28
	movw r24,r16
	call WRN_Update
	movw r30,r16
	ldd r20,Z+25
	ldd r18,Z+22
	ldd r19,Z+23
	ld r24,Z
	ldd r25,Z+1
	sbrs r20,4
	rjmp .L29
	cpi r24,11
	cpc r25,__zero_reg__
	brlo .L29
	ori r18,lo8(-128)
.L30:
	sbrs r20,5
	rjmp .L31
	cpi r24,6
	cpc r25,__zero_reg__
	brlo .L31
	ori r19,lo8(1)
.L32:
	sbrs r20,3
	rjmp .L33
	cpi r24,6
	cpc r25,__zero_reg__
	brlo .L33
	ori r19,lo8(2)
.L34:
	movw r30,r16
	std Z+22,r18
	std Z+23,r19
	ldd r22,Y+14
	ldd r23,Y+15
	lds r21,s_overspeedActive
	cpse r21,__zero_reg__
	rjmp .L35
	cp r22,r24
	cpc r23,r25
	brsh .L36
	ldi r24,lo8(1)
	sts s_overspeedActive,r24
.L37:
	ori r18,lo8(64)
	rjmp .L95
.L12:
	sts s_keyHoldTicks,__zero_reg__
	sts s_keyHoldTicks+1,__zero_reg__
	sts s_keyHeldFired,__zero_reg__
	rjmp .L14
.L16:
	lds r18,s_prevTripStable
	or r18,r25
	ldi r25,lo8(1)
	cpse r18,__zero_reg__
	ldi r25,0
.L20:
	sts s_tripHoldTicks,__zero_reg__
	sts s_tripHoldTicks+1,__zero_reg__
	sts s_tripHeldFired,__zero_reg__
	rjmp .L19
.L29:
	andi r18,lo8(127)
	rjmp .L30
.L31:
	andi r19,lo8(-2)
	rjmp .L32
.L33:
	andi r19,lo8(-3)
	rjmp .L34
.L35:
	subi r22,5
	sbci r23,0
	cp r24,r22
	cpc r25,r23
	brsh .L37
	sts s_overspeedActive,__zero_reg__
.L36:
	andi r18,lo8(-65)
.L95:
	movw r30,r16
	std Z+22,r18
	std Z+23,r19
	lds r24,s_blinkCallCount
	subi r24,lo8(-(1))
	cpi r24,lo8(9)
	brsh .L38
	sts s_blinkCallCount,r24
.L39:
	movw r30,r16
	ldd r24,Z+26
	cpi r24,lo8(3)
	brne .+2
	rjmp .L97
	brlo .+2
	rjmp .L42
	cpi r24,lo8(2)
	brne .+2
	rjmp .L43
	ldi r24,0
.L41:
	movw r30,r16
	std Z+24,r24
	call Lmp_Shift
.L28:
	movw r22,r8
	movw r24,r10
	ldi r18,lo8(10)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	sbiw r24,0
	sbci r23,hi8(2)
	sbci r22,lo8(2)
	breq .+2
	rjmp .L57
	movw r30,r16
	ldd r24,Z+26
	cpi r24,lo8(0)
	brne .+2
	rjmp .L58
	movw r24,r28
	adiw r24,1
	movw r22,r24
	movw r24,r16
	call SPD_Task100ms
.L59:
	movw r30,r16
	ld r24,Z
	ldd r25,Z+1
	cpi r24,-5
	cpc r25,__zero_reg__
	brsh .L60
	ldd r18,Y+12
	ldd r19,Y+13
	cp r18,r24
	cpc r19,r25
	brsh .L60
	std Y+12,r24
	std Y+13,r25
.L60:
	movw r30,r16
	ldd r25,Z+26
	cpse r25,__zero_reg__
	rjmp .L61
.L67:
	ldi r24,0
	ldi r25,0
	rjmp .L210
.L38:
	lds r25,s_blinkOn
	sts s_blinkCallCount,__zero_reg__
	ldi r24,lo8(1)
	cpse r25,__zero_reg__
	ldi r24,0
.L40:
	sts s_blinkOn,r24
	rjmp .L39
.L42:
	cpi r24,lo8(6)
	breq .L44
	cpi r24,lo8(7)
	breq .L45
	cpi r24,lo8(4)
	brne .L46
.L45:
	ldi r24,lo8(6)
	rjmp .L41
.L44:
	movw r24,r16
	call WRN_Highest
	movw r18,r24
	ldi r24,lo8(2)
	cpi r18,1
	cpc r19,__zero_reg__
	breq .L209
	ldi r24,lo8(8)
	cpi r18,3
	cpc r19,__zero_reg__
	breq .L209
	ldi r24,lo8(1)
	cpi r18,2
	sbci r19,0
	breq .L48
	ldi r24,0
.L48:
	lsl r24
	lsl r24
.L209:
	ori r24,lo8(16)
	rjmp .L41
.L43:
	bst r18,5
	clr r24
	bld r24,0
	sbrc r18,1
	ori r24,lo8(2)
.L49:
	sbrc r18,2
	ori r24,lo8(4)
.L50:
	sbrc r18,3
	ori r24,lo8(8)
.L51:
	sbrs r18,4
	rjmp .L41
	rjmp .L209
.L46:
	lds r25,s_blinkOn
	bst r18,5
	clr r24
	bld r24,0
	sbrc r18,1
	ori r24,lo8(2)
.L52:
	sbrc r18,2
	ori r24,lo8(4)
.L53:
	sbrc r18,3
	ori r24,lo8(8)
.L54:
	sbrc r18,4
	ori r24,lo8(16)
.L55:
	sbrc r20,2
	ori r24,lo8(-128)
.L56:
	cpi r25,lo8(0)
	brne .+2
	rjmp .L41
	bst r20,0
	clr r25
	bld r25,5
	or r24,r25
	sbrs r20,1
	rjmp .L41
	ori r24,lo8(64)
	rjmp .L41
.L97:
	ldi r24,lo8(-1)
	rjmp .L41
.L58:
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	rjmp .L59
.L61:
	ldd r24,Z+25
	andi r24,lo8(3)
	breq .L62
	ldi r24,lo8(1)
	lds r18,s_blinkOn
	cpse r18,__zero_reg__
	rjmp .L62
	ldi r24,0
.L62:
	cpi r25,lo8(6)
	breq .+2
	rjmp .L64
	ldi r24,lo8(2)
	ldi r25,0
.L210:
	call CHM_Play
	call CHM_Update
.L57:
	movw r22,r8
	movw r24,r10
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
	rjmp .L68
	movw r24,r28
	adiw r24,1
	movw r22,r24
	movw r24,r16
	call TAC_Task250ms
.L69:
	movw r22,r8
	movw r24,r10
	ldi r18,lo8(50)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	sbiw r24,0
	sbci r23,hi8(4)
	sbci r22,lo8(4)
	brne .L89
	movw r24,r16
	call GAU_Update
.L89:
	movw r22,r8
	movw r24,r10
	ldi r18,lo8(100)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	sbiw r24,0
	sbci r23,hi8(6)
	sbci r22,lo8(6)
	breq .+2
	rjmp .L90
	movw r30,r16
	ldd r24,Z+26
	cpi r24,lo8(0)
	breq .L91
	lds r24,s_tripSeconds
	lds r25,s_tripSeconds+1
	lds r26,s_tripSeconds+2
	lds r27,s_tripSeconds+3
	ldd r20,Z+28
	ldd r21,Z+29
	ldd r22,Z+30
	ldd r23,Z+31
	subi r20,-1
	sbci r21,-1
	sbci r22,-1
	sbci r23,-1
	std Z+28,r20
	std Z+29,r21
	std Z+30,r22
	std Z+31,r23
	adiw r24,1
	adc r26,__zero_reg__
	adc r27,__zero_reg__
	sts s_tripSeconds,r24
	sts s_tripSeconds+1,r25
	sts s_tripSeconds+2,r26
	sts s_tripSeconds+3,r27
.L91:
	lds r4,s_tripSeconds
	lds r5,s_tripSeconds+1
	lds r6,s_tripSeconds+2
	lds r7,s_tripSeconds+3
	ldi r18,0
	ldi r19,0
	cp r4,__zero_reg__
	cpc r5,r4
	cpc r6,r4
	cpc r7,r4
	breq .L92
	movw r30,r16
	ldd r18,Z+14
	ldd r19,Z+15
	ldd r20,Z+16
	ldd r21,Z+17
	ldi r26,lo8(36)
	ldi r27,0
	call __muluhisi3
	adiw r28,68-60
	std Y+60,r22
	std Y+61,r23
	std Y+62,r24
	std Y+63,r25
	sbiw r28,68-60
	ldi r26,lo8(10)
	movw r18,r4
	movw r20,r6
	call __muluhisi3
	movw r18,r22
	movw r20,r24
	adiw r28,68-60
	ldd r22,Y+60
	ldd r23,Y+61
	ldd r24,Y+62
	ldd r25,Y+63
	sbiw r28,68-60
	call __udivmodsi4
.L92:
	movw r30,r16
	std Z+20,r18
	std Z+21,r19
.L90:
	movw r22,r8
	movw r24,r10
	ldi r18,lo8(-12)
	ldi r19,lo8(1)
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	sbiw r24,0
	sbci r23,hi8(8)
	sbci r22,lo8(8)
	brne .L93
	call Console_SendTelemetry
.L93:
	ldi r20,0
	ldi r22,lo8(6)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	rjmp .L9
.L64:
	lds r25,s_overspeedActive
	cpi r25,lo8(0)
	breq .L66
	ldi r24,lo8(1)
	ldi r25,0
	rjmp .L210
.L66:
	cpi r24,lo8(0)
	brne .+2
	rjmp .L67
	ldi r24,lo8(3)
	ldi r25,0
	rjmp .L210
.L68:
	sbiw r24,0
	sbci r23,hi8(5)
	sbci r22,lo8(5)
	breq .+2
	rjmp .L69
	movw r30,r14
	ldi r24,lo8(17)
	0:
	st Z+,__zero_reg__
	dec r24
	brne 0b
	movw r30,r12
	ldi r24,lo8(17)
	0:
	st Z+,__zero_reg__
	dec r24
	brne 0b
	lds r18,s_lcdBacklightOn
	movw r30,r16
	ldd r24,Z+26
	cpse r24,__zero_reg__
	rjmp .L70
	lds r24,s_offTicks250
	lds r25,s_offTicks250+1
	adiw r24,1
	sts s_offTicks250,r24
	sts s_offTicks250+1,r25
	sbiw r24,41
	brsh .L71
	cpse r18,__zero_reg__
	rjmp .L72
	ldi r24,lo8(1)
	call LCD_SetBacklight
	ldi r24,lo8(1)
	sts s_lcdBacklightOn,r24
.L72:
	movw r30,r16
	ldd r24,Z+13
	push r24
	ldd r24,Z+12
	push r24
	ldd r24,Z+11
	push r24
	ldd r24,Z+10
	push r24
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	push r25
	push r24
	push __zero_reg__
	ldi r24,lo8(17)
	push r24
	push r15
	push r14
	call snprintf
	ldi r22,lo8(.LC1)
	ldi r23,hi8(.LC1)
	movw r24,r12
	call strcpy
.L217:
	movw r20,r12
	movw r22,r14
	ldi r24,0
.L216:
	call DSP_Render
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	rjmp .L69
.L71:
	cpi r18,lo8(0)
	brne .+2
	rjmp .L69
	ldi r24,0
	call LCD_SetBacklight
	call LCD_Clear
	sts s_lcdBacklightOn,__zero_reg__
	rjmp .L69
.L70:
	sts s_offTicks250,__zero_reg__
	sts s_offTicks250+1,__zero_reg__
	cpse r18,__zero_reg__
	rjmp .L74
	ldi r24,lo8(1)
	call LCD_SetBacklight
	ldi r24,lo8(1)
	sts s_lcdBacklightOn,r24
.L74:
	movw r30,r16
	ldd r24,Z+26
	cpi r24,lo8(4)
	brne .+2
	rjmp .L75
	brsh .L76
	cpi r24,lo8(1)
	breq .L77
	cpi r24,lo8(3)
	brne .+2
	rjmp .L78
.L79:
	movw r30,r16
	ldd r24,Z+27
	cpi r24,lo8(3)
	brne .+2
	rjmp .L82
	brlo .+2
	rjmp .L83
	cpi r24,lo8(1)
	brne .+2
	rjmp .L84
	cpi r24,lo8(2)
	brne .+2
	rjmp .L85
.L86:
	movw r30,r16
	ldd r24,Z+1
	push r24
	ld r24,Z
	push r24
	ldi r24,lo8(.LC16)
	ldi r25,hi8(.LC16)
	push r25
	push r24
	push __zero_reg__
	ldi r24,lo8(17)
	mov r7,r24
	push r7
	push r15
	push r14
	call snprintf
	movw r30,r16
	ldd r24,Z+4
	push __zero_reg__
	push r24
	ldd r24,Z+3
	push r24
	ldd r24,Z+2
	push r24
	ldi r24,lo8(.LC17)
	ldi r25,hi8(.LC17)
	rjmp .L213
.L76:
	cpi r24,lo8(6)
	brne .+2
	rjmp .L80
	cpi r24,lo8(7)
	brne .L79
	ldi r22,lo8(.LC7)
	ldi r23,hi8(.LC7)
	movw r24,r14
	call strcpy
	ldi r22,lo8(.LC8)
	ldi r23,hi8(.LC8)
	rjmp .L219
.L77:
	ldd r24,Z+13
	push r24
	ldd r24,Z+12
	push r24
	ldd r24,Z+11
	push r24
	ldd r24,Z+10
	push r24
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	push r25
	push r24
	push __zero_reg__
	ldi r22,lo8(17)
	mov r7,r22
	push r7
	push r15
	push r14
	call snprintf
	movw r30,r16
	ldd r24,Z+17
	push r24
	ldd r24,Z+16
	push r24
	ldd r24,Z+15
	push r24
	ldd r24,Z+14
	push r24
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	push r25
	push r24
	push __zero_reg__
	push r7
	push r13
	push r12
	call snprintf
	rjmp .L217
.L78:
	ldi r22,lo8(.LC3)
	ldi r23,hi8(.LC3)
	movw r24,r14
	call strcpy
	ldi r22,lo8(.LC4)
	ldi r23,hi8(.LC4)
.L219:
	movw r24,r12
	call strcpy
	movw r20,r12
	movw r22,r14
	ldi r24,lo8(4)
.L214:
	call DSP_Render
	rjmp .L69
.L75:
	ldi r22,lo8(.LC5)
	ldi r23,hi8(.LC5)
	movw r24,r14
	call strcpy
	movw r30,r16
	ldd r24,Z+3
	push r24
	ldd r24,Z+2
	push r24
	ldi r24,lo8(.LC6)
	ldi r25,hi8(.LC6)
	push r25
	push r24
	push __zero_reg__
	ldi r24,lo8(17)
	push r24
	push r13
	push r12
	call snprintf
.L215:
	movw r20,r12
	movw r22,r14
	ldi r24,lo8(4)
	rjmp .L216
.L80:
	ldi r24,lo8(.LC9)
	ldi r25,hi8(.LC9)
	push r25
	push r24
	push __zero_reg__
	ldi r21,lo8(17)
	mov r7,r21
	push r7
	push r15
	push r14
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
	ldi r24,lo8(.LC10)
	ldi r25,hi8(.LC10)
	push r25
	push r24
	push __zero_reg__
	push r7
	push r13
	push r12
	call snprintf
	rjmp .L215
.L83:
	cpi r24,lo8(4)
	breq .+2
	rjmp .L86
	ldd r24,Z+3
	push r24
	ldd r24,Z+2
	push r24
	ldd r24,Z+1
	push r24
	ld r24,Z
	push r24
	ldi r24,lo8(.LC10)
	ldi r25,hi8(.LC10)
	push r25
	push r24
	push __zero_reg__
	ldi r25,lo8(17)
	mov r7,r25
	push r7
	push r15
	push r14
	call snprintf
	movw r30,r16
	ldd r24,Z+23
	push r24
	ldd r24,Z+22
	push r24
	ldi r24,lo8(.LC15)
	ldi r25,hi8(.LC15)
	push r25
	push r24
	push __zero_reg__
	push r7
	push r13
	push r12
	call snprintf
.L212:
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	movw r20,r12
	movw r22,r14
	movw r30,r16
	ldd r24,Z+27
	rjmp .L214
.L84:
	ldd r24,Z+17
	push r24
	ldd r24,Z+16
	push r24
	ldd r24,Z+15
	push r24
	ldd r24,Z+14
	push r24
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	push r25
	push r24
	push __zero_reg__
	ldi r20,lo8(17)
	mov r7,r20
	push r7
	push r15
	push r14
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
	ldi r24,lo8(.LC11)
	ldi r25,hi8(.LC11)
.L218:
	push r25
	push r24
	push __zero_reg__
	push r7
	push r13
	push r12
.L211:
	call snprintf
	rjmp .L212
.L85:
	ldd r24,Z+6
	push r24
	ldd r24,Z+5
	push r24
	ldd r24,Z+3
	push r24
	ldd r24,Z+2
	push r24
	ldi r24,lo8(.LC12)
	ldi r25,hi8(.LC12)
	push r25
	push r24
	push __zero_reg__
	ldi r19,lo8(17)
	mov r7,r19
	push r7
	push r15
	push r14
	call snprintf
	movw r30,r16
	ldd r24,Z+9
	ldi r22,lo8(10)
	call __udivmodqi4
	push __zero_reg__
	push r25
	push __zero_reg__
	push r24
	ldi r24,lo8(.LC13)
	ldi r25,hi8(.LC13)
	rjmp .L218
.L82:
	ldd r24,Z+8
	push r24
	ldd r24,Z+7
	push r24
	ldi r24,lo8(.LC14)
	ldi r25,hi8(.LC14)
	push r25
	push r24
	push __zero_reg__
	ldi r18,lo8(17)
	mov r7,r18
	push r7
	push r15
	push r14
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
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
.L213:
	push r25
	push r24
	push __zero_reg__
	push r7
	push r13
	push r12
	rjmp .L211
.L17:
	cpi r25,lo8(0)
	brne .+2
	rjmp .L96
	rjmp .L18
	.size	main, .-main
	.section	.data.s_prevState.0,"aw"
	.type	s_prevState.0, @object
	.size	s_prevState.0, 1
s_prevState.0:
	.byte	-1
	.section	.bss.s_startPressed,"aw",@nobits
	.type	s_startPressed, @object
	.size	s_startPressed, 1
s_startPressed:
	.zero	1
	.section	.bss.s_ignitionHeld,"aw",@nobits
	.type	s_ignitionHeld, @object
	.size	s_ignitionHeld, 1
s_ignitionHeld:
	.zero	1
	.section	.bss.s_ignitionPress,"aw",@nobits
	.type	s_ignitionPress, @object
	.size	s_ignitionPress, 1
s_ignitionPress:
	.zero	1
	.section	.bss.s_tripHeldFired,"aw",@nobits
	.type	s_tripHeldFired, @object
	.size	s_tripHeldFired, 1
s_tripHeldFired:
	.zero	1
	.section	.bss.s_keyHeldFired,"aw",@nobits
	.type	s_keyHeldFired, @object
	.size	s_keyHeldFired, 1
s_keyHeldFired:
	.zero	1
	.section	.bss.s_tripHoldTicks,"aw",@nobits
	.type	s_tripHoldTicks, @object
	.size	s_tripHoldTicks, 2
s_tripHoldTicks:
	.zero	2
	.section	.bss.s_keyHoldTicks,"aw",@nobits
	.type	s_keyHoldTicks, @object
	.size	s_keyHoldTicks, 2
s_keyHoldTicks:
	.zero	2
	.section	.data.s_prevTripStable,"aw"
	.type	s_prevTripStable, @object
	.size	s_prevTripStable, 1
s_prevTripStable:
	.byte	1
	.section	.data.s_prevDispStable,"aw"
	.type	s_prevDispStable, @object
	.size	s_prevDispStable, 1
s_prevDispStable:
	.byte	1
	.section	.data.s_prevKeyStable,"aw"
	.type	s_prevKeyStable, @object
	.size	s_prevKeyStable, 1
s_prevKeyStable:
	.byte	1
	.section	.data.s_dbTrip,"aw"
	.type	s_dbTrip, @object
	.size	s_dbTrip, 3
s_dbTrip:
	.byte	1
	.byte	1
	.byte	0
	.section	.data.s_dbDisp,"aw"
	.type	s_dbDisp, @object
	.size	s_dbDisp, 3
s_dbDisp:
	.byte	1
	.byte	1
	.byte	0
	.section	.data.s_dbStart,"aw"
	.type	s_dbStart, @object
	.size	s_dbStart, 3
s_dbStart:
	.byte	1
	.byte	1
	.byte	0
	.section	.data.s_dbKey,"aw"
	.type	s_dbKey, @object
	.size	s_dbKey, 3
s_dbKey:
	.byte	1
	.byte	1
	.byte	0
	.section	.bss.s_lcdBacklightOn,"aw",@nobits
	.type	s_lcdBacklightOn, @object
	.size	s_lcdBacklightOn, 1
s_lcdBacklightOn:
	.zero	1
	.section	.bss.s_offTicks250,"aw",@nobits
	.type	s_offTicks250, @object
	.size	s_offTicks250, 2
s_offTicks250:
	.zero	2
	.section	.bss.s_tripSeconds,"aw",@nobits
	.type	s_tripSeconds, @object
	.size	s_tripSeconds, 4
s_tripSeconds:
	.zero	4
	.section	.bss.s_blinkCallCount,"aw",@nobits
	.type	s_blinkCallCount, @object
	.size	s_blinkCallCount, 1
s_blinkCallCount:
	.zero	1
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
