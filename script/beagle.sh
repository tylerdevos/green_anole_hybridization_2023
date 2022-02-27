#!/bin/bash
#script provided by Dan Bock

#change these variables to fit the path on your system
keepgeno='vcfkeepgeno'
mnp_snp='vcfallelicprimitives'

module load ddocent
module load Java/1.8

#impute missing genotype data using BEAGLE
#make sure all fields are tab-separated
sed -i 's/\s/\t/g' all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.vcf

#convert multi-nucleotide polymorphisms to SNPs for BEAGLE compatibility
$mnp_snp all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.vcf > snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.vcf

#keep only genotype field
$keepgeno snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.vcf GT > snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.GT.vcf
sed -i 's/\t\./\t\.\/\./g' snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.GT.vcf
sed -i 's/|/\//g' snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.GT.vcf
sed -i 's/\.\/\.\tA/\.\tA/g' snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.GT.vcf
sed -i 's/\.\/\.\tC/\.\tC/g' snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.GT.vcf
sed -i 's/\.\/\.\tG/\.\tG/g' snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.GT.vcf
sed -i 's/\.\/\.\tT/\.\tT/g' snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.GT.vcf

#impute missing genotypes using BEAGLE at default settings
java -jar beagle.28Jun21.220.jar gt=snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.GT.vcf out=snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.imputed
gunzip snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.imputed.vcf.gz
sed -i 's/|/\//g' snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.imputed.vcf
rm *.log snp.*
