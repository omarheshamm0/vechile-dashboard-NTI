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
	out 0x2f,__zero_reg__
	ldi r24,lo8(-61)
	out 0x2e,r24
	in r24,0x39
	ori r24,lo8(36)
	out 0x39,r24
/* epilogue start */
	ret
	.size	SPD_Init, .-SPD_Init
	.section	.text.SPD_OnCaptureISR,"ax",@progbits
.global	SPD_OnCaptureISR
	.type	SPD_OnCaptureISR, @function
SPD_OnCaptureISR:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r18,0x26
	in r19,0x26+1
	in __tmp_reg__,0x38
	sbrs __tmp_reg__,2
	rjmp .L3
	sbrc r19,7
	rjmp .L3
	lds r24,g_captureData+2
	lds r25,g_captureData+2+1
	adiw r24,1
	sts g_captureData+2+1,r25
	sts g_captureData+2,r24
	in r24,0x38
	ori r24,lo8(4)
	out 0x38,r24
.L3:
	lds r24,g_captureData+2
	lds r25,g_captureData+2+1
	lds r20,g_captureData
	lds r21,g_captureData+1
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
	sts g_captureData+1,r19
	sts g_captureData,r18
	sts g_captureData+2+1,__zero_reg__
	sts g_captureData+2,__zero_reg__
	sts g_captureData+4,r24
	sts g_captureData+4+1,r25
	sts g_captureData+4+2,r26
	sts g_captureData+4+3,r27
	ldi r24,lo8(1)
	sts g_captureData+8,r24
	sts g_captureData+9+1,__zero_reg__
	sts g_captureData+9,__zero_reg__
/* epilogue start */
	ret
	.size	SPD_OnCaptureISR, .-SPD_OnCaptureISR
	.section	.text.SPD_OnOverflowISR,"ax",@progbits
.global	SPD_OnOverflowISR
	.type	SPD_OnOverflowISR, @function
SPD_OnOverflowISR:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r30,lo8(g_captureData)
	ldi r31,hi8(g_captureData)
	ldd r24,Z+2
	ldd r25,Z+3
	adiw r24,1
	std Z+3,r25
	std Z+2,r24
/* epilogue start */
	ret
	.size	SPD_OnOverflowISR, .-SPD_OnOverflowISR
	.section	.text.__vector_6,"ax",@progbits
.global	__vector_6
	.type	__vector_6, @function
__vector_6:
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
	call SPD_OnCaptureISR
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
	.size	__vector_6, .-__vector_6
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
	.section	.text.SPD_Task100ms,"ax",@progbits
.global	SPD_Task100ms
	.type	SPD_Task100ms, @function
SPD_Task100ms:
	push r28
	push r29
	rcall .
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 4 */
/* stack size = 6 */
.L__stack_usage = 6
	std Y+3,r24
	std Y+4,r25
	std Y+1,r22
	std Y+2,r23
/* #APP */
 ;  57 "HAL/SPEEDO/speedo.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r20,g_captureData+4
	lds r21,g_captureData+4+1
	lds r22,g_captureData+4+2
	lds r23,g_captureData+4+3
	lds r24,g_captureData+8
	sts g_captureData+8,__zero_reg__
/* #APP */
 ;  61 "HAL/SPEEDO/speedo.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	cp r24, __zero_reg__
	brne .+2
	rjmp .L12
	cp r20,__zero_reg__
	cpc r21,__zero_reg__
	cpc r22,__zero_reg__
	cpc r23,__zero_reg__
	brne .+2
	rjmp .L12
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
	cpi r18,-5
	cpc r19,__zero_reg__
	cpc r20,__zero_reg__
	cpc r21,__zero_reg__
	brlo .L14
	ldi r20,0
	ldi r21,0
	movw r18,r20
.L14:
	ldd r30,Y+3
	ldd r31,Y+4
	st Z,r18
	std Z+1,r19
	ldd r24,Z+18
	ldd r25,Z+19
	cp r24,r18
	cpc r25,r19
	brsh .L15
	std Z+18,r18
	std Z+19,r19
.L15:
	ldd r30,Y+1
	ldd r31,Y+2
	ldd r18,Z+22
	cp r18, __zero_reg__
	breq .L12
	ldd r22,Z+23
	ldd r23,Z+24
	ldi r24,0
	ldi r25,0
	ldi r19,0
	movw r20,r24
	call __udivmodsi4
	movw r22,r18
	movw r24,r20
	ldi r18,lo8(-24)
	ldi r19,lo8(3)
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	ldd r30,Y+3
	ldd r31,Y+4
	ldd r24,Z+10
	ldd r25,Z+11
	ldd r26,Z+12
	ldd r27,Z+13
	add r24,r18
	adc r25,r19
	adc r26,r20
	adc r27,r21
	std Z+10,r24
	std Z+11,r25
	std Z+12,r26
	std Z+13,r27
	ldd r24,Z+14
	ldd r25,Z+15
	ldd r26,Z+16
	ldd r27,Z+17
	add r24,r18
	adc r25,r19
	adc r26,r20
	adc r27,r21
	std Z+14,r24
	std Z+15,r25
	std Z+16,r26
	std Z+17,r27
.L12:
	lds r24,g_captureData+9
	lds r25,g_captureData+9+1
	adiw r24,1
	sts g_captureData+9+1,r25
	sts g_captureData+9,r24
	lds r24,g_captureData+9
	lds r25,g_captureData+9+1
	sbiw r24,10
	brlo .L10
	ldd r30,Y+3
	ldd r31,Y+4
	st Z,__zero_reg__
	std Z+1,__zero_reg__
.L10:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	ret
	.size	SPD_Task100ms, .-SPD_Task100ms
	.section	.bss.g_captureData,"aw",@nobits
	.type	g_captureData, @object
	.size	g_captureData, 11
g_captureData:
	.zero	11
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
