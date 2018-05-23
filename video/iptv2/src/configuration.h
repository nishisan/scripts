#ifndef CONFIGURATION_H__
 #define CONFIGURATION_H__

#include <libconfig.h>
const char *loadStringKey(config_t *cfg,char* key);
int loadIntKey(config_t *cfg,char* key);

#endif
