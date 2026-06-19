#include <stdio.h>
#include <string.h>

#include "modules.h"

void print_idle_inhibit(void) {
	printf("{");
	printf("\"full_text\": \"idle_inhibit\"");
	printf(",\"background\": \"#323232\"");
	printf(",\"border\": \"#323232\"");
	printf(",\"border_left\": 10");
	printf(",\"separator\": false");
	printf(",\"separator_block_width\": 0");
	printf("},\n");
}

void on_click_idle_inhibit(void * data) {
	(void) data;
	return;
}

struct module init_idle_inhibit(void) {
	struct module mod = {
		.name = strdup("idle_inhibit"),
		.print = print_idle_inhibit,
		.on_click = on_click_idle_inhibit,
	};
	return mod;
}
