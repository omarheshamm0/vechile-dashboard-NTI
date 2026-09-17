	.file	"speedo.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SPD_Init,"ax",@progbits
.global	SPD_Init
	.type	SPD_Init, @function
SPD_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cbi 0x17,2
	cbi 0x18,2
	sts s_lastCnt+1,__zero_reg__
	sts s_lastCnt,__zero_reg__
	sts s_ovfCount+1,__zero_reg__
	sts s_ovfCount,__zero_reg__
	sts s_deltaTicks,__zero_reg__
	sts s_deltaTicks+1,__zero_reg__
	sts s_deltaTicks+2,__zero_reg__
	sts s_deltaTicks+3,__zero_reg__
	sts s_fresh,__zero_reg__
	sts s_stallTicks,__zero_reg__
	sts s_stallTicks+1,__zero_reg__
	ldi r24,lo8(1)
	sts s_firstEdge,r24
	sts s_pulseAccum+1,__zero_reg__
	sts s_pulseAccum,__zero_reg__
	out 0x2f,__zero_reg__
	ldi r24,lo8(3)
	out 0x2e,r24
	ldi r24,lo8(4)
	out 0x38,r24
	in r24,0x39
	ori r24,lo8(4)
	out 0x39,r24
	out 0x2c+1,__zero_reg__
	out 0x2c,__zero_reg__
	in r24,0x34
	ori r24,lo8(64)
	out 0x34,r24
	in r24,0x3a
	ori r24,lo8(32)
	out 0x3a,r24
	in r24,0x3b
	ori r24,lo8(32)
	out 0x3b,r24
/* epilogue start */
	ret
	.size	SPD_Init, .-SPD_Init
	.section	.text.SPD_OnOverflowISR,"ax",@progbits
.global	SPD_OnOverflowISR
	.type	SPD_OnOverflowISR, @function
SPD_OnOverflowISR:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,s_ovfCount
	lds r25,s_ovfCount+1
	adiw r24,1
	sts s_ovfCount+1,r25
	sts s_ovfCount,r24
/* epilogue start */
	ret
	.size	SPD_OnOverflowISR, .-SPD_OnOverflowISR
	.section	.text.__vector_9,"ax",@progbits
.global	__vector_9
	.type	__vector_9, @function
__vector_9:
	push r1
	push r0
	in r0,__SREG__
	push r0
	clr __zero_reg__
	push r18
	push r19
	push r20
	push r21
	push r22
	push r23
	push r24
	push r25
	push r26
	push r27
	push r30
	push r31
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 15 */
.L__stack_usage = 15
	call SPD_OnOverflowISR
/* epilogue start */
	pop r31
	pop r30
	pop r27
	pop r26
	pop r25
	pop r24
	pop r23
	pop r22
	pop r21
	pop r20
	pop r19
	pop r18
	pop r0
	out __SREG__,r0
	pop r0
	pop r1
	reti
	.size	__vector_9, .-__vector_9
	.section	.text.__vector_3,"ax",@progbits
.global	__vector_3
	.type	__vector_3, @function
__vector_3:
	__gcc_isr 1
	push r19
	push r20
	push r21
	push r24
	push r25
	push r26
	push r27
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 7...11 */
.L__stack_usage = 7 + __gcc_isr.n_pushed
	in r18,0x2c
	in r19,0x2c+1
	lds r24,s_firstEdge
	cp r24, __zero_reg__
	breq .L5
	sts s_firstEdge,__zero_reg__
	sts s_lastCnt+1,r19
	sts s_lastCnt,r18
	sts s_ovfCount+1,__zero_reg__
	sts s_ovfCount,__zero_reg__
.L4:
/* epilogue start */
	pop r27
	pop r26
	pop r25
	pop r24
	pop r21
	pop r20
	pop r19
	__gcc_isr 2
	reti
.L5:
	lds r24,s_ovfCount
	lds r25,s_ovfCount+1
	lds r20,s_lastCnt
	lds r21,s_lastCnt+1
	movw r26,r24
	ldi r25,0
	ldi r24,0
	sub r24,r20
	sbc r25,r21
	sbc r26,__zero_reg__
	sbc r27,__zero_reg__
	add r24,r18
	adc r25,r19
	adc r26,__zero_reg__
	adc r27,__zero_reg__
	sts s_lastCnt+1,r19
	sts s_lastCnt,r18
	sts s_ovfCount+1,__zero_reg__
	sts s_ovfCount,__zero_reg__
	sts s_deltaTicks,r24
	sts s_deltaTicks+1,r25
	sts s_deltaTicks+2,r26
	sts s_deltaTicks+3,r27
	ldi r24,lo8(1)
	sts s_fresh,r24
	sts s_stallTicks,__zero_reg__
	sts s_stallTicks+1,__zero_reg__
	lds r24,s_pulseAccum
	lds r25,s_pulseAccum+1
	adiw r24,1
	sts s_pulseAccum+1,r25
	sts s_pulseAccum,r24
	rjmp .L4
	__gcc_isr 0,r18
	.size	__vector_3, .-__vector_3
	.section	.text.SPD_Task100ms,"ax",@progbits
.global	SPD_Task100ms
	.type	SPD_Task100ms, @function
SPD_Task100ms:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 6 */
.L__stack_usage = 6
	movw r16,r24
	movw r14,r22
	or r24,r25
	brne .+2
	rjmp .L7
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	brne .+2
	rjmp .L7
	movw r30,r22
	ldd r24,Z+22
	cp r24, __zero_reg__
	brne .+2
	rjmp .L7
	in r25,__SREG__
/* #APP */
 ;  100 "HAL/SPEEDO/speedo.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r20,s_deltaTicks
	lds r21,s_deltaTicks+1
	lds r22,s_deltaTicks+2
	lds r23,s_deltaTicks+3
	lds r24,s_fresh
	sts s_fresh,__zero_reg__
	lds r28,s_pulseAccum
	lds r29,s_pulseAccum+1
	sts s_pulseAccum+1,__zero_reg__
	sts s_pulseAccum,__zero_reg__
	out __SREG__,r25
	cp r24, __zero_reg__
	brne .+2
	rjmp .L11
	cp r20,__zero_reg__
	cpc r21,__zero_reg__
	cpc r22,__zero_reg__
	cpc r23,__zero_reg__
	brne .+2
	rjmp .L11
	movw r18,r20
	movw r20,r22
	ldi r24,3
	1:
	lsl r18
	rol r19
	rol r20
	rol r21
	dec r24
	brne 1b
	ldi r22,lo8(64)
	ldi r23,lo8(119)
	ldi r24,lo8(27)
	ldi r25,0
	call __udivmodsi4
	movw r30,r16
	cpi r18,-5
	cpc r19,__zero_reg__
	cpc r20,__zero_reg__
	cpc r21,__zero_reg__
	brsh .L12
	st Z,r18
	std Z+1,r19
	ldd r24,Z+18
	ldd r25,Z+19
	cp r24,r18
	cpc r25,r19
	brsh .L13
	std Z+18,r18
	std Z+19,r19
.L13:
	sts s_stallTicks,__zero_reg__
	sts s_stallTicks+1,__zero_reg__
.L14:
	sbiw r28,0
	breq .L7
	movw r30,r14
	ldd r22,Z+22
	ldi r23,0
	ldd r24,Z+23
	ldd r25,Z+24
	call __udivmodhi4
	cpi r28,101
	cpc r29,__zero_reg__
	brlo .L17
	ldi r28,lo8(100)
	ldi r29,0
.L17:
	mul r22,r28
	movw r24,r0
	mul r22,r29
	add r25,r0
	mul r23,r28
	add r25,r0
	clr r1
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	jmp ODO_AddDistance
.L12:
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	rjmp .L13
.L11:
	lds r24,s_stallTicks
	lds r25,s_stallTicks+1
	cpi r24,-1
	cpc r25,r24
	brne .L15
.L16:
	movw r30,r16
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	rjmp .L14
.L15:
	adiw r24,1
	sts s_stallTicks,r24
	sts s_stallTicks+1,r25
	sbiw r24,10
	brlo .L14
	rjmp .L16
.L7:
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret
	.size	SPD_Task100ms, .-SPD_Task100ms
	.section	.bss.s_pulseAccum,"aw",@nobits
	.type	s_pulseAccum, @object
	.size	s_pulseAccum, 2
s_pulseAccum:
	.zero	2
	.section	.bss.s_firstEdge,"aw",@nobits
	.type	s_firstEdge, @object
	.size	s_firstEdge, 1
s_firstEdge:
	.zero	1
	.section	.bss.s_stallTicks,"aw",@nobits
	.type	s_stallTicks, @object
	.size	s_stallTicks, 2
s_stallTicks:
	.zero	2
	.section	.bss.s_fresh,"aw",@nobits
	.type	s_fresh, @object
	.size	s_fresh, 1
s_fresh:
	.zero	1
	.section	.bss.s_deltaTicks,"aw",@nobits
	.type	s_deltaTicks, @object
	.size	s_deltaTicks, 4
s_deltaTicks:
	.zero	4
	.section	.bss.s_ovfCount,"aw",@nobits
	.type	s_ovfCount, @object
	.size	s_ovfCount, 2
s_ovfCount:
	.zero	2
	.section	.bss.s_lastCnt,"aw",@nobits
	.type	s_lastCnt, @object
	.size	s_lastCnt, 2
s_lastCnt:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
