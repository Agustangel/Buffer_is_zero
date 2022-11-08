#pragma once

#include <stdint.h>
#include <stddef.h>

#define DEFAULT_BUF_SIZ 4096

//! const for describing input parameters
static const char* USAGE = "Usage: ./biz.[perf, test] size_buffer position_flag position value_flag value\n \
        size_buffer - size of input buffer.\n \
                                           \n \
        position_flag - option to specify element position.\n \
        type '-p' to indicate the position of element.     \n \
                                                           \n \
        position - type the position of a nonzero element. \n \
        type '-1' to indicate that the buffer is zero.     \n \
                                          \n \
        value_flag - option to specify element value.\n \
        type '-v' to indicate the value of element.  \n \
        the option is not necessary if the buffer is filled with zeros.\n \
                                          \n \
        value - type the value of a nonzero element. \n";

enum error_names
{
    ERR_INC_INPUT = -5
};

typedef struct args_t
{
    size_t size;
    int position;
    int value;
}args_t;

int parse_args(int argc, char** argv, args_t* arg);


#define unlikely(expr) __builtin_expect((expr), 0)
#define   likely(expr) __builtin_expect((expr), 1)

void position_nonzero_elem(char* buf, size_t position, int value);

uint64_t load64(const void* V);

uint64_t nonzero_chunk(const char *p);

int is_empty_fast(const char * buf, size_t size);