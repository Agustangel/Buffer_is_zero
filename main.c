#include <stdio.h>
#include <stdlib.h>

#include "bufferiszero.h"
#include "bufferiszero_utils.h"
#include "perfcnt.h"
#include "tests.h"


#ifdef __SANITIZE_ADDRESS__
const char *__asan_default_options(void) { return "detect_leaks=0"; }
#endif

int main(int argc, char **argv) {
  int perf_fd;
  struct perf_counters cnt0, cnt1;
  if ((perf_fd = perf_setup()) < 0) {
    perf_hint();
    return 1;
  }

  // TODO make size configurable from command line
  args_t args;
  parse_args(argc, argv, &args);
  int expected_value = 1;
  if (args.position >= 0 && args.value > 0) {
    expected_value = 0;
  }

  size_t size = args.size;
  char *buf = (char *)calloc(size, 1);
  if (args.position >= 0) {
    buf[args.position] = args.value;
  }
  perf_measure(perf_fd, &cnt0);
  int res = buffer_is_zero(buf, size);
  if (expected_value != res) {
    printf("ERROR: test case (%ld, %d, %d), expected: %d, got: %d\n", args.size,
           args.position, args.value, 0, 1);
    return 1;
  }

#ifdef __SANITIZE_ADDRESS__
  return 0;
#endif
  unsigned long long min_c = -1, min_i = 0;
  for (int i = 0; i < 1000000; i++) {
    unsigned long long nc, ni;

    perf_measure(perf_fd, &cnt0);
    buffer_is_zero(buf, size);
    perf_measure(perf_fd, &cnt1);

    nc = cnt1.cycles - cnt0.cycles;
    ni = cnt1.instructions - cnt0.instructions;

    if (min_c > nc) {
      min_c = nc;
      min_i = ni;
    }
  }
  const char *log_fmt = "%llu cycles minimum for %zu bytes\n"
                        "%.3g bytes/cycle, %.3g instructions/cycle\n";
  printf(log_fmt, min_c, size, 1. * size / min_c, 1. * min_i / min_c);

  log_to_file(log_fmt, min_c, size, 1. * size / min_c, 1. * min_i / min_c);
}
