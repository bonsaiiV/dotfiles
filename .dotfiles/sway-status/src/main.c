#include <stdio.h>
#include <unistd.h>
#include <time.h>
#include <stdlib.h>
#include <fcntl.h>

time_t currentTime;
struct tm * currentTime_local;
char date_fulltext[100];

typedef struct {
	void (*init) (void);
	void (*print) (void);
	void (*cleanup) (void);
} module;

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

int charge_fd;
char * battery_fulltext;
size_t len_battery_fulltext = 5;
char * file_buf;
size_t len_charge_file_buf = 10;
size_t charge_full;

void init_battery(void) {
	battery_fulltext = calloc(len_battery_fulltext, sizeof(char));
	file_buf = calloc(len_charge_file_buf, sizeof(char));
	charge_fd = open("/sys/class/power_supply/BAT1/charge_full", O_NONBLOCK, O_RDONLY);
	if (read(charge_fd, file_buf, len_charge_file_buf-1) <= 0) exit(1);
	close(charge_fd);
	charge_full = atoi(file_buf);
	charge_fd = open("/sys/class/power_supply/BAT1/charge_now", O_NONBLOCK, O_RDONLY);
}

void cleanup_battery(void) {
	close(charge_fd);
	free(battery_fulltext);
	free(file_buf);
}

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

module mod_battery = {init_battery, print_battery, cleanup_battery};

module alle_module[] = {
	{init_battery, print_battery, cleanup_battery},
	{noop, print_time, noop},
	{0, 0, 0}
};

int main(void) {
	setlinebuf(stdout);
	module * mod_it = alle_module;
	while (mod_it->init) {
		mod_it->init();
		mod_it++;
	}

	printf("{\"version\": 1}\n");
	printf("[\n");
	//fflush(stdout);
	while (1) {
		mod_it = alle_module;
		printf("[\n");
		while (mod_it->print) {
			mod_it->print();
			mod_it++;
		}

		//print_time();

		printf("],\n");
		//fflush(stdout);
		sleep(1);
	}
	mod_it = alle_module;
	while (mod_it->cleanup) {
		mod_it->cleanup();
		mod_it++;
	}
}
