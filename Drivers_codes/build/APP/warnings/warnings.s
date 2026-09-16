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
	ldd r18,Z+25
	sbrs r18,6
	rjmp .L2
	ldd r24,Z+9
	cpi r24,lo8(10)
	brlo .+2
	rjmp .L2
	lds r24,oil_counter.6
	lds r25,oil_counter.6+1
	adiw r24,1
	sts oil_counter.6,r24
	sts oil_counter.6+1,r25
	sbiw r24,40
	brlo .L3
	ldi r24,lo8(1)
	sts Latched_Oil,r24
.L3:
	ldd r24,Z+5
	ldd r25,Z+6
	cpi r24,111
	sbci r25,0
	brlt .L4
	lds r24,coolant_counter.5
	lds r25,coolant_counter.5+1
	adiw r24,1
	sts coolant_counter.5,r24
	sts coolant_counter.5+1,r25
	sbiw r24,60
	brlo .L5
	ldi r24,lo8(1)
	sts Latched_Coolant,r24
.L5:
	ldd r24,Z+7
	ldd r25,Z+8
	sbrs r18,6
	rjmp .L6
	cpi r24,-32
	ldi r18,46
	cpc r25,r18
	brsh .L6
	lds r24,batt_low_counter.4
	lds r25,batt_low_counter.4+1
	adiw r24,1
	sts batt_low_counter.4,r24
	sts batt_low_counter.4+1,r25
	cpi r24,100
	sbci r25,0
	brlo .L7
	ldi r24,lo8(1)
	sts batt_low_warn.3,r24
.L7:
	sts batt_high_counter.2,__zero_reg__
	sts batt_high_counter.2+1,__zero_reg__
	sts batt_high_warn.1,__zero_reg__
	rjmp .L11
.L2:
	sts oil_counter.6,__zero_reg__
	sts oil_counter.6+1,__zero_reg__
	rjmp .L3
.L4:
	sts coolant_counter.5,__zero_reg__
	sts coolant_counter.5+1,__zero_reg__
	rjmp .L5
.L6:
	sts batt_low_counter.4,__zero_reg__
	sts batt_low_counter.4+1,__zero_reg__
	cpi r24,-43
	ldi r18,48
	cpc r25,r18
	brlo .L7
	sts batt_low_warn.3,__zero_reg__
	cpi r24,-103
	ldi r18,58
	cpc r25,r18
	brsh .L9
	cpi r24,-92
	sbci r25,56
	brlo .L7
	sts batt_high_counter.2,__zero_reg__
	sts batt_high_counter.2+1,__zero_reg__
	rjmp .L11
.L9:
	lds r24,batt_high_counter.2
	lds r25,batt_high_counter.2+1
	adiw r24,1
	sts batt_high_counter.2,r24
	sts batt_high_counter.2+1,r25
	cpi r24,100
	sbci r25,0
	brlo .L11
	ldi r24,lo8(1)
	sts batt_high_warn.1,r24
.L11:
	ldd r24,Z+4
	cpi r24,lo8(10)
	brsh .L13
	ldi r24,lo8(1)
	sts fuel_warn_active.0,r24
.L14:
	ldd r18,Z+22
	ldd r19,Z+23
	lds r24,Latched_Oil
	cpi r24,lo8(0)
	breq .L15
	ori r18,lo8(2)
.L16:
	lds r24,Latched_Coolant
	cpi r24,lo8(0)
	breq .L17
	ori r18,lo8(8)
.L18:
	lds r24,batt_low_warn.3
	lds r25,batt_high_warn.1
	or r24,r25
	breq .L19
	ori r18,lo8(4)
.L20:
	lds r24,fuel_warn_active.0
	cpi r24,lo8(0)
	breq .L21
	ori r18,lo8(32)
.L22:
	std Z+22,r18
	std Z+23,r19
/* epilogue start */
	ret
.L13:
	cpi r24,lo8(14)
	brlo .L14
	sts fuel_warn_active.0,__zero_reg__
	rjmp .L14
.L15:
	andi r18,lo8(-3)
	rjmp .L16
.L17:
	andi r18,lo8(-9)
	rjmp .L18
.L19:
	andi r18,lo8(-5)
	rjmp .L20
.L21:
	andi r18,lo8(-33)
	rjmp .L22
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
	rjmp .L37
	sbrc r18,2
	rjmp .L38
	sbrc r18,3
	rjmp .L39
	sbrc r18,4
	rjmp .L40
	sbrc r18,5
	rjmp .L41
	sbrc r18,6
	rjmp .L42
	sbrc r18,7
	rjmp .L43
	sbrc r19,0
	rjmp .L44
	ldi r24,0
	mov r25,r19
	andi r25,1<<1
	sbrs r19,1
	rjmp .L35
	ldi r24,lo8(9)
	ldi r25,0
.L35:
/* epilogue start */
	ret
.L37:
	ldi r24,lo8(1)
	ldi r25,0
	ret
.L38:
	ldi r24,lo8(2)
	ldi r25,0
	ret
.L39:
	ldi r24,lo8(3)
	ldi r25,0
	ret
.L40:
	ldi r24,lo8(4)
	ldi r25,0
	ret
.L41:
	ldi r24,lo8(5)
	ldi r25,0
	ret
.L42:
	ldi r24,lo8(6)
	ldi r25,0
	ret
.L43:
	ldi r24,lo8(7)
	ldi r25,0
	ret
.L44:
	ldi r24,lo8(8)
	ldi r25,0
	ret
	.size	WRN_Highest, .-WRN_Highest
	.section	.bss.fuel_warn_active.0,"aw",@nobits
	.type	fuel_warn_active.0, @object
	.size	fuel_warn_active.0, 1
fuel_warn_active.0:
	.zero	1
	.section	.bss.batt_high_warn.1,"aw",@nobits
	.type	batt_high_warn.1, @object
	.size	batt_high_warn.1, 1
batt_high_warn.1:
	.zero	1
	.section	.bss.batt_high_counter.2,"aw",@nobits
	.type	batt_high_counter.2, @object
	.size	batt_high_counter.2, 2
batt_high_counter.2:
	.zero	2
	.section	.bss.batt_low_warn.3,"aw",@nobits
	.type	batt_low_warn.3, @object
	.size	batt_low_warn.3, 1
batt_low_warn.3:
	.zero	1
	.section	.bss.batt_low_counter.4,"aw",@nobits
	.type	batt_low_counter.4, @object
	.size	batt_low_counter.4, 2
batt_low_counter.4:
	.zero	2
	.section	.bss.coolant_counter.5,"aw",@nobits
	.type	coolant_counter.5, @object
	.size	coolant_counter.5, 2
coolant_counter.5:
	.zero	2
	.section	.bss.oil_counter.6,"aw",@nobits
	.type	oil_counter.6, @object
	.size	oil_counter.6, 2
oil_counter.6:
	.zero	2
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
	.ident	"GCC: (GNU) 16.1.0"
.global __do_clear_bss
