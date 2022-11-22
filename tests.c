#include <stdio.h>

#include "bufferiszero.h"
#include "bufferiszero_utils.h"
#include "tests.h"

int test_zero_buffer(char* buf, size_t size) 
{
	position_nonzero_elem(buf, -1, 0);
    int ret = buffer_is_zero(buf, size);
    if (ret != 1) {
        printf("ERROR (test_zero_buffer): incorrect return code. Expected: %d, got: %d\n", 0, ret);
        return 1;
    } else {
        printf("OK (test_zero_buffer)\n");
        return 0;
    }
    return 0;
}

int test_nonzero_buffer(char* buf, size_t pos, int value, size_t size) 
{
	position_nonzero_elem(buf, pos, value);
    int ret = buffer_is_zero(buf, size);
    if (ret != 0) {
        printf("ERROR (test_zero_buffer): incorrect return code. Expected: %d, got: %d\n", 1, ret);
        return 1;
    } else {
        printf("OK (test_zero_buffer)\n");
        return 0;
    }
    return 0;
}


