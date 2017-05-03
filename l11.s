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
	
    /* Se cambian los GPIO de escritura por los puertos 11,12 y 13  */
	@GPIO para escritura (salida) puerto 11
	mov r0,#11
	mov r1,#1 
	bl SetGpioFunction
    /* Comienzan cambios */ 
    /* Se añaden puertos de escritura para los leds  */
    @GPIO para escritura (salida) puerto 12
	mov r0,#12
	mov r1,#1
	bl SetGpioFunction

	@GPIO para escritura (salida) puerto 13
	mov r0,#13
	mov r1,#1
	bl SetGpioFunction
	/* El puerto de lectura se fija en el GPIO 14 */ 
   	@GPIO para lectura (entrada) puerto 14 
	mov r0,#14
	mov r1,#0
	bl SetGpioFunction
	bl wait @ Se añade una sub rutina de espera para que se puedan observar los cambios en los leds 

	/* Se incorpora instruccion de apagar */ 
	@Apagar GPIO 12
	mov r0,#12
	mov r1,#0
	bl SetGpio

	/* Se incorpora instruccion de apagar */ 
	@Apagar GPIO 13
	mov r0,#13
	mov r1,#0
	bl SetGpio

	bl wait @ se añade instrucción de pausa 

loop:
	@Revision del boton
	@Para revisar si el nivel de un GPIO esta en alto o bajo se revisa 
	@se lee en la direccion 0x20200034 para los GPIO 0-31
	ldr r6, =myloc
 	ldr r0, [r6] 		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34] 	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#14
	and r5,r7 		@se revisa el bit 14 (puerto de entrada)

	/* Se añaden cambios*/ 


	@Si el boton esta en alto (1), fue presionado y enciende GPIO 11
	cmp r5,#0
	beq  revision1 @se llama a la etiqueta revision 1 
	b  loop

	/* Se añaden etiquetas*/ 
revision1:
	@Revision del boton
	@Para revisar si el nivel de un GPIO esta en alto o bajo se revisa 
	@se lee en la direccion 0x20200034 para los GPIO 0-31
	ldr r6, =myloc
 	ldr r0, [r6] 		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34] 	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#11
	and r5,r7		@se revisa el bit 11 (puerto de salida)
	@Si el boton esta en alto (1), fue presionado y enciende GPIO 11
	cmp  r5,#0
	beq fin1 @se llama a la etiqueta fin1 
	bne revision2 
	b  loop 

revision2: 
	@Revision del boton
	@Para revisar si el nivel de un GPIO esta en alto o bajo se revisa 
	@se lee en la direccion 0x20200034 para los GPIO 0-31
	ldr r6, =myloc
 	ldr r0, [r6] 		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34] 	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#12
	and r5,r7		@se revisa el bit 12 (puerto de salida)
	@Si el boton esta en alto (1), fue presionado y enciende GPIO 12
	cmp  r5,#0
	beq fin2 @se llama a la etiqueta fin2
	bne revision3
	b  loop 

revision3: 
	@Revision del boton
	@Para revisar si el nivel de un GPIO esta en alto o bajo se revisa 
	@se lee en la direccion 0x20200034 para los GPIO 0-31
	ldr r6, =myloc
 	ldr r0, [r6] 		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34] 	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#13
	and r5,r7		@se revisa el bit 13 (puerto de salida)
	@Si el boton esta en alto (1), fue presionado y enciende GPIO 13
	cmp  r5,#0
	beq fin3 @se llama a la etiqueta fin3
	bne loop
	b   loop 

/* Se realizan las instrucciones de salida del sistema*/ 

fin1: 
	movne r0,#11 
	movne r1, #1 
	blne SetGpio 
	b loop 
fin2: 
	movne r0,#12 
	movne r1, #1 
	blne SetGpio 
	b loop 
fin3: 
	movne r0,#13 
	movne r1, #1 
	blne SetGpio 
	b loop 

@ brief pause routine
wait:
 mov r0, #0x4000000 @ big number

 .data
 .align 2
.global myloc
myloc: .word 0

 .end
