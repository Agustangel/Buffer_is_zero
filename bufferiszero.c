#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "bufferiszero.h"
#include "bufferiszero_utils.h"


int buffer_is_zero(void* vbuf, size_t size)
{
	char* buf = (char*) vbuf;
    const size_t word_length = sizeof(size_t);
    size_t chunk = 0;
    size_t last_chunk_pos = size  - size % 8;

    
    // process until less than word_length bytes remain
	for (unsigned long idx = 0; idx + word_length <= size; idx += word_length) 
    {
        memcpy(&chunk, buf + idx, sizeof(size_t));
        if (chunk)
            return 0;
    }
    // process remaining bytes
    const char *current_byte = buf + last_chunk_pos;
    const char *end = buf + size;
    unsigned char t = 0;
    while (current_byte < end)
    {
        t |= *(current_byte++);
    }

    return t == 0;
}

int buffer_is_zero_fast(void* vbuf, size_t size)
{
    const unsigned width = sizeof(uint64_t) * 2; // 8 byte

    if (likely(size >= width))
    {   
        const char *endp = vbuf + size - width;  
        
        uintptr_t misalign = (uintptr_t)vbuf % width; // check if memory is aligned
        const char *p = vbuf + width  - misalign; 
        while (p < endp)
        {
            if(nonzero_chunk(p)) return 0;
            p += width;
        }

        if(nonzero_chunk(endp)) return 0;
    } 
    else
    {
        const unsigned char *p = vbuf;
        const unsigned char *e = vbuf + size;
        unsigned char t = 0;

        do
        {
            t |= *(p++);
        } while (p < e);

        return t == 0;
    }
    return 1;
}
