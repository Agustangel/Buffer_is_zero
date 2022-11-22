#pragma once
#include <stdlib.h>

int test_zero_buffer(char* buf, size_t size, int expected);

int test_nonzero_buffer(char* buf, size_t pos, int value, size_t size, int expected);
