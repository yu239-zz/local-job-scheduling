#!/bin/bash

(($# < 1)) && echo "usage: ./check-jobs.sh <io-dir> [<worker-id>]" && exit

io_dir=`realpath $1`

if [ ! -d $io_dir ]; then
    echo "directory $io_dir does not exist"
    exit
fi

if (($# < 2)); then
    for pid in `cat ${io_dir}/pids`; do
	if ps -p $pid > /dev/null; then
	    echo $pid, alive
	else
	    echo $pid, dead
	fi
    done
    exit
fi

worker_id=$2
n_workers=`ls $io_dir/*.output | wc -l`

(($worker_id < 0)) && echo "worker id must be nonnegative" && exit
(($worker_id >= $n_workers)) && echo "invalid worker id: only $n_workers workers exist (starts with 0)" && exit

outputs=(`ls $io_dir/*.output`)
cat ${outputs[$worker_id]}

