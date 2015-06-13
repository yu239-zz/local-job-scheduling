# local-job-scheduling
light-weight scripts for scheduling jobs running on multiple cpus on a local machine

prerequiste: "realpath" needs to be installed first
             on Ubuntu: sudo apt-get install realpath

usage: ./schedule-jobs.sh job-script files-list n-workers io-dir

       job-script: the binary or script file to run
       files-list: a list of input files that can be accepted by the job-script
       n-workers: how many cpus you want to split the jobs into
       io-dir: the directory to store the i/o and jobs information
       
usage: ./check-jobs.sh io-dir [worker-id]

       io-dir: the job directory you want to check with
       [worker-id]: the job id to check; if not specified, return the status of jobs (dead or alive)
       
       
usage: ./kill-jobs.sh io-dir [rm]

       io-dir: the job batch you want to destroy
       [rm]: whether to remove all the io of the job batch
