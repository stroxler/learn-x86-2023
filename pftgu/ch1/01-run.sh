#!/usr/bin/env sh

set -e
echo "Assembling..."
as 01-exit.s -o 01-exit.o
echo "Linking..."
ld 01-exit.o -o 01-exit.exe
set +e

echo "Running..."
./01-exit.exe
echo "Exited $?"
