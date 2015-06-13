#!/bin/bash

(($# < 1)) && echo "usage: ./kill-jobs.sh <io-dir> [rm]" && exit

io_dir=`realpath $1`

if [ ! -f ${io_dir}/pids ]; then
    echo "file ${io_dir}/pids does not exist; no jobs to kill"
    exit
fi

for pid in `cat ${io_dir}/pids`; do
    echo "pkill -TERM -P $pid"
    pkill -TERM -P $pid            # this also kills the children
done

(($# >= 2)) && [ "$2" == "rm" ] && rm -rf $io_dir
