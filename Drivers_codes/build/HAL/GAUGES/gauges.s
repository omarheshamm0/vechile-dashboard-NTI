	.file	"gauges.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
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
	.ident	"GCC: (GNU) 15.2.0"
