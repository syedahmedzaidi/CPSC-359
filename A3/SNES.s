.section .text

.equ GPIOSEL0,	0x20200000
.equ GPIOSET0,	0x2020001C
.equ GPIOCLR0,	0x20200028

.globl SNES
SNES:
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	mov r4, #0 //button
	mov r0, #1
	bl clock
	mov r0, #1
	bl LAT
	bl wait_12ms
	mov r0,#0
	bl LAT
	mov r10, #0 // bit i = 0

pulseloop:
	bl wait_6ms
	mov r0, #0		//clear input button
	bl clock		//branch to clock
	bl wait_6ms			//wait 6ms
	bl DATA				//read from pin 10
	cmp r2, #1 			//check if button is pressed or not (1 is not pressed)
	bne isPressed	//if pressed, branch to button is pressed
	lsl r2, r10
	orr r4, r2
	

isPressed:
	mov r0, #1
	bl clock
	add r10, #1
	cmp r10, #16
	blt pulseloop
	mov r2, r4
	pop {r4,r5,r6,r7,r8,r9,r10, pc} // lr was pc

	

wait_12ms:
	ldr r0, =0x20003004 // address of CLO 
	ldr r1, [r0] // read CLO 
	add r1, #12 // add 12 micros 
	b waitLoop

wait_6ms:
	ldr r0, =0x20003004 // address of CLO 
	ldr r1, [r0] // read CLO 
	add r1, #6 // add 6 micros
	b waitLoop

waitLoop: 
	ldr r2, [r0] 
	cmp r1, r2 // stop when CLO = r1 
	bhi waitLoop 
	bx lr



