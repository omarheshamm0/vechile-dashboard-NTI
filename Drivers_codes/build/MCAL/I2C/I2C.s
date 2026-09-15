	.file	"I2C.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.I2C_InitMaster,"ax",@progbits
.global	I2C_InitMaster
	.type	I2C_InitMaster, @function
I2C_InitMaster:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r18,r22
	movw r20,r24
	cp r18,__zero_reg__
	cpc r19,__zero_reg__
	cpc r20,__zero_reg__
	cpc r21,__zero_reg__
	breq .L4
	ldi r22,0
	ldi r23,lo8(18)
	ldi r24,lo8(122)
	ldi r25,0
	call __udivmodsi4
	movw r24,r18
	movw r26,r20
	sbiw r24,16
	sbc r26,__zero_reg__
	sbc r27,__zero_reg__
	movw r20,r24
	movw r22,r26
	lsr r23
	ror r22
	ror r21
	ror r20
	cpi r25,2
	cpc r26,__zero_reg__
	cpc r27,__zero_reg__
	brsh .L4
	out 0,r20
	out 0x1,__zero_reg__
	ldi r24,lo8(4)
	out 0x36,r24
	ldi r24,0
	ldi r25,0
	ret
.L4:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	I2C_InitMaster, .-I2C_InitMaster
	.section	.text.I2C_SendStart,"ax",@progbits
.global	I2C_SendStart
	.type	I2C_SendStart, @function
I2C_SendStart:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(-92)
	out 0x36,r24
.L6:
	in __tmp_reg__,0x36
	sbrs __tmp_reg__,7
	rjmp .L6
	in r25,0x1
	andi r25,lo8(-8)
	ldi r18,lo8(1)
	ldi r19,0
	cpi r25,lo8(8)
	brne .L7
	ldi r18,0
.L7:
	movw r24,r18
/* epilogue start */
	ret
	.size	I2C_SendStart, .-I2C_SendStart
	.section	.text.I2C_SendRepeatedStart,"ax",@progbits
.global	I2C_SendRepeatedStart
	.type	I2C_SendRepeatedStart, @function
I2C_SendRepeatedStart:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(-92)
	out 0x36,r24
.L10:
	in __tmp_reg__,0x36
	sbrs __tmp_reg__,7
	rjmp .L10
	in r25,0x1
	andi r25,lo8(-8)
	ldi r18,lo8(1)
	ldi r19,0
	cpi r25,lo8(16)
	brne .L11
	ldi r18,0
.L11:
	movw r24,r18
/* epilogue start */
	ret
	.size	I2C_SendRepeatedStart, .-I2C_SendRepeatedStart
	.section	.text.I2C_SendStop,"ax",@progbits
.global	I2C_SendStop
	.type	I2C_SendStop, @function
I2C_SendStop:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(-108)
	out 0x36,r24
.L14:
	in __tmp_reg__,0x36
	sbrc __tmp_reg__,4
	rjmp .L14
/* epilogue start */
	ret
	.size	I2C_SendStop, .-I2C_SendStop
	.section	.text.I2C_SendSlaveAddressWithWrite,"ax",@progbits
.global	I2C_SendSlaveAddressWithWrite
	.type	I2C_SendSlaveAddressWithWrite, @function
I2C_SendSlaveAddressWithWrite:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lsl r24
	out 0x3,r24
	ldi r24,lo8(-124)
	out 0x36,r24
.L17:
	in __tmp_reg__,0x36
	sbrs __tmp_reg__,7
	rjmp .L17
	in r25,0x1
	andi r25,lo8(-8)
	ldi r18,lo8(1)
	ldi r19,0
	cpi r25,lo8(24)
	brne .L18
	ldi r18,0
.L18:
	movw r24,r18
/* epilogue start */
	ret
	.size	I2C_SendSlaveAddressWithWrite, .-I2C_SendSlaveAddressWithWrite
	.section	.text.I2C_SendSlaveAddressWithRead,"ax",@progbits
.global	I2C_SendSlaveAddressWithRead
	.type	I2C_SendSlaveAddressWithRead, @function
I2C_SendSlaveAddressWithRead:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lsl r24
	ori r24,lo8(1)
	out 0x3,r24
	ldi r24,lo8(-124)
	out 0x36,r24
.L21:
	in __tmp_reg__,0x36
	sbrs __tmp_reg__,7
	rjmp .L21
	in r25,0x1
	andi r25,lo8(-8)
	ldi r18,lo8(1)
	ldi r19,0
	cpi r25,lo8(64)
	brne .L22
	ldi r18,0
.L22:
	movw r24,r18
/* epilogue start */
	ret
	.size	I2C_SendSlaveAddressWithRead, .-I2C_SendSlaveAddressWithRead
	.section	.text.I2C_SendByte,"ax",@progbits
.global	I2C_SendByte
	.type	I2C_SendByte, @function
I2C_SendByte:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	out 0x3,r24
	ldi r24,lo8(-124)
	out 0x36,r24
.L25:
	in __tmp_reg__,0x36
	sbrs __tmp_reg__,7
	rjmp .L25
	in r25,0x1
	andi r25,lo8(-8)
	ldi r18,lo8(1)
	ldi r19,0
	cpi r25,lo8(40)
	brne .L26
	ldi r18,0
.L26:
	movw r24,r18
/* epilogue start */
	ret
	.size	I2C_SendByte, .-I2C_SendByte
	.section	.text.I2C_ReceiveByte,"ax",@progbits
.global	I2C_ReceiveByte
	.type	I2C_ReceiveByte, @function
I2C_ReceiveByte:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	or r24,r25
	brne .L29
.L33:
	ldi r24,lo8(1)
	ldi r25,0
	ret
.L29:
	cpi r22,lo8(1)
	brne .L31
	ldi r24,lo8(-60)
	out 0x36,r24
	ldi r24,lo8(80)
.L34:
	in __tmp_reg__,0x36
	sbrs __tmp_reg__,7
	rjmp .L34
	in r25,0x1
	andi r25,lo8(-8)
	cpse r25,r24
	rjmp .L33
	in r24,0x3
	st Z,r24
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
.L31:
	brsh .L33
	ldi r24,lo8(-124)
	out 0x36,r24
	ldi r24,lo8(88)
	rjmp .L34
	.size	I2C_ReceiveByte, .-I2C_ReceiveByte
	.ident	"GCC: (GNU) 15.2.0"
