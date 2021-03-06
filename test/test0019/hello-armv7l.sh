#! /bin/sh
## Copyright (C) 2017 Jeremiah Orians
## This file is part of M2-Planet.
##
## M2-Planet is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## M2-Planet is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with M2-Planet.  If not, see <http://www.gnu.org/licenses/>.

set -ex
# Build the test
bin/M2-Planet --architecture armv7l -f test/common_armv7l/functions/file.c \
	-f test/common_armv7l/functions/malloc.c \
	-f functions/calloc.c \
	-f test/common_armv7l/functions/exit.c \
	-f functions/match.c \
	-f functions/in_set.c \
	-f functions/numerate_number.c \
	-f functions/file_print.c \
	-f test/test0019/getopt.c \
	-o test/test0019/getopt.M1 || exit 1

# Macro assemble with libc written in M1-Macro
M1 -f test/common_armv7l/armv7l_defs.M1 \
	-f test/common_armv7l/libc-core.M1 \
	-f test/test0019/getopt.M1 \
	--LittleEndian \
	--architecture armv7l \
	-o test/test0019/getopt.hex2 || exit 2

# Resolve all linkages
hex2 -f test/common_armv7l/ELF-armv7l.hex2 -f test/test0019/getopt.hex2 --LittleEndian --architecture armv7l --BaseAddress 0x10000 -o test/results/test0019-armv7l-binary --exec_enable || exit 3

# Ensure binary works if host machine supports test
if [ "$(get_machine ${GET_MACHINE_FLAGS})" = "armv7l" ]
then
	. ./sha256.sh
	# Verify that the resulting file works
	./test/results/test0019-armv7l-binary -f test/test0019/input -o test/test0019/proof || exit 4
	out=$(sha256_check test/test0019/proof.answer)
	[ "$out" = "test/test0019/proof: OK" ] || exit 5
fi
exit 0
