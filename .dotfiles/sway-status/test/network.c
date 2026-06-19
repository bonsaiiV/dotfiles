#include "nm-dbus-interface.h"
#include <glib.h>
#include <NetworkManager.h>
#include <unistd.h>
#include <stdio.h>

NMConnectivityState state = 0;
NMClient *client;
void connectivity_ready(void * object, void * result, void * data) {
	(void) object;
	(void) result;
	(void) data;
	state = nm_client_get_connectivity(client);
	fprintf(stderr, "callback\n");
}

int main (void) {

	client = nm_client_new (NULL, NULL);
	if (client)
		g_print ("NetworkManager version: %s\n", nm_client_get_version (client));

	while (1) {
		nm_client_check_connectivity_async(client, 0, (GAsyncReadyCallback) connectivity_ready, 0);

		if (state == NM_CONNECTIVITY_FULL) {
			fprintf(stderr, "connected\n");
		} else {
			fprintf(stderr, "disconnected\n");
		}
		sleep(1);
	}
}
