# Simple example x86 program to exit with code 42.

# These sections aren't needed until our program has static data
.section .data
.section .text

# Tell the assembler to remember this label (needed for any
# labels we want to use in certain ways). The _start label is
# a special built-in for the entrypoint.
#
# By the way, `main` in C code isn't the true entrypoint, it's
# run by a system-lib provided `_start`. Here we are hand-rolling
# everything so we write _start ourselves.
.globl _start


# In 32-bit x86 syscalls are done by sending a 0x80
# interrupt signal.
#
# The syscall identifier lives in # %eax; in our case we want
# `exit` which is syscall 1.
#
# For a single-arg syscall like exit, the arg lives in %ebx
_start: 
movl $1, %eax
movl $42, %ebx
int $0x80
