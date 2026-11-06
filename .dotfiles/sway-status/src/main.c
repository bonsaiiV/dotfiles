#include <stdio.h>
#include <unistd.h>

#include "modules.h"

module modules[4];
int (*modules_init[4]) (module *) = {init_battery, init_time, init_idle_inhibit, NULL};

int main(void) {
	setlinebuf(stdout);
	int (**init_it) (module *) = modules_init;
	module *mod_it;
	mod_it = modules;
	while (*init_it) {
		if ((*init_it)(mod_it)) {
			mod_it++;
		}
		init_it++;
	}
	*mod_it = (module) {NULL, NULL, NULL};

	printf("{");
	printf("\t\"version\": 1");
	//printf(",\"click_events\": true\n");
	printf("}\n[\n");
	//fflush(stdout);
	while (1) {
		mod_it = modules;
		printf("\t[\n");
		while (mod_it->print) {
			//fprintf(stderr, "name: %s, print_fn: %p\n", mod_it->name, mod_it->print);
			mod_it->print();
			mod_it++;
		}

		printf("\t],\n");
		//fflush(stdout);
		sleep(1);
	}
}
