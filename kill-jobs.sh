#!/bin/bash

# example: ./kill-jobs.sh dtBOW-io rm

(($# < 1)) && echo "usage: ./kill-jobs.sh <io-dir> [rm]" && exit

io_dir=$1

if [ ! -f ${io_dir}/pids ]; then
    echo "file ${io_dir}/pids does not exist; no jobs to kill"
else
    ## don't kill twice so that some other processes might be killed
    if [ ! -f ${io_dir}/killed ]; then
	for pid in `cat ${io_dir}/pids`; do
	    echo "pkill -TERM -P $pid"
	    pkill -TERM -P $pid &>/dev/null
	    touch ${io_dir}/killed
	done
    fi
fi

(($# >= 2)) && [ "$2" == "rm" ] && echo "rm -rf $io_dir nohup.out" && rm -rf $io_dir nohup.out
