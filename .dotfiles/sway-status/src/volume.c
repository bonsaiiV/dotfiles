#include <wp/wp.h>
#include <stdio.h>

#include "modules.h"

void print_volume(void) {
	printf("{");
	printf("\"full_text\": \"%s\"", "tmp");
	printf(",\"background\": \"#337733\"");
	printf("},\n");
}

int init_volume(module *ret) {
	wp_init(0);
	*ret = (module) {
		.name = strdup("volume"),
		.print = print_volume,
		.on_click = 0,
	};
	return 1;
}
