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
  uint64_t *start = (uint64_t *)buf;
  uint64_t word_length = 8;
  uint64_t eight_word_length = 8 * word_length;

  __m128i chunk1;
  __m128i chunk2;
  __m128i chunk3;
  __m128i chunk4;
  size_t last_chunk_pos = size - size % eight_word_length;

  __m128i zero_vec = _mm_setzero_si128();

  for (unsigned long idx = 0; idx + eight_word_length <= size;
       idx += eight_word_length) {

    chunk1 = _mm_load_si128((__m128i*) (buf + idx));
    chunk2 = _mm_load_si128((__m128i*) (buf + idx + 2 * sizeof(uint64_t)));
    chunk3 = _mm_load_si128((__m128i*) (buf + idx + 4 * sizeof(uint64_t)));
    chunk4 = _mm_load_si128((__m128i*) (buf + idx + 6 * sizeof(uint64_t)));

    chunk1 = _mm_or_si128(chunk1, chunk2);
    chunk3 = _mm_or_si128(chunk3, chunk4);
    chunk1 = _mm_or_si128(chunk1, chunk3);

    __mmask16 mask = _mm_cmpeq_epi8_mask(zero_vec, chunk1);
    if (mask != 0xFFFF)
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
