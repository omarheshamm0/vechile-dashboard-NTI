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
	.section	.text.SPI_TransmitByte,"ax",@progbits
.global	SPI_TransmitByte
	.type	SPI_TransmitByte, @function
SPI_TransmitByte:
	push r28
	push r29
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 3 */
.L__stack_usage = 3
	out 0xf,r24
.L39:
	sbis 0xe,7
	rjmp .L39
	in r24,0xf
	std Y+1,r24
	ldd r24,Y+1
	ldi r24,0
	ldi r25,0
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	ret
	.size	SPI_TransmitByte, .-SPI_TransmitByte
	.section	.text.SPI_Acquire,"ax",@progbits
.global	SPI_Acquire
	.type	SPI_Acquire, @function
SPI_Acquire:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(-1)
	breq .L44
	lds r25,Local_u8BusOwner
	cpi r25,lo8(-1)
	brne .L44
	sts Local_u8BusOwner,r24
	ldi r24,0
	ldi r25,0
	ret
.L44:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	SPI_Acquire, .-SPI_Acquire
	.section	.text.SPI_Release,"ax",@progbits
.global	SPI_Release
	.type	SPI_Release, @function
SPI_Release:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(-1)
	sts Local_u8BusOwner,r24
/* epilogue start */
	ret
	.size	SPI_Release, .-SPI_Release
	.section	.data.Local_u8BusOwner,"aw"
	.type	Local_u8BusOwner, @object
	.size	Local_u8BusOwner, 1
Local_u8BusOwner:
	.byte	-1
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
