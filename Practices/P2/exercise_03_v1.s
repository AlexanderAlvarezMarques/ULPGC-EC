despIzq:

	# Cogemos y desplazamos a la izq el registro de led's verdes
	ldwio r5, 0(r4)
	slli r5, r5, 8

	# Se paso del limite de 8 bits
	beq r5, r0, reiniciar
	stwio r5, 0(r4)
	ret

reiniciar:

	movia r5, vDisplay
	ldb r5, 0(r5)
	stwio r5, 0(r4)
	ret

.global _start

_start:

	# Cargamos las direcciones de memoria
	movia r4, 0x10000020

	# Cargamos el numero correspondiente
	movia r5, vDisplay
	ldbu r5, 0(r5)

display:

	# Encendemos display
	stwio r5, 0(r4)

	# Desplazamos r5
	call despIzq

contador:

	# Cargamos contador de programa
	movia r23, timer
	ldw r23, 0(r23)

cBucle:

	beq r23, r0, display
	addi r23, r23, -1
	br cBucle

.data

vDisplay:	.byte 0x3F,0x06,0x5B,0x4F,0x36,0x3D,0x7C,0x03,0x7F,0x6F,0,0 # 0,1,2,3,4,5,6,7,8,9
timer:		.word 500000

.end
