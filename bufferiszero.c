#include "bufferiszero.h"
#include "bufferiszero_utils.h"
#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <immintrin.h>
#include <xmmintrin.h>


typedef uint64_t v2du __attribute__ ((vector_size (16), aligned(16)));

static inline int is_aligned(const void* ptr, unsigned alignment) {
  return (uintptr_t) ptr % alignment == 0;
}

int buffer_is_zero(void *vbuf, size_t size) {

  char *buf = (char *)vbuf;
  uint64_t word_length = 8;
  uint64_t eight_word_length = 8 * word_length;

  char* current_byte = buf;
  unsigned char t = 0;
  while (!is_aligned(current_byte, 16)) {
    t |= *(current_byte++);
  }
  if (t != 0) {
    return 0;
  }
  size_t offset = current_byte - buf;
  size_t last_chunk_pos = size - (size - offset) % eight_word_length;

  v2du zero_vec = {0};
  v2du chunk_1 = {0};
  v2du chunk_2 = {0};

  v2du *start = (v2du *)(current_byte);
  for (size_t idx = 0; idx + offset + eight_word_length <= size;
       idx += eight_word_length) {
    
    start = (v2du *)(buf + offset + idx);  

    chunk_1 = *(start) | *(start + 1);
    chunk_2 = *(start + 2) | *(start + 3);;
    chunk_1 = chunk_1 | chunk_2;

    uint32_t mask = _mm_movemask_epi8(_mm_cmpeq_epi8((__m128i) chunk_1, (__m128i) zero_vec));
    if (mask != 0xFFFF)
      return 0;
  }

  // process remaining bytes
  current_byte = buf + last_chunk_pos;
  const char *end = buf + size;
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
