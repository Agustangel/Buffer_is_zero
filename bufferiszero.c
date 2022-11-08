#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "bufferiszero.h"
#include "bufferiszero_utils.h"


int buffer_is_zero_slow(void* vbuf, size_t size)
{
	char* buf = (char*) vbuf;
	for (size_t i = 0; i < size; i++)
		if (buf[i])
			return 0;
	return 1;
}

int buffer_is_zero_fast(void* vbuf, size_t size)
{
    const unsigned width = sizeof(uint_fast32_t) * 2; // 8 byte

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
