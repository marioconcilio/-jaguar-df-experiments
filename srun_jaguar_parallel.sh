#!/bin/bash -v

#SBATCH --job-name=jaguar      			# Job name
#SBATCH --output output-jaguar.%J       # Job output
#SBATCH --partition=SP2
#SBATCH --ntasks=6              		# number of tasks / mpi processes
#SBATCH --cpus-per-task=1       		# Number OpenMP Threads per process
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL                 # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=mario.neto@usp.br   # Email to which notifications will be sent

#OpenMP settings:
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export OMP_PLACES=threads
export OMP_PROC_BIND=spread

echo $SLURM_JOB_ID              #ID of job allocation
echo $SLURM_SUBMIT_DIR          #Directory job where was submitted
echo $SLURM_JOB_NODELIST        #File containing allocated hostnames
echo $SLURM_NTASKS              #Total number of cores for job

# Load the default version of GNU parallel.
module load parallel

# When running a large number of tasks simultaneously, it may be
# necessary to increase the user process limit.
ulimit -u 10000

a=("Chart 1b" "Cli 1b" "Closure 1b" "Codec 1b" "Collections 25b" "Compress 1b" "Csv 1b" "Gson 1b" "JacksonCore 1b")

parallel --delay 0.2 -j $SLURM_NTASKS --joblog runtask.log --resume \
	srun --exclusive -N1 -n1 \
	./docker_jaguar.sh ::: "${a[@]}"
