#!/bin/bash

(($# < 1)) && echo "usage: ./clean-jobs.sh <io-dir>" && exit

io_dir=$1

echo "rm -rf $io_dir nohup.out" && rm -rf $io_dir nohup.out
