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


Some notes on addressing modes:
- Register mode just moves data between registers
- Immediate mode involves inlining a value. Most of our ch3 examples are immediate, these
  use the dollar sign. The meaning of immediate is that the value is inlined into the
  actual machine code (the term is used for bytecode vms as well, not just assembly).
- Direct addressing mode lets you use an address (a label in `.data`) *directly* as the LHS
  of a `mov*` operation. For example `movl myarray %eax` would move 4 bytes from the start
  of the `myarray` label in .data.
- Index-mode addressing syntax is most used for arrays looks like this:
  - `address_or_offset(%base_or_offset,%index,multiplier)`
  - In our loop example we use `myarray(,%edi,4)` because we are indexing from
    the start of `myarray` (so no offset is needed), using `%edi` as the index
    and using 32-bit = 4 byte
    chunks.
- Indirect address lets you just use parentheses if a register points directly to the address
  you want to load, e.g. `movl (%edx) %ecx` moves 32-bits from whatever chunk of memory is
  at an address equal to the current context of `%edx`.
  - You can prefix it with an offset, e.g. `movl 4(%edx) %ecx` will increment by 4. You'd
    want to use this (as opposed to index-style) most frequently when dealing with structs
    or with local vars that are offset against a stack frame pointer.


Recall the various register and sub-register naming conventions:
- `r..` are the 64-bit registers like `rax` (not used in this book which is 32-bit only)
- `e..` are the 32-bit sub-registers like `eax`
- `.x` are the 16-bit sub-registers like `ax`
- `.h` and `.l` are the 8-bit sub-registers of hi and lo bits, e.g. `al` and `al` for `ax`


