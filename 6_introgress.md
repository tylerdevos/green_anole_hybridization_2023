### Part 6: INTROGRESS
Identify and create a subset of ancestry-informative markers (AIMs)
###### This step requires the script [`ID_AIMs_fixed.sh`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/ID_AIMs_fixed.sh), along with text files listing which individuals belong to each parental population (`carolinensis.txt` and `porcatus.txt`). AIMs retained are those which display fixed differences (FST=1) between parental populations.
```
sbatch ./ID_AIMs_fixed.sh
```
Convert VCF to INTROGRESS format
###### This step requires the script [`VCF_to_introgress.py`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/VCF_to_introgress.py) and an additional input file ([`assignment_file.csv`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/assignment_file.csv)) containing sample names, population IDs, and population assignment probabilities from STRUCTURE.
```
module load PyVCF/0.6.8-GCC-8.3.0-Python-2.7.16
./VCF_to_introgress.py AIMs_fixed.vcf assignment_file.csv 0.999 0 introgress_input --include
```
Process and plot data using the R package introgress (triangle plot & ancestry plot)
###### This step requires the script [`introgress.R`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/introgress.R), and should be run manually in the R Studio interface.
  
### [<<< Back to Page 5: STRUCTURE](https://github.com/tylerdevos/green_anole_hybridization/blob/main/5_STRUCTURE.md)                    [To Page 7: FST >>>](https://github.com/tylerdevos/green_anole_hybridization/blob/main/7_FST.md)
