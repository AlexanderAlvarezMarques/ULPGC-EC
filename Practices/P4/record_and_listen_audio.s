	.global _start

_start:

	# Direcciones de memoria
	movia r4, 0x10003040		# Audio
	movia r5, 0x10000020		# Display
	movia r6, 0x10000050		# Botones
	movia r7, vDisplay		# Valores display

encuestaBotones:

	# Encendemos display
	movia r23, vDisplay
	ldb r23, 0(r23)
	stbio r23, 0(r5)

	# Lectura del puerto
	ldwio r8, 0(r6)

	# Comprobamos boton pulsado
	andi r9, r8, 0b0010
	bne r9, r0, grabarAudio
	andi r9, r8, 0b1000
	bne r9, r0, escucharAudio

	br encuestaBotones

grabarAudio:

	# Cargamos el contador de tiempo
	movia r8, timer
	ldw r8, 0(r8)

	# Direcciones para los buffer
	movia r10, buffer_izq
	movia r11, buffer_der

	# Mascara de lectura
	movia r9, 0x0000FFFF

	# Encendemos display
	movia r23, vDisplay
	ldb r23, 1(r23)
	stbio r23, 0(r5)

grabacion:

	# Esperamos a que haya algun dato en el
	# buffer del canal de audio
	ldwio r12, 4(r4)
	and r12, r12, r9
	beq r12, r0, grabacion # Muestra de audio?

	# Cogemos la muestra y las guardamos en el buffer
	ldwio r12, 8(r4)  # Muestra izq
	ldwio r13, 12(r4) # Muestra der

	# Guardamos en buffer
	stw r12, 0(r10) # IZQ
	stw r13, 0(r11) # DER

	# Actualizar direcciones
	addi r10, r10, 4
	addi r11, r11, 4
	subi r8, r8, 1

	# Termino el contador
	bne r8, r0, grabacion
	br encuestaBotones

escucharAudio:

	# Cargamos el contador de tiempo
	movia r8, timer
	ldw r8, 0(r8)

	# Direcciones para los buffer
	movia r10, buffer_izq
	movia r11, buffer_der

	# Mascara de lectura
	movia r9, 0xFFFF0000

	# Encendemos display
	movia r23, vDisplay
	ldb r23, 2(r23)
	stbio r23, 0(r5)

escuchar:

	# Comprobamos espacio disponible para escuchar
	# audio
	ldw r12, 4(r4)
	and r12, r12, r9
	beq r12, r0, escuchar # No hay espacio disponible

	# Leemos las muestra de audio y la ponemos en
	# el canal de salida
	ldw r12, 0(r10) # IZQ
	ldw r13, 0(r11) # DER
	
	stwio r12, 8(r4)  # IZQ
	stwio r13, 12(r4) # DER

	# Actualizamos direcciones de memoria
	addi r10, r10, 4
	addi r11, r11, 4
	subi r8, r8, 1

	# Comprobamos timer
	bne r8, r0, escuchar
	br encuestaBotones

.data

timer:	  .word 150000 # 3s
vDisplay: .byte 0x3F,0x06,0x5B,0x00
buffer_izq: .skip 600000
buffer_der:	.skip 600000

.end
