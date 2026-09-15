	.file	"chime.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Tone_On,"ax",@progbits
	.type	Tone_On, @function
Tone_On:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(127)
	out 0x23,r24
	ldi r24,lo8(108)
	out 0x25,r24
	ldi r24,lo8(1)
	sts Is_Playing,r24
/* epilogue start */
	ret
	.size	Tone_On, .-Tone_On
	.section	.text.Tone_Off,"ax",@progbits
	.type	Tone_Off, @function
Tone_Off:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	out 0x25,__zero_reg__
	out 0x23,__zero_reg__
	sts Is_Playing,__zero_reg__
/* epilogue start */
	ret
	.size	Tone_Off, .-Tone_Off
	.section	.text.CHM_Init,"ax",@progbits
.global	CHM_Init
	.type	CHM_Init, @function
CHM_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	ldi r22,lo8(7)
	ldi r24,lo8(3)
	call GPIO_SetPinDirection
	jmp Tone_Off
	.size	CHM_Init, .-CHM_Init
	.section	.text.CHM_Play,"ax",@progbits
.global	CHM_Play
	.type	CHM_Play, @function
CHM_Play:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r18,Current_Pattern
	lds r19,Current_Pattern+1
	cp r18,r24
	cpc r19,r25
	breq .L4
	sts Current_Pattern,r24
	sts Current_Pattern+1,r25
	sts Timer_Ticks,__zero_reg__
	sts Timer_Ticks+1,__zero_reg__
	or r24,r25
	brne .L6
	jmp Tone_Off
.L6:
	jmp Tone_On
.L4:
/* epilogue start */
	ret
	.size	CHM_Play, .-CHM_Play
	.section	.text.CHM_Update,"ax",@progbits
.global	CHM_Update
	.type	CHM_Update, @function
CHM_Update:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r18,Current_Pattern
	lds r19,Current_Pattern+1
	cp r18,__zero_reg__
	cpc r19,__zero_reg__
	breq .L7
	lds r24,Timer_Ticks
	lds r25,Timer_Ticks+1
	adiw r24,1
	sts Timer_Ticks,r24
	sts Timer_Ticks+1,r25
	cpi r18,2
	cpc r19,__zero_reg__
	breq .L10
	cpi r18,3
	cpc r19,__zero_reg__
	breq .L11
	cpi r18,1
	cpc r19,__zero_reg__
	brne .L12
	cpi r24,5
	cpc r25,__zero_reg__
	brne .L13
.L12:
	jmp Tone_Off
.L13:
	sbiw r24,50
.L25:
	brlo .L7
	call Tone_On
	sts Timer_Ticks,__zero_reg__
	sts Timer_Ticks+1,__zero_reg__
	ret
.L10:
	cpi r24,51
	cpc r25,__zero_reg__
	brsh .L15
	lds r24,Is_Playing
	cpse r24,__zero_reg__
	rjmp .L7
	jmp Tone_On
.L15:
	cpi r24,55
	cpc r25,__zero_reg__
	breq .L12
	cpi r24,-106
	cpc r25,__zero_reg__
	brlo .L7
	call Tone_On
	ldi r24,lo8(50)
	sts Timer_Ticks,r24
	sts Timer_Ticks+1,__zero_reg__
	ret
.L11:
	cpi r24,4
	cpc r25,__zero_reg__
	breq .L12
	sbiw r24,9
	rjmp .L25
.L7:
/* epilogue start */
	ret
	.size	CHM_Update, .-CHM_Update
	.section	.bss.Is_Playing,"aw",@nobits
	.type	Is_Playing, @object
	.size	Is_Playing, 1
Is_Playing:
	.zero	1
	.section	.bss.Timer_Ticks,"aw",@nobits
	.type	Timer_Ticks, @object
	.size	Timer_Ticks, 2
Timer_Ticks:
	.zero	2
	.section	.bss.Current_Pattern,"aw",@nobits
	.type	Current_Pattern, @object
	.size	Current_Pattern, 2
Current_Pattern:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
