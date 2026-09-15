	.file	"warnings.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.WRN_Update,"ax",@progbits
.global	WRN_Update
	.type	WRN_Update, @function
WRN_Update:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	ldd r24,Z+25
	sbrs r24,6
	rjmp .L2
	ldd r25,Z+9
	cpi r25,lo8(10)
	brsh .L2
	ldi r25,lo8(1)
	sts Latched_Oil,r25
.L2:
	ldd r18,Z+5
	ldd r19,Z+6
	cpi r18,111
	cpc r19,__zero_reg__
	brlt .L3
	ldi r25,lo8(1)
	sts Latched_Coolant,r25
.L3:
	ldd r18,Z+7
	ldd r19,Z+8
	sbrs r24,6
	rjmp .L4
	cpi r18,-32
	ldi r24,46
	cpc r19,r24
	brlo .L17
.L4:
	ldi r24,lo8(1)
	cpi r18,-103
	sbci r19,58
	brsh .L5
	ldi r24,0
.L5:
	ldd r25,Z+4
	cpi r25,lo8(10)
	brsh .L7
	ldi r25,lo8(1)
	sts fuel_warn_active.0,r25
.L8:
	ldd r18,Z+22
	ldd r19,Z+23
	lds r25,Latched_Oil
	cp r25, __zero_reg__
	breq .L9
	ori r18,lo8(2)
.L10:
	lds r25,Latched_Coolant
	cp r25, __zero_reg__
	breq .L11
	ori r18,lo8(8)
.L12:
	cp r24, __zero_reg__
	breq .L13
	ori r18,lo8(4)
.L14:
	lds r24,fuel_warn_active.0
	cp r24, __zero_reg__
	breq .L15
	ori r18,lo8(32)
.L16:
	std Z+22,r18
	std Z+23,r19
/* epilogue start */
	ret
.L17:
	ldi r24,lo8(1)
	rjmp .L5
.L7:
	cpi r25,lo8(14)
	brlo .L8
	sts fuel_warn_active.0,__zero_reg__
	rjmp .L8
.L9:
	andi r18,lo8(-3)
	rjmp .L10
.L11:
	andi r18,lo8(-9)
	rjmp .L12
.L13:
	andi r18,lo8(-5)
	rjmp .L14
.L15:
	andi r18,lo8(-33)
	rjmp .L16
	.size	WRN_Update, .-WRN_Update
	.section	.text.WRN_Highest,"ax",@progbits
.global	WRN_Highest
	.type	WRN_Highest, @function
WRN_Highest:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	ldd r18,Z+22
	ldd r19,Z+23
	sbrc r18,1
	rjmp .L26
	sbrc r18,2
	rjmp .L27
	sbrc r18,3
	rjmp .L28
	sbrc r18,4
	rjmp .L29
	sbrc r18,5
	rjmp .L30
	sbrc r18,6
	rjmp .L31
	sbrc r18,7
	rjmp .L32
	sbrc r19,0
	rjmp .L33
	ldi r24,0
	mov r25,r19
	andi r25,1<<1
	sbrs r19,1
	rjmp .L24
	ldi r24,lo8(9)
	ldi r25,0
.L24:
/* epilogue start */
	ret
.L26:
	ldi r24,lo8(1)
	ldi r25,0
	ret
.L27:
	ldi r24,lo8(2)
	ldi r25,0
	ret
.L28:
	ldi r24,lo8(3)
	ldi r25,0
	ret
.L29:
	ldi r24,lo8(4)
	ldi r25,0
	ret
.L30:
	ldi r24,lo8(5)
	ldi r25,0
	ret
.L31:
	ldi r24,lo8(6)
	ldi r25,0
	ret
.L32:
	ldi r24,lo8(7)
	ldi r25,0
	ret
.L33:
	ldi r24,lo8(8)
	ldi r25,0
	ret
	.size	WRN_Highest, .-WRN_Highest
	.section	.bss.fuel_warn_active.0,"aw",@nobits
	.type	fuel_warn_active.0, @object
	.size	fuel_warn_active.0, 1
fuel_warn_active.0:
	.zero	1
	.section	.bss.Latched_Coolant,"aw",@nobits
	.type	Latched_Coolant, @object
	.size	Latched_Coolant, 1
Latched_Coolant:
	.zero	1
	.section	.bss.Latched_Oil,"aw",@nobits
	.type	Latched_Oil, @object
	.size	Latched_Oil, 1
Latched_Oil:
	.zero	1
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
