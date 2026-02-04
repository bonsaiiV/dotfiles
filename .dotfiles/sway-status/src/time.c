#include <stdio.h>
#include <time.h>

#include "init_functions.h"

time_t currentTime;
struct tm * currentTime_local;
char date_fulltext[100];

void print_time(void) {
	time(&currentTime);
	currentTime_local = localtime(&currentTime);
	strftime(date_fulltext, sizeof(date_fulltext), "%Y-%m-%d %H:%M:%S", currentTime_local);
	printf("{");
	printf("\"full_text\": \"%s\"", date_fulltext);
	//printf(",\"background\": \"#337733\"");
	printf(",\"background\": \"#323232\"");
	printf(",\"border\": \"#323232\"");
	printf(",\"border_left\": 10");
	printf(",\"separator\": false");
	printf(",\"separator_block_width\": 0");
	printf("},\n");
}

print_fun init_time(void) {
	return print_time;
}
