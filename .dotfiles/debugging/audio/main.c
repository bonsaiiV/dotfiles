#include <pipewire/pipewire.h>

struct object_info {
	int is_filled;
	char *type;
	char *name;
};

#define MAX_OBJECTS 200
static const char *port_key = "port.alias";
static const char *node_key = "node.nick";
static const char *device_key = "device.nick";

struct object_info known_objects[MAX_OBJECTS];

static void registry_event_global(void *data, uint32_t id,
                uint32_t permissions, const char *type, uint32_t version,
                const struct spa_dict *props)
{
	unsigned int i;
	(void) data;
	(void) permissions;
	if (id > MAX_OBJECTS) {
		printf("id to large of object: id:%u type:%s/%d\n", id, type, version);
	} else {
		struct object_info *obj = &known_objects[id];
		obj->type = strdup(type);

		char * name_key = 0;
		if (spa_type_is_a(type, "PipeWire:Interface:Port")) {
			//name_key = port_key;
			return;
		} else if (spa_type_is_a(type, "PipeWire:Interface:Node")) {
			//name_key = node_key;
			return;
		} else if (spa_type_is_a(type, "PipeWire:Interface:Device")) {
			name_key = device_key;
		} else {
			return;
		}

		printf("object: id:%u type: %s/%d\n", id, type, version);

		obj->name = 0;
		for (i = 0; i < props->n_items; i++) {
			struct spa_dict_item item = props->items[i];
			printf("\t%s=%s\n", item.key, props->items[i].value);
			if (!strcmp(item.key, name_key)) {
				obj->name = strdup(item.value);
			}
		}
	}
}

static void registry_event_global_remove(void *data, uint32_t id)
{
	(void) data;
	printf("removed object: id:%u", id);
	if (id > MAX_OBJECTS) {
		printf("\n");
		return;
	}
	struct object_info *obj = &known_objects[id];
	if (obj->type) {
		printf(", type: %s", obj->type);
		free(obj->type);
		obj->type = 0;
	}
	if (obj->name) {
		printf(", name: %s", obj->name);
		free(obj->name);
		obj->name = 0;
	}
	printf("\n");
}

static const struct pw_registry_events registry_events = {
        PW_VERSION_REGISTRY_EVENTS,
        .global = registry_event_global,
        .global_remove = registry_event_global_remove,
};

int main(int argc, char *argv[])
{
        struct pw_main_loop *loop;
        struct pw_context *context;
        struct pw_core *core;
        struct pw_registry *registry;
        struct spa_hook registry_listener;

        pw_init(&argc, &argv);

        loop = pw_main_loop_new(NULL /* properties */);
        context = pw_context_new(pw_main_loop_get_loop(loop),
                        NULL /* properties */,
                        0 /* user_data size */);

        core = pw_context_connect(context,
                        NULL /* properties */,
                        0 /* user_data size */);

        registry = pw_core_get_registry(core, PW_VERSION_REGISTRY,
                        0 /* user_data size */);

        spa_zero(registry_listener);
        pw_registry_add_listener(registry, &registry_listener,
                                       &registry_events, NULL);

        pw_main_loop_run(loop);

        pw_proxy_destroy((struct pw_proxy*)registry);
        pw_core_disconnect(core);
        pw_context_destroy(context);
        pw_main_loop_destroy(loop);

        return 0;
}
