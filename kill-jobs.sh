#!/bin/bash

# example: ./kill-jobs.sh dtBOW-io rm

(($# < 1)) && echo "usage: ./kill-jobs.sh <io-dir> [rm]" && exit

io_dir=$1

if [ ! -f ${io_dir}/pids ]; then
    echo "file ${io_dir}/pids does not exist; no jobs to kill"
else
    for pid in `cat ${io_dir}/pids`; do
	echo "kill -9 $pid"
	kill -9 $pid &>/dev/null
    done
fi

(($# >= 2)) && [ "$2" == "rm" ] && rm -rf $io_dir
