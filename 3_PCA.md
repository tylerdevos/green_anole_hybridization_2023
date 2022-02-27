## Principle Component Analysis
Select a random subset of ~10,000 SNPs from the fully filtered, 95% call rate file
###### Note: the `-r` flag denotes the selection probability for individual SNPs. This parameter is determined by dividing the desired number of output SNPs by the total number of SNPs in the input file.
```
module load ddocent
vcfrandomsample -r 0.06776 all.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.noreps.vcf > subset.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.noreps.vcf
```
Count the number of randomly selected SNPs in the subset file
```
grep -v '#' subset.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.noreps.vcf | wc -l
```
Count the number of header lines in the subset file
```
grep '#' subset.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.noreps.vcf | wc -l
```
Copy the header lines and first 10,000 SNPs in the subset file into a new file
###### The `-n` flag should be set to 10,000 + the number of header lines in the subset file
```
head -n 16523 subset.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.noreps.vcf > 10Ksubset.vcf
```
Check that there are exactly 10,000 SNPs in the final subset VCF
```
grep -v '#' 10Ksubset.vcf | wc -l
```
Convert subsetted VCF file to adegenet format for use in R
###### This step uses the script [`VCF_to_adegenet.sh`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/VCF_to_adegenet.sh), within which line 9 must be modified on a per-file basis. A file named [`population.temp`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/population.temp) (containing a population designation for each individual) must also be placed in the directory in which the script is being run.
```
sbatch ./VCF_to_Adegenet.sh
```
Perform PCA using the R program adegenet
###### This step uses the script [`adegenet_PCA.R`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/adegenet_PCA.R), within which line 17 must be modified on a per-file basis. Two output files are produced: one containing PC scores, and one containing eigenvalues.
```
Rscript ./adegenet_PCA.R 10Ksubset.snp
```
Plot PCA results
###### This step requires the script [`plot_PCA.R`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/plot_PCA.R), and should be run manually in the RStudio interface.


 ### [<<< Back to Page 2: Data Cleanup](https://github.com/tylerdevos/green_anole_hybridization/blob/main/2_data_cleanup.md)                    [To Page 4: DAPC >>>](https://github.com/tylerdevos/green_anole_hybridization/blob/main/4_DAPC.md)
