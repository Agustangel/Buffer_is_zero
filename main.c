#include <stdio.h>
#include <stdlib.h>

#include "bufferiszero.h"
#include "bufferiszero_utils.h"
#include "perfcnt.h"

//! const for describing input parameters
static const char* USAGE = "Usage: ./biz.perf <size> [<pos>:<val>]\n";


#ifdef __SANITIZE_ADDRESS__
const char *__asan_default_options(void)
{
        return "detect_leaks=0";
}
#endif

int main(int argc, char** argv)
{
	int perf_fd;
	struct perf_counters cnt0, cnt1;
	if ((perf_fd = perf_setup()) < 0)
	{
		perf_hint();
		return 1;
	}

	// TODO make size configurable from command line
	args_t args;
	int ret = parse_args(argc, argv, &args);
	if (ret < 0) {
		printf("Usage: %s\n", USAGE);
		return EXIT_FAILURE;
	}

	size_t size = args.size;
	char* buf = (char*) calloc(size, 1);

	// TODO make position and value of non-zero element configurable
	position_nonzero_elem(buf, args.position, args.value);

#ifdef __SANITIZE_ADDRESS__
	return 0;
#endif
	unsigned long long min_c = -1, min_i = 0;
	for (int i = 0; i < 1000000; i++) {
		unsigned long long nc, ni;

		perf_measure(perf_fd, &cnt0);
		buffer_is_zero_fast(buf, size);
		perf_measure(perf_fd, &cnt1);

		nc = cnt1.cycles - cnt0.cycles;
		ni = cnt1.instructions - cnt0.instructions;

		if (min_c> nc) {
			min_c = nc;
			min_i = ni;
		}
	}
	printf("%llu cycles minimum for %zu bytes\n"
	       "%.3g bytes/cycle, %.3g instructions/cycle\n",
	       min_c, size,
	       1. * size / min_c, 1. * min_i / min_c);
}
