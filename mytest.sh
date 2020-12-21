#! /bin/sh

set -e
ARCH=$(get_machine)
COMMON=test/common_${ARCH}

bin/M2-Planet --architecture ${ARCH} -f ${COMMON}/functions/file.c \
	-f ${COMMON}/functions/malloc.c \
	-f functions/calloc.c \
	-f mytest.c \
	-o mytest.M1 || exit 1

M1 -f ${COMMON}/${ARCH}_defs.M1 \
	-f ${COMMON}/libc-core.M1 \
	-f mytest.M1 \
	--LittleEndian \
	--architecture ${ARCH} \
	-o mytest.hex2 || exit 2

hex2 -f ${COMMON}/ELF-${ARCH}.hex2 -f mytest.hex2 --LittleEndian --architecture ${ARCH} --BaseAddress 0x00600000 -o mytest-${ARCH}-binary --exec_enable || exit 3

./mytest-${ARCH}-binary
