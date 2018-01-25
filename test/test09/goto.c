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

/* Validate that call statements behave correctly */
int putchar(int);
void exit(int);

void printstring(char* s)
{
	while(0 != s[0])
	{
		putchar(s[0]);
		s = s + 1;
	}
}

int main()
{
	goto win;
	exit(1);

mes:
	printstring("Hello mes\x0A");
	goto done;

win:
	goto mes;
	exit(2);

done:
	return 42;
}
