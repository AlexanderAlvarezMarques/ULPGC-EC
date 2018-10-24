# Rutina de interrupciones
.section .reset, "ax"

	movia r2, _start
	jmp r2
    
.section .exceptions, "ax"
.global EXCEPTIONS_HANDLER

EXCEPTIONS_HANDLER:
    # Creacion de pila
	movia sp, pila
    
    # Guardamos et en pila
    subi sp, sp, 12
    stwio et, 4(sp)
    
    # Guardamos registros usados
    stwio r7, 8(sp)
    stwio r23, 12(sp)
    
    # Comprobamos si es una interrupcion interna
    beq et, r0, fin
    
    # Como es interna comprobamos quien interrumpe
    # Botones
    andi r7, et, 2
    beq r7, r0, fin
    
boton:

	# Comprobamos boton pulsado
    ldwio r7, 0xC(r5)
    
    # Boton 1
    movia r23, 1
    and r7, r7, r23
    beq r7, r23, boton_1
    
    # Comprobamos boton pulsado
    ldwio r7, 0xC(r5)
    
    # Boton 1
    movia r23, 2
    and r7, r7, r23
    beq r7, r23, boton_2
    
boton_3:

	# Cargamos el valor 3 en registro r23 que esta actualmente en sp
    ldwio r7, 3(r6)
    stwio r7, 12(sp)
    
    # Saltamos a fin
    br fin

boton_2:

	# Cargamos el valor 3 en registro r23 que esta actualmente en sp
    ldwio r7, 2(r6)
    stwio r7, 12(sp)
    
    # Saltamos a fin
    br fin
    
boton_1:

	# Cargamos el valor 3 en registro r23 que esta actualmente en sp
    ldwio r7, 1(r6)
    stwio r7, 12(sp)

fin:

	# Recuperamos registros
    ldwio et, 4(sp)
    ldwio r7, 8(sp)
    ldwio r23, 12(sp)
    
    # Retornamos pila
    addi sp, sp, 12
    
    # Volvemos al programa
    ret

.global _start
_start:
	
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
    
    # Usamos r23 como registro de escritura para display
    ldbio r23, 0(r6)
    
mostrarDisplay:

	stwio r23, 0(r4)
    br mostrarDisplay
    
.data

numeros:	.byte	0x3F,0x06,0x5B,0x4F,0x36,0x3D,0x7C,0x03,0x7F,0x6F # 0,1,2,3,4,5,6,7,8,9

.org 0x00100000
pila:	.skip 32




