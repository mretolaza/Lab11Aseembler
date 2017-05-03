@Autores: Ivette Cardona, Maria Mercedes Retolaza
@Laboratorio 11 
@Fecha: 02/05/2017

@GetGpio

.text
.align 2 
.global GetGpio

GetGpio:
	push {lr}

	ldr r3,[r0,#0x34]	@Direccion r0+0x34:lee en r3 estado de puertos de entrada
	mov r4,#1
	lsl r4,r1
	and r3,r4		@se revisa el bit r1 (puerto de entrada)

	cmp r3,#0
	@Regresa 0 o 1 dependiendo del estado
	moveq r0, #0
	movne r0, #1

	pop {pc}