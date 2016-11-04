.section .text
.globl DrawFont

// r10/r1 = y 
// r9/r0 = x

DrawFont:
	push	{r4,r5,r6,r7,r8,r9,r10, lr}

	chAdr	.req	r4
	px	.req	r5
	py	.req	r6
	row	.req	r7
	mask	.req	r8

	ldr	chAdr,	=font		// load the address of the font map
	add	chAdr,	r3, lsl #4	// char address = font base + (char * 16)
	mov	r10, 	r2		// set y to r10
	mov	py,	r10		// init the Y coordinate (pixel coordinate)
	mov	r9,	r1		
charLoop$:
	mov	px,	r9		// init the X coordinate	
	mov	mask,	#0x01		// set the bitmask to 1 in the LSB
	ldrb	row,	[chAdr], #1		// load the row byte, post increment chAdr

rowLoop$:
	tst	row,	mask		// test row byte against the bitmask
	beq	noPixel$
	mov	r1,	px		// move x-axis location to r1
	mov	r2,	py		// move y-axis location to r2
	ldr	r3,	=0x0007E000 	//F81F	
	bl	DrawPixelbpp		// draw red pixel at (px, py)

noPixel$:
	add	px,	#1		// increment x coordinate by 1
	lsl	mask,	#1		// shift bitmask left by 1

	tst	mask,	#0x100		// test if the bitmask has shifted 8 times (test 9th bit)
	beq	rowLoop$

	add	py,	#1		// increment y coordinate by 1

	tst	chAdr,	#0xF
	bne	charLoop$


	pop 	{r4,r5,r6,r7,r8,r9,r10, pc}

.section .data

.align 4
font:		.incbin	"font.bin"


