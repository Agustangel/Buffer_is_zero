#include "bufferiszero.h"
#include "bufferiszero_utils.h"
#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define percent 8

int buffer_is_zero(void *vbuf, size_t size) {

  char *buf = (char *)vbuf;
  uint64_t *start = (uint64_t *)buf;
  uint64_t word_length = 8;
  uint64_t eight_word_length = 8 * word_length;

  uint64_t chunk = 0;
  size_t start_chunk_pos = size * percent / 100 - size * percent / 100 % 8;
  size_t last_chunk_pos = size - (size - start_chunk_pos) % eight_word_length;

  // buffer start check
  if (size >= 2 * word_length) {
    chunk = (*start == 0) && !memcmp(start, start + 1, start_chunk_pos - 8);
    if (!chunk)
      return 0;
  }
  chunk = 0;

  for (unsigned long idx = start_chunk_pos; idx + eight_word_length <= size;
       idx += eight_word_length) {

    start = (uint64_t *)(buf + idx);
    chunk = (*(start) | *(start + 1)) | (*(start + 2) | *(start + 3)) |
            (*(start + 4) | *(start + 5)) | (*(start + 6) | *(start + 7));
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
