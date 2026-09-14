	.file	"GPIO.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.GPIO_SetPinDirection,"ax",@progbits
.global	GPIO_SetPinDirection
	.type	GPIO_SetPinDirection, @function
GPIO_SetPinDirection:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(4)
	brlo .+2
	rjmp .L17
	cpi r22,lo8(8)
	brlo .+2
	rjmp .L17
	cpi r20,lo8(3)
	brlo .+2
	rjmp .L17
	ldi r18,lo8(1)
	ldi r19,0
	movw r30,r18
	rjmp 2f
	1:
	lsl r30
	2:
	dec r22
	brpl 1b
	cpi r24,lo8(2)
	breq .L3
	cpi r24,lo8(3)
	breq .L4
	cpi r24,lo8(1)
	breq .L5
	cpi r20,lo8(1)
	brne .L6
	in r24,0x1a
	or r24,r30
	out 0x1a,r24
.L7:
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
.L6:
	in r25,0x1a
	mov r24,r30
	com r24
	and r25,r24
	out 0x1a,r25
	cpi r20,lo8(2)
	brne .L8
	in r24,0x1b
	or r24,r30
.L19:
	out 0x1b,r24
	rjmp .L7
.L5:
	cpi r20,lo8(1)
	brne .L9
	in r24,0x17
	or r24,r30
	out 0x17,r24
	rjmp .L7
.L9:
	in r25,0x17
	mov r24,r30
	com r24
	and r25,r24
	out 0x17,r25
	cpi r20,lo8(2)
	brne .L10
	in r24,0x18
	or r24,r30
.L18:
	out 0x18,r24
	rjmp .L7
.L3:
	cpi r20,lo8(1)
	brne .L11
	in r24,0x14
	or r24,r30
	out 0x14,r24
	rjmp .L7
.L11:
	in r25,0x14
	mov r24,r30
	com r24
	and r25,r24
	out 0x14,r25
	cpi r20,lo8(2)
	brne .L12
	in r24,0x15
	or r24,r30
.L20:
	out 0x15,r24
	rjmp .L7
.L4:
	cpi r20,lo8(1)
	brne .L13
	in r24,0x11
	or r24,r30
	out 0x11,r24
	rjmp .L7
.L13:
	in r25,0x11
	mov r24,r30
	com r24
	and r25,r24
	out 0x11,r25
	cpi r20,lo8(2)
	brne .L14
	in r24,0x12
	or r24,r30
.L21:
	out 0x12,r24
	rjmp .L7
.L17:
	ldi r24,lo8(1)
	ldi r25,0
	ret
.L14:
	in r25,0x12
	and r24,r25
	rjmp .L21
.L8:
	in r25,0x1b
	and r24,r25
	rjmp .L19
.L10:
	in r25,0x18
	and r24,r25
	rjmp .L18
.L12:
	in r25,0x15
	and r24,r25
	rjmp .L20
	.size	GPIO_SetPinDirection, .-GPIO_SetPinDirection
	.section	.text.GPIO_SetPinValue,"ax",@progbits
.global	GPIO_SetPinValue
	.type	GPIO_SetPinValue, @function
GPIO_SetPinValue:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(4)
	brsh .L34
	cpi r22,lo8(8)
	brsh .L34
	cpi r20,lo8(2)
	brsh .L34
	ldi r18,lo8(1)
	ldi r19,0
	movw r30,r18
	rjmp 2f
	1:
	lsl r30
	2:
	dec r22
	brpl 1b
	mov r22,r30
	cpi r24,lo8(2)
	breq .L24
	cpi r24,lo8(3)
	breq .L25
	cpi r24,lo8(1)
	breq .L26
	in r24,0x1b
	cpi r20,lo8(1)
	brne .L27
	or r24,r30
	out 0x1b,r24
.L28:
	ldi r24,0
	ldi r25,0
	ret
.L27:
	com r22
	and r22,r24
	out 0x1b,r22
	rjmp .L28
.L26:
	in r24,0x18
	cpi r20,lo8(1)
	brne .L29
	or r24,r30
	out 0x18,r24
	rjmp .L28
.L29:
	com r22
	and r22,r24
	out 0x18,r22
	rjmp .L28
.L24:
	in r24,0x15
	cpi r20,lo8(1)
	brne .L30
	or r24,r30
	out 0x15,r24
	rjmp .L28
.L30:
	com r22
	and r22,r24
	out 0x15,r22
	rjmp .L28
.L25:
	in r24,0x12
	cpi r20,lo8(1)
	brne .L31
	or r24,r30
	out 0x12,r24
	rjmp .L28
.L31:
	com r22
	and r22,r24
	out 0x12,r22
	rjmp .L28
.L34:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	GPIO_SetPinValue, .-GPIO_SetPinValue
	.section	.text.GPIO_GetPinValue,"ax",@progbits
.global	GPIO_GetPinValue
	.type	GPIO_GetPinValue, @function
GPIO_GetPinValue:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r20
	cpi r24,lo8(4)
	brsh .L47
	cpi r22,lo8(8)
	brsh .L47
	sbiw r30,0
	breq .L47
	ldi r18,lo8(1)
	ldi r19,0
	movw r20,r18
	rjmp 2f
	1:
	lsl r20
	2:
	dec r22
	brpl 1b
	mov r22,r20
	cpi r24,lo8(2)
	breq .L37
	cpi r24,lo8(3)
	breq .L38
	cpi r24,lo8(1)
	breq .L39
	in r24,0x19
.L49:
	and r24,r22
	ldi r25,lo8(1)
	cpse r24,__zero_reg__
	rjmp .L44
	ldi r25,0
.L44:
	st Z,r25
	ldi r24,0
	ldi r25,0
	ret
.L39:
	in r24,0x16
	rjmp .L49
.L37:
	in r24,0x13
	rjmp .L49
.L38:
	in r24,0x10
	rjmp .L49
.L47:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	GPIO_GetPinValue, .-GPIO_GetPinValue
	.section	.text.GPIO_TogglePinValue,"ax",@progbits
.global	GPIO_TogglePinValue
	.type	GPIO_TogglePinValue, @function
GPIO_TogglePinValue:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(4)
	brsh .L57
	cpi r22,lo8(8)
	brsh .L57
	ldi r18,lo8(1)
	ldi r19,0
	movw r20,r18
	rjmp 2f
	1:
	lsl r20
	2:
	dec r22
	brpl 1b
	cpi r24,lo8(2)
	breq .L52
	cpi r24,lo8(3)
	breq .L53
	cpi r24,lo8(1)
	breq .L54
	in r24,0x1b
	eor r24,r20
	out 0x1b,r24
.L55:
	ldi r24,0
	ldi r25,0
	ret
.L54:
	in r24,0x18
	eor r24,r20
	out 0x18,r24
	rjmp .L55
.L52:
	in r24,0x15
	eor r24,r20
	out 0x15,r24
	rjmp .L55
.L53:
	in r24,0x12
	eor r24,r20
	out 0x12,r24
	rjmp .L55
.L57:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	GPIO_TogglePinValue, .-GPIO_TogglePinValue
	.section	.text.GPIO_SetPortDirection,"ax",@progbits
.global	GPIO_SetPortDirection
	.type	GPIO_SetPortDirection, @function
GPIO_SetPortDirection:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(4)
	brsh .L64
	cpi r24,lo8(2)
	breq .L60
	cpi r24,lo8(3)
	breq .L61
	cpi r24,lo8(1)
	breq .L62
	out 0x1a,r22
.L63:
	ldi r24,0
	ldi r25,0
	ret
.L62:
	out 0x17,r22
	rjmp .L63
.L60:
	out 0x14,r22
	rjmp .L63
.L61:
	out 0x11,r22
	rjmp .L63
.L64:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	GPIO_SetPortDirection, .-GPIO_SetPortDirection
	.section	.text.GPIO_SetPortValue,"ax",@progbits
.global	GPIO_SetPortValue
	.type	GPIO_SetPortValue, @function
GPIO_SetPortValue:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(4)
	brsh .L71
	cpi r24,lo8(2)
	breq .L67
	cpi r24,lo8(3)
	breq .L68
	cpi r24,lo8(1)
	breq .L69
	out 0x1b,r22
.L70:
	ldi r24,0
	ldi r25,0
	ret
.L69:
	out 0x18,r22
	rjmp .L70
.L67:
	out 0x15,r22
	rjmp .L70
.L68:
	out 0x12,r22
	rjmp .L70
.L71:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	GPIO_SetPortValue, .-GPIO_SetPortValue
	.section	.text.GPIO_GetPortValue,"ax",@progbits
.global	GPIO_GetPortValue
	.type	GPIO_GetPortValue, @function
GPIO_GetPortValue:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r22
	cpi r24,lo8(4)
	brsh .L79
	sbiw r30,0
	breq .L79
	cpi r24,lo8(2)
	breq .L74
	cpi r24,lo8(3)
	breq .L75
	cpi r24,lo8(1)
	breq .L76
	in r24,0x19
.L80:
	st Z,r24
	ldi r24,0
	ldi r25,0
	ret
.L76:
	in r24,0x16
	rjmp .L80
.L74:
	in r24,0x13
	rjmp .L80
.L75:
	in r24,0x10
	rjmp .L80
.L79:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	GPIO_GetPortValue, .-GPIO_GetPortValue
	.ident	"GCC: (GNU) 15.2.0"
