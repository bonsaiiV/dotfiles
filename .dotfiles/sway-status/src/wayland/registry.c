#include <assert.h>
#include <mylib/data/list.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "wayland.h"

struct list * objects;

wl_id next_wl_id = 0;

int unhandled_object_request(wl_header header, char *body, uint64_t body_len) {
	(void) body;
	(void) body_len;
	struct wl_object called_obj;
	list_get(objects, header.object_id, &called_obj);
	printf("unhandled request on: \"%s\", opcode: %u\n", called_obj.name, header.opcode);
	return 0;
}

void init_wl_object_list() {
	objects = list_create(sizeof(struct wl_object));
	struct wl_object new_wl_obj = {
		strdup("0"),
		unhandled_object_request,
	};
	list_push(objects, &new_wl_obj);
	next_wl_id = 1;
}

void add_wl_object(const char *name, request_handler_fn request_handler) {
	struct wl_object new_wl_obj = {
		strdup(name),
		request_handler,
	};
	list_push(objects, &new_wl_obj);
}

wl_id wayland_wl_registry_bind(wl_new_id * new_id) {
	uint64_t msg_size = wire_size_header() + wire_size_new_id(new_id) + wire_size_uint();
	char * buf, msg[msg_size];
	wl_header header = {
		.object_id = wl_state.wl_registry,
		.opcode = wayland_wl_registry_request_bind_opcode,
		.msg_size = msg_size,
	};
	buf = msg;
	buf = write_header(buf, &header);
	buf = write_new_id(buf, new_id);
	buf = write_uint(buf, next_wl_id);
	printf("sending bind a global (%s) <<%u, %u, %u>, <%u := %u>>\n", new_id->interface.data, header.object_id, header.opcode, header.msg_size, new_id->name, next_wl_id);
	if ((int64_t) msg_size != my_send(msg, msg_size)) {
		perror("failed to send \"bind to registry\"");
		return 0;
	}
	return next_wl_id++;
}

int handle_wl_registry_request(wl_header header, char * body, size_t body_len) {
	if (header.opcode == wayland_wl_registry_event_global_opcode) {
		/*for (int i = 0; i < body_len; i++) {
			printf("%0hhx ", ((char *) body)[i]);
		}
		printf("\n");//*/
		char tmp[body_len];
		wl_new_id * new_id = (wl_new_id *) tmp;
		read_new_id(body, new_id);
		assert(new_id->interface.data[new_id->interface.len - 1] == 0);
		printf("<- wl_registry@%u.global: name=%u interface=%.*s version=%u\n", wl_state.wl_registry, new_id->name, new_id->interface.len, new_id->interface.data, new_id->version);

		if (!strcmp("zwp_idle_inhibit_manager_v1", new_id->interface.data)) {
			if (!(wl_state.idle_inhibit_manager = wayland_wl_registry_bind(new_id))) {
				return -1;
			}
			add_wl_object(new_id->interface.data, unhandled_object_request);
		} else {
			return 0;
		}
	}
	return 0;
}
