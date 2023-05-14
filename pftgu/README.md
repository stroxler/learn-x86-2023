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

The main datatypes in x86 32-bit are:
- .byte: 8 bytes (maybe an 8 bit integer)
- .int: 16 bit integer
- .long: 32 bit integer
- .ascii: entering byte arrays as C-strings (e.g. `.ascii "Hello\0"`. Note the \0 does appear!)

Comparisons (or rather the conditiion instructions that go after them) are
generally written in a backward order in x86 relative to any normal language,
e.g. the "le" condition is met when the *right* side is <= the *left* side.
