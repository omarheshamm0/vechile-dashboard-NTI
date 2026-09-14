	.file	"SPI.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SPI_InitMaster,"ax",@progbits
.global	SPI_InitMaster
	.type	SPI_InitMaster, @function
SPI_InitMaster:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	mov r28,r24
	cpi r24,lo8(4)
	brlo .L2
.L4:
	ldi r24,lo8(1)
	ldi r25,0
.L1:
/* epilogue start */
	pop r28
	ret
.L2:
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	sbiw r24,1
	breq .L4
	ldi r20,lo8(1)
	ldi r22,lo8(5)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	sbiw r24,1
	breq .L4
	ldi r20,0
	ldi r22,lo8(6)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	sbiw r24,1
	breq .L4
	ldi r20,lo8(1)
	ldi r22,lo8(7)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	sbiw r24,1
	breq .L4
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	sbiw r24,1
	breq .L4
	cbi 0xe,0
	ori r28,lo8(80)
	out 0xd,r28
	ldi r24,0
	ldi r25,0
	rjmp .L1
	.size	SPI_InitMaster, .-SPI_InitMaster
	.section	.text.SPI_InitSlave,"ax",@progbits
.global	SPI_InitSlave
	.type	SPI_InitSlave, @function
SPI_InitSlave:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,0
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	sbiw r24,1
	brne .L21
.L23:
	ldi r24,lo8(1)
	ldi r25,0
	ret
.L21:
	ldi r20,0
	ldi r22,lo8(5)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	sbiw r24,1
	breq .L23
	ldi r20,lo8(1)
	ldi r22,lo8(6)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	sbiw r24,1
	breq .L23
	ldi r20,0
	ldi r22,lo8(7)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	sbiw r24,1
	breq .L23
	cbi 0xe,0
	ldi r24,lo8(64)
	out 0xd,r24
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	SPI_InitSlave, .-SPI_InitSlave
	.section	.text.SPI_Transceive,"ax",@progbits
.global	SPI_Transceive
	.type	SPI_Transceive, @function
SPI_Transceive:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L36
	out 0xf,r24
.L35:
	sbis 0xe,7
	rjmp .L35
	in r24,0xf
	movw r30,r22
	st Z,r24
	ldi r24,0
	ldi r25,0
	ret
.L36:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	SPI_Transceive, .-SPI_Transceive
	.section	.text.SPI_SelectSlave,"ax",@progbits
.global	SPI_SelectSlave
	.type	SPI_SelectSlave, @function
SPI_SelectSlave:
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 4 */
.L__stack_usage = 4
	std Y+1,r24
	std Y+2,r22
	ldi r20,lo8(1)
	call GPIO_SetPinDirection
	cpi r24,1
	cpc r25,__zero_reg__
	breq .L38
	ldi r20,0
	ldd r22,Y+2
	ldd r24,Y+1
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	jmp GPIO_SetPinValue
.L38:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	ret
	.size	SPI_SelectSlave, .-SPI_SelectSlave
	.section	.text.SPI_ReleaseSlave,"ax",@progbits
.global	SPI_ReleaseSlave
	.type	SPI_ReleaseSlave, @function
SPI_ReleaseSlave:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	jmp GPIO_SetPinValue
	.size	SPI_ReleaseSlave, .-SPI_ReleaseSlave
	.ident	"GCC: (GNU) 15.2.0"
