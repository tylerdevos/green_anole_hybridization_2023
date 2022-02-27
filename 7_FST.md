## Pairwise Windowed FST
Impute missing data with BEAGLE
###### This step requires the script [`beagle.sh`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/beagle.sh). A partially filtered version of the 70% call rate VCF (all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.vcf) should be used for this analysis. Any loci too sparse for BEAGLE to impute can be removed by creating a list of the chromosome and base positions of the problematic loci and then running the command `grep -Fwvf snp_exclude_list.txt all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.vcf > all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.cleaned.vcf`.
```
sbatch ./beagle.sh
```
Calculate FST for each group
###### This step requires a set of .txt files listing which individuals belong to each group ([`carolinensis.txt`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/carolinensis.txt), [`hybrid.txt`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/hybrid.txt), and [`porcatus.txt`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/porcatus.txt)). Window size is set to 50,000 bp.
```
module load ddocent
vcftools --vcf snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.imputed.vcf --weir-fst-pop carolinensis.txt --weir-fst-pop hybrid.txt --fst-window-size 50000 --out CH_FST
vcftools --vcf snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.imputed.vcf --weir-fst-pop porcatus.txt --weir-fst-pop hybrid.txt --fst-window-size 50000 --out PH_FST
vcftools --vcf snp.all.biallelic.snps.MQ20.dp4.70d.maf3.AB.noreps.imputed.vcf --weir-fst-pop carolinensis.txt --weir-fst-pop porcatus.txt --fst-window-size 50000 --out CP_FST
```
Plot FST
###### This step requires the script [`plot_FST.R`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/plot_FST.R), and should be run manually in the R Studio interface.

### [<<< Back to Page 6: introgress](https://github.com/tylerdevos/green_anole_hybridization/blob/main/6_introgress.md)                    [To Page 8: Genomic Clines >>>](https://github.com/tylerdevos/green_anole_hybridization/blob/main/8_genomic_clines.md)
