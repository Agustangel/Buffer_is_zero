#!/bin/bash

read MESSAGE
echo "$MESSAGE" > commit_msg.tmp
echo "=======================" >> commit_msg.tmp
./biz.perf >> commit_msg.tmp
git commit -F commit_msg.tmp

