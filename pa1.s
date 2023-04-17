.section .data

input_prompt	:   .asciz  "Input a string: "
input_spec	:   .asciz  "%[^\n]"
length_spec	:   .asciz  "String length: %d\n"
palindrome_spec	:   .asciz  "String is a palindrome (T/F): %c\n"

input_str	:   .space 7

.section .text

.global main

# program execution begins here
main:

	ldr x0, =input_prompt
	bl printf

	ldr x0, =input_spec
	ldr x1, =input_str
	bl scanf
	
	ldr x0, =length_spec
	ldr x9, =input_str
	bl length
	ldr x0, =length_spec
	bl printf

	ldr x2, =palindrome_spec
	ldr x9, =input_str
	ldr x10, =input_str
	ldr x11, =input_str
	bl palindrome
	finish:

	mov x0, x1
	ldr x0, =palindrome_spec
	bl printf
	b exit
	
	
# function to calculate length of input string
length: 
	mov x1, #-1
	# loop increments on each pass, breaks if end of string
	length_loop:
		add x1, x1, #1
		ldr x3, [x9], #1
		cmp x3, #0
		bne length_loop
	mov x0, x1
	ret

is_pali: 
	mov x1, #'T'
	bl finish

not_pali:
	mov x1, #'F'
	bl finish

palindrome: 
	#using length to cmp front and back until middle of string
	
	mov x0, #1
	bl length
	ldrb w3, [x10], #1
	add x11, x11, x0
	sub x11, x11, #1
	ldrb w4, [x11]
	cmp w3, #0
	beq is_pali
	cmp w3, w4
	bne not_pali
	
	check_pali:
		ldrb w3, [x10], #1
		sub x11, x11, #1
		ldrb w4, [x11]
		cmp w3, #0
		beq is_pali
		cmp w3, w4
		beq check_pali
		bl not_pali
	
	ret
	

# branch to this label on program completion
exit:

    mov x0, 0
    mov x8, 93
    svc 0
    ret