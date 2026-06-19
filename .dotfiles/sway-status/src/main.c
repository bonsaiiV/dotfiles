#include <stdio.h>
#include <unistd.h>

#include "modules.h"

struct module modules[4];
struct module (*modules_init[4]) (void) = {init_battery, init_time, init_idle_inhibit, NULL};

int main(void) {
	setlinebuf(stdout);
	struct module (**init_it) (void) = modules_init;
	struct module *mod_it;
	mod_it = modules;
	while (*init_it) {
		*mod_it = (*init_it)();
		if (mod_it) mod_it++;
		init_it++;
	}

	printf("{\n");
	printf("\"version\": 1,\n");
	printf("\"click_events\": true\n");
	printf("}[\n");
	//fflush(stdout);
	while (1) {
		mod_it = modules;
		printf("[\n");
		while (mod_it) {
			(*mod_it).print();
			mod_it++;
		}

		//print_time();

		printf("],\n");
		//fflush(stdout);
		sleep(1);
	}
}
