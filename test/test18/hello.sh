#! /bin/sh
set -ex
# Build the test
bin/M2-Planet -f functions/file.c \
	-f functions/malloc.c \
	-f functions/calloc.c \
	-f test/test18/math.c \
	-o test/test18/math.M1 || exit 1

# Macro assemble with libc written in M1-Macro
M1 -f test/common_x86/x86_defs.M1 \
	-f functions/libc-core.M1 \
	-f test/test18/math.M1 \
	--LittleEndian \
	--Architecture 1 \
	-o test/test18/math.hex2 || exit 2

# Resolve all linkages
hex2 -f test/common_x86/ELF-i386.hex2 -f test/test18/math.hex2 --LittleEndian --Architecture 1 --BaseAddress 0x8048000 -o test/results/test18-binary --exec_enable || exit 3

# Ensure binary works if host machine supports test
if [ "$(get_machine)" = "x86_64" ]
then
	# Verify that the resulting file works
	./test/results/test18-binary >| test/test18/proof || exit 4
	out=$(sha256sum -c test/test18/proof.answer)
	[ "$out" = "test/test18/proof: OK" ] || exit 5
fi
exit 0
