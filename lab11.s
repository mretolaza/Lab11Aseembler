/* Integrantes: 
Ivette Cardona, 16020 
Mercedes Retolaza, 16339 
Laboratorio no.11 
Descripción del programa: Se encienden tres leds de manera intermitente.;*/ 

@ puertosES_2.s prueba con puertos de entrada y salida
@ Funciona con cualquier puerto, utilizando biblioteca gpio0_2.s
	
  .text
 .align 2
 .global main
 
main:
	@utilizando la biblioteca GPIO (gpio0.s)
	bl GetGpioAddress 	@solo se llama una vez
	/* Se fija puerto de lectura*/ 
	@GPIO para lectura (entrada) puerto 14 
	mov r0,#14
	mov r1,#0
	bl SetGpioFunction
	/* Se añaden los puertos de escritura (Salida del programa)*/ 
    /* Se cambian los GPIO de escritura por los puertos 17,18 y 27  */
	@GPIO para escritura (salida) puerto 17
	mov r0,#17
	mov r1,#1 
	bl SetGpioFunction
    /* Comienzan cambios */ 
    /* Se añaden puertos de escritura para los leds  */
    @GPIO para escritura (salida) puerto 18
	mov r0,#18
	mov r1,#1
	bl SetGpioFunction

	@GPIO para escritura (salida) puerto 27
	mov r0,#27
	mov r1,#1
	bl SetGpioFunction
	
	/* Se incorpora instrucciones de apagar */ 
	@Apagar GPIO 17
	mov r0,#17
	mov r1,#0
	bl SetGpio

	/* Se incorpora instruccion de apagar */ 
	@Apagar GPIO 18
	mov r0,#27
	mov r1,#0
	bl SetGpio

	@Apagar GPIO 27
	mov r0,#27
	mov r1,#0
	bl SetGpio

	bl wait @ se añade instrucción de pausa 

loop:
	/*@Revision del boton
	@Para revisar si el nivel de un GPIO esta en alto o bajo se revisa 
	@se lee en la direccion 0x20200034 para los GPIO 0-31*/ 

	ldr r6, =myloc
 	ldr r0, [r6] 		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34] 	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#14
	and r7,r5,r7 		@se revisa el bit 14 (puerto de entrada)

	/* Se añaden cambios*/ 
	@Si el boton esta en alto (1), fue presionado y enciende GPIO 17
	teq r7,#0

	bne  revision1 @1
	b  loop

	/* Se añaden etiquetas en el programa, esto con el fin de hacer mas sencilla su interacion y movimientos */ 
revision1: @1
	ldr r6, =myloc
 	ldr r0, [r6] 		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34] 	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#17
	and r5,r7 		@se revisa el bit 17 (puerto de salida)
	teq r7, #0
	beq fin1 @se llama a la etiqueta fin1 
	bne revision2 @2
	b  loop 


revision2: @2
	ldr r6, =myloc
 	ldr r0, [r6] 		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34] 	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#18
	and r7,r5,r7 @se revisa el bit 18 (puerto de salida)
	
	@Si el boton esta en alto (1), fue presionado y enciende GPIO 18
	teq r7,#0
	beq fin2 @se llama a la etiqueta fin2
	bne revision3 @3
	b  loop 

revision3: @3
	ldr r6, =myloc
 	ldr r0, [r6] 		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34] 	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#27
	and r7,r5,r7		@se revisa el bit 27 (puerto de salida)
	
	@Si el boton esta en alto (1), fue presionado y enciende GPIO 27
	teq  r7,#0
	beq fin3 @se llama a la etiqueta fin3
	bne loop
	b   loop 

/* Espacio donde se establecen las etiquetas de salida
del programa */ 

fin1: 
	movne r0,#17 
	movne r1, #1 
	bl SetGpio

	mov r0, #18
	mov r1,#0 
	bl SetGpio 

	b loop 
fin2: 
	movne r0,#18 
	movne r1, #1 
	bl SetGpio 

	mov r0, #27
	mov r1,#0 
	bl SetGpio 

	b loop 
fin3: 
	movne r0,#27 
	movne r1, #1 
	blne SetGpio 

	mov r0, #17 
	mov r1,#0 
	bl SetGpio 

	b loop 

@ brief pause routine
 wait:
 mov r0, #0x4000000 @ big number
 sleepLoop:
 subs r0,#1
 bne sleepLoop @ loop delay
 mov pc,lr

 .data
 .align 2
.global myloc
myloc: .word 0

 .end
