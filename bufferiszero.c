#include "bufferiszero.h"
#include "bufferiszero_utils.h"
#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int buffer_is_zero(void *vbuf, size_t size) {
  char *buf = (char *)vbuf;
  const size_t word_length = sizeof(size_t);

  size_t chunk = 0;
  size_t last_chunk_pos = size - size % (5 * word_length);
  int quadr_word_length = 4 * word_length;

  uint32_t *start = (uint32_t *)buf;
  for (unsigned long idx = 0; idx + quadr_word_length <= size;
       idx += quadr_word_length) {

    start = (uint32_t *)(buf + idx);
    chunk = *(start) + *(start + 1) + *(start + 2) + *(start + 3) +
            *(start + 4) + *(start + 5) + *(start + 6) + *(start + 7);

    if (chunk)
      return 0;
  }

  // process remaining bytes
  const char *current_byte = buf + last_chunk_pos;
  const char *end = buf + size;
  unsigned char t = 0;
  while (current_byte < end) {
    t |= *(current_byte++);
  }

  return t == 0;
}

int buffer_is_zero_fast(void *vbuf, size_t size) {
  const unsigned width = sizeof(uint64_t) * 2; // 8 byte

  if (likely(size >= width)) {
    const char *endp = vbuf + size - width;

    uintptr_t misalign = (uintptr_t)vbuf % width; // check if memory is aligned
    const char *p = vbuf + width - misalign;
    while (p < endp) {
      if (nonzero_chunk(p))
        return 0;
      p += width;
    }

    if (nonzero_chunk(endp))
      return 0;
  } else {
    const unsigned char *p = vbuf;
    const unsigned char *e = vbuf + size;
    unsigned char t = 0;

    do {
      t |= *(p++);
    } while (p < e);

    return t == 0;
  }
  return 1;
}
