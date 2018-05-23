#include <stdlib.h>
#include <libconfig.h>

const char *loadStringKey(config_t *cfg,char* key){
    const char *value = NULL;
    config_lookup_string(cfg, key, &value);
    return value;
}

int loadIntKey(config_t *cfg,char* key){
    int value  ;
    config_lookup_int(cfg, key, &value);
    return (int)value;
}
