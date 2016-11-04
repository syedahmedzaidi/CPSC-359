.section .text

.equ	GPIOFSEL0,	0x20200000//pin 0 to 9
.equ	GPIOFSEL1,	0x20200004//pin 10 to 19



.globl InitialSNES

InitialSNES:
	
	//Set GPIO pin 09

	ldr r0, =GPIOFSEL0 // first GPIO reg
	ldr r1, [r0] //copy GPFSEL0 into r1
	mov r2, #7 // 0b0111
	lsl r2, #27 //index of 1st bit for pin 09
	bic r1, r2 //clear pin 09 bits
	mov r3, #1 //output function code
	lsl r3, #27 //sets 1 on the 27th bit for GPIO pin 9 output 
	orr r1, r3 //set pin 09 function in r1
	str r1, [r0] //write back to GPFSEL0
	
	//Completed pin 9 set-up
	
	//Set GPIO pin 11

	ldr r0, =GPIOFSEL1 // base GPIO reg
	ldr r1, [r0] //copy GPFSEL1 into r1
	mov r2, #7 //0b0111
	lsl r2, #3 //index of 1st bit for pin 11
	bic r1, r2 //clear pin 11 bits
	mov r3, #1 //output function code
	lsl r3, #3 //sets 1 on the 3rd bit 
	orr r1, r3 //set pin11 function in r1
	str r1, [r0] //write back to GPFSEL1
	

	//Completed pin 11 set-up


	//Set GPIO pin 10

	ldr r0, =GPIOFSEL1 //base GPIO reg
	ldr r1, [r0] //copy GPFSEL1 into r1
	mov r2, #7 //0b0111
	bic r1, r2 //clear pin 10 bits (sets input)
	//000 for input
	str r1, [r0] //write back to GPFSEL1

	//Completed pin 10 set-up

	bx lr
	
