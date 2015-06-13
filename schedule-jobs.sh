#!/bin/bash

(($# < 4)) && echo "usage: ./schedule-jobs.sh <job-script> <files-list> <n-workers> <io-dir>" && exit

rm -rf $4; mkdir -p $4

# get absolute paths
job_script=`realpath $1`
files_list=`realpath $2`
n_workers=$3
io_dir=`realpath $4`

# compute how to split the job list
files_n=`cat $files_list | wc -l`
n_lines_per_batch=$(((files_n+n_workers-1)/n_workers)) # rounding up

split -l $n_lines_per_batch $files_list $io_dir/

running_dir=$(dirname "$job_script")
script=$(basename "$job_script")

for file in `ls $io_dir/*`; do
    echo "#!/bin/bash" > $file.sh
    # there might be some data dependency on the relative path of script
    echo "cd $running_dir; ./$script $file 2>&1 | tee $file.output" >> $file.sh
    chmod 755 $file.sh
    nohup bash $file.sh &
done

ps -U $USER | grep $script | awk '{print $1}' > $io_dir/pids
