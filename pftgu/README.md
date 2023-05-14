# Following along with "Programming from the Ground Up"

This repo is my working code as I learn x86 programming.

If I remember correctly, the source is all 32-bit x86, so
it will be a bit dated but that's okay because:
- most of the ideas are the same (the biggest real difference
  is that 64-bit added a non-interrupt way to do syscalls, if
  I remember correctly)
- many compiler tutorials use 32-bit x86, so for my current
  purposes it might be more useful anyway

I can learn basic 64-bit from "Low Level Programming" later.

# Notes from Chapter 3

There are 7 general-purpose registers in 32-bit x86:
* %eax
* %ebx
* %ecx
* %edx
* %edi
* %esi

There are also four special-purpose registers:
* %ebp
* %esp
* %eip
* %eflags


