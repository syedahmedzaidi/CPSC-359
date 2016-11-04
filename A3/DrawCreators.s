.section .text

.globl drawCreators
	
	
drawCreators:
	push	{r4,r5,r6,r7,r8,r9,r10,lr}
	ldr	r1, =400		//x location
	ldr	r2, =50		//y location
	ldr	r6, =creators		//loading the sentence of "Creators" to r6
	mov	r5, #0			//Offset

loop_creators:				//write creators
	ldrb	r3, [r6, r5]
	cmp	r3, #'#'		//Check to see if we reach the end of the sentence of "#". If so, branch to "fix" to go to the next line
	beq 	fix
	ldr	r2, =50		
	mov 	r10, r1
	bl	DrawFont
	mov	r1, r10		
	add	r5, #1
	add	r1, #9
	b	loop_creators

fix:	
	ldr	r1, =400
	ldr	r2, =50
	ldr	r4, =names		//Prints the names
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
	ldr	r1, =630		//x
	ldr	r2, =700			//y
	ldr	r7, =numberKeys
	mov	r5, #0			

loop_keys:				//write keys
	ldrb	r3, [r7, r5]
	cmp	r3, #'#'
	beq 	fix3
	ldr	r2, =700
	mov 	r10, r1
	bl	DrawFont
	mov	r1, r10	
	add	r5, #1
	add	r1, #9
	b	loop_keys
	
	
fix3:
	ldr	r1, =430	//x
	ldr	r2, =13		//y
	ldr	r8, =title
	mov	r5, #0		


loop_title:				//write title
	ldrb	r3, [r8, r5]
	cmp	r3, #'#'
	beq 	fix4
	ldr	r2, =13	
	mov 	r10, r1
	bl	DrawFont
	mov	r1, r10	
	add	r5, #1
	add	r1, #9
	b	loop_title

fix4:
	ldr	r1, =230			//x
	ldr	r2, =700			//y
	ldr	r9, =moving
	mov	r5, #0			

loop_moves:				//write moves
	ldrb	r3, [r9, r5]
	cmp	r3, #'#'
	beq 	end
	ldr	r2, =700	
	mov 	r10, r1
	bl	DrawFont
	mov	r1, r10	
	add	r5, #1
	add	r1, #9
	b	loop_moves


end:
	pop	{r4,r5,r6,r7,r8,r9,r10, pc}
	
.section .data

creators: .ascii "Made By:#"				   //r6
names: .ascii "          Ahmed Zaidi#"    			//r4
numberKeys: .ascii "keys: #"				   //r7
title: .ascii "Maze Game#"				   //r8
moving: .ascii "Moves Remaining:#"		            //r9



