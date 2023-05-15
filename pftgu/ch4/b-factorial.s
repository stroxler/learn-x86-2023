# Example of an x86 32-bit program to compute 5! = 120 with recursion.
#
# (This is without tail call optimization, just simple recursion)

.section .data
.section .text

.globl _start

# This isn't really needed yet, but if you want to be able to
# access the function from linked code you would need to declare
# it in the .globl section (basically any non-static C function is
# a .globl).
.globl factorial


_start:

pushl $5  # argument to factorial is 4
call factorial
addl $4, %esp  # remember we have to deallocate args on caller side
movl %eax, %ebx  # move call result to %ebx so we can exit with it
# sys exit
movl $1, %eax
int $0x80

# Factorial function:
.type factorial, @function
factorial:
# standard function header: push %ebp then set it to %esp
pushl %ebp
movl %esp, %ebp
# body:
# - put the argument into %eax
# - return if arg is 1, otherwise recurse
movl 8(%ebp), %eax
cmpl $1, %eax
je end_factorial
decl %eax  # set up the...
pushl %eax  # ... recurive call
call factorial

# Use the recursive call: get our own argument back and
# multiply with the return value in %eax. Note that we skipped
# cleaning up the args here, which we can get away with because
# we're almost done, we don't need any pop instructions for the rest
# of the body, and we'll set %esp to %ebp in end_factorial. This is
# another bit of laziness that an optimizing compiler could manage.
movl 8(%ebp), %ebx
imul %ebx, %eax  # our own return value is now in %eax, ready to end!

end_factorial:
# standard function wrap up: reset esp
movl %ebp, %esp
popl %ebp
ret
