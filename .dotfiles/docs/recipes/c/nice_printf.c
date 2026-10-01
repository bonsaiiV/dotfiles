#include<stdio.h>

/*
 * The replacement string to the left in the formatting of printf
 * for example: %5d causes the decimal number to be padded to be 5 wide
 */

int main(void) {
	unsigned int val = 1;
	printf("| %3s | %5s |\n", "i", "4^i");
	printf("| --- | ----- |\n");
	for (unsigned int i = 0; i <= 6; i++) {
		printf("| %3d | %5d |\n", i, val);
		val *= 4;
	}
	/*
	 * Values, that are too long are not shortened.
	 * The entire representation is always printed
	 */
	printf("| %3s | %5d |\n", "test", 100000);
}
