#!/usr/bin/env sh

set -e
echo "Assembling..."
as --32 b-factorial.s -o b-factorial.o
echo "Linking..."
ld -melf_i386 b-factorial.o -o b-factorial.exe
set +e

echo "Running..."
./b-factorial.exe
echo "Exited $?"
