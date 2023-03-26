#include "bufferiszero.h"
#include "bufferiszero_utils.h"
#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <immintrin.h>
#include <xmmintrin.h>

int buffer_is_zero(void *vbuf, size_t size) {

  char *buf = (char *)vbuf;
  uint64_t word_length = 8;
  uint64_t eight_word_length = 8 * word_length;
  size_t last_chunk_pos = size - size % eight_word_length;

  typedef uint64_t v4si __attribute__ ((vector_size (16), aligned(16)));

  v4si zero_vec = {0};
  v4si chunk_1 = {0};
  v4si chunk_2 = {0};
  v4si chunk_3 = {0};
  v4si chunk_4 = {0};

  for (unsigned long idx = 0; idx + eight_word_length <= size;
       idx += eight_word_length) {

    memcpy(&chunk_1, (buf + idx), sizeof(v4si));
    memcpy(&chunk_2, (buf + idx + 2 * word_length), sizeof(v4si));
    memcpy(&chunk_3, (buf + idx + 4 * word_length), sizeof(v4si));
    memcpy(&chunk_4, (buf + idx + 6 * word_length), sizeof(v4si));

    chunk_1 = (chunk_1 | chunk_2) | (chunk_3 | chunk_4);

    if (chunk_1[0] | chunk_1[1])
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
