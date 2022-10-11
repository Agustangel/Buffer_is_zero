#include <ctype.h>
#include <getopt.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "bufferiszero.h"


int buffer_is_zero(void* vbuf, size_t size)
{
	char* buf = (char*) vbuf;
	for (size_t i = 0; i < size; i++)
		if (buf[i])
			return 0;
	return 1;
}

void position_nonzero_elem(char* buf, size_t position, int value)
{
	if(position == -1)
		return;
	buf[position] = value;
}

int parse_args(int argc, char** argv, args_t* args)
{
    if(strcmp(argv[1], "--help") == 0)
    {
        printf("%s\n", USAGE);
        exit(EXIT_SUCCESS);
    }

	if (argc < 4)
    {
        printf("ERROR: incorrect number of argumnets.\n");
        return ERR_INC_INPUT;
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
