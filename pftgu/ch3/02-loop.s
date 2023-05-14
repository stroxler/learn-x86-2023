# Simple example x86 program to find the max entry in an array.
#
# During our loop:
# - %edi stores the current index into the array
# - %eax holds the current array value (which needs to be in a register)
# - %ebx holds the running max so far


# Static data. In our case we have an array `myarray` of i32 values
.section .data

# len(myarray) == 8, the final value 0 is a marker for end of list
myarray:
.long 3,67,34,222,45,75,34,44,0

# Text: this section isn't needed for our program
.section .text

.globl _start
_start: 

# Move the first entry of the array to %eax, and a running max to %ebx
movl $0, %edi
movl myarray(,%edi,4), %eax
movl %eax, %ebx

start_loop:

# Check if we've reached the end of the array; remember 0 marks end of array.
# - We use cmpl because these are "long" (i32) values
# - cmpl returns LE 
cmpl $0, %eax
je loop_exit

# Otherwise, bump the index (incl increments an i32)
incl %edi
movl myarray(,%edi,4), %eax

# Now compare, and either continue the loop or bump our running max.
#
# Note that jle is backward relative to how assembly is written! It jumps if the
# *second* register has a value <= the *first*. Eww.
cmpl %ebx, %eax
jle start_loop
movl %eax, %ebx
jmp start_loop

# When the loop finishes, %ebx has our running max. Recall that
# sys exit is an interrupt with the syscall for exit (1) in %eax and the
# exit code in %ebx.
loop_exit:
movl $1, %eax
int $0x80
