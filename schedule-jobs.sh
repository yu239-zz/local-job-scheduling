#!/bin/bash

# example: ./schedule-jobs.sh ~/dtBOW/dtBOW.py ~/YouTubeClips/videos.txt 5 dtBOW-io

(($# < 4)) && echo "usage: ./schedule-jobs.sh <job-script> <files-list> <n-workers> <io-dir>" && exit

rm -rf $4; mkdir -p $4

# get absolute paths
job_script=`realpath $1`
files_list=`realpath $2`
n_workers=$3
device_id=0

# when n_workers is negative, use cpu instead of gpu
(( $n_workers < 0 )) && device_id=$3 && n_workers=$((0-n_workers))

io_dir=`realpath $4`

# compute how to split the job list
files_n=`cat $files_list | wc -l`
n_lines_per_batch=$(((files_n+n_workers-1)/n_workers)) # rounding up

split -l $n_lines_per_batch $files_list $io_dir/

running_dir=$(dirname "$job_script")
script=$(basename "$job_script")

echo > $io_dir/pids
for file in `ls $io_dir/* | grep -v pids`; do
    echo "#!/bin/bash" > $file.sh
    # there might be some data dependency on the relative path of script
    echo "cd $running_dir; nice -n 19 ./$script $file ${device_id} 2>&1 | tee $file.output" >> $file.sh
    chmod 755 $file.sh
    nohup $file.sh &>/dev/null &
    echo $! >> $io_dir/pids
    device_id=$((device_id+1))
done

sleep 1
echo "${n_workers} jobs scheduled; use ./check-jobs.sh to see the progress"

