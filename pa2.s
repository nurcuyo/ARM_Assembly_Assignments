.section .data

input_x_prompt	:	.asciz	"Please enter x: "
input_y_prompt	:	.asciz	"Please enter y: "
input_spec	:	.asciz	"%d"
result		:	.asciz	"x^y = %d\n"

.section .text

.global main

main:

	ldr x0, =input_x_prompt
	bl printf
	bl input
	mov x19, x0
	
	ldr x0, =input_y_prompt
	bl printf
	bl input
	mov x20, x0

	mov x0, x19
	mov x1, x20
	mov x2, #1

	sub sp, sp, 8
	str x30, [sp]
	sub sp, sp, 8
	str x2, [sp]
	sub sp, sp, 8
	str x1, [sp]
	sub sp, sp, 8
	str x0, [sp]
	
	bl power
	continue:
	mov x1, x2
	mov x0, x1
	ldr x0, =result
	bl printf
	b exit
	
input: 
	sub sp, sp, 8
	str x30, [sp]
	ldr x0, =input_spec
	sub sp, sp, 8
	mov x1, sp
	bl scanf
	
	ldrsw x0, [sp]	
	ldr x30, [sp, 8]
	add sp, sp, 16
	ret

power:

	ldrsw x0, [sp]
	add sp, sp, 8
	ldrsw x1, [sp]
	add sp, sp, 8
	ldrsw x2, [sp]
	add sp, sp, 8
	ldr x30, [sp]
	add sp, sp, 8

	cmp x0, #0
	beq zero_base

	cmp x1, #0
	blt neg_exp
	beq zero_exp

	mul x2, x2, x0
	sub x1, x1, #1
	
	sub sp, sp, 8
	str x30, [sp]
	sub sp, sp, 8
	str x2, [sp]
	sub sp, sp, 8
	str x1, [sp]
	sub sp, sp, 8
	str x0, [sp]

	bl power	

	zero_base:
		mov x2, #0
		bl continue
	neg_exp:
		mov x2, #0
		bl continue
	zero_exp:
		bl continue
	ret

# branch to this label on program completion
exit:
	mov x0, 0
	mov x8, 93
	svc 0
	ret
