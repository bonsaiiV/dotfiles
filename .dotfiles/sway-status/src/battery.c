#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "init_functions.h"

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

print_fun init_battery(void) {
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
		return print_battery;
	}
cleanup:
	fprintf(stderr, "failed to initialize battery module, continuing without\n");
	free(battery_fulltext);
	free(file_buf);
	return 0;
}

void cleanup_battery(void) {
	close(charge_fd);
	free(battery_fulltext);
	free(file_buf);
}
