.section .text

.globl DrawBox

DrawBox:
	
	
init:
	push 	{r4,r5,r6,r7,r8,r9,r10, lr}

	px	.req	r7	//location x
	py	.req	r8	//location y
	color	.req	r6	//color	
	sizey	.req	r4	//size y
	sizex	.req	r5	//size x

	mov	px,	r0
	mov	py,	r1
	mov	r10,	r2	
	mov 	sizex, 	#36		//size of each box
	mov 	sizey, 	#36		//size of each box
	mov	r9, r0

color_code:
	//color codes are used from the following website
	//http://www.december.com/html/spec/colorsafe.html
	cmp	r10,	#0
	ldreq	color,	=0xFFFFFF		//white - path
	cmp	r10,	#1
	ldreq	color,	=0x000000		//black - walls
	cmp	r10,	#2 
	ldreq	color,	=0x006600     //light green - player
	cmp	r10,	#3	
	ldreq	color,	=0xCCFF00 		//yellow - keys
	cmp	r10,	#4
	ldreq	color,	=0x000033		//dark blue - doors
	cmp	r10,	#5
	ldreq	color,	=0xFFF000		//red 	- exit door	
	cmp	r10, 	#6
	ldreq	color,  =0xFFFFFF		//white- Starting point
	cmp 	r10, 	#7
	ldreq	color,  =0x000000	//black to cover writing

loop_x_line: 		
	
	cmp 	sizex, #0
	beq 	y_counter
	sub	sizex, #1
	mov	r1, px
	mov	r2, py
	mov	r3, color
	bl	DrawPixelbpp
	add 	px, #1		
    b	loop_x_line
	

y_counter:
	cmp	sizey,	#1			
	mov	sizex,  #36			//size of box
	mov	px,	r9			
	subne	sizey,	#1		//subtracts the 1 pixel to make lines appear
	addne	py,	#1
	bne	loop_x_line
	beq	done

done:
	.unreq	px
	.unreq	py
	.unreq	sizex
	.unreq	sizey
	.unreq	color
	pop {r4,r5,r6,r7,r8,r9,r10, pc}
	
.globl DrawPixelbpp
DrawPixelbpp:
	push	{r4}

	startingpoint	.req	r4
	ldr		r0,		=FrameBufferPointer
	ldr		r0,		[r0]

	// startingpoint = (y * 1024) + x = x + (y << 10)
	add		startingpoint,	r1, r2, lsl #10
	// startingpoint *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		startingpoint, #1

	// store the colour (half word) at framebuffer pointer + offset
	strh	r3,		[r0, startingpoint]

	pop		{r4}
	bx		lr



