## Data Cleanup Procedure
### Part 1: Rename Files
Rename files for compatibility with downstream pipelines
###### This step uses the script [`Rename_Fastq.sh`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/Rename_Fastq.sh).
```
../script/Rename_Fastq.sh
```
Check the number of files present for each population/group under the new naming scheme
###### __Group Designations:__
###### - S = _Anolis smaragdinus_ (outgroup)
###### - P = _Anolis porcatus_ (pure parental from western Cuba)
###### - C = _Anolis carolinensis_ (pure parental from Hobe Sound, Florida)
###### - H = Potential hybrids (_A. carolinensis_ x _A. porcatus_)
```
find ./ -name 'S*' | wc
find ./ -name 'P*' | wc
find ./ -name 'C*' | wc
find ./ -name 'H*' | wc
```
  
### Part 2: Read Trimming  
Send adapter file from home desktop to remote directory  
```
scp ~/Desktop/TruSeq3-PE-2.fa tylerdevos@ssh3.hac.uri.edu:../../data/kolbelab/Tyler_folder/raw_data
```
Trim reads using the program Trimmomatic  
###### This step uses the script [`Trimmomatic_Clean.sh`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/Trimmomatic_Clean.sh) and the adapter file [`TruSeq3-PE-2.fa`](https://github.com/tylerdevos/Thesis_code/blob/main/Other_files/TruSeq3-PE-2.fa).  
###### Trimming parameters were as follows:
###### - Cut illumina-specific sequences from the reads
###### - Cut bases off the start and end of reads if below a quality score of 20
###### - Scan each read with a 3 base wide window and cut any windows in which the average quality score drops below 15
###### - Cut reads below a length of 36 bp
###### Only paired versions of the trimmed reads were retained following completion of the trimming process
```
sbatch ../script/Trimmomatic_Clean.sh
```
Move trimmed reads to their own directory
```
mkdir ../trimmed_data
mv *R1.fq.gz ../trimmed_data
mv *R2.fq.gz ../trimmed_data
```
  
### Part 3: Read Mapping and SNP Calling
Place untrimmed reads, trimmed reads, and reference genome in a single directory
```
mkdir ddocent_input
cp raw_data/*fq.gz ddocent_input/
cp trimmed_data/*fq.gz ddocent_input/
mv reference.fna ddocent_input/reference.fasta
```
Optional: remove unassigned scaffolds from reference genome prior to mapping (did not do this for final dataset)
```
module load SAMtools/1.9-foss-2018b
samtools faidx reference.fasta
samtools faidx reference.fasta NC_014776.1 NC_014777.1 NC_014778.1 NC_014779.1 NC_014780.1 NC_014781.1 NC_014782.1 NC_014783.1 NC_014784.1 NC_014785.1 NC_014786.1 NC_014787.1 NC_014788.1 NC_010972.2 > reduced_reference.fasta
```
Send config file from home desktop to ddocent input directory  
```
scp ~/Desktop/config.file tylerdevos@ssh3.hac.uri.edu:../../data/kolbelab/Tyler_folder/ddocent_input
```
Map reads and call SNPs using the program dDocent
###### This step uses the script [`ddocent.sh`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/ddocent.sh) and the config file [`config.file`](https://github.com/tylerdevos/Thesis_code/blob/main/Other_files/config.file).
###### Reads were mapped using a mismatch value of 4 and a gap opening penalty of 6.
```
sbatch ../script/ddocent.sh
```
Determine the proportion of bases in the reference genome covered by the mapped reads
###### Divide the number of mapped bases (`awk '{SUM+=$3-$2+1}END{print SUM}' mapped.bed`) by the total number of bases in the reference genome (`grep -v ">" reference.fasta | wc | awk '{print $3-$1}'`).
  
### Part 4: SNP Filtering
Copy all raw SNPs into a filtering directory
###### I copied the files into multiple subdirectories so that they could be filtered in multiple ways simultaneously.
```
mkdir Filtering_input
mkdir Filtering_input/Filter_NS70
mkdir Filtering_input/Filter_NS90
mkdir Filtering_input/Filter_NS95
cp raw.vcf/raw* Filtering_input/Filter_NS70
cp raw.vcf/raw* Filtering_input/Filter_NS90
cp raw.vcf/raw* Filtering_input/Filter_NS95
```
Filter SNPs using the program dDocent
###### This step uses the scripts [`VCF_Filtering_70.sh`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/VCF_Filtering_70.sh), [`VCF_Filtering_90.sh`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/VCF_Filtering_90.sh), and [`VCF_Filtering_95.sh`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/VCF_Filtering_95.sh) to filter SNPs at call rates of 70%, 90%, and 95%, respectively.
###### Filtering parameters (in addition to the script-specific call rate specification) were as follows:
###### -  Only bi-allelic markers were retained
###### -  Complex variants (non-SNPs) were excluded
###### -  Markers with quality scores less than or equal to 20 were excluded
###### -  Genotypes with fewer than 4 reads were marked as missing data
###### -  Markers with minor allele frequencies less than or equal to 3% were excluded
###### -  Individual samples with more than 30% missing data were excluded
```
cd Filtering_input/Filter_NS70
sbatch ../../../script/VCF_Filtering_70.sh
cd ../Filter_NS90
sbatch ../../../script/VCF_Filtering_90.sh
cd ../Filter_NS95
sbatch ../../../script/VCF_Filtering_95.sh
```
Optional: Fix missing contig lines in header of filtered VCF (modify and repeat for each file as necessary/desired)
```
grep '#' all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.vcf > old_header.txt
head -4 old_header.txt > header_top.txt
grep '##contig' ../../raw.vcf/raw.01.vcf > header_middle.txt
awk 'NR > 5' old_header.txt > header_bottom.txt
cat header_top.txt header_middle.txt header_bottom.txt > new_header.txt
grep -v '#' all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.vcf > filtered_no_header.txt
cat new_header.txt filtered_no_header.txt > all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.vcf
rm old_header.txt header_top.txt header_middle.txt header_bottom.txt new_header.txt filtered_no_header.txt
```
### Part 5: Allele Balance Assessment
Calculate per-sample allele balance (perform this step only for the VCF filtered at a call rate of 70%)
###### This step uses the script [`Allele_Balance.sh`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/Allele_Balance.sh) to calculate allele balance ratios for heterozygote calls supported by a minimum of 15 reads. Samples are excluded if more than 20% of calls show allele balance ratios less than 0.2 or greater than 0.8.
```
cd ../Filter_NS70
sbatch ../../../script/Allele_Balance.sh
```
Create directory containing allele balance ratio lists for individual samples
```
cd AB_calculations
mkdir AO_ratios
mv *AO_ratio.txt AO_ratios/
```
Send allele balance ratio lists to home desktop for visual inspection in R
```
scp -r tylerdevos@ssh3.hac.uri.edu:/../../data/kolbelab/Tyler_folder/ddocent_input/Filtering_input/Filter_NS70/AB_calculations/AO_ratios ~/Desktop/
```
Plot allele balance ratio distributions for individual samples of interest
###### This step requires the script [`Allele_Balance_Histograms.R`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/Allele_Balance_Histograms.R), and should be run manually in the R Studio interface. Sample distributions should be unimodally centered around a peak at 0.5. The resulting plot of 2 known problematic samples and 7 randomly selected samples can be viewed [here](https://github.com/tylerdevos/Thesis_code/blob/main/Output_files/AB_histograms.pdf).

Remove any problematic samples (those not retained in the .AB_filtered.txt output file/those with unusual AB ratio distributions) from all three VCF files (70% / 90% / 95% call rates)
###### Here, individuals H_AC35 and H_JJK1950 were flagged as problematic with allele balance deviation percent values of 0.41 and 0.23, respectively.
```
vcfremovesamples all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.vcf H_AC35 H_JJK1950 > all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.vcf
vcfremovesamples all.biallelic.snps.MQ20.dp4.70d.maf3.vcf H_AC35 H_JJK1950 > all.biallelic.snps.MQ20.dp4.70d.maf3.AB.vcf
vcfremovesamples all.biallelic.snps.MQ20.dp4.70d.header.vcf H_AC35 H_JJK1950 > all.biallelic.snps.MQ20.dp4.70d.header.AB.vcf
cd ../Filter_NS90/
vcfremovesamples all.biallelic.snps.MQ20.dp4.90d.maf3.70perc_data_samples.header.vcf H_AC35 H_JJK1950 > all.biallelic.snps.MQ20.dp4.90d.maf3.70perc_data_samples.header.AB.vcf
cd ../Filter_NS95/
vcfremovesamples all.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.vcf H_AC35 H_JJK1950 > all.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.vcf
vcfremovesamples all.biallelic.snps.MQ20.dp4.95d.maf3.header.vcf H_AC35 H_JJK1950 > all.biallelic.snps.MQ20.dp4.95d.maf3.header.AB.vcf
```

### Part 6: IBS Analysis
Send partially filtered 70% and 95% call rate files to home desktop (`all.biallelic.snps.MQ20.dp4.[70/95]d.maf3.AB.vcf`)
```
scp -r tylerdevos@ssh3.hac.uri.edu:/../../data/kolbelab/Tyler_folder/ddocent_input/Filtering_input/Filter_NS70/all.biallelic.snps.MQ20.dp4.70d.maf3.AB.vcf ~/Desktop/
scp -r tylerdevos@ssh3.hac.uri.edu:/../../data/kolbelab/Tyler_folder/ddocent_input/Filtering_input/Filter_NS95/all.biallelic.snps.MQ20.dp4.95d.maf3.AB.vcf ~/Desktop/
```
Run an identity by state analysis to compare technical replicates across libraries
###### This step requires the scripts [`IBS.R`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/IBS.R) and [`Trim_IBS.sh`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/trim_IBS.sh), and should be run manually in the R Studio interface (first script)/home computer command line (second script). The process should be repeated separately for each VCF file.
###### __Results:__ The lowest IBS values observed among replicates were 0.986583 (70% call rate VCF) and 0.988466 (95% call rate VCF). In both cases, the two _smaragdinus_ samples surpassed this threshold value, but no other sample pairs came close (see histograms [here (70%)](https://github.com/tylerdevos/Thesis_code/blob/main/Output_files/IBS_results_70.pdf) and [here (95%)](https://github.com/tylerdevos/Thesis_code/blob/main/Output_files/IBS_results_95.pdf)).

Remove duplicate versions of replicate samples from the dataset
###### Here, I removed the version of each replicate individual with the lower number of reads.
```
vcfremovesamples all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.vcf H_AC18rep H_AC21rep > all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.vcf
vcfremovesamples all.biallelic.snps.MQ20.dp4.70d.header.AB.vcf H_AC18rep H_AC21rep P_JJK2793rep P_JJK2794rep P_JJK2795rep > all.biallelic.snps.MQ20.dp4.70d.header.AB.noreps.vcf
cd ../Filter_NS90/
vcfremovesamples all.biallelic.snps.MQ20.dp4.90d.maf3.70perc_data_samples.header.AB.vcf H_AC18rep H_AC21rep P_JJK2793rep P_JJK2794rep P_JJK2795rep > all.biallelic.snps.MQ20.dp4.90d.maf3.70perc_data_samples.header.AB.noreps.vcf
cd ../Filter_NS95/
vcfremovesamples all.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.vcf H_AC18rep H_AC21rep P_JJK2793rep P_JJK2794rep P_JJK2795rep > all.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.noreps.vcf
```

### Part 7: Summarize File Contents
Count the number of position-specific SNPs in each of the final files
```
cd ../Filter_NS70/
grep -v '#' all.biallelic.snps.MQ20.dp4.70d.header.AB.noreps.vcf | wc -l
grep -v '#' all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.vcf | wc -l
cd ../Filter_NS90/
grep -v '#' all.biallelic.snps.MQ20.dp4.90d.maf3.70perc_data_samples.header.AB.noreps.vcf | wc -l
cd ../Filter_NS95/
grep -v '#' all.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.noreps.vcf | wc -l
```
Check the number of individuals retained in each of the final files
```
cd ../Filter_NS70/
awk '{if ($1 == "#CHROM"){print NF-9; exit}}' all.biallelic.snps.MQ20.dp4.70d.header.AB.noreps.vcf
awk '{if ($1 == "#CHROM"){print NF-9; exit}}' all.biallelic.snps.MQ20.dp4.70d.maf3.70perc_data_samples.header.AB.noreps.vcf
cd ../Filter_NS90/
awk '{if ($1 == "#CHROM"){print NF-9; exit}}' all.biallelic.snps.MQ20.dp4.90d.maf3.70perc_data_samples.header.AB.noreps.vcf
cd ../Filter_NS95/
awk '{if ($1 == "#CHROM"){print NF-9; exit}}' all.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.noreps.vcf
```
__Results:__
###### - 70% call rate (partially filtered): 1,088,807 SNPs, 103 individuals retained
###### - 70% call rate: 222,567 SNPs, 100 individuals retained (missing H_MIA670, S_JBL4329, and S_JBL4330)
###### - 90% call rate: 166,030 SNPs, 103 individuals retained
###### - 95% call rate: 147,594 SNPs, 103 individuals retained

### Part 8: Pruning for Linkage Disequilibrium
Remove _smaragdinus_ samples from the fully filtered, 95% call rate dataset
```
module load ddocent
vcfremovesamples all.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.noreps.vcf S_JBL4329 S_JBL4330 > all.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.noreps.nosmaragdinus.vcf
```
Impute missing data with beagle
###### This step requires the script [`beagle_for_LD.sh`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/beagle_for_LD.sh). Any loci too sparse for BEAGLE to impute can be removed by creating a list of the chromosome and base positions of the problematic loci and then running the command `grep -Fwvf snp_exclude_list.txt all.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.noreps.nosmaragdinus.vcf > all.biallelic.snps.MQ20.dp4.95d.maf3.70perc_data_samples.header.AB.noreps.nosmaragdinus.cleaned.vcf`.
```
sbatch ../../script/beagle_for_LD.sh
```
Convert imputed VCF to .bed format
```
module load PLINK/1.9b_6.21-x86_64
plink --vcf imputed.vcf --make-bed --out imputed --allow-extra-chr
```
Prune loci using the R program bigsnpr
###### This step requires the scripts [`bigsnpr.sh`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/bigsnpr.sh) and [`bigsnpr.R`](https://github.com/tylerdevos/Thesis_code/blob/main/Short_script/bigsnpr.R). Smoothing of p-values was suppressed (`roll.size=0`) to avoid errors caused by short scaffolds.
```
sbatch ../../script/bigsnpr.sh
```
Remove pruned loci from VCF
```
grep -Fwf bigsnpr_filtered_loci imputed.vcf > loci.txt
grep '#' imputed.vcf > header.txt
cat header.txt loci.txt > LD_filtered_loci.vcf
```

  
  
### [<<< Back to Page 2: Quality Check](https://github.com/tylerdevos/Thesis_code/blob/main/2_Initial_Data_Quality_Check_Procedure.md)                    [To Page 4: Data Analysis >>>](https://github.com/tylerdevos/Thesis_code/blob/main/4_Data_Analysis_Procedure.md)
