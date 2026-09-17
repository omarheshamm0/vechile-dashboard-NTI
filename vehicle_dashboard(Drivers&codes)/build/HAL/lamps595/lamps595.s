	.file	"lamps595.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.LMP_Set,"ax",@progbits
.global	LMP_Set
	.type	LMP_Set, @function
LMP_Set:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(8)
	brsh .L6
	cpi r22,lo8(2)
	brsh .L6
	ldi r18,lo8(1)
	ldi r19,0
	movw r20,r18
	rjmp 2f
	1:
	lsl r20
	2:
	dec r24
	brpl 1b
	mov r24,r20
	lds r18,Local_u8LampByte
	cpi r22,lo8(1)
	brne .L3
	or r18,r20
	sts Local_u8LampByte,r18
.L4:
	ldi r24,0
	ldi r25,0
	ret
.L3:
	com r24
	and r24,r18
	sts Local_u8LampByte,r24
	rjmp .L4
.L6:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	LMP_Set, .-LMP_Set
	.section	.text.LMP_Refresh,"ax",@progbits
.global	LMP_Refresh
	.type	LMP_Refresh, @function
LMP_Refresh:
	push r28
	push r29
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 3 */
.L__stack_usage = 3
	ldi r24,lo8(1)
	call SPI_Acquire
	sbiw r24,1
	breq .L8
	lds r24,Local_u8LampByte
	call SPI_TransmitByte
	sbiw r24,1
	brne .L9
	call SPI_Release
.L8:
	ldi r24,lo8(1)
	ldi r25,0
.L7:
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	ret
.L9:
	call SPI_Release
	ldi r20,lo8(1)
	ldi r22,lo8(2)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	std Y+1,__zero_reg__
.L11:
	ldd r24,Y+1
	cpi r24,lo8(4)
	brlo .L12
	ldi r20,0
	ldi r22,lo8(2)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r24,0
	ldi r25,0
	rjmp .L7
.L12:
	ldd r24,Y+1
	subi r24,lo8(-(1))
	std Y+1,r24
	rjmp .L11
	.size	LMP_Refresh, .-LMP_Refresh
	.section	.text.LMP_Init,"ax",@progbits
.global	LMP_Init
	.type	LMP_Init, @function
LMP_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	ldi r22,lo8(2)
	ldi r24,lo8(2)
	call GPIO_SetPinDirection
	cpi r24,1
	cpc r25,__zero_reg__
	breq .L18
	ldi r20,0
	ldi r22,lo8(2)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	cpi r24,1
	cpc r25,__zero_reg__
	breq .L18
	sts Local_u8LampByte,__zero_reg__
	sts Local_u8SavedLampByte,__zero_reg__
	sts Local_u8BulbCheckActive,__zero_reg__
	jmp LMP_Refresh
.L18:
/* epilogue start */
	ret
	.size	LMP_Init, .-LMP_Init
	.section	.text.LMP_BulbCheckStart,"ax",@progbits
.global	LMP_BulbCheckStart
	.type	LMP_BulbCheckStart, @function
LMP_BulbCheckStart:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,Local_u8LampByte
	sts Local_u8SavedLampByte,r24
	ldi r24,lo8(-1)
	sts Local_u8LampByte,r24
	ldi r24,lo8(1)
	sts Local_u8BulbCheckActive,r24
	jmp LMP_Refresh
	.size	LMP_BulbCheckStart, .-LMP_BulbCheckStart
	.section	.text.LMP_BulbCheckUpdate,"ax",@progbits
.global	LMP_BulbCheckUpdate
	.type	LMP_BulbCheckUpdate, @function
LMP_BulbCheckUpdate:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r18,Local_u8BulbCheckActive
	cp r18, __zero_reg__
	breq .L24
	cpi r24,-72
	sbci r25,11
	brlo .L24
	sts Local_u8BulbCheckActive,__zero_reg__
	lds r24,Local_u8SavedLampByte
	sts Local_u8LampByte,r24
	jmp LMP_Refresh
.L24:
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	LMP_BulbCheckUpdate, .-LMP_BulbCheckUpdate
	.section	.bss.Local_u8BulbCheckActive,"aw",@nobits
	.type	Local_u8BulbCheckActive, @object
	.size	Local_u8BulbCheckActive, 1
Local_u8BulbCheckActive:
	.zero	1
	.section	.bss.Local_u8SavedLampByte,"aw",@nobits
	.type	Local_u8SavedLampByte, @object
	.size	Local_u8SavedLampByte, 1
Local_u8SavedLampByte:
	.zero	1
	.section	.bss.Local_u8LampByte,"aw",@nobits
	.type	Local_u8LampByte, @object
	.size	Local_u8LampByte, 1
Local_u8LampByte:
	.zero	1
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
