	.global _start

_start:

	# Declaracion de registros
	movia r4, 0x10003040
	movia r5, 0x10000050
	ldw r6, timer

	# Encuesta para los botones

encuesta_botones:

	# Reseteamos el registro de audio tanto lectura como esritura
	movia r7, 0b1100
	stwio r7, 0(r4)
	stwio r0, 0(r4)

	# Lectura de registro
	ldwio r7, 0(r5)
	beq r7, r0, encuesta_botones

	# Comprobamos el boton pulsado
	andi r8, r7, 0b0100
	bne r8, r0, boton_2

	andi r8, r7, 0b0010
	bne r8, r0, boton_1

	encuesta_botones

boton_2: # Configuracion de lectura de audio

	# Configuramos resigstros
	movia r7, izq
	movia r8, der

	# Configuramos limite de lectura
	movia r9, 0xFFFF

lectura: # Lectura del audio

	# Comprobamos que haya espacio para grabar audio
	ldwio r10, 4(r4)
	andi r10, r10, 0x0000FFFF
	bge r10, r9, encuesta_botones

	# Recogemos muestra del lado izq
	ldwio r10, 8(r4)
	stw r10, 0(r7)

	# Recogemos muestra del lado der
	ldwio r10, 12(r4)
	stw r10, 0(r8)

	# Desplazamos punteros
	addi r7, r7, 4
	addi r8, r8, 4

	# Volvemos a leer
	br lectura

boton_1: # Configuracion de escritura de audio

	# Configuramos resigstros
	movia r7, izq
	movia r8, der

escritura:

	# Comprobamos si queda espacio para escribir
	ldwio r9, 4(r4)
	slri r9, r9, 16
	beq r9, r0, encuesta_botones

	# Cogemos muestra del lado izq y la escribimos
	ldw r9, 0(r7)
	stwio r9, 8(r4)

	# Cogemos muestra del lado der y la escribimos
	ldw r9, 0(r8)
	stwio r9, 12(r4)

	# Desplazamos punteros
	addi r7, r7, 4
	addi r8, r8, 4

	# Volvemos a leer
	br escritura

.data

izq: .skip 1200000
der: .skip 1200000

.end
