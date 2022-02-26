#!/bin/bash

#script provided by Dan Bock

module load ddocent
names='vcfsamplenames'
keepgeno='vcfkeepgeno'

#calculate allele balance (AB) and exclude samples for which more than 20% of high depth (DP 15x or more) heterozygotes show AB ratios outside the range of 0.2-0.8
$names all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.vcf > samples.txt
mkdir AB_calculations

cat samples.txt | while read line
do
prefix=$line
vcfkeepsamples all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.vcf $prefix  > AB_calculations/$prefix.vcf
grep "0/1" AB_calculations/$prefix.vcf > AB_calculations/$prefix.hets.temp.txt
grep "#" AB_calculations/$prefix.vcf > AB_calculations/$prefix.header
cat AB_calculations/$prefix.header AB_calculations/$prefix.hets.temp.txt > AB_calculations/$prefix.hets.temp.vcf
rm AB_calculations/$prefix.header AB_calculations/$prefix.hets.temp.txt
$keepgeno AB_calculations/$prefix.hets.temp.vcf DP | grep -v "#" | cut -f 10- > AB_calculations/$prefix.DP.txt
$keepgeno AB_calculations/$prefix.hets.temp.vcf RO | grep -v "#" | cut -f 10- > AB_calculations/$prefix.RO.txt
$keepgeno AB_calculations/$prefix.hets.temp.vcf AO | grep -v "#" | cut -f 10- > AB_calculations/$prefix.AO.txt
paste AB_calculations/$prefix.DP.txt AB_calculations/$prefix.RO.txt AB_calculations/$prefix.AO.txt | grep -v "\." > AB_calculations/$prefix.hets.read_counts.txt
awk '$1 >= 15 {print $3/$1}' AB_calculations/$prefix.hets.read_counts.txt > AB_calculations/$prefix.AO_ratio.txt
rm AB_calculations/$prefix.vcf AB_calculations/$prefix.hets.temp.vcf AB_calculations/$prefix.DP.txt AB_calculations/$prefix.RO.txt AB_calculations/$prefix.AO.txt AB_calculations/$prefix.hets.read_counts.txt
wc -l AB_calculations/$prefix.AO_ratio.txt >> total.txt
awk '{print $1-0.5}' AB_calculations/$prefix.AO_ratio.txt > AB_calculations/$prefix.deviations.txt
sed -i 's/-//g' AB_calculations/$prefix.deviations.txt
awk '$1 > 0.3 {print $0}' AB_calculations/$prefix.deviations.txt | wc -l >> deviations.txt
done

paste samples.txt total.txt deviations.txt > temp.txt
awk '{print $1,$4/$2}' temp.txt > AB_deviation_percent.txt
rm temp.txt total.txt deviations.txt samples.txt
awk '$2 <= 0.2 {print $1}' AB_deviation_percent.txt > all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB_filtered.txt
