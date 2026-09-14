	.file	"gauges.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Check_Plausibility,"ax",@progbits
	.type	Check_Plausibility, @function
Check_Plausibility:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbiw r24,0
	breq .L2
	cpi r24,-1
	sbci r25,3
	brne .L4
.L2:
	movw r30,r22
	ld r25,Z
	subi r25,lo8(-(1))
	cpi r25,lo8(10)
	brsh .L5
.L9:
	ldi r24,0
.L3:
	movw r30,r22
	st Z,r25
/* epilogue start */
	ret
.L4:
	ldi r25,0
	rjmp .L9
.L5:
	ldi r24,lo8(1)
	ldi r25,lo8(10)
	rjmp .L3
	.size	Check_Plausibility, .-Check_Plausibility
	.section	.text.GAU_Init,"ax",@progbits
.global	GAU_Init
	.type	GAU_Init, @function
GAU_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r22,lo8(6)
	ldi r24,0
	jmp ADC_Init
	.size	GAU_Init, .-GAU_Init
	.section	.text.GAU_Update,"ax",@progbits
.global	GAU_Update
	.type	GAU_Update, @function
GAU_Update:
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,10
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 10 */
/* stack size = 28 */
.L__stack_usage = 28
	movw r16,r24
	movw r22,r28
	subi r22,-7
	sbci r23,-1
	ldi r24,0
	call ADC_ReadChannel
	movw r22,r28
	subi r22,-5
	sbci r23,-1
	ldi r24,lo8(1)
	call ADC_ReadChannel
	movw r22,r28
	subi r22,-3
	sbci r23,-1
	ldi r24,lo8(2)
	call ADC_ReadChannel
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	ldi r24,lo8(3)
	call ADC_ReadChannel
	ldd r8,Y+7
	ldd r9,Y+8
	ldi r22,lo8(ErrCount_Fuel)
	ldi r23,hi8(ErrCount_Fuel)
	movw r24,r8
	call Check_Plausibility
	mov r7,r24
	ldd r10,Y+5
	ldd r11,Y+6
	ldi r22,lo8(ErrCount_Coolant)
	ldi r23,hi8(ErrCount_Coolant)
	movw r24,r10
	call Check_Plausibility
	mov r6,r24
	ldd r12,Y+3
	ldd r13,Y+4
	ldi r22,lo8(ErrCount_Batt)
	ldi r23,hi8(ErrCount_Batt)
	movw r24,r12
	call Check_Plausibility
	std Y+9,r24
	ldd r14,Y+1
	ldd r15,Y+2
	ldi r22,lo8(ErrCount_Oil)
	ldi r23,hi8(ErrCount_Oil)
	movw r24,r14
	call Check_Plausibility
	std Y+10,r24
	movw r30,r16
	ldd r24,Z+22
	ldd r25,Z+23
	cp r7, __zero_reg__
	brne .+2
	rjmp .L12
	cp r6, __zero_reg__
	brne .+2
	rjmp .L12
	ldd r31,Y+9
	cp r31, __zero_reg__
	brne .+2
	rjmp .L12
	ldd r18,Y+10
	cp r18, __zero_reg__
	brne .+2
	rjmp .L12
	ori r24,lo8(16)
.L13:
	movw r30,r16
	std Z+22,r24
	std Z+23,r25
	lds r24,Filter_Idx
	ldi r25,0
	movw r18,r24
	lsl r18
	rol r19
	movw r30,r18
	subi r30,lo8(-(Fuel_Buffer))
	sbci r31,hi8(-(Fuel_Buffer))
	st Z,r8
	std Z+1,r9
	subi r18,lo8(-(Coolant_Buffer))
	sbci r19,hi8(-(Coolant_Buffer))
	movw r30,r18
	st Z,r10
	std Z+1,r11
	adiw r24,1
	andi r24,7
	sts Filter_Idx,r24
	ldi r30,lo8(Fuel_Buffer)
	ldi r31,hi8(Fuel_Buffer)
	ldi r26,lo8(Coolant_Buffer)
	ldi r27,hi8(Coolant_Buffer)
	ldi r24,lo8(Fuel_Buffer+16)
	ldi r25,hi8(Fuel_Buffer+16)
	mov r10,__zero_reg__
	mov r11,__zero_reg__
	movw r8,r10
	movw r2,r8
	movw r4,r8
.L14:
	ld r20,Z+
	ld r21,Z+
	add r2,r20
	adc r3,r21
	adc r4,__zero_reg__
	adc r5,__zero_reg__
	ld r20,X+
	ld r21,X+
	add r8,r20
	adc r9,r21
	adc r10,__zero_reg__
	adc r11,__zero_reg__
	cp r24,r30
	cpc r25,r31
	brne .L14
	cp r7, __zero_reg__
	breq .L15
	ldi r25,3
	1:
	lsr r5
	ror r4
	ror r3
	ror r2
	dec r25
	brne 1b
	movw r18,r2
	ldi r26,lo8(100)
	ldi r27,0
	call __umulhisi3
	ldi r18,lo8(-1)
	ldi r19,lo8(3)
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	movw r30,r16
	std Z+4,r18
.L15:
	cp r6, __zero_reg__
	breq .L16
	ldi r24,3
	1:
	lsr r11
	ror r10
	ror r9
	ror r8
	dec r24
	brne 1b
	movw r18,r8
	ldi r26,lo8(-86)
	ldi r27,0
	call __umulhisi3
	ldi r18,lo8(-1)
	ldi r19,lo8(3)
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	subi r18,40
	sbc r19,__zero_reg__
	movw r30,r16
	std Z+5,r18
	std Z+6,r19
.L16:
	ldd r31,Y+9
	cp r31, __zero_reg__
	breq .L17
	movw r18,r12
	ldi r26,lo8(-128)
	ldi r27,lo8(62)
	call __umulhisi3
	ldi r18,lo8(-1)
	ldi r19,lo8(3)
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	movw r30,r16
	std Z+7,r18
	std Z+8,r19
.L17:
	ldd r31,Y+10
	cp r31, __zero_reg__
	breq .L11
	movw r18,r14
	ldi r26,lo8(100)
	ldi r27,0
	call __umulhisi3
	ldi r18,lo8(-1)
	ldi r19,lo8(3)
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	movw r30,r16
	std Z+9,r18
.L11:
/* epilogue start */
	adiw r28,10
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	ret
.L12:
	andi r24,lo8(-17)
	rjmp .L13
	.size	GAU_Update, .-GAU_Update
	.section	.bss.ErrCount_Oil,"aw",@nobits
	.type	ErrCount_Oil, @object
	.size	ErrCount_Oil, 1
ErrCount_Oil:
	.zero	1
	.section	.bss.ErrCount_Batt,"aw",@nobits
	.type	ErrCount_Batt, @object
	.size	ErrCount_Batt, 1
ErrCount_Batt:
	.zero	1
	.section	.bss.ErrCount_Coolant,"aw",@nobits
	.type	ErrCount_Coolant, @object
	.size	ErrCount_Coolant, 1
ErrCount_Coolant:
	.zero	1
	.section	.bss.ErrCount_Fuel,"aw",@nobits
	.type	ErrCount_Fuel, @object
	.size	ErrCount_Fuel, 1
ErrCount_Fuel:
	.zero	1
	.section	.bss.Filter_Idx,"aw",@nobits
	.type	Filter_Idx, @object
	.size	Filter_Idx, 1
Filter_Idx:
	.zero	1
	.section	.bss.Coolant_Buffer,"aw",@nobits
	.type	Coolant_Buffer, @object
	.size	Coolant_Buffer, 16
Coolant_Buffer:
	.zero	16
	.section	.bss.Fuel_Buffer,"aw",@nobits
	.type	Fuel_Buffer, @object
	.size	Fuel_Buffer, 16
Fuel_Buffer:
	.zero	16
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
