#!/bin/bash
#script provided by Dan Bock

#change these variables to fit the path on your system
biallelic='vcfbiallelic'
combine='vcfcombine'
filter='vcffilter'
fixup='vcffixup'
info='vcfkeepinfo'
keepgeno='vcfkeepgeno'
keepsamples='vcfkeepsamples'
names='vcfsamplenames'
removesamples='vcfremovesamples'
mnp_snp='vcfallelicprimitives'
sort='vcfsort'

module load ddocent
module load BCFtools/1.9-foss-2018b
module load BEDTools/2.27.1-foss-2018b


#make separate VCF files for the carolinensis and porcatus samples (goal is to identify AIMs)
#prerequisites: text files of all carolinensis samples (carolinensis.txt) and all porcatus samples (porcatus.txt)

#make a VCF of only carolinensis samples
bcftools view -S carolinensis.txt all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.vcf > carolinensis.vcf

#make a VCF of only porcatus samples
bcftools view -S porcatus.txt all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.vcf > porcatus.vcf


#update the NS values in the INFO field (needed to filter for call rate) and keep SNPs with data in at least 70% of samples
for input in {"carolinensis","porcatus"}
do
$fixup $input.vcf > $input.fixed_a.vcf
grep "#" $input.fixed_a.vcf > $input.header.temp
grep -v "#" $input.fixed_a.vcf | grep -v "DP=0" > $input.all.temp
awk -F 'NS=' '{print $1}' $input.all.temp > $input.all.first_column.temp
awk -F 'NS=' '{print $2}' $input.all.temp | cut -d ";" -f 2- > $input.all.second_column.temp
awk -F ':GL' '{print $2}' $input.all.temp > $input.all.genotypes.temp
sed -i.bak 's/\.:\.:\.:\.:\.:\.:\.:\./NA/g' $input.all.genotypes.temp
awk '{print NF}' $input.all.genotypes.temp > $input.total_samples.temp
awk -F 'NA' '{print NF-1}' $input.all.genotypes.temp > $input.missing.temp
paste $input.total_samples.temp $input.missing.temp > $input.total_samples_and_missing.temp
awk '{print "NS=",$1-$2,";"}' $input.total_samples_and_missing.temp > $input.NS.temp
sed -i.bak 's/ //g' $input.NS.temp
paste -d '\0' $input.all.first_column.temp $input.NS.temp $input.all.second_column.temp > $input.all.fixed.temp
cat $input.header.temp $input.all.fixed.temp > $input.fixed_b.vcf
rm *.temp *.bak *.fixed_a.vcf
done

$filter -f "NS > 12" carolinensis.fixed_b.vcf > carolinensis.70d.vcf
$filter -f "NS > 11" porcatus.fixed_b.vcf > porcatus.70d.vcf

#get only markers present at high or low allele frequencies in each sample group (these will be intersected in the next step)
for input in {"carolinensis","porcatus"}
do
grep -v "AF=-nan" $input.70d.vcf | $filter -f "AF < 0.001" > $input.70d.maf0.vcf
grep -v "AF=-nan" $input.70d.vcf | $filter -f "AF > 0.999" > $input.70d.maf100.vcf
#break up multiple nucleotide polymorphisms (bedtools compatibility)
$mnp_snp $input.70d.maf0.vcf > snp.$input.70d.maf0.vcf
$mnp_snp $input.70d.maf100.vcf > snp.$input.70d.maf100.vcf
sed -i 's/|/\//g' snp.$input.70d.maf0.vcf
sed -i 's/|/\//g' snp.$input.70d.maf100.vcf
done

#find AIM positions by intersecting the vcf files for carolinensis and porcatus, each with contrasting AF (20% and 80%)
#the outputs are .txt files (no VCF header)
#AIM1 are SNPs with small alternate allele frequency in carolinensis
#AIM2 are SNPs with large alternate allele frequency in carolinensis
bedtools intersect -a snp.carolinensis.70d.maf0.vcf -b snp.porcatus.70d.maf100.vcf -wa > snp.carolinensis.AIM1.txt
bedtools intersect -a snp.carolinensis.70d.maf100.vcf -b snp.porcatus.70d.maf0.vcf -wa > snp.carolinensis.AIM2.txt
#get columns 1 & 2 from the outputs (chromosome and bp)
cut -f 1,2 snp.carolinensis.AIM1.txt > snp.carolinensis.AIM1.positions
sed -i 's/\t/_/g' snp.carolinensis.AIM1.positions
cut -f 1,2 snp.carolinensis.AIM2.txt > snp.carolinensis.AIM2.positions
sed -i 's/\t/_/g' snp.carolinensis.AIM2.positions
rm snp.carolinensis.AIM1.txt snp.carolinensis.AIM2.txt

#separate temporal samples (invasive samples with temporal replicates) from the final filtered VCF file (obtained using the "vcf_filtering.sh" script), and annotate it with position information (to be used for separating SNPs identified as AIMs)
$mnp_snp all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.vcf > snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.vcf
sed -i 's/|/\//g' snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.vcf
grep -v "#" snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.vcf > snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.txt
grep "#" snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.vcf > header.txt
cut -f 1-2 snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.txt > all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.positions.txt
sed -i 's/\t/_/g' all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.positions.txt
paste all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.positions.txt snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.txt > snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.annotated.txt

#use grep to isolate AIM1 and AIM2 positions from the temporal samples annotated VCF file
for AIM in {"AIM1","AIM2"}
do
cat snp.carolinensis.$AIM.positions | while read line
do
	prefix=$line
	grep -w -m 1 $prefix snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.annotated.txt >> snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.annotated.carolinensis.txt
done
cut -f 2- snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.annotated.carolinensis.txt > snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.carolinensis.txt
cat header.txt snp.all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.carolinensis.txt > AIMs_fixed.vcf
done

