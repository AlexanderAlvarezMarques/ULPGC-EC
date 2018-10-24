# Rutina de interrupciones
.section .reset, "ax"

	movia r2, _start
	jmp r2
    
.section .exceptions, "ax"
.global EXCEPTIONS_HANDLER

EXCEPTIONS_HANDLER:
    
    # Actualizamos pila
    subi sp, sp, 28

    # Guardamos registros en la pila
    stw et, 4(sp)
    stw r7, 8(sp)
    stw r8, 12(sp)
    stw r9, 16(sp)

    # Comprobamos tipo de interrupcion
    rdctl et, ctl4 # ctl4 I - Pending

    # Si es 0 es interrupcion interna
    beq r7, r0, fin

    # Interrupcion externa, actualizo return adress
    subi ea, ea, 4

    # Comprobamos quien ha interrumpido
    andi r7, et, 2
    beq r7, r0, fin # Como no son botones nos vamos a fin

botones:

	# Leo el estado de los botones
	ldwio r7, 0xC(r5)

	# Reinicio interrupcion del botones
	stwio r0, 0xC(r5)

	# Comprobamos que boton interrumpe
	movia r8, 2
	and r9, r7, r8
	beq r9, r8, boton_1

	movia r8, 4
	and r9, r7, r8
	beq r9, r8, boton_2

	movia r8, 8
	and r9, r7, r8
	beq r9, r8, boton3

	br fin

boton_3:

	ldb r8, 3(r6)
	stw r8, 12(sp)
	br fin

boton_2:

	ldb r8, 2(r6)
	stw r8, 12(sp)
	br fin

boton_1:

	ldb r8, 1(r6)
	stw r8, 12(sp)

fin:

	# Restauro registros
	ldw et, 4(sp)
    ldw r7, 8(sp)
    ldw r8, 12(sp)
    stw r9, 16(sp)

    # Restauro pila
    addi sp, sp, 28

    # Retorno al programa
    eret

.global _start
_start:
	
	# Creamos pila
	movia sp, 0x007FFFFC

	# Carga de direcciones
    movia r4, 0x10000020 # Displays
    movia r5, 0x10000050 # PushButton
    movia r6, numeros
    
    # Habilitamos interrupciones de botones (mascara)
    movia r7, 0b1110
    stwio r7, 8(r5) # Mascara
    
    # Habilitar interrupciones del pushButton
    movia r7, 0b010
    wrctl ienable, r7
    
    # Habilitamos interrupciones del procesador
    movia r7, 0b001
    wrctl status, r7
    
    # Usamos r8 como registro de escritura para display
    ldbio r8, 0(r6)
    
mostrarDisplay:

	stwio r8, 0(r4)
    br mostrarDisplay
    
.data

numeros:	.byte	0x3F,0x06,0x5B,0x4F,0x36,0x3D,0x7C,0x03,0x7F,0x6F # 0,1,2,3,4,5,6,7,8,9
