.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    mov     sp, #0x8000
	
	bl		EnableJTAG

	bl		InitialSNES			//initialize snes controlller
	bl		InitFrameBuffer		//initialize FrameBuffer
Game:
	cmp		r0, #0
	beq		haltLoop	// branch to the halt loop if there was an error initializing the framebuffer
	
startingpoint:

	bl 		mainScreen			//loads the main screen
	bl 		SomethingPressed
	cmp r0, #4					//sees what button is pressed
	beq playon					/if button start is pressed then move to playing game
	cmp r0, #3					//see what button is pressed
	beq haltLoop				//if select button is pressed then move to end game
	cmp r0, #5					//any other button is pressed than stay put
	beq startingpoint
	cmp r0, #6
	beq startingpoint
	cmp r0, #7
	beq startingpoint
	cmp r0, #8
	beq startingpoint
	cmp r0, #9
	beq startingpoint
		
playon:
	bl 		DrawMap				//draws the map
	bl		playingGame			
	
	cmp r0, #1					//if start button pressed again
	bleq RestartGame			//restart game
	beq	Game					//else stay in game
	cmp r0, #2					
	bne haltLoop				//if button quit is pressed
	bleq SomethingPressed		// take that button
	mov r0, #1					//move 1 in it
	b Game						//start of loop again

SomethingPressed:
	push {lr}
	bl SNES				//talks to snes which sets up input
	bl controller		//button from controller	
	cmp r0, #100		//nothing pressed, check with that
	beq SomethingPressed
	pop {pc}
	
	
haltLoop:

	b haltLoop


