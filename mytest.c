#include<stdlib.h>
#include<stdio.h>
#include<string.h>

void write_string(char* s, FILE* f)
{
	while(0 != s[0])
	{
		fputc(s[0], f);
		s = s + 1;
	}
}

void* empty = 0;

int main()
{
	if (0 == empty) {
		write_string("Yes, is empty\n", stdout);
	} else {
		write_string("Oops, why not?\n", stdout);
	}
	return 0;
}
