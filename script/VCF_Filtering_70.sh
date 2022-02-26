#!/bin/bash
#SBATCH -t 900:00:00
#SBATCH --exclusive --nodes=1 --ntasks-per-node=20

#script provided by Dan Bock

module load ddocent

#make a list of vcf files to be combined
ls *.vcf | sort -V > vcf.list
#all files listed on the same line, separated by space
sed -i ':a;N;$!ba;s/\n/ /g' vcf.list

#combine unfiltered vcf files
vcfcombine $(cat vcf.list) > raw.all.vcf
rm $(cat vcf.list)

#keep only biallelic markers
vcfbiallelic < raw.all.vcf > all.biallelic.vcf

#keep only snps (exclude complex variants)
vcffilter all.biallelic.vcf -f "TYPE = snp" > all.biallelic.snps.vcf

#keep only markers with mapping quality scores larger than 20
vcffilter all.biallelic.snps.vcf -f "MQM > 20 & MQMR > 20" > all.biallelic.snps.MQ20.vcf

#keep only genotypes supported by 4 or more reads (genotypes with fewer reads are changed to missing data)
vcffilter -g "DP > 3" all.biallelic.snps.MQ20.vcf > all.biallelic.snps.MQ20.dp4.vcf

#fix info field post-filtering (use vcffixup for AF, bash lines below for NS)
vcffixup all.biallelic.snps.MQ20.dp4.vcf > all.fixed_a.vcf
grep "#" all.fixed_a.vcf > all.header.temp
grep -v "#" all.fixed_a.vcf | grep -v "DP=0" > all.temp
awk -F 'NS=' '{print $1}' all.temp > all.first_column.temp
awk -F 'NS=' '{print $2}' all.temp | cut -d ";" -f 2- > all.second_column.temp
awk -F ':GL' '{print $2}' all.temp > all.genotypes.temp
sed -i 's/\.:\.:\.:\.:\.:\.:\.:\./NA/g' all.genotypes.temp
awk '{print NF}' all.genotypes.temp > total_samples.temp
awk -F 'NA' '{print NF-1}' all.genotypes.temp > missing.temp
paste total_samples.temp missing.temp > total_samples_and_missing.temp
awk '{print "NS=",$1-$2,";"}' total_samples_and_missing.temp > NS.temp
sed -i 's/ //g' NS.temp
paste -d '\0' all.first_column.temp NS.temp all.second_column.temp > all.fixed.temp
cat all.header.temp all.fixed.temp > all.biallelic.snps.MQ20.dp4.fixed.vcf
rm *.temp all.fixed_a.vcf

#filter based on call rate, keeping only SNPs with data for at least 70% of samples
vcffilter -f "NS > 70" all.biallelic.snps.MQ20.dp4.fixed.vcf > all.biallelic.snps.MQ20.dp4.70d.vcf

#filter based on minor allele frequency, keeping SNPs with maf higher than 3%
grep -v "AF=-nan" all.biallelic.snps.MQ20.dp4.70d.vcf | vcffilter -f "AF > 0.03 & AF < 0.97" > all.biallelic.snps.MQ20.dp4.70d.maf3.vcf

#quantify missing data
vcfkeepgeno all.biallelic.snps.MQ20.dp4.70d.maf3.vcf GT | grep -v "#" | cut -f 10- > all.geno.txt
END="$(awk '{print NF;exit}' all.geno.txt)"
for ((i=1;i<=$END;i++)); do
cut -f$i all.geno.txt | grep '\.' | wc -l >> all.missing_counts.txt
cut -f$i all.geno.txt | wc -l >> all.total_loci.txt
done

vcfsamplenames all.biallelic.snps.MQ20.dp4.70d.maf3.vcf > all_samples.txt
paste all.missing_counts.txt all.total_loci.txt all_samples.txt > all.counts_annotated.txt
awk '{print $3,$1*100/$2}' all.counts_annotated.txt > all.percent.missing_data
rm all.counts_annotated.txt all_samples.txt all.geno.txt all.missing_counts.txt all.total_loci.txt

#make a list of samples that have less than 30% missing data, and subset only those samples from the filtered VCF file
awk '{if ($2 <= 30) print $1}' all.percent.missing_data > all.70samples_to_keep.txt
sed -i ':a;N;$!ba;s/\n/ /g' all.70samples_to_keep.txt

cat all.70samples_to_keep.txt | while read line
do
samples=$line
vcfkeepsamples all.biallelic.snps.MQ20.dp4.70d.maf3.vcf $samples > all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.vcf
done

