/* Copyright (C) 2016 Jeremiah Orians
 * This file is part of stage0.
 *
 * stage0 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * stage0 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with stage0.  If not, see <http://www.gnu.org/licenses/>.
 */

/* Ensure that C library calls function correctly */

#include <stdio.h>
int putchar(int);
void exit(int);

int main()
{
	putchar(72);
	putchar(101);
	putchar(108);
	putchar(108);
	putchar(111);
	putchar(32);
	putchar(109);
	putchar(101);
	putchar(115);
	putchar(10);
	exit(42);
	return 1;
}