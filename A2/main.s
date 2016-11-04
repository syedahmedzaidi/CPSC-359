.equ AUXENB, 0x20215004  			//enable mini uart register
.equ AUX_MU_IO_REG, 0x20215040 	//write data to and read data register
.equ AUX_MU_IER_REG, 0x20215044	//clear this whole register, Interrupts
.equ AUX_MU_CNTL_REG, 0x20215060   //Receiver and Transmitter control register
.equ AUX_MU_LCR_REG, 0x2021504C	//controls the line data format and gives access to the baudrate register
.equ AUX_MU_MCR_REG, 0x20215050	//controls the 'modem' signals
.equ AUX_MU_IIR_REG, 0x20215048	//set FIFO Clear bits register
.equ AUX_MU_BAUD, 0x20215068		//baud rate register
.equ AUX_MU_LSR_REG, 0x20215054	//data status register

.section .init
.globl _start

_start:

	b main //jumps to main


.section .text


main:


	mov sp, #0x8000		//moves stack pointer
	bl EnableJTAG		//enables JTAG
	bl UARTIntialize	//initializes my miniUart
	b loop1				//infinite loop for input
	
loop1:
			ldrb r0, =prompt		//a prompt message is passed to r0
			ldrb r0, [r0,#0]		//first offset(first byte stored)
			bl putCharacter			//it prints it to the screen
			ldrb r0, [r0,#1]		//second byte stored
			bl putCharacter			//it prints on the screen
			ldrb r0, [r0,#2]		//third byte stored
			bl putCharacter			//prints it on screen
			mov r3, #0				//general program counter
			ldr r4, =buffer			//loads starting offset of buffer
			mov r1, #0				
			loop2:
				PUSH {r4, r10}	
				bl getCharacter			//calls getcharacter to start writing on uart
				cmp r0, #0xD			//checks if enter was pressed
				beq checkBuffer			//if it is equal, it jumps to checking my Buffer for commands
				strb r0, [r13], r1		//else it stores the value of r0 into the place [r13] so basically r13 has address of buffer
										//it goes to place of buffer and stores it there, it then post-increments by value of r1

				add r1, #1				//increments r1 thus allowing us to move ahead in buffer when it loops
				ldr r10, [r13]			//loads the value of my stack pointer to r10 thus the value of my buffer is in r10
				cmp r10, #256			//checks to see if my buffer is full or not
				bne loop2				//while my buffer is not full, it keeps asking to enter value into buffer
				POP {r4,r10}
			b loop1					//branches to start of buffer again, thus keeps overwritting it

		checkBuffer:
				ldr r0, =buffer		//offset of buffer is passed
				mov r7, #0			//moves a terminating sign to r7
				strb r7, [r0,r1]	//moves the terminating sign to the end of the buffer where new line feed was pressed.
				ldr r1, =led		//address of "led o" is passed and stored in r1
				ldr r2, =echo		//address of "echo (")" is passed and stored in r2

				ldrb r4, [r1,r3]	//loads the value of r3th offset of "led o" string which happens to be "l"
				ldrb r5, [r0,r3]	//loads the value at r3th offset of buffer
				cmp r5, r4			//compares if the first value in buffer with "l"
				beq checkLed		//if it is equal (both subtracted with each other sets the Zero flag) then it jumps to checkLed
				cmp r5, [r2,r3]		//if it is not equal, it checks with first offset of "echo (")" string.
				beq checkEcho		//if it is equal, it jumps to checkEcho
				b invalidCommand	//if none of them are true, thus it is an invalid command because it its none of the following
									//led on
									//led off
									//echo "<string>"

			checkLed:
				add r3, #1			//since it has already checked "l" it increments general program counter to 1 place ahead.
				cmp r3, #4			//compares program counter to see if it has read 4 string letters meaning all of the string "led o" 
				beq checkStateOn	//if it has it moves to check if it has state on
				ldrb r4, [r1,r3]	//otherwise it loads the next byte in string "led o" which happens to be e
				ldrb r5, [r0,r3]	//it loads the next byte in my buffer
				cmp r5, r4			//it compares them
				bne invalidCommand	//if not equal to "e" it moves to invalid command	
				b checkLed			//otherwise it keeps looking

			checkStateOn:
				add r3, #1			//adds 1 to r3 to moves forward in my general buffer
				ldrb r5, [r0,r3]	//loads the next value in my buffer to r5
				ldrb r1, =stateOn	//it loads "n" in r1 and 
				cmp r5, [r1]		//compares if the next value in my buffer(r5) is equal to n
				beq ledOn			//if it is, a complete "led on" string has been generated and it moves to turning led on
				b checkStateOff		//if the value in my buffer(r5) is not equal to n, it moves too see if it is "led off"command

			checkStateOff:

				ldrb r1, =stateOff	//loads the offset of string "ff" to r1
				ldrb r7, [r1,#1]	//contains next address of state off 
				cmp r5, [r1,r4]		//compares to see if the first offset of string "ff" is same as my r5
				bne invalidCommand	//if it isnt, it moves to print invalid command since it isnt "led on" or "led off"
				add r3, #1			//moves to next byte in my buffer to check for last "f"
				ldrb r5, [r0, r3]	//loads the next value in my buffer
				cmp r5, r7			//compares my next value in buffer with second offset of stateOFF
				bne invalidCommand	//if my value does not equal thus the last input in my buffer is not an "f" and thus it is not the string "led off"
				b ledoff			//if it does equal it branches to ledoff to turn off led

			checkEcho:
				add r3, #1			//since it has already checked fthe first input in my buffer for "e", we move forward in our buffer
				cmp r3, #6			//we compare to check if we have already read "echo (")"
				beq checkString		//if we have we move to checking for terminator to end string and print it
				ldrb r4, [r2,r3]	//if we havent check all of string "echo (")" we load the next offset in string "echo (")"
				ldrb r5, [r0,r3]	// and we load next value in our buffer to r5
				cmp r5,r4			//we compare them
				bne invalidCommand	//if not equal then it is invalid string
				b checkEcho			//if equal then we move to checking next offset in string echo " with our next offset in buffer

			checkString:
				add r3,#1			//since we have checked for first quotation
				ldrb r5, [r0,r3]	//we load next value in our buffer and verify that we have correct command
				cmp r5, #0x22		//we check for another " after the first quotation
				beq checkandStore	// if there is another quote, we move to saving that quote in buffer as it should be printed
				cmp r5, #0xA		//else we check for new line after first quotation to see if the command is invalid
				beq invalidCommand	//if there is, then it is invalid command
				bne checkandStore	//else if itsnt and there is another symbol we move to saving that symbol too
			
			checkandStore:
				ldr r7, =echo_buffer	//we load offset of our echo buffer
				mov r11, #0				//use r11 as a counter for echo buffer
				ldrb r5, [r0,r3]		//load the last symbol seen into r5
				strb r5, [r7,r11]		//store r5 into echo's buffer
				b checkandStore1		// we move to continuing scanning our string	

			//scann rest of the string
			checkandStore1:			
					mov r11, #0				//load 0 to point to start of echo buffer
					ldr r7, =echo_buffer	//load address of echo buffer
					add r11, #1				//move one space up in buffer because you have already stored the last symbol at this place 
					add r3,#1				//increment further into the original buffer
					ldrb r5, [r0,r3]		//grab the original buffer value
					cmp r5, #0				//check to see if a terminating sign has occurred
					beq checkforLastQuote	//if it has occurred.
					strb r5,[r7,r11]		//if not then store the next value of original buffer to echo buffer
					b checkandStore1		//continue looping until a terminating sign has occured

			checkforLastQuote:
				mov r11, #0			//point to start of echo buffer
				ldr r7, =echo_buffer	//echo buffer loaded to r7
				ldr r4, [r7,r11]		//load the first value of echo buffer to r4
				add r11, #1				//increment in echo buffer
				cmp r4, #0				//check to see if the value is the terminating value
				bne checkforLastQuote	//if it isnt, loop back to top to find the terminating value
				sub r11, #1				//once the terminating value has been found, subtract 1 from r11 to move one iteration behind the quote
				ldr r4, [r7,r11]		//load the value before the quote appeared
				cmp r4, #0x22		//compare to see if r4 is a quote
				bne invalidCommand	//if it isnt the termination quote, it is invalid command
				b printEcho			//if it is, hurray! we have a complete correct command, move to printing that string

			printEcho:
				mov r11, #0				//move r11 to 0 to point to start of buffer	
				ldr r7, =echo_buffer	//move start offset of echo buffer to r7
				ldr r4, [r7,r11]		//load the value of the offset to r4
				cmp r4, #0				//compare r4 with terminator
				beq loop1				//if a terminator appeared, we have completed printing our string, Loop back to Command Prompt
				mov r0, r4				//else move the value of r4 to r0 so it can be printed
				bl putcharacter			//print the character to screen
				b printEcho				//move forward in the buffer

		invalidCommand:
			mov r3,#0					//counter for printing this string
			printInvalid;

				ldr r6, =invalid_command	//move offset of invalid command to r6
				ldrb r0, [r6,r3]			//load the offset byte into r0
				bl putCharacter				//print that character to screen
				cmp r3, #14					//once we have iterated it 14 times, we have finished printing the string "Command not found"
				beq loop1					//loop back to command prompt
				add r3, #1					//if we havent finished printing it all, add to offset
				b printInvalid				//jump back to top to start printing again.
			

UARTIntialize:	
	
	PUSH {r4,r5,lr}
	
	//enable mini uart
	ldr r0, =AUXENB 				//load the address of enable mini uart register
	ldr r4, [r0]  					// get contents
	orr r4, r4,#0x1					// set the 0 bit to enable mini uart
	str r4, [r0]
	
	//disable interrupts
	ldr r0, =AUX_MU_IER_REG 		//load address of interrupt enable register
	ldr r4, [r0]					//get contents
	and r4, #0x00000000				//cleared all of the register to disable interrupts
	str r4, [r0]
	
	//Disable Receiving & Transmitting
	ldr r0, =AUX_MU_CNTL_REG		//load address of Receiver and Transmitter control register
	ldr r4, [r0]					//get contents
	and r4,#0x00000000				//clear the last two bits and perserve the others
	str r4, [r0]
	
	//Set Symbol Width(# of bits)
	ldr r0, =AUX_MU_LCR_REG			//load address of Mini UART line control register
	ldr r4, [r0]					//get contents
	orr r4, r4, #0x0000003			// set bit 0 of the line control register to get 8-bit mode running
	str r4, [r0]
	
	//set the RTS line high
	ldr r0, =AUX_MU_MCR_REG			//load address of control model signal register
	ldr r4, [r0]					//get contents
	and r4,  #0x00000000				//perserve other bits except bit 1, which should be cleared.
	str r4, [r0]
	
	//Clear the Input and Output Buffers
	ldr r0, =AUX_MU_IIR_REG			//Mini UART Interrupt Status Register loaded in r0
	ldr r4, [r0]					//get contents
	and r4, #0x000000C6			//cleared input output buffers by setting bits 	1 and 2
	str r4, [r0]
	
	/*set baud rate*/
	ldr r0, =AUX_MU_BAUD			//baud rate register
	ldr r4, =270					// baud rate of 270.
	str r4, [r0]					//store baud rate inside the physical memory address AUX_MU_BAUD
	
	//set the RXD and TXD  GPIO lines to Alt function 5
	/*1) RXD*/
	ldr r0, =0x20200004				// Function Select 1 Address
	ldr r4, [r0]					// Load value into register
	mov r5, #0b111					// Set up clear mask
	bic r4, r5, lsl #15	    		// Clear bits 18-20
	mov r5, #0b010					// Value mask (alt5 = 010)
	orr r4, r5, lsl #15			    // OR-mask into bits 18-20
	str r4, [r0]					// Store register to memory
	
	/*2) TXD*/
	ldr r0, =0x20200004				// Function Select 1 Address
	ldr r4, [r0]					// Load value into register
	mov r5, #0b111					// Set up clear mask
	bic r4, r5, lsl #12 			// Clear bits 18-20
	mov r2, #0b010					// Value mask (output = 010)
	orr r4, r5, lsl #12			    // OR-mask into bits 18-20
	str r4, [r0]					// Store register to memory

	//Disable Pull-up/down for RXD (15) and TXD (14) GPIO lines
	/*RXD*/
	ldr r0, =0x20200094				//load GPPUD to register. Base address 20200000 + 37 offset for GPPUD
	ldr r4, [r0]					//load contents into register
	and r4, =0x00000000					// clear GPIO Pull-up/down register;
	str r4, [r0]					//clear bits[1:0] (disable pull-up/down)
	b wait							//wait 150 cycles
	ldr r0, =0x20200098				//load GPIO pull-up/down clock register 0 . Base address 20200000 + 38
	ldr r4, [r0]					//load contents
	orr r4, r4,  =0x0000C000		// write to GPIO Pull-up/down Clock register 0;
									// set bit 14 and 15 (assert clock lines 14 & 15)
	str r4,[r0]

	b wait							//wait 150 cycles
	ldr r0, =0x20200038				//load GPIO pull-up/down clock register 0 . Base address 20200000 + 38
	ldr r4, [r0]
	and r3, =0x00000000					//clear GPIO Pull-up/down Clock register 0
		

	//Enable recieveing and transmitting
	ldr r0, =AUX_MU_CNTL_REG		//load address of Receiver and Transmitter control register
	ldr r4, [r0]					//get contents
	mov r4,#3						//clear the last two bits and perserve the others
	str r4, [r0]
	POP {r4,r5,pc}

	/* initializing mini uart ends here ----------------------------------------------------------------------------------------------------------------*/

putCharacter:

	PUSH {lr}
	
	putChar:
		ldr r2, =AUX_MU_LSR_REG 		//load Miniuart line status register
		ldr r1, [r2]					//get contents
		tst r1, #0x20					//check the 5th bit if it is set					
		beq putChar				//wait in loop until #5 is set.
		ldr r2, =AUX_MU_IO_REG		
		strb r0,[r2]
	POP {pc}
	
getCharacter:

	PUSH {lr}
	
	getChar:
		ldr r2, =AUX_MU_LSR_REG			//load Miniuart line status register
		ldr r1, [r2]					//get contents
		tst r1, #0x01					//checks the first bit if it is set thus making data read to be transfered
		beq getChar						//wait until the first bit is set, once it is it moves on
		ldr r2, =AUX_MU_IO_REG			//address of input output register 
		ldrb r0, [r2]					//loads r0 into input output register
		bl putCharacter
	POP {pc}
	

wait:			//wait function
	
	PUSH {lr}
	mov r2, #150		//moves 150 in r2 and then keeps subtracting 1 from r2 until there is a 0 in r2. Once there is it goes back to pc.
	wait$:
		sub r2, #1
		cmp r2, #0
		bne wait$
		POP {pc}

ledon:

	ldr r0, =0x20200004 // Function Select 1 Address
	ldr r1, [r0]		// Load value into register
	mov r2, #0b111		// Set up clear mask
	bic r1, r2, lsl #18 // Clear bits 18-20
	mov r2, #0b001		// Value mask (output = 001)
	orr r1, r2, lsl #18 // OR-mask into bits 18-20
	str r1, [r0]		// Store register to memory
	ldr r1, =0x2020001C
	mov r1, =0x00010000	//set gpio 16
	str r1, [r0]
	bl loop1		//loop back to command prompt
	

ledoff:

	ldr r0, =0x20200004 // Function Select 1 Address
	ldr r1, [r0]		// Load value into register
	mov r2, #0b111		// Set up clear mask
	bic r1, r2, lsl #18 // Clear bits 18-20
	mov r2, #0b001		// Value mask (output = 001)
	orr r1, r2, lsl #18 // OR-mask into bits 18-20
	str r1, [r0]		// Store register to memory
	ldr r1, =0x20200028
	mov r1, =0x00010000	//clear gpio 16
	str r1, [r0] 
	bl loop1			//loop back to command prompt


.section .data

.align 2
buffer:				//this is my buffer which stores numbers from Pi's fifo buffer
	.rept 256
	.byte 0
	.endr
echo_buffer:		//this is my echo buffer which stores string that are supposed to be echoed.
	.rept 256
	.byte 0
	.endr
led: 
	.ascii "led o"		//checks for command "led o.."
stateOn:
	.ascii "n"			//used in conjunction with "led o.." if this string exist after led string then it goes to turns on led
stateOff:
	.ascii "ff"			//used in conjunction with "led o.." if this string exist after led string then it goes to turns off led		
echo:
	.ascii "echo '"'"	// checks for command "echo (")"
illegal_command:
	.ascii "Command Not Found"		//used if illegal command has been pressed
prompt:
	.ascii "\r\n>"			//prompts user to type in a word!
.end

