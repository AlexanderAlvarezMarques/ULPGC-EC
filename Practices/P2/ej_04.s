	.global _start

_start:

	# Carga de direcciones
	movia r4, 0x10000000 # Led's rojos
	movia r5, 0x10000040 # switch button

	# Registros auxiliares
	movia r23, 0x3FFFF

pBucle:
	
	# Cargamos valores switch
	ldw r6, 0(r5)

	# Invertimos la seleccion de los switch
	xor r6, r6, r23

	# Almacenamos la inversion del switch en los leds
	stw r6, 0(r4)

	# Volvemos al bucle
	br pBucle

.data
.end