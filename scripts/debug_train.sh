#!/bin/bash
#SBATCH -N 1
#SBATCH -C gpu
#SBATCH -G 4
#SBATCH -q debug
#SBATCH -J debug_train
#SBATCH --mail-user=mingfong@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH -t 00:30:00
#SBATCH -A m3246
#SBATCH -o logs/%x-%j.out

#OpenMP settings:
export OMP_NUM_THREADS=1
export OMP_PLACES=threads
export OMP_PROC_BIND=spread

date
set -x    # log commands
image=vmikuni/tensorflow:ngc-23.12-tf2-v1

#run the application:
#applications may perform better with --gpu-bind=none instead of --gpu-bind=single:1 
# srun -n 4 -c 32 --cpu_bind=cores -G 4 --gpu-bind=single:1  python scripts/train.py --dataset toy
srun -l -u --mpi=pmi2 shifter --image=$image \
  bash -c "python scripts/train.py --dataset toy --folder /pscratch/sd/m/mingfong/omnilearn/ --epoch 5"
