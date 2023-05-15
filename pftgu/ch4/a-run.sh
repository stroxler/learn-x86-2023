#!/usr/bin/env sh

set -e
echo "Assembling..."
as --32 a-power.s -o a-power.o
echo "Linking..."
ld -melf_i386 a-power.o -o a-power.exe
set +e

echo "Running..."
./a-power.exe
echo "Exited $?"
