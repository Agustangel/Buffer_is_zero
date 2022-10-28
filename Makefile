
CFLAGS ?= -O2 -g1

CFLAGS += -Wall -falign-loops=32

test: CC += -fsanitize=address,undefined
test: CFLAGS += -fno-omit-frame-pointer

P := biz

V := test perf
all: $V
.PHONY: $V all clean

$V: %: $P.%
#./$<

OBJ := main.o bufferiszero.o

OBJ-test := $(addprefix .o/test/, $(OBJ))
OBJ-perf := $(addprefix .o/perf/, $(OBJ))

$P.test: $(OBJ-test)
$P.perf: $(OBJ-perf)

$(V:%=$P.%): %:
	$(CC) -o $@ $^

$(OBJ-test): | .o/test/
$(OBJ-perf): | .o/perf/

%/:
	@mkdir -p $@

$(OBJ-test): .o/test/%.o: %.c
$(OBJ-perf): .o/perf/%.o: %.c

$(OBJ-test) $(OBJ-perf): %:
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	-rm -rf .o $(addprefix $P., $V)

.SUFFIXES:
.SECONDARY:
%.c:;
Makefile:;
