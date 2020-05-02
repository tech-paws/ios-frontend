#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct {
  const uint8_t *data;
  uintptr_t length;
} RawBuffer;

RawBuffer get_render_commands(void);

void init_world(void);

void step(void);
