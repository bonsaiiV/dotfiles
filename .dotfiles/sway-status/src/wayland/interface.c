#include <assert.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <my_lib/data/list.h>

#include "wayland.h"

wl_id next_wl_id = 1;

struct obj_ids wl_state;

int handle_request(char ** msg, unsigned long * msg_len) {
	assert(msg_len != NULL);
	assert(*msg_len >= 8);
	assert(msg != NULL);
	wl_header header = *(*(wl_header **) (msg))++;
	if (*msg_len < header.msg_size) {
		fprintf(stderr, "msg size, that is specified in msg header, is too large for actual message (specified: %d, actual: %ld)\n", header.msg_size, *msg_len);
		exit(1);
	}
	char * body = *msg;
	unsigned long body_len = header.msg_size - sizeof(wl_header);
	*msg += body_len;
	*msg_len -= header.msg_size;
	struct wl_object called_object;
	if (list_get(objects, header.object_id, &called_object)) {
		return called_object.request_handler(header, body, body_len);
	} else {
		printf("unknown id: %u\n", header.object_id);
	}
	return 0;
}


int wl_display_get_registry(void) {
	struct {
		wl_header header;
		wl_id id;
	} msg = {
		.header = {
			.object_id = 1,
			.opcode = 1,
			.msg_size = sizeof(msg),
		},
		.id = next_wl_id,
	};

	printf("sending create registry\n");
	if (sizeof(msg) != my_send(&msg, sizeof(msg))) {
		perror("failed to send \"create registry\"");
		return -1;
	}
	wl_state.wl_registry = next_wl_id++;

	add_wl_object("wl_registry", handle_wl_registry_request);

	return 0;
}//*/

int handle_wl_display_request(wl_header header, char * body_data, size_t body_len) {
	if (header.opcode == wayland_wl_display_event_error_opcode) {
		assert(sizeof(wl_display_error_event) <= body_len);
		wl_display_error_event * ev_body = (void *) body_data;
		fprintf(stderr, "fatal error: target_object_id=%u code=%u error=%s()\n", ev_body->object_id, ev_body->code, ev_body->error);
		return 1;
	} else {
		printf("unhandled display event: opcode %u\n", header.opcode);
	}
	return 0;
}

int setup_wayland(void) {
	init_wl_object_list();
	if (wayland_display_connect()) {
		exit(1);
	}
	wl_state.wl_display = next_wl_id++;
	add_wl_object("wl_display", handle_wl_display_request);

	if (wl_display_get_registry()) {
		exit(1);
	}
	wl_state.wl_registry = next_wl_id++;
	add_wl_object("wl_display", handle_wl_registry_request);

	return 0;
}
