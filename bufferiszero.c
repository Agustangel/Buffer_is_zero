#include "bufferiszero.h"

int buffer_is_zero(void *vbuf, size_t size)
{
	char *buf = vbuf;
	for (size_t i = 0; i < size; i++)
		if (buf[i])
			return 0;
	return 1;
}
