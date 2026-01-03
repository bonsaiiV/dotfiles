#include <stdio.h>
#include <unistd.h>
#include <time.h>
#include <stdlib.h>
#include <fcntl.h>

time_t currentTime;
struct tm * currentTime_local;
char date_fulltext[100];

/*typedef struct {
	void (*init) (void);
	void (*print) (void);
	void (*cleanup) (void);
} module;//*/

void noop(void) {}

void print_time(void) {
	time(&currentTime);
	currentTime_local = localtime(&currentTime);
	strftime(date_fulltext, sizeof(date_fulltext), "%Y-%m-%d %H:%M:%S", currentTime_local);
	printf("{");
	printf("\"full_text\": \"%s\"", date_fulltext);
	printf(",\"background\": \"#337733\"");
	printf("},\n");
}

void init_time(void (**module_print) (void)) {
	*module_print = print_time;
}

int charge_fd;
char * battery_fulltext;
size_t len_battery_fulltext = 5;
char * file_buf;
size_t len_charge_file_buf = 10;
size_t charge_full;

void print_battery(void) {
	lseek(charge_fd, 0, SEEK_SET);
	if (read(charge_fd, file_buf, len_charge_file_buf-1) <= 0) {
		exit(1);
	}
	snprintf(battery_fulltext, len_battery_fulltext, "%ld%%", 100 * atoi(file_buf)/charge_full);
	printf("{");
	printf("\"full_text\": \"%s\"", battery_fulltext);
	printf(",\"border\": \"#55cc55\"");
	printf("},\n");
}

void init_battery(void (**module_print) (void)) {
	battery_fulltext = calloc(len_battery_fulltext, sizeof(char));
	file_buf = calloc(len_charge_file_buf, sizeof(char));
	charge_fd = open("/sys/class/power_supply/BAT1/charge_full", O_NONBLOCK, O_RDONLY);
	if (charge_fd == -1) goto cleanup;
	if (read(charge_fd, file_buf, len_charge_file_buf-1) <= 0) {
		close(charge_fd);
		goto cleanup;
	}
	close(charge_fd);
	charge_full = atoi(file_buf);
	charge_fd = open("/sys/class/power_supply/BAT1/charge_now", O_NONBLOCK, O_RDONLY);
	if (charge_fd == -1) {
		goto cleanup;
	} else {
		*module_print = print_battery;
		return;
	}
cleanup:
	fprintf(stderr, "failed to initialize battery module, continuing without\n");
	free(battery_fulltext);
	free(file_buf);
}

void cleanup_battery(void) {
	close(charge_fd);
	free(battery_fulltext);
	free(file_buf);
}


/*module mod_battery = {init_battery, print_battery, cleanup_battery};

module all_modules[] = {
	{init_battery, print_battery, cleanup_battery},
	{noop, print_time, noop},
	{0, 0, 0}
};//*/

void (*modules_print[3]) (void) = {NULL, NULL, NULL};
void (*modules_init[3]) (void (**) (void)) = {init_battery, init_time, NULL};

int main(void) {
	setlinebuf(stdout);
	void (**init_it) (void (**) (void)) = modules_init;
	void (**print_it) (void);
	print_it = modules_print;
	while (*init_it) {
		(*init_it)(print_it);
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
