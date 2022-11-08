
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <getopt.h>

#include "bufferiszero_utils.h"


int parse_args(int argc, char** argv, args_t* args)
{
    // Default buffer initialization
	if (argc == 1) {

        args->position = -1;
        args->size = DEFAULT_BUF_SIZ;
        return 0;
        
    }

    if(strcmp(argv[1], "--help") == 0)
    {
        printf("%s\n", USAGE);
        exit(EXIT_SUCCESS);
    }

	int ret = 0;
	static const char opts[] = "p:v:";
    while((ret = getopt(argc, argv, opts)) != -1)
	{
        switch (ret)
        {
		case 'p':
			args->position = atoi(optarg);
			break;
		case 'v':
			args->value = atoi(optarg);
			break;
		default:
            printf("ERROR: invalied option.\n");
            exit(ERR_INC_INPUT);   			
		}
	}
	args->size = atoi(argv[optind]);

	if(args->size < 0)
	{
		printf("ERROR: invalied size of buffer.\n");
		return ERR_INC_INPUT;
	}
	if((args->position >= args->size) && (args->position < -1))
	{
		printf("ERROR: invalied position.\n");
		return ERR_INC_INPUT;
	}

	return 0;
}

uint64_t nonzero_chunk(const char *p)
{
    uint64_t tmp1, tmp2;    

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

