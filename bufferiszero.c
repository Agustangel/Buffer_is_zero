#include "bufferiszero.h"
#include "bufferiszero_utils.h"
#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int buffer_is_zero(void *vbuf, size_t size) {
  char *buf = (char *)vbuf;
  uint64_t word_length = 8;
  uint64_t eight_word_length = 8 * word_length;

  uint64_t chunk0 = 0;
  uint64_t chunk1 = 0;
  uint64_t chunk2 = 0;
  uint64_t chunk3 = 0;
  size_t last_chunk_pos = size - size % word_length;

  // handle cases with buffer length less than sizeof(uint64_t) bytes
  if (size < word_length) {
    memcpy(&chunk0, buf, size);
    return chunk0 == 0;
  }
  memcpy(&chunk0, buf, sizeof(uint64_t));
  if (chunk0)
    return 0;

  uint64_t *start = (uint64_t *)buf;
  for (unsigned long idx = 0; idx + eight_word_length <= size;
       idx += eight_word_length) {

    start = (uint64_t *)(buf + idx);

    chunk0 |= *(start) | *(start + 1);
    chunk1 |= *(start + 2) | *(start + 3);
    chunk2 |= *(start + 4) | *(start + 5);
    chunk3 |= *(start + 6) | *(start + 7);
  }
  chunk0 |= chunk1;
  chunk2 |= chunk3;
  chunk0 |= chunk2;
  if (chunk0)
    return 0;

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
