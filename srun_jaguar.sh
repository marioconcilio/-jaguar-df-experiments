#!/bin/bash -v

#SBATCH --job-name=jaguar      			# Job name
#SBATCH --output output-jaguar.%J       # Job output
#SBATCH --partition=SP2
#SBATCH --ntasks=17              		# number of tasks / mpi processes
#SBATCH --cpus-per-task=2       		# Number OpenMP Threads per process
#SBATCH --time=48:00:00
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

# module swap gnu intel/18.0.2.199

# Run tasks:

# jfreechart
srun -n1 -N1 --job-name=Chart --exclusive \
		./docker_jaguar.sh Chart 1b &

# commons-cli
srun -n1 -N1 --job-name=Cli --exclusive \
		./docker_jaguar.sh Cli 1b &

# closure-compiler
srun -n1 -N1 --job-name=Closure --exclusive \
		./docker_jaguar.sh Closure 1b &

# commons-codec
srun -n1 -N1 --job-name=Codec --exclusive \
		./docker_jaguar.sh Codec 1b &

# commons-collections
srun -n1 -N1 --job-name=Collections --exclusive \
		./docker_jaguar.sh Collections 25b &

# commons-compress
srun -n1 -N1 --job-name=Compress --exclusive \
		./docker_jaguar.sh Compress 1b &

# commons-csv
srun -n1 -N1 --job-name=Csv --exclusive \
		./docker_jaguar.sh Csv 1b &

# gson
srun -n1 -N1 --job-name=Gson --exclusive \
		./docker_jaguar.sh Gson 1b &

# jackson-core
srun -n1 -N1 --job-name=JacksonCore --exclusive \
		./docker_jaguar.sh JacksonCore 1b &

# jackson-databind
srun -n1 -N1 --job-name=JacksonDatabind --exclusive \
		./docker_jaguar.sh JacksonDatabind 1b &

# jackson-dataformat-xml
srun -n1 -N1 --job-name=JacksonXml --exclusive \
		./docker_jaguar.sh JacksonXml 1b &

# jsoup
srun -n1 -N1 --job-name=Jsoup --exclusive \
		./docker_jaguar.sh Jsoup 1b &

# commons-jxpath
srun -n1 -N1 --job-name=JxPath --exclusive \
		./docker_jaguar.sh JxPath 1b &

# commons-lang
srun -n1 -N1 --job-name=Lang --exclusive \
		./docker_jaguar.sh Lang 1b &

# commons-math
srun -n1 -N1 --job-name=Math --exclusive \
		./docker_jaguar.sh Math 1b &

# mockito
srun -n1 -N1 --job-name=Mockito --exclusive \
		./docker_jaguar.sh Mockito 1b &

# joda-time
srun -n1 -N1 --job-name=Time --exclusive \
		./docker_jaguar.sh Time 1b &

wait
