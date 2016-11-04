.section .text
.globl DrawMap
DrawMap:
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	mov r6, #200	//starting location of each box x
	mov r7, #100	// starting location of each box y
	ldr r9, =map	// starting offset of the map
	mov r10, #0	//counters number of boxes x
	mov r5, #0	// counter number of boxes y
	
WholeMapX:		//draws all the boxes in x axis
	ldrb r8, [r9],#1
	mov	r0, r6
	mov	r1, r7
	mov	r2, r8
	bl DrawBox
	cmp r10 , #15
	add r6, #37
	add r10, #1
	bne WholeMapX
	
WholeMapY:			//draws all the boxes in y axis
	
	add r7, #37
	mov r6, #200
	mov r10,#0

	add r5, #1
	cmp r5, #16
	bne WholeMapX
	beq done


done:
	pop	{r4,r5,r6,r7,r8,r9,r10, pc}
	
	
.globl Loser
Loser:
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	mov r4, r0
	mov r6, #200	//starting location of each box x
	mov r7, #100	// starting location of each box y
	ldr r9, =Loser1	// starting byte of the map
	mov r10, #0	//counters number of boxes x
	mov r5, #0	// counter number of boxes y
	
LoserX:
	ldrb r8, [r9],#1
	mov	r0, r6
	mov	r1, r7
	mov	r2, r8
	bl DrawBox
	cmp r10 , #15
	add r6, #37
	add r10, #1
	bne LoserX
LoserY:
	
	add r7, #37
	mov r6, #200
	mov r10,#0

	add r5, #1
	cmp r5, #16
	bne LoserX
	beq done1
	
.globl Winner
Winner:
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	mov r4, r0
	mov r6, #200	//starting location of each box x
	mov r7, #100	// starting location of each box y
	ldr r9, =Win1	// starting byte of the map
	mov r10, #0	//counters number of boxes x
	mov r5, #0	// counter number of boxes y
	
WinnerX:
	ldrb r8, [r9],#1
	mov	r0, r6
	mov	r1, r7
	mov	r2, r8
	bl DrawBox
	cmp r10 , #15
	add r6, #37
	add r10, #1
	bne WinnerX
WinnerY:
	
	add r7, #37
	mov r6, #200
	mov r10,#0

	add r5, #1
	cmp r5, #16
	bne WinnerX
	beq done1
	
//-------------------------------------------------------------------------------------------------
drawwon:
	ldr	r1, =450		//x location
	ldr	r2, =510		//y location
	ldr	r6, =won		//loading the sentence of "won" to r6
	mov	r5, #0			//Offset

loop_won:				//write won
	ldrb	r3, [r6, r5]
	cmp	r3, #'#'		//Check to see if we reach the end of the sentence of "#". If so, branch to "fix" to go to the next line
	beq 	fix
	ldr	r2, =510		
	mov 	r10, r1
	bl	DrawFont
	mov	r1, r10		
	add	r5, #1
	add	r1, #9
	b	loop_won
	
fix:	
	ldr	r1, =450
	ldr	r2, =525
	ldr	r4, =names		//Prints the names
	mov	r5, #0 


done1:
	mov r0,r4
	pop	{r4,r5,r6,r7,r8,r9,r10, pc}
	
.section .data
.globl map
//the map is 128x128  bytes perfect square starting at 200pixel on x axis and 100pixel on y axis
map:
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 1
	.byte	1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1
	.byte	1, 0, 1, 3, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1
	.byte	1, 0, 1, 0, 1, 0, 1, 0, 4, 0, 1, 0, 0, 1, 0, 1
	.byte	1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1
	.byte	1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 4, 1, 0, 1, 0, 1, 1, 0, 1
	.byte	1, 3, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 4, 0, 0, 1
	.byte	1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1
	.byte	1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1
	.byte	1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1
	.byte	1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1
	.byte	1, 2, 0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 1, 0, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 1
	
Loser1:
	.byte	5, 1, 1, 1, 5, 5, 5, 1, 5, 5, 5, 1, 5, 5, 5, 1
	.byte	5, 1, 1, 1, 5, 1, 5, 1, 5, 1, 1, 1, 5, 1, 1, 1
	.byte	5, 1, 1, 1, 5, 1, 5, 1, 5, 5, 5, 1, 5, 5, 5, 1
	.byte	5, 1, 1, 1, 5, 1, 5, 1, 1, 1, 5, 1, 5, 1, 1, 1
	.byte	5, 5, 5, 1, 5, 5, 5, 1, 5, 5, 5, 1, 5, 5, 5, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	
Win1:
	.byte	5, 1, 5, 1, 5, 1, 5, 1, 5, 5, 5, 1, 1, 1, 1, 1
	.byte	5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 1, 1, 1, 1
	.byte	5, 5, 5, 5, 5, 1, 5, 1, 5, 1, 5, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	.byte	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	
won: .ascii "You Have Won#"			//r6
names: .ascii "Player#"    			//r4

	
.globl playerLoc
playerLoc:
	.byte	1, 14


	
	
