#!/bin/bash
#SBATCH -t 10:00:00
#SBATCH --exclusive --nodes=1 --ntasks-per-node=1

for f in ./raw_data/*.fastq.gz; do fastqc -o ./output/fastqc_output/ $f; done
