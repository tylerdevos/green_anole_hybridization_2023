## Bayesian Estimation of Genomic Clines
Remove loci without allele depth information from the VCF of ancestry-informative markers (generated for introgress analysis two pages back)
###### Some depth values are lost during decomposition of multiple nucleotide polymorphisms by vcfallelicprimatives in the `ID_AIMs_fixed.sh` script, and cannot be reconstructed due to the multiple sample nature of the VCF.
```
grep '#' AIMs_fixed.vcf > header.txt
grep -v '#' AIMs_fixed.vcf > AIMs_fixed.txt
grep 'AB' AIMs_fixed.txt > AIMs_fixed.with_allele_depth.txt
cat header.txt AIMs_fixed.with_allele_depth.txt > AIMs_fixed.with_allele_depth.vcf
```
Convert VCF to bgc input format
###### This step requires the script [`VCF_to_bgc.py`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/VCF_to_bgc.py) and a tab separated file ([`popmap`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/popmap)) containing a population designation for each sample in the input VCF.
```
module load PyVCF/0.6.8-GCC-8.3.0-Python-2.7.16
./VCF_to_bgc.py -v AIMs_fixed.with_allele_depth.vcf -m popmap --p1 porcatus --p2 carolinensis --admixed hybrid -o AIMs_bgc -l
```
Run bgc (this can take days to weeks)
###### This step requires the script [`bgc.sh`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/bgc.sh). Analysis specifications are as follows:
###### - Perform 100,000 MCMC steps (don't discard any now, but the first 50,000 will later be removed as burnin)
###### - Genotype-uncertainty model included with a sequence error probability of 0.001
###### - ICARrho model for linked loci included with a maximum free recombination distance of 0.5.

```
module load bgc/1.03-gompi-2020b
sbatch --exclusive --nodes=1 --mail-type=END --mail-user=[your_email_here] ./bgc.sh
```
Convert bgc output from HDF5 format to ASCII using estpost
```
estpost -i anolis.hdf5 -p LnL -o out_bgc_stat_LnL_1 -s 2 -w 0
estpost -i anolis.hdf5 -p alpha -o out_bgc_stat_a0_1 -s 2 -w 0
estpost -i anolis.hdf5 -p beta -o out_bgc_stat_b0_1 -s 2 -w 0
estpost -i anolis.hdf5 -p hi -o out_bgc_stat_hi_1 -s 2 -w 0
estpost -i anolis.hdf5 -p gamma-quantile -o out_bgc_stat_qa_1 -s 2 -w 0
estpost -i anolis.hdf5 -p zeta-quantile -o out_bgc_stat_qb_1 -s 2 -w 0
mkdir output
mv out_* output/
cp popmap output/
cp AIMs_bgc_loci.txt output/loci
```
Concatenate output files and identify outliers
###### This step requires the scripts [`bgc_analysis.sh`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/bgc_analysis.sh) and [`bgc_analysis.R`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/bgc_analysis.R).
```
sbatch ./bgc_analysis.sh
```

Plot outlier loci (genomic cline plot, alpha-beta contour plot, and ideogram)
###### This step requires the script [`plot_genomic_clines.R`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/plot_genomic_clines.R), and should be run manually in the R Studio interface. Parameter plots should be inspected for convergence before plotting/interpreting cline data.

### [<<< Back to Page 7: FST](https://github.com/tylerdevos/green_anole_hybridization/blob/main/7_FST.md)                    [To Page 9: Environmental Association Analyses>>>](https://github.com/tylerdevos/green_anole_hybridization/blob/main/9_environmental_association_analyses.md)
