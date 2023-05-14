#!/usr/bin/env sh

set -e
echo "Assembling..."
as 02-loop.s -o 02-loop.o
echo "Linking..."
ld 02-loop.o -o 02-loop.exe
set +e

echo "Running..."
./02-loop.exe
echo "Exited $?"
