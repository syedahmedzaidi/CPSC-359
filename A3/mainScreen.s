.section .text

.globl mainScreen

mainScreen:

	push {r4-r10,lr}
	ldr	r1, =400		//x location
	ldr	r2, =50		//y location
	ldr	r6, =creator		//loading the sentence of "Creator" to r6
	mov	r5, #0			//Offset

loop_creator:				//write creators
	ldrb	r3, [r6, r5]
	cmp	r3, #'#'		//Check to see if we reach the end of the sentence of "#". If so, branch to "fix" to go to the next line
	beq 	fix
	ldr	r2, =50		
	mov 	r10, r1
	bl	DrawFont
	mov	r1, r10		
	add	r5, #1
	add	r1, #9
	b	loop_creator

fix:	
	ldr	r1, =400
	ldr	r2, =50
	ldr	r4, =name		//Prints the names
	mov	r5, #0 
			
loop_names:				//write names
	ldrb	r3, [r4, r5]
	cmp	r3, #'#'
	beq 	fix2
	ldr	r2, =50
	mov 	r10, r1
	bl	DrawFont
	mov	r1, r10		
	add	r5, #1
	add	r1, #9
	b	loop_names
	

fix2:
	ldr	r1, =400		//x
	ldr	r2, =200			//y
	ldr	r7, =start
	mov	r5, #0	
	
loop_start:
	ldrb	r3, [r7, r5]
	cmp	r3, #'#'
	beq 	fix3
	ldr	r2, =200
	mov 	r10, r1
	bl	DrawFont
	mov	r1, r10	
	add	r5, #1
	add	r1, #9
	b	loop_start
	
fix3:
	ldr	r1, =400	//x
	ldr	r2, =300	//y
	ldr	r8, =quit
	mov	r5, #0	
	
loop_quit:				//write title
	ldrb	r3, [r8, r5]
	cmp	r3, #'#'
	beq endofScreen
	ldr	r2, =300	
	mov 	r10, r1
	bl	DrawFont
	mov	r1, r10	
	add	r5, #1
	add	r1, #9
	b	loop_quit
	
endofScreen:
	pop	{r4-r10, pc}


.section .data

creator: .ascii "Made By:#"				   //r6
name: .ascii "          Ahmed Zaidi#"    			//r4
start: .ascii "Start Game#"
quit:  .ascii "Quit Game#"

