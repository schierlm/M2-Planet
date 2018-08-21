#! /bin/sh
set -x
# Build the test
bin/M2-Planet -f functions/putchar.c \
	-f functions/exit.c \
	-f functions/malloc.c \
	-f test/test20/struct.c \
	-o test/test20/struct.M1 || exit 1

# Macro assemble with libc written in M1-Macro
M1 -f test/common_x86/x86_defs.M1 \
	-f functions/libc-core.M1 \
	-f test/test20/struct.M1 \
	--LittleEndian \
	--Architecture 1 \
	-o test/test20/struct.hex2 || exit 2

# Resolve all linkages
hex2 -f test/common_x86/ELF-i386.hex2 -f test/test20/struct.hex2 --LittleEndian --Architecture 1 --BaseAddress 0x8048000 -o test/results/test20-binary --exec_enable || exit 3

# Ensure binary works if host machine supports test
if [ "$(get_machine)" = "x86_64" ]
then
	# Verify that the compiled program returns the correct result
	out=$(./test/results/test20-binary 2>&1 )
	[ 20 = $? ] || exit 4
	[ "$out" = "35419896642975313541989657891634" ] || exit 5
fi
exit 0
