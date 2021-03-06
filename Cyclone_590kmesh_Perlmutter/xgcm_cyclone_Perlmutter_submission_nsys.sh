#!/bin/bash
#SBATCH -A m499_g
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH -t 0:10:00
#SBATCH -n 8
#SBATCH --ntasks-per-node=4
#SBATCH -c 32
#SBATCH --gpus-per-task=1
#SBATCH --gpu-bind=map_gpu:0,1,2,3
#SBATCH --job-name=Cyclone_590k

module load PrgEnv-gnu
module load systemlayer
module load cuda/11.4.2
module load cpe-cuda
module load craype-accel-nvidia80
module load cmake/3.22.0
export KOKKOS_PROFILE_LIBRARY=/global/homes/z/zhangc20/xgcm/kokkos-tools/kp_nvprof_connector.so
export SLURM_CPU_BIND="cores"

srun /global/homes/z/zhangc20/nsight-systems-2021.5.1/bin/nsys \
profile -o XGCm_profile_nsys_%q{SLURM_PROCID} -f true --stats=true \
./XGCm --kokkos-threads=1 590kmesh.osh 590kmesh_6.cpn \
1 1 bfs bfs 0 0 0 3 input_xgcm petsc petsc_xgcm.rc \
-use_gpu_aware_mpi 0
