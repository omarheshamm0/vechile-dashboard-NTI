	.file	"odometer.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.ODO_AddDistance,"ax",@progbits
.global	ODO_AddDistance
	.type	ODO_AddDistance, @function
ODO_AddDistance:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r20,__SREG__
/* #APP */
 ;  17 "APP/odometer/odometer.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r18,Accumulator_mm
	lds r19,Accumulator_mm+1
	add r18,r24
	adc r19,r25
	sts Accumulator_mm+1,r19
	sts Accumulator_mm,r18
.L4:
	lds r24,Accumulator_mm
	lds r25,Accumulator_mm+1
	cpi r24,-24
	sbci r25,3
	brsh .L5
	out __SREG__,r20
/* epilogue start */
	ret
.L5:
	lds r24,Accumulator_mm
	lds r25,Accumulator_mm+1
	subi r24,-24
	sbci r25,3
	sts Accumulator_mm+1,r25
	sts Accumulator_mm,r24
	lds r24,Odo_LifetimeMetres
	lds r25,Odo_LifetimeMetres+1
	lds r26,Odo_LifetimeMetres+2
	lds r27,Odo_LifetimeMetres+3
	cpi r24,-1
	sbci r25,-1
	sbci r26,-1
	sbci r27,-1
	breq .L3
	lds r24,Odo_LifetimeMetres
	lds r25,Odo_LifetimeMetres+1
	lds r26,Odo_LifetimeMetres+2
	lds r27,Odo_LifetimeMetres+3
	adiw r24,1
	adc r26,__zero_reg__
	adc r27,__zero_reg__
	sts Odo_LifetimeMetres,r24
	sts Odo_LifetimeMetres+1,r25
	sts Odo_LifetimeMetres+2,r26
	sts Odo_LifetimeMetres+3,r27
.L3:
	lds r24,Odo_TripMetres
	lds r25,Odo_TripMetres+1
	lds r26,Odo_TripMetres+2
	lds r27,Odo_TripMetres+3
	cpi r24,-1
	sbci r25,-1
	sbci r26,-1
	sbci r27,-1
	brne .+2
	rjmp .L4
	lds r24,Odo_TripMetres
	lds r25,Odo_TripMetres+1
	lds r26,Odo_TripMetres+2
	lds r27,Odo_TripMetres+3
	adiw r24,1
	adc r26,__zero_reg__
	adc r27,__zero_reg__
	sts Odo_TripMetres,r24
	sts Odo_TripMetres+1,r25
	sts Odo_TripMetres+2,r26
	sts Odo_TripMetres+3,r27
	rjmp .L4
	.size	ODO_AddDistance, .-ODO_AddDistance
	.section	.text.ODO_GetTotal,"ax",@progbits
.global	ODO_GetTotal
	.type	ODO_GetTotal, @function
ODO_GetTotal:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbiw r24,0
	breq .L11
	in r18,__SREG__
/* #APP */
 ;  48 "APP/odometer/odometer.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r20,Odo_LifetimeMetres
	lds r21,Odo_LifetimeMetres+1
	lds r22,Odo_LifetimeMetres+2
	lds r23,Odo_LifetimeMetres+3
	movw r30,r24
	st Z,r20
	std Z+1,r21
	std Z+2,r22
	std Z+3,r23
	out __SREG__,r18
.L11:
/* epilogue start */
	ret
	.size	ODO_GetTotal, .-ODO_GetTotal
	.section	.text.ODO_GetTrip,"ax",@progbits
.global	ODO_GetTrip
	.type	ODO_GetTrip, @function
ODO_GetTrip:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbiw r24,0
	breq .L16
	in r18,__SREG__
/* #APP */
 ;  61 "APP/odometer/odometer.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	lds r20,Odo_TripMetres
	lds r21,Odo_TripMetres+1
	lds r22,Odo_TripMetres+2
	lds r23,Odo_TripMetres+3
	movw r30,r24
	st Z,r20
	std Z+1,r21
	std Z+2,r22
	std Z+3,r23
	out __SREG__,r18
.L16:
/* epilogue start */
	ret
	.size	ODO_GetTrip, .-ODO_GetTrip
	.section	.text.ODO_ResetTrip,"ax",@progbits
.global	ODO_ResetTrip
	.type	ODO_ResetTrip, @function
ODO_ResetTrip:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r24,__SREG__
/* #APP */
 ;  76 "APP/odometer/odometer.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	sts Odo_TripMetres,__zero_reg__
	sts Odo_TripMetres+1,__zero_reg__
	sts Odo_TripMetres+2,__zero_reg__
	sts Odo_TripMetres+3,__zero_reg__
	out __SREG__,r24
/* epilogue start */
	ret
	.size	ODO_ResetTrip, .-ODO_ResetTrip
	.section	.bss.Accumulator_mm,"aw",@nobits
	.type	Accumulator_mm, @object
	.size	Accumulator_mm, 2
Accumulator_mm:
	.zero	2
	.section	.bss.Odo_TripMetres,"aw",@nobits
	.type	Odo_TripMetres, @object
	.size	Odo_TripMetres, 4
Odo_TripMetres:
	.zero	4
	.section	.bss.Odo_LifetimeMetres,"aw",@nobits
	.type	Odo_LifetimeMetres, @object
	.size	Odo_LifetimeMetres, 4
Odo_LifetimeMetres:
	.zero	4
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
