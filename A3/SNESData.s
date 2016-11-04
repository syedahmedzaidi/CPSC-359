.section .text
.equ GPIOSEL0,	0x20200000
.equ GPIOSET0,	0x2020001C
.equ GPIOCLR0,	0x20200028
.globl clock
clock:
	push {r5,r6,lr}
	ldr r5,	=GPIOSEL0
	mov r6, #1			//0b001  (input)
	lsl r6, #11			//align pin 11
	cmp r0,#0
	streq r6, [r5, #40]				
	strne r6, [r5, #28]			
	pop {r5,r6,pc}
	
.globl LAT
LAT:
	push {r5,r6, lr}
	ldr r6, =GPIOSEL0
	mov r5, #1				//0b001
	lsl r5, #9				//align pin 9
	cmp r0, #0
	streq r5, [r6, #40]		//GPIOCLR
	strne r5, [r6, #28]		//GPIOSET
	pop	{r5,r6,pc}
	
.globl DATA
DATA:
	push {r5,r6,lr}
	ldr r5, =GPIOSEL0
	ldr r0, [r5, #52]		//GPIOLEV
	mov r6, #1 //0b001
	lsl r6, #10				//align pin 10
	and r0, r6				//masking
	cmp r0, #0
	moveq r2, #0			//button pressed
	movne r2, #1			//button not pressed
	pop {r5,r9,pc}



