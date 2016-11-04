.section .text
.globl	controller


//algorithm to compare if buttons are pressed is simple

// it takes the input button and stores their address in a register
//it compares the address that the input has and compares it with each buttons address
//if they are equal it store a specific number that i have assigned inthis program to the button
//for the sake of simplicity the following are the assigned numbers to each button in this program
//3 = select
//4 = start
//5 = up
//6 = down
//7 = left
//8 = right
//9 = a
//100 = no button pushed
			
controller:
	push	{r4,r5,r6,lr}
	mov	r4, r2			//r2 is input recieved from SNES, stored in r4			

	//Check A button
	ldr	r5, =0xFEFF		//a  button address is 65279
	teq	r4, r5
	moveq	r0, #9
	beq	end
	
	//Check right button
	ldr	r5, =0xFF7F		//right button address is 65407
	teq	r4, r5
	moveq	r0, #8
	beq	end

	//Check left button
	ldr	r5, =0xFFBF		//left button address is 65471
	teq	r4, r5
	moveq	r0, #7
	beq	end

	//Check down button
	ldr	r5, =0xFFDF		//down button address in decimal 65503
	teq 	r4, r5
	moveq	r0, #6
	beq	end

	//Check up button
	ldr	r5, =0xFFEF		//up butotn address in decimal 65519
	teq	r4, r5
	moveq	r0, #5
	beq	end

	//Check start button
	ldr	r5, =0xFFF7		//start button address in decimal 65527
	teq     r4, r5
	moveq 	r0, #4
	beq	end
	

	//check select button
	ldr r5, =0xFFFB		//select button addressin decimal 65531
	teq r4, r5
	moveq r0, #3
	beq end

	
	//No buttons pressed
	ldr	r5, =0xFFFF
	teq	r4, r5
	moveq	r0, #100
	bne	end

end:
	
	pop {r4,r5,r6, pc}
