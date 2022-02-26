#!/bin/bash
#SBATCH -t 100:00:00
#SBATCH --nodes=1 --ntasks-per-node=20

#script provided by Dan Bock and updated by Tyler DeVos

module load Trimmomatic/0.39-Java-11
java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar

###make a list of all file names
ls *.F.* > prefix.list
sed -i 's/\.F\.fq.gz//g' prefix.list

###loop over the list and trim the reads, keeping only the read pairs that remain intact (exclude a read if its pair was trimmed completely)
#parameter values/meaning: 
cat prefix.list | while read line
do
prefix=$line
java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE -threads 20 -phred33 -trimlog $prefix.trimlog $prefix.F.fq.gz $prefix.R.fq.gz $prefix.R1.fq.gz $prefix.unpaired.R1.fq.gz $prefix.R2.fq.gz $prefix.unpaired.R2.fq.gz ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:3:15 MINLEN:36 > ${prefix}.trimSTDOUT
done
rm *.unpaired.*
rm *.trimlog
rm *.trimSTDOUT
rm prefix.list
