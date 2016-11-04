.section .text
.globl playingGame

playingGame:
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	bl drawCreators			//draws Creators on screen
	bl showKeys				//shows keys
	bl showMoves			//shows moves
	mov r0, #0				

//a continous loop that takes continous input from snes and performs actions based on the inputs
SNESLoop:
	ldr r9, =moves 		//loads the address of the loop	
	ldrb r8, [r9]		// stores it in r8 for checking
	cmp r8, #0			// if moves remaining == 0	
	bleq Lose			// jump o lose
	ldr r4, =playerLoc	//loads the player location
	ldrb r5,[r4],#1		//gets starting position + 1
	ldrb r6, [r4]		//gets starting offset of player location
	cmp r5, #14			// compares to see if equal to 14 or 15
	cmpeq r6, #15		// if equal jump to win 
	bleq Win	
	bl SNES 			// goes to snes to talk to snes controller
	bl controller		//sets the controllers key
	cmp r0, #100		//compare to see if the control is 100 meaning no buttons have been pressed
	beq SNESLoop		// if so then goes to start of loop again to get button inpu

	cmp r0, #4			//check to see if start button is pressed which is donated by #4
	bleq snesStart		// jump to snesStart if equal
	cmp r0, #5
	bleq snesUp			// is the up key on d-pad pressed?	
	cmp r0, #6		
	bleq snesDown		// is the down key on d-pad pressed?
	cmp r0, #7
	bleq snesLeft		// is the left key on d-pad pressed?
	cmp r0, #8
	bleq snesRight		//	is the right key on d-pad pressed?
	cmp r0, #9
	bleq snesA			// is the A key on the controller pressed?

waitRelease:			// waits for button to be released before taking another input key
	bl SNES 
	bl controller
	cmp r0, #100
	bne waitRelease
	beq SNESLoop
	

snesRight:
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	mov r7, #37 	//size of the box; x and y 36x36
	mov r8,r5 		//initial location of x boxes; 1
	mov r9,r6 		//initial location of y boxes ;1
	mul r8, r7 		// size of box times number of the boxes and store it to r8
	add r8, #200 	//add 200 to r8; first box location in the x-axis (x =  (r5 * 37) + 200)
	mul r9, r7 		//size of the box of the y-axis
	add r9, #100 	//add 100 to r9; to the location of the y-axis ( y = (r6 * 37) + 100)
	mov r1, r6		//move values of initial  to r1 and r2
	mov r2, r5		
	mov r0, #1		//
	bl surrounding	//returns the value of the tile beside(right) the player in r0
	mov r4, r3
	cmp r4, #1		//check if there is a wall beside(right) the player
	beq end
	cmp r4, #4		//check if there is a door beside(right) the player
	beq end
	cmp r4, #5		//check if there is a exit door beside(right) the player
	beq end	
	cmp r4, #3		//check if there is a key beside(right) the player  
	mov r1, r6
	mov r2, r5
	bleq gold		// if a key is beside the player on right, jump to gold to collect key

	mov r2, #0
	mov r0, r8 		//store it to r0 to pass the value of x-axis to DrawBox 
	mov r1, r9 		//store it to r1 to pass the value of y-axis to DrawBox
	bl  DrawBox		//draw a whiebox again

	ldr r4, =playerLoc		//load player location offset
	ldrb r10, [r4]			//get the initial offset
	cmp r10, #1				//compare to see if a wall is beside it
	ldreqb r10,[r4,#1]		// if so get the next location (beside the key, last location)
	cmpeq	r10, #14		//compare to see if it is 14
	moveq r2, #6			//move the color white
	moveq r0, r8			//x value
	moveq r1, r9			//y values
	bleq DrawBox			//draws a box

	add r8, r7 				// add 37 to r8; moving to the next first x-axis box location
	
	ldr r4, =playerLoc		//load the value of player location
	add r5,#1 				//next box to the right of the x-axis; playerLoc = 2
	strb r5, [r4]			//update the player location
	
	mov r2,#2 				//color of the green
	mov r0,r8 				//location of the updated box the second box x-axis
	mov r1,r9 				//location of the updated box the second box y-axis
	bl DrawBox 				//draw the green box
	ldr r9, =moves			// loads the address of moves	
	ldrb r8, [r9]			// moves the contents to r8
	sub r8, #1				//decrement the number of moves
	strb r8, [r9]			//  stores it back to location of "moves"
	bl showMoves			//updates the moves on the screen
	b end

snesUp:
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	mov r7, #37				//the size of the box
	mov r8, r5				
	mov r9, r6
	mul r8, r7
	add r8, #200			//original position ( x axis)
	mul r9, r7				//multiply is by the size of the box
	add r9, #100			//original position (y axis)
	mov r0, #-16			//since two boxes have to be moved. from 1 byte to another byte above it on the map (8x8)
	mov r1, r6				//store y axis value
	mov r2, r5
	bl surrounding			//checks surrounding
	mov r4, r3				//gets the color
	cmp r4, #1				//compares to see if color is black
	beq end					//if so then go to end
	cmp r4, #4				//if the color is blue end.
	beq end
	cmp r4, #5				//if the color is red end
	beq end
	cmp r4, #3				//if the color is yellow(gold)
	mov r1, r6
	mov r2, r5
	bleq gold				//go to pick up key

	mov r2, #0				//load the color white
	mov r0, r8				//get the location of the key
	mov r1, r9
	bl  DrawBox				//draw the box white.
	sub r9,r7 			//y-coordinates for one box above
	sub r6, #1 			//one box above the player location (subtracted the lines which are basically 1 pixels of space)
	
	ldr r4, =playerLoc		//gets player location
	add r4, #1				//moves up one
	strb r6, [r4]		
	mov r2, #2				//sets color as green as the updated location
	mov r0, r8
	mov r1, r9
	bl DrawBox				//draws the green box at that location
	ldr r9, =moves			//set the moves and updates it
	ldrb r8, [r9]
	sub r8, #1
	strb r8, [r9]
	bl showMoves			//show moves
	b end					//take input again


snesDown:

	push {r4,r5,r6,r7,r8,r9,r10,lr}
	mov r7, #37				//size of the boxes + 1 pixel space
	mov r8, r5				//values of x
	mov r9, r6				//value of u
	mul r8, r7				//get updated value
	add r8, #200			//original position x
	mul r9, r7				//updated value
	add r9, #100			//original position y
	mov r0, #16				//move 16 bytes
	mov r1, r6				//y value remains the same
	mov r2, r5				//same color
	bl surrounding			//check surrounding
	mov r4, r3				//load the color
	cmp r4, #1				//if the color is black end
	beq end
	cmp r4, #4				//if the color is door, end
	beq end
	cmp r4, #5				//if the color is red door end.
	beq end
	cmp r4, #3				//if the color is yellow
	mov r1, r6			
	mov r2, r5
	bleq gold				//pick up key and increment key
	

	mov r2, #0				//draw the yellow box as a white box now since key is picked up
	mov r0, r8
	mov r1, r9
	bl  DrawBox				//draw the box
	add r9, r7
	ldr r4, =playerLoc		
	add r6, #1				//1 pix
	strb r6,[r4,#1]
	mov r2, #2
	mov r0, r8
	mov r1, r9
	bl DrawBox				//updates player location
	ldr r9, =moves			//update moves
	ldrb r8, [r9]
	sub r8, #1
	strb r8, [r9]
	bl showMoves			//show moves
	b end					//take input again



snesLeft:

	push {r4,r5,r6,r7,r8,r9,r10,lr}
	mov r7, #37			//box size + pixel of space for line
	mov r8, r5	
	mov r9, r6
	mul r8, r7				//get updated value of two boxes
	add r8, #200			//original location
	mul r9, r7
	add r9, #100			//original location y
	mov r0, #-1				//the x location will be updated so that the 1 pixel of line is ignored
	mov r1, r6
	mov r2, r5				

	bl surrounding			//check surrounding

	mov r4, r3				//check for color
	cmp r4, #1				//if color is black, end
	beq end
	cmp r4, #4				//if black is blue door, end
	beq end
	cmp r4, #5				//if the red door, end
	beq end
	cmp r4, #3				//if gold key is there
	mov r1, r6
	mov r2, r5
	bleq gold				//pick up key increment key
	
	mov r2, #0				//put the key box as white now
	mov r0, r8
	mov r1, r9
	bl  DrawBox				//draw the box
	sub r8,r7				//update location
	ldr r4, =playerLoc		//update player location
	sub r5,#1				//1 byte
	strb r5, [r4],#1
	strb r6, [r4]
	mov r2,#2				//color green
	mov r0,r8
	mov r1, r9
	bl DrawBox				//draw green box box
	ldr r9, =moves			//update moves
	ldrb r8, [r9]
	sub r8, #1				//subtract one since one move is used
	strb r8, [r9]
	bl showMoves			//show moves on screen again
	b end					//take input again

snesA:
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	mov r1, r6			
	mov r2, r5
	mov r0, #-1
	mov r1,r6
	mov r2,r5
	bl surrounding		//check left

	mov r4, r3			//check to see the color of boxes
	cmp r4, #5			//if the box is red
	mov r1, r6
	mov r2, r5
	mov r0, #-1			//leave one pixel of space
	bleq open			//open the door
	
	cmp r4, #4			//if the color of next box is blue
	mov r1, r6
	mov r2, r5
	mov r0, #-1			//leave one pixel of space
	bleq open			//open door again
	mov r1,r6
	mov r2,r5
	mov r0, #1			//add another pixel
	bl surrounding		//check right
	
	mov r4, r3			//check color
	cmp r4, #5			//if the color of box is red
	mov r1, r6
	mov r2, r5
	mov r0, #1			
	bleq open			//OPEN DOOR
	
	cmp r4, #4			//if door color is blue
	mov r1, r6
	mov r2, r5
	mov r0, #1	
	bleq open			//open
	mov r1,r6
	mov r2,r5
	mov r0, #16			//two boxes space
	bl surrounding  //check down

	mov r4, r3
	cmp r4, #5			//if box is red
	mov r1, r6
	mov r2, r5
	mov r0, #16			//two box down
	
	bleq open
	cmp r4, #4			//if box is blue
	mov r1, r6
	mov r2, r5
	mov r0, #16			//two boxes space
	bleq open			//open door
	mov r1,r6
	mov r2,r5
	mov r0, #-16		//two boxes space is subtracted to ensure that one door is opened
	bl surrounding  //check up

	mov r4, r3
	cmp r4, #5			//if door is red
	mov r1, r6
	mov r2, r5
	mov r0, #-16	//two boxes space is subtracted to ensure that one door is opened
	bleq open		//open door
	
	cmp r4, #4		//if door is blue
	mov r1, r6
	mov r2, r5
	mov r0, #-16	//leave two spaces of boxes
	bleq open		//open the door
	b end			//jump to end

snesStart:
	mov r0, #1
	ldr r9, =moves		//just when the start button is pressed, it restarts the game and sets moves as 150 agian
	ldrb r8, [r9]
	mov r8, #150
	strb r8, [r9]
	bl showMoves
	b end
	
end:
	pop {r4,r5,r6,r7,r8,r9,r10, pc}			//pc is back to SNESLOOP

surrounding:
	push {r4,r5,r6,r10,lr}		//perserve register
	mov r4, r1					
	mov r10, r2`				
	add r10, r4, lsl #4			//check 16 bytes since two different color and one is black one is white. Thus two boxes
	add r10, r0					//add the x location into it
	ldr r4, =map				//store the starting offset of map
	add r4, r10					//put the updated location
	ldrb r3, [r4]				//end up putting color there
	pop {r4-r6,r10,pc}			//back to wher eu were

gold:
	push {r4,r5,r6,r7,lr}
	ldr r4, =key			//number of keys
	ldrb r5, [r4]			//r5 contains keys
	add r5, #1				//increment a key
	strb r5, [r4]			//store the updated version
	bl showKeys				//show keys again
	ldr r4, =map			//address of map
	mov r5, r2				
	mov r6, r1
	add r5, r6, lsl #4
	add r5, r0
	add r5, r4				//location of keys on map
	mov r7, #0
	strb r7,[r5]			//update it
	pop {r4,r5,r6,r7,pc}
	

open:
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	

	ldr r4, =key
	ldrb r5, [r4]
	cmp r5, #1
	blt end
	sub r5, #1
	strb r5, [r4]
	bl showKeys
	ldr r4, =map
	mov r5, r2
	mov r6, r1
	add r5, r6, lsl #4
	add r5, r0
	add r5, r4
	mov r7, #0
	strb r7,[r5]

	sub r5, #1
	strb r5, [r4]
	ldr r4, =playerLoc
	ldrb r5,[r4],#1//x location of player
	ldrb r6, [r4]	//y location of player
	mov r7, #37
	mov r8, r5
	mov r9, r6
	mul r8, r7
	add r8, #200
	mul r9, r7
	add r9, #100
	cmp r0, #1
	addeq r8,r7
	cmp r0, #-1
	subeq r8, r7
	cmp r0, #16
	addeq r9,r7
	cmp r0, #-16
	subeq r9,r7
	mov r2, #0			//white box
	mov r0, r8
	mov r1, r9
	bl  DrawBox			//draws a white box
	ldr r9, =moves
	ldrb r8, [r9]
	sub r8, #1
	strb r8, [r9]
	bl showMoves
	pop {r4,r5,r6,r7,r8,r9,r10,pc}
	
.globl RestartGame
RestartGame:
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	ldr r4, =key				//update the number of keys
	mov r5, #0
	strb r5, [r4]
	ldr r4, =playerLoc			//player location is back to where it was
	mov r5, #1
	mov r6, #14					//bottom left hand corner
	strb r5, [r4], #1
	strb r6, [r4] 	
	mov r5, #3	//key
	mov r6, #4	//door
	mov r7, #5	//exit door
	mov r8, #1
	ldr r4, =map
	strb r5,[r4,#51]			//put all the keys
	ldr r4, =map 
	strb r5,[r4,#129]			//put all the keys
	ldr r4, =map
	strb r5,[r4,#233]			//put all the keys
	ldr r4, =map
	strb r6,[r4,#24]			//load all the doors on map
	ldr r4, =map
	strb r6,[r4,#72]			//load all the doors on map again
	ldr r4, =map
	strb r6,[r4,#119]			//load all the doors on map again
	ldr r4, =map
	strb r6,[r4,#140]			//load all the doors on map agian
	ldr r4, =map
	strb r7,[r4,#254]			//load exit door
	ldr r4, =map
	strb r8,[r4]
	pop	{r4,r5,r6,r7,r8,r9,r10, pc}
		
Win:
	mov r0, #2
	bl Winner		//you are the winner

	ldr r4, =moves		//load new number of moves
	mov r6, #150
	strb r6, [r4]
	
	bl RestartGame			//restart game
	 
	pop  {r4,r5,r6,r7,r8,r9,r10,pc}

Lose:
	mov r0, #2
	bl Loser		//you are the loser

	ldr r4, =moves		//update moves again
	mov r6, #150
	strb r6, [r4]
	
	bl RestartGame	//restart game
	 
	pop  {r4,r5,r6,r7,r8,r9,r10,pc}

showKeys:					//the place where our keys will be shown on the screen
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	mov r10,r3
	mov r9, r1
	mov r8, r2
	mov r7, r0
	ldr r0, =680
	ldr r1, =700	 // on the map
	mov r2, #1
	bl DrawBox
	ldr r4, =key
	ldrb r4, [r4]
	add r4, #48
	ldr r1, =700
	ldr r2, =700
	mov r3, r4
	bl DrawFont	
	mov r0, r7
	mov r1, r9
	mov r2, r8
	mov r3, r10
	pop  {r4,r5,r6,r7,r8,r9,r10,pc}

showMoves:					//place where our moves will be shows on the screen
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	mov r10,r3
	mov r9, r1
	mov r8, r2
	mov r7, r0
	ldr r0, =380
	ldr r1, =700
	mov r2, #1
	bl DrawBox
	ldr r4, =moves
	ldrb r4, [r4]
	ldr r1, =400
	ldr r2, =700
	mov r5, #0 //r5 will be our quotient


countM:			
	cmp r4, #10
	blt countM2
	sub r4, #10
	add r5, #1
	b countM

countM2:		
	
	add r3, r4, #48
	ldr r2, =700
	mov r6, r1
	bl DrawFont
	mov r1, r6
	sub r1, #9
	mov r4, r5
	mov r5, #0
	cmp r4, #1
	bge countM


	mov r0, r7
	mov r1, r9
	mov r2, r8
	mov r3, r10
	pop  {r4,r5,r6,r7,r8,r9,r10,pc}


.section .data

key: .byte 0

moves: .byte 150

