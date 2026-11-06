typedef void (*print_fun) (void);
typedef void (*click_fun) (void * data);

typedef struct _module {
	char * name;
	print_fun print;
	click_fun on_click;
}module;

int init_battery(module *ret);
int init_time(module *ret);
int init_volume(module *ret);
int init_idle_inhibit(module *ret);
