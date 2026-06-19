typedef void (*print_fun) (void);
typedef void (*click_fun) (void * data);

struct module {
	char * name;
	print_fun print;
	click_fun on_click;
};

struct module init_battery(void);
struct module init_time(void);
struct module init_volume(void);
struct module init_idle_inhibit(void);
