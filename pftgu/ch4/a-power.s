# Example x86 32-bit program to compute
# 2 ** 3 + 5 ** 2 = 33


# Notes on `call` and `ret` (which are built-in, but are really just compound
# instructions):
#
# A `call` instruction will automatically do the following:
# - push the next instruction location (return instruction)
# - jump to the label given
#
# A `ret` instruction will automatically do the following
# - pop (which should give the instruction pushed by `call`)
# - jump to to that instruction location (i.e. set %eip)
#
# Just to note: %esp always points to the next *available* spot on the stack,
# rather than the last added thing. One way to remember this is that because
# you can push different-size data (e.g. 16- vs 32- vs 64-bit), pointing at
# the last-added thing doesn't really make sense. So whenever you address
# a local, you need some (positive) offset from %esp.
#
# The %ebp register generally holds the value of %esp as of the current
# function start. It's more common to use offsets from %ebp (which will
# always be the same in a given function body, assuming your code is 
# bug-free) than %esp. In that case, arguments will have positive offsets
# because the stack "grows down" and locals will have negative offsets.
#
# Our callsite responsibilities as a user of C calling conventions are:
# - ensure args are on the stack in reverse order
# - ensure that we have saved all register values we'll need later
# - eventually remove args from the stack (they are still there
#   after the call completes - this is handy if, for example, they were
#   passed by reference).
#
# Our callee responsibilities as a user of C conventions are:
# - push %ebp at the very start of our function; this is our caller's
#   stack frame base, and if we don't store it there will be no recovery!
# - copy the old %esp to %ebp (because the stack at function start is our
#   new stack frame root)... technically you can skip this *if* the function
#   body never makes any other calls.
# - store any result in %eax
#   - this applies to any single-register result
#   - I'm unsure how it applies if we return a compound value like a struct
#     (obviously a pointer is just one register, but an actual struct isn't)
# - before returning, in this order:
#   - restore %esp to value just after we pushed %ebp via `movl %ebp, %esp`
#   - restore %ebp to the caller stack frame by popping (this also increments esp)
#
# As a rule we also generally want to allocate room for locals (by subtracting
# from esp) in the header, but that's not required - we could choose to manage
# our internal state as a stack machine using `push` and `pop` or we could
# allocate room for locals on the fly if we want to... C calling conventions
# only *require* us to do things at function boundaries.



.section .data
.section .text

.globl _start

_start:

# call power for 2 ** 3
pushl $3
pushl $2
call power
# clear out args from the stack and store result on stack
addl $8, %esp
pushl %eax
# call power for 5 ** 2
pushl $2
pushl $5
call power
# clear out args from the stack (no need to store this result b/c we're almost done)
addl $8, %esp

# retrieve the result of the first clal from the stack...
popl %ebx
# ...at this point eax and ebx contain the two `power` return values!
addl %eax, %ebx  # add them together; the result is now in ebx

# now we exit with the result using the usual eax / ebx / interrupt sequence
movl $1, %eax
int $0x80

.type power, @function
power:

# standard function header: push the current %ebp (which is the stack frame
# marker for our caller) and set %ebp to be %esp (which is this stack frame
# marker).
#
# Then, allocate room for locals (we only have one local here) which
# requires subtracting from %esp.
pushl %ebp
movl %esp, %ebp
subl $4, %esp

movl 8(%ebp), %ebx  # 1st argument (offset is 8 b/c of ebp itself) is the "base"
movl 12(%ebp), %ecx  # 2nd argument is the "exponent"

movl %ebx, -4(%ebp)  # store current result in our local

# now, loop with multiplication...
power_loop_start:
cmpl $1, %ecx
je end_power  # when exponent gets to 1, we are finished...
# ... otherwise, we multiply and decrement
movl -4(%ebp), %eax   # current local value is in eax, recall 2nd arg is in ebx
imull %ebx, %eax      # results of this will be in eax
movl %eax, -4(%ebp)     # store the result back
decl %ecx             # decrement so we'll end the loop
jmp power_loop_start

end_power:
movl -4(%ebp), %eax
movl %ebp, %esp
popl %ebp
ret


# Optimization: this code illustrates "typical" C-style frame management
# where we store a local in -4(%ebp).
#
# But we're actually not using %eax for anything else, so we could have skipped
# this and skipped all of the movl instructions associated with it by just
# keeping that value in a register the whole time.
#
# One thing an optimizing compiler should do is recognize this scenario and
# take advantage!
