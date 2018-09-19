	.org 0x00000000
	.global _start

_start:

	# Direcciones de memoria
	movia r4, 0x10000000 # Led's rojos
	
	# Valores para el programa
	movia r10, 0x2AAAA # Led's rojos impares
	movia r11, 0x15555 # Led's rojos pares

	# Registros auxiliares
	movia r16, 0 # 0 pares ; 1 impares
	movia r17, reloj

loop:
	
	# Contador para el programa
	ldw r20, 0(r17)

	# Comprobamos que led's hay que encender
	beq r16, r0, pares:

impares:

	# Modificamos el auxiliar de par - impar
	movia r16, 0

	# Encendemos led's
	stwio r10, 0(r4)

	# Salto a retardo
	br delay

pares:

	# Modificamos el auxiliar de par - impar
	movia r16, 1

	# Encendemos led's
	stwio r11, 0(r4)

delay:

	# Condicion de salida
	beq r20, r0, loop

	# Contador
	addi r20, r20, -0x1
	br delay

# Declaracion de variables
.data

reloj:	.word 250000

.end
