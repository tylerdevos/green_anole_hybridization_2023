#!/bin/bash
#SBATCH -t 10:00:00
#SBATCH --exclusive --nodes=1 --ntasks-per-node=1

#Script provided by Dan Bock

#first make a text file (we'll call it list.txt) containing on each line the files with a .fastq.gz ending in the current folder (i.e. all raw reads files)
ls *.fastq.gz > list.txt


#read that txt file one line at a time, using the commant "cat"
#for each line that is being read (i.e. for each fastq file), search for the "@" character and count the number of lines that contain this character
#in the fastq format, the @ sign is used once per read, to indicate flow cell information, etc..so by counting the number of lines that contain "@" we are counting the number of reads
cat list.txt | while read line
do
	gunzip -c $line | grep "@" | wc -l >> read_counts
done

#make an output file (we'll call it read_counts.txt), by pasting the list of files and the read counts together
paste list.txt read_counts > read_counts.txt
