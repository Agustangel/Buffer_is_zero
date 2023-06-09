#pragma once

#include <stdint.h>
#include <stddef.h>

#define DEFAULT_BUF_SIZ 4096

#define MAX_LOG_LEN 2048

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

void parse_args(int argc, char** argv, args_t* arg);

void log_to_file(const char* fmt, ...);


#define unlikely(expr) __builtin_expect((expr), 0)
#define   likely(expr) __builtin_expect((expr), 1)

void position_nonzero_elem(char* buf, size_t position, int value);

uint64_t load64(const void* V);

uint64_t nonzero_chunk(const char *p);
