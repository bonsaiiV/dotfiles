#include <wp/wp.h>
#include <stdio.h>

#include "init_functions.h"

void print_volume(void) {
	printf("{");
	printf("\"full_text\": \"%s\"", "tmp");
	printf(",\"background\": \"#337733\"");
	printf("},\n");
}

print_fun init_volume(void) {
	wp_init(0);
	return print_volume;
}
