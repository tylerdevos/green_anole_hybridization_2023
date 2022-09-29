#!/bin/bash
###re-order samples in the STRUCTURE results files
#prerequisites: STRUCTURE results files

#script provided by Dan Bock

#set the sample size variable; edit this as needed, depending on dataset
sample_size='47'

#loop over K values to be plotted, and re-order samples for each analysis
for k_value in {"1","2","3","4","5","6","7","8"}
do
#define coordinates (line numbers) where the individual ancestry proportions are located in the input files
last_coordinate_before_genotypes=$(grep -n Label Anolis_k${k_value} | cut -d ':' -f 1)
coordinate_genotypes_start=$(expr $last_coordinate_before_genotypes + 1)
coordinate_genotypes_end=$(expr $last_coordinate_before_genotypes + $sample_size)
first_coordinate_after_genotypes=$(expr $coordinate_genotypes_end + 1)
last_coordinate_in_file=$(cat Anolis_k${k_value} | wc -l)

#get the first lines in the results file (these are all the lines that precede individual ancestry proportions)
head -n $last_coordinate_before_genotypes Anolis_k${k_value} > header_k${k_value}.txt
#get individual membership proportions (these will be used below to reorder samples)
sed -n "$coordinate_genotypes_start,$coordinate_genotypes_end p" Anolis_k${k_value} > genotypes_k${k_value}.txt
#get all lines after the individual ancestry proportions (which consist of estimated allele frequencies for each locus in the ancestral populations inferred by STRUCTURE)
sed -n "$first_coordinate_after_genotypes,$last_coordinate_in_file p" Anolis_k${k_value} > allele_freq_k${k_value}.txt

#loop over a text file containing each sample in the desired order, and use grep to re-order the genotypes_<k_value>.txt files
cat samples_ordered.txt | while read line
do
prefix=$line
grep -w -m 1 $prefix genotypes_k${k_value}.txt >> genotypes_k${k_value}.ordered.txt
done

#re-assemble STRUCTURE results file with the new sample order
cat header_k${k_value}.txt genotypes_k${k_value}.ordered.txt allele_freq_k${k_value}.txt > Anolis_k${k_value}.ordered
#remove intermediate files
rm header_k${k_value}.txt genotypes_k${k_value}.txt genotypes_k${k_value}.ordered.txt allele_freq_k${k_value}.txt
done

