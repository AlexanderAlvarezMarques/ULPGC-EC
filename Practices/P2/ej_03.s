	.global _start

_start:

	# Cargamos las direcciones de memoria
	movia r4, 0x10000020

	# Cargamos el numero correspondiente
	movia r5, vDisplay
	ldw r5, 0(r5)

display:

	# Encendemos display
	stw r5, 0(r4)

	# Desplazamos r5
	slri r5, 8

contador:

	# Cargamos el valor del contador
	movia r23, timer
	ldw r23, 0(r23)

pBucle:

	beq r23, r0, display
	addi r23, r23, -0x01
	br pBucle

.data

vDisplay:	.byte 0x3F,0x06,0x5B,0x4F,0x36,0x3D,0x7C,0x03,0x7F,0x6F # 0,1,2,3,4,5,6,7,8,9
timer:		.word 250000

.end