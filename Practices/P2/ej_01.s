	.global _start

_start:

	# Carga de las direcciones de memoria
	movia r4, 0x10000000 # Led's rojos
	movia r5, valores

	# Registro auxiliar para comprobar que leds han de encenderse
	movia r23, 0

pBucle:

	# Comprobamos si encendemos par o impar
	beq r23, r0, par

impar:

	# Modificamos para encender led's pares
	movia r23, 0

	# Cargamos valor par
	movia r22, valores

	# Lo guardamos en led's rojos
	ldw r22, 0(r22)
	stw r22, 0(r4)

	# Timer
	br retardo

par:

	# Modificamos para encender led's impares
	movia r23, 1

	# Cargamos valor par
	movia r22, valores

	# Lo guardamos en led's rojos
	ldw r22, 4(r22)
	stw r22, 0(r4)

retardo:

	# Cargamos y ejecutamos retardo
	movia r22, timer
	ldw r22, 0(r22)

sBucle:

	beq r22, r0, pBucle
	addi r22, r22, -0x01
	br sBucle

.data

valores:	.word 0x2AAAA, 0x15555
timer:		.word 250000

.end