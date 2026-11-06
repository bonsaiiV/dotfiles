#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/socket.h>
#include <sys/un.h>

#include "wayland.h"

int wl_socket_fd;

size_t wire_size_uint() {
	return sizeof(uint32_t);
}

char * write_uint(char * buf, uint32_t uint) {
	*(uint32_t *) buf = uint;
	return buf + sizeof(uint32_t);
}

char * read_uint(char * buf, uint32_t * ret) {
	*ret = *(uint32_t *) buf;
	buf += sizeof(uint32_t);
	return buf;
}

size_t wire_size_header() {
	return sizeof(wl_header);
}

char * write_header(char * buf, wl_header * header) {
	*(wl_header *) buf = *header;
	buf += sizeof(wl_header);
	return buf; 
}

size_t wire_size_string(wl_string * string) {
	return sizeof(wl_string) + round4(string->len);
}

char * write_string(char * buf, wl_string * string) {
	buf = write_uint(buf, string->len);
	memcpy(buf, &string->data, string->len);
	return(buf + round4(string->len));
}

char * read_string(char * buf, wl_string * ret) {
	buf = read_uint(buf, &ret->len);
	memcpy(&ret->data, buf, ret->len);
	buf += round4(ret->len);
	return buf;
}

size_t wire_size_new_id(wl_new_id * new_id) {
	return sizeof(wl_new_id) + round4(new_id->interface.len);
}

char * write_new_id(char * buf, wl_new_id * new_id) {
	buf = write_uint(buf, new_id->name);
	buf = write_string(buf, &new_id->interface);
	buf = write_uint(buf, new_id->version);
	return buf;
}

char * read_new_id(char * buf, wl_new_id * ret) {
	buf = read_uint(buf, &ret->name);
	buf = read_string(buf, &ret->interface);
	buf = read_uint(buf, &ret->version);
	return buf;
}

void print_header(wl_header * header) {
	printf("header <id: %u, opcode: %u, size: %u>\n", header->object_id, header->opcode, header->msg_size);
}

ssize_t my_send(void * msg, size_t size) {
	/*for (int i = 0; i < size; i++) {
		printf("%0hhx ", ((char *) msg)[i]);
	}
	printf("\n");//*/
	return send(wl_socket_fd, msg, size, MSG_DONTWAIT);
}

int send_socket_msg(struct msghdr * socket_msg) {
	return sendmsg(wl_socket_fd, socket_msg, 0);
}

ssize_t my_recv(void * msg, size_t size, int flags) {
	return recv(wl_socket_fd, msg, size, flags);
}

int wayland_display_connect() {
	char * xdg_runtime_dir, * wayland_display;
	size_t xdg_runtime_dir_len, wayland_display_len, socket_path_len;
	struct sockaddr_un addr;

	xdg_runtime_dir = getenv("XDG_RUNTIME_DIR");
	if (!xdg_runtime_dir) {
		fprintf(stderr, "variable \"XDG_RUNTIME_DIR\" not set\n");
		return -1;
	}
	xdg_runtime_dir_len = strlen(xdg_runtime_dir);

	wayland_display = getenv("WAYLAND_DISPLAY");

	if (!wayland_display) {
		fprintf(stderr, "variable \"WAYLAND_DISPLAY\" not set\n");
		return -1;
	}
	wayland_display_len = strlen(wayland_display);

	wl_socket_fd = socket(AF_UNIX, SOCK_STREAM, 0);
	if (wl_socket_fd == -1) {
		perror("failed to create socket");
		return -1;
	}

	memset(&addr, 0, sizeof(addr));
	addr.sun_family = AF_UNIX;
	socket_path_len = xdg_runtime_dir_len + 1 + wayland_display_len;
	if (sprintf(addr.sun_path, "%s/%s", xdg_runtime_dir, wayland_display) != socket_path_len) {
		fprintf(stderr, "path to socket is too long\n");
		return -1;
	}

	if (connect(wl_socket_fd, (const struct sockaddr *) &addr, sizeof(addr))) {
		perror("failed to connect to socket");
	}

	return 0;
}
