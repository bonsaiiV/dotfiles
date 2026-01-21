#include <stdio.h>
#include <unistd.h>

#include "init_functions.h"

void (*modules_print[3]) (void) = {NULL, NULL, NULL};
print_fun (*modules_init[3]) (void) = {init_battery, init_time, NULL};

int main(void) {
	setlinebuf(stdout);
	print_fun (**init_it) (void) = modules_init;
	void (**print_it) (void);
	print_it = modules_print;
	while (*init_it) {
		*print_it = (*init_it)();
		if (*print_it) print_it++;
		init_it++;
	}

	printf("{\"version\": 1}\n");
	printf("[\n");
	//fflush(stdout);
	while (1) {
		print_it = modules_print;
		printf("[\n");
		while (*print_it) {
			(*print_it)();
			print_it++;
		}

		//print_time();

		printf("],\n");
		//fflush(stdout);
		sleep(1);
	}
	/*mod_it = all_modules;
	while (mod_it->cleanup) {
		mod_it->cleanup();
		mod_it++;
	}//*/
}
