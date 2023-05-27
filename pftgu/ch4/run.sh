#!/usr/bin/env sh

S_FILE=$1

if [[ -z "$S_FILE" ]]; then
	echo "Expected name of file to compile"
fi

NAME="${S_FILE%.s}"

set -e
echo "Assembling ${NAME}.s ..."
as --32 "${NAME}.s" -o "${NAME}.o"
echo "Linking ${NAME}.o ..."
ld -melf_i386 "${NAME}.o" -o "${NAME}.exe"
set +e

echo "Running ./${NAME}.exe ..."
./"${NAME}.exe"
echo "Exited $?"
