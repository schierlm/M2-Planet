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

set -x
# Build the test
bin/M2-Planet --architecture armv7l \
	-f test/common_armv7l/functions/chdir.c \
	-f test/common_armv7l/functions/malloc.c \
	-f test/common_armv7l/functions/getcwd.c \
	-f test/common_armv7l/functions/exit.c \
	-f test/common_armv7l/functions/file.c \
	-f functions/calloc.c \
	-f functions/string.c \
	-f functions/match.c \
	-f functions/file_print.c \
	-f test/test0021/chdir.c \
	--debug \
	-o test/test0021/chdir.M1 || exit 1

# Build debug footer
blood-elf -f test/test0021/chdir.M1 \
	--entry _start \
	-o test/test0021/chdir-footer.M1 || exit 2

# Macro assemble with libc written in M1-Macro
M1 -f test/common_armv7l/armv7l_defs.M1 \
	-f test/common_armv7l/libc-core.M1 \
	-f test/test0021/chdir.M1 \
	-f test/test0021/chdir-footer.M1 \
	--LittleEndian \
	--architecture armv7l \
	-o test/test0021/chdir.hex2 || exit 3

# Resolve all linkages
hex2 -f test/common_armv7l/ELF-armv7l-debug.hex2 \
	-f test/test0021/chdir.hex2 \
	--LittleEndian \
	--architecture armv7l \
	--BaseAddress 0x10000 \
	-o test/results/test0021-armv7l-binary \
	--exec_enable || exit 4

# Ensure binary works if host machine supports test
if [ "$(get_machine ${GET_MACHINE_FLAGS})" = "armv7l" ]
then
	. ./sha256.sh
	# Verify that the resulting file works
	./test/results/test0021-armv7l-binary
	[ 0 = $? ] || exit 5
fi
exit 0
