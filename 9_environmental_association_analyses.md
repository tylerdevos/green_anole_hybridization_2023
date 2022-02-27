## Environmental Association Analyses
### Part 1: Latent Factor Mixed Models
Create a version of the fully filtered 70% call rate dataset containing only hybrid individuals (I also removed hybrid JJK3423 here since we don't have environmental data for that individual)
```
vcfremovesamples all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.vcf H_JJK3423 C_CRYO4393 C_CRYO4394 C_CRYO4395 C_CRYO4397 C_CRYO4398 C_CRYO4399 C_CRYO4400 C_CRYO4401 C_CRYO4402 C_CRYO4403 C_CRYO4404 C_CRYO4405 C_CRYO4406 C_CRYO4407 H_JJK1932 H_JJK1933 P_JJK2793 P_JJK2794 P_JJK2795 P_JJK2796 P_JJK2797 P_JJK2799 P_JJK2800 P_JJK2825 P_JJK2827 P_JJK2830 P_JJK2832 P_JJK3066 P_JJK3068 P_JJK3070 P_JJK3071 S_JBL4329 S_JBL4330 > all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.only_hybrids.vcf
```
Create a chromosome map and use this to convert the VCF file to .ped format
```
grep -v "#" all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.only_hybrids.vcf | cut -f 1 | uniq | awk '{print $0"\t"$0}' > chrom-map.txt
vcftools --vcf all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.only_hybrids.vcf --out genotypes --chrom-map chrom-map.txt --plink
```
Count number of loci on each chromosome (these numbers are needed for manual modifications to the `LFMM.R` script below)
```
grep -v "#" all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.only_hybrids.vcf > markers.vcf
grep "NC_014776.1" markers.vcf | wc -l
grep "NC_014777.1" markers.vcf | wc -l
grep "NC_014778.1" markers.vcf | wc -l
grep "NC_014779.1" markers.vcf | wc -l
grep "NC_014780.1" markers.vcf | wc -l
grep "NC_014781.1" markers.vcf | wc -l

grep "NC_014782.1" markers.vcf | wc -l
grep "NC_014783.1" markers.vcf | wc -l
grep "NC_014784.1" markers.vcf | wc -l
grep "NC_014785.1" markers.vcf | wc -l
grep "NC_014786.1" markers.vcf | wc -l
grep "NC_014787.1" markers.vcf | wc -l
grep "NC_014788.1" markers.vcf | wc -l

grep "NW_00*" markers.vcf | wc -l
```
Assess enviornmental associations using latent factor mixed models
###### This step requires the script [`LFMM.R`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/LFMM.R) and a file of ordered environmental variables named [`environment.csv`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/environment.csv), and should be run manually in the R Studio interface.

Bonus: print lines from VCF file corresponding to loci identified as significant
```
grep -v '#' all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.only_hybrids.vcf > noheader.txt
sed '2922q;d' noheader.txt
sed '50335q;d' noheader.txt
sed '50338q;d' noheader.txt
```
   
### Part 2: Additional Tests
Compare average habitat characteristics between the two hybrid groups using Wilcoxon rank-sum, Mantel, and partial Mantel tests
###### This step requires the script [`habitat_tests.R`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/habitat_tests.R) and a [`mantel_data.csv`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/mantel_data.csv) file containing group assignment, environmental, and spatial information for each hybrid individual. This script should be run manually in the R Studio interface.

### [<<< Back to Page 8: Genomic Clines](https://github.com/tylerdevos/green_anole_hybridization/blob/main/8_genomic_clines.md)
