#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct {
  const uint8_t *data;
  uintptr_t length;
} RawBuffer;

RawBuffer get_exec_commands(void);

RawBuffer get_render_commands(void);

void init_world(void);

void send_request_commands(RawBuffer data);

void step(void);
