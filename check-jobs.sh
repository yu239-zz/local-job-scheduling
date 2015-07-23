#!/bin/bash

# example: ./check-jobs.sh dtBOW-io 0

(($# < 1)) && echo "usage: ./check-jobs.sh <io-dir> [<worker-id>]" && exit

io_dir=$1

if [ ! -d $io_dir ]; then
    echo "directory $io_dir does not exist"
    exit
fi

if (($# < 2)); then    
    worker_id=0
    for pid in `cat ${io_dir}/pids`; do
	if ps -p $pid > /dev/null; then
	    echo pid $pid, worker ${worker_id} "=> alive"
	else
	    echo pid $pid, worker ${worker_id} "=> dead"
	fi
	worker_id=$((worker_id+1))
    done
    exit
fi

worker_id=$2
n_workers=`ls $io_dir/*.output | wc -l`

(($worker_id < 0)) && echo "worker id must be nonnegative" && exit
(($worker_id >= $n_workers)) && echo "invalid worker id: only $n_workers workers exist (starts with 0)" && exit

outputs=(`ls $io_dir/*.output`)
echo "==== last 500 lines of the output ===="
cat ${outputs[$worker_id]} | tail -n 500

