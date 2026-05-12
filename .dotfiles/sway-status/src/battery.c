#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>

#include "init_functions.h"

int charge_fd;
char * battery_fulltext;
size_t len_battery_fulltext = 5;
char * file_buf;
size_t len_charge_file_buf = 10;
size_t charge_full = 100;

void print_battery(void) {
	lseek(charge_fd, 0, SEEK_SET);
	if (read(charge_fd, file_buf, len_charge_file_buf-1) <= 0) {
		exit(1);
	}
	snprintf(battery_fulltext, len_battery_fulltext, "%ld%%", 100 * atoi(file_buf)/charge_full);
	printf("{");
	printf("\"full_text\": \"%s\"", battery_fulltext);
	printf(",\"background\": \"#323232\"");
	printf(",\"border\": \"#323232\"");
	printf(",\"separator\": false");
	printf(",\"separator_block_width\": 0");
	printf("},\n");
}

print_fun init_battery(void) {
	battery_fulltext = calloc(len_battery_fulltext, sizeof(char));
	file_buf = calloc(len_charge_file_buf, sizeof(char));
	struct dirent *dp;
	DIR * power_supply_dir = opendir("/sys/class/power_supply");
	char * bat_name = 0;
	while ((dp = readdir(power_supply_dir)) != NULL) {
		if (strncmp(dp->d_name, "BAT", 3) == 0) {
			bat_name = dp->d_name;
			break;
		}
	}
	closedir(power_supply_dir);
	if (!bat_name) {
		return	0;
	}

	// charge_full is the maximal length
	size_t max_filepath_len = snprintf(0, 0, "/sys/class/power_supply/%s/charge_full", bat_name) + 1;

	char * filepath = calloc(max_filepath_len, sizeof(char));

	if (snprintf(filepath, max_filepath_len, "/sys/class/power_supply/%s/capacity", bat_name) < 0) {
		free(filepath);
		return 0;
	}

	charge_fd = open(filepath, O_NONBLOCK, O_RDONLY);
	if (charge_fd != -1) {
		// succes
		charge_full = 100;
		return print_battery;
	}

	if (snprintf(filepath, max_filepath_len, "/sys/class/power_supply/%s/charge_full", bat_name) < 0) {
		free(filepath);
		return 0;
	}


	charge_fd = open(filepath, O_NONBLOCK, O_RDONLY);
	if (charge_fd == -1) goto cleanup;
	if (read(charge_fd, file_buf, len_charge_file_buf-1) <= 0) {
		close(charge_fd);
		goto cleanup;
	}
	close(charge_fd);
	charge_full = atoi(file_buf);
	charge_fd = open(filepath, O_NONBLOCK, O_RDONLY);
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
