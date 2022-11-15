#pragma once

#include <stddef.h>

int buffer_is_zero(void* vbuf, size_t size);
int buffer_is_zero_fast(void* vbuf, size_t size);

