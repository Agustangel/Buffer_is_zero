
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "bufferiszero_utils.h"


int parse_args(int argc, char** argv, args_t* args)
{
    // Default buffer initialization
	if (argc == 1) {

        args->position = -1;
        args->size = DEFAULT_BUF_SIZ;
        return 0;
        
    }

    args->size = strtoll(argv[1], &argv[1], 10);
    char* arg = argv[2];
    sscanf(arg, "%d:%d", &args->position, &args->value);

	return 0;
}

uint64_t nonzero_chunk(const char *p)
{
    uint64_t tmp1, tmp2;    

    __builtin_prefetch(p);
    __builtin_prefetch(p);
    tmp1 = load64(p);
    tmp2 = load64(p + 8);

    return tmp1|tmp2;
}

uint64_t load64(const void* V)
{
   uint64_t Ret = 0;
   uint8_t* Val = (uint8_t*) V;

   Ret |= ((uint64_t) Val[0]);
   Ret |= ((uint64_t) Val[1]) << 8;
   Ret |= ((uint64_t) Val[2]) << 16;
   Ret |= ((uint64_t) Val[3]) << 24;
   Ret |= ((uint64_t) Val[4]) << 32;
   Ret |= ((uint64_t) Val[5]) << 40;
   Ret |= ((uint64_t) Val[6]) << 48;
   Ret |= ((uint64_t) Val[7]) << 56;

   return Ret;
}

void position_nonzero_elem(char* buf, size_t position, int value)
{
	if(position == -1)
		return;
	buf[position] = value;
}

