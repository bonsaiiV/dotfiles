#include <wp/wp.h>
#include <stdio.h>

#include "modules.h"

void print_volume(void) {
	printf("{");
	printf("\"full_text\": \"%s\"", "tmp");
	printf(",\"background\": \"#337733\"");
	printf("},\n");
}

struct module init_volume(void) {
	wp_init(0);
	struct module mod = {
		.name = strdup("volume"),
		.print = print_volume,
		.on_click = 0,
	};
	return mod;
}
