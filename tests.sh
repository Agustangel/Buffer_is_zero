#!/bin/bash

./biz.test 512
./biz.test 512 511:1
./biz.test 512 511:0
./biz.test 511
./biz.test 511 510:1
# ./biz.test 8
# ./biz.test 8 7:1
# ./biz.test 5
# ./biz.test 4
./biz.test 4096 4095:1
./biz.test 4096
