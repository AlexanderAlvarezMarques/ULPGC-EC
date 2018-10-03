despIzq:

	# Cogemos y desplazamos a la izq el registro de led's verdes
	ldw r5, 0(r4)
	slli r5, r5, 1

	# Se paso del limite de 8 bits
	movia r6, 128
	bgt r5, r6, reiniciar
	stw r5, 0(r4)
	ret

reiniciar:

	addi r5, r0, 1
	stw r5, 0(r4)
	ret

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
	call despIzq

	# Volvemos al bucle
	br contador

.data

timer:	.word	250000

.end
