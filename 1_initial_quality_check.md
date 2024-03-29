## Initial Quality Check
### Part 1: Read Counting
Count reads for all files
###### This step uses the script [`count_reads.sh`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/count_reads.sh). When complete, read counts for each sample are listed in a file named `read_counts.txt`.
```
sbatch ./count_reads.sh
```
Search for reads counts below or above a given value (here, 1,500,000 & 3,500,000)
```
awk '$2<1500000' read_counts.txt
awk '$2>3500000' read_counts.txt
```
   
### Part 2: FastQC
Load FastQC
```
module load FastQC/0.11.8-Java-1.8
```
Create an output directory and run FastQC
###### This step uses the script [`FastQC.sh`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/FastQC.sh).
```
mkdir fastqc_output
sbatch ./FastQC.sh
```
   
### [To Page 2: Data Cleanup >>>](https://github.com/tylerdevos/green_anole_hybridization/blob/main/2_data_cleanup.md)
