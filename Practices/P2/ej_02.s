	.global _start

_start:

	# Cargamos las direcciones de memoria
	movia r4, 0x10000010

	# Inicializamos led's verdes
	movia r5, 1
	stw r5, 0(r4)

contador:

	# Cargamos contador de programa
	movia r5, timer
	ldw r5, 0(r5)

cBucle:

	beq r5, r0, desp
	addi r5, r5, -0x01
	br cBucle

desp:

	# Cargamos y desplazamos el led verde
	ldw r5, 0(r4)
	slri r5, 1
	stw r5, 0(r4)

	# Volvemos al bucle
	br contador

.data

timer:	.word	250000

.end