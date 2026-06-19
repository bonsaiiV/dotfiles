#include <wp/wp.h>
#include <stdio.h>

#define eprintf(format,...) fprintf(stderr, "error on line %d: "format, __LINE__ __VA_OPT__(,) __VA_ARGS__)
WpCore *wp_core;

void default_nodes_api_loaded(WpObject *p, GAsyncResult *res, void *data){
	(void) data;
	(void) p;
	g_autoptr(GError) error = 0;

	wp_core_load_component_finish(wp_core, res, &error);
	fprintf(stderr, "default nodes api load finished\n");

}

void object_manager_installed(void *data) {
	(void) data;
	fprintf(stderr, "object manager installed\n");
	return;
}

int main(void) {
	wp_init(WP_INIT_PIPEWIRE);
	wp_core = wp_core_new(NULL, NULL, NULL);
	wp_core_connect(wp_core);

	WpObjectManager *object_manager = wp_object_manager_new();
	g_signal_connect_swapped(object_manager, "installed", (GCallback)object_manager_installed, NULL);

	fprintf(stderr, "loading default nodes api\n");
	wp_core_load_component(wp_core, "libwireplumber-module-default-nodes-api", "module", NULL,
                         "default-nodes-api", NULL, (GAsyncReadyCallback)default_nodes_api_loaded,
                         NULL);
	sleep(5);

	WpPlugin *def_nodes_api = wp_plugin_find(wp_core, "default-nodes-api");

	if (def_nodes_api == NULL) {
		eprintf("default nodes api is not loaded\n");
		return -1;
	}

	WpPlugin *mixer_api_ = wp_plugin_find(wp_core, "mixer-api");

	if (mixer_api_ == NULL) {
		eprintf("mixer api is not loaded\n");
		return -1;
	}

	// Get default sink
	char *default_sink_name;
	g_signal_emit_by_name(
		def_nodes_api,
		"get-default-configured-node-name",
		"Audio/Sink",
		&default_sink_name
	);
	uint32_t default_sink_id;
	g_signal_emit_by_name(def_nodes_api, "get-default-node", "Audio/Sink", &default_sink_id);

	GVariant *variant = 0;
	g_signal_emit_by_name(mixer_api_, "get-volume", default_sink_id, &variant);

	double volume;
	g_variant_lookup(variant, "volume", "d", &volume);

	eprintf("volume %f\n", volume);
}
