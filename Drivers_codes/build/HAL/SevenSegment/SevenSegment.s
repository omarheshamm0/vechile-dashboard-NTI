	.file	"SevenSegment.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SevenSegment_init,"ax",@progbits
.global	SevenSegment_init
	.type	SevenSegment_init, @function
SevenSegment_init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(4)
	brsh .L2
	ldi r22,lo8(-1)
	jmp GPIO_SetPortDirection
.L2:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	SevenSegment_init, .-SevenSegment_init
	.section	.text.SevenSegment_display,"ax",@progbits
.global	SevenSegment_display
	.type	SevenSegment_display, @function
SevenSegment_display:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(4)
	brsh .L3
	cpi r22,lo8(10)
	brsh .L3
	mov r30,r22
	ldi r31,0
	subi r30,lo8(-(SevenSegment_u8Digits))
	sbci r31,hi8(-(SevenSegment_u8Digits))
	ld r22,Z
	jmp GPIO_SetPortValue
.L3:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	SevenSegment_display, .-SevenSegment_display
	.section	.rodata.SevenSegment_u8Digits,"a"
	.type	SevenSegment_u8Digits, @object
	.size	SevenSegment_u8Digits, 10
SevenSegment_u8Digits:
	.base64	"PwZbT2ZtfQd/bw=="
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
