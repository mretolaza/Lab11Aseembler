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
	
	@GPIO para escritura (salida) puerto 4
	mov r0,#4
	mov r1,#1
	bl SetGpioFunction

	@GPIO para lectura (entrada) puerto 14 
	mov r0,#14
	mov r1,#0
	bl SetGpioFunction
loop:
	@Apagar GPIO 4
	mov r0,#4
	mov r1,#0
	bl SetGpio

	@Revision del boton
	@Para revisar si el nivel de un GPIO esta en alto o bajo se revisa 
	@se lee en la direccion 0x20200034 para los GPIO 0-31
	ldr r6, =myloc
 	ldr r0, [r6] 		@ obtener direccion de la memoria virtual 
	ldr r5,[r0,#0x34] 	@Direccion r0+0x34:lee en r5 estado de puertos de entrada
	mov r7,#1
	lsl r7,#14
	and r5,r7 		@se revisa el bit 14 (puerto de entrada)

	@Si el boton esta en alto (1), fue presionado y enciende GPIO 4
	teq r5,#0
	movne r0,#4		@instrucciones para encender GPIO 4
	movne r1,#1
	blne SetGpio
		
	b loop

	@ salida al sistema operativo
	mov r7,#1
	swi 0






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
