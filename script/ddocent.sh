#!/bin/bash
#SBATCH -t 300:00:00
#SBATCH -J calls_reference          # Name of the job
#SBATCH -o calls_reference.out      # Name of file that will have program output
#SBATCH -e calls_reference.err      # Name of the file that will have job errors, if any
#SBATCH -N 1                      # Number of nodes (the normal cluster partition has 22 total)
#SBATCH -n 20                     # Number of cores (my test allocated 2 per node)

#script provided by Dan Bock

module load ddocent

dDocent config.file