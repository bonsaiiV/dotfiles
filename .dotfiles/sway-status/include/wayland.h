#include <sys/socket.h>
#include <stdint.h>


/***********************************
 *
 *         interface functions
 *
 ***********************************/

int setup_wayland(void);

/***********************************
 *
 *         wayland protocol
 *
 ***********************************/
#define wayland_wl_display_event_error_opcode 0
#define wayland_wl_display_request_get_registry_opcode 1


#define wayland_wl_registry_event_global_opcode 0
#define wayland_wl_registry_request_bind_opcode 0

/***********************************
 *
 *         data types
 *
 ***********************************/

typedef uint32_t wl_id;

typedef struct wl_string {
	uint32_t len;
	char data[];
} wl_string;

typedef struct wl_new_id {
	uint32_t name;
	uint32_t version;
	wl_string interface;
} wl_new_id;

typedef struct wl_display_error_event {
	uint32_t object_id;
	uint32_t code;
	uint32_t error_len;
	char error[];
} wl_display_error_event;

typedef struct {
	wl_id object_id;
	uint16_t opcode;
	uint16_t msg_size;
} wl_header;

typedef int (*request_handler_fn) (wl_header header, char *body, uint64_t body_len);

struct wl_object {
	char *name;
	request_handler_fn request_handler;
};

struct obj_ids {
	wl_id wl_display;
	wl_id wl_registry;
	wl_id idle_inhibit_manager;
	wl_id idle_inhibitor;
};

extern struct obj_ids wl_state;

struct list * objects;

/***********************************
 *
 *         socket functions
 *
 ***********************************/

uint64_t wire_size_uint();
char * write_uint(char * buf, uint32_t uint);
char * read_uint(char * buf, uint32_t * uint);

uint64_t wire_size_header();
char * write_header(char * buf, wl_header * header);
void print_header(wl_header * header);

uint64_t wire_size_string(wl_string * string);
char * write_string(char * buf, wl_string * string);
char * read_string(char * buf, wl_string * ret);

uint64_t wire_size_new_id(wl_new_id * new_id);
char * write_new_id(char * buf, wl_new_id * new_id);
char * read_new_id(char * buf, wl_new_id * ret);


int wayland_display_connect();
int64_t my_send(void * msg, uint64_t size);
int send_socket_msg(struct msghdr * socket_msg);
int64_t my_recv(void * msg, uint64_t size, int flags);

/***********************************
 *
 *         registry functions
 *
 ***********************************/

void init_wl_object_list();
void add_wl_object(const char *name, request_handler_fn request_handler);
int handle_wl_registry_request(wl_header header, char * body, size_t body_len);
