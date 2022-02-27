## STRUCTURE
Convert VCF file to STRUCTURE format
###### This step requires the script [`VCF_to_STRUCTURE.sh`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/VCF_to_STRUCTURE.sh) and the [`population_ID`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/population_ID) file created for the DAPC analysis (previous page)
```
./VCF_to_STRUCTURE.sh
```
Create and prepare directories for parallelized STRUCTURE runs
```
mkdir k1 k2 k3 k4 k5 k6 k7 k8 log
cd log
mkdir k1 k2 k3 k4 k5 k6 k7 k8
cd ../
```
Activate and run STRUCTURE (20 replicates each for K values 1-8)
###### This step requires various K-modified versions of the script [`STRUCTURE_K1.sh`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/STRUCTURE_K1.sh). The files [`mainparams`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/mainparams) and [`extraparams`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/extraparams) must be customized and placed in the directory in which STRUCTURE is being run. Parameter options are described in detail in the [STRUCTURE manual](https://web.stanford.edu/group/pritchardlab/structure_software/release_versions/v2.3.4/structure_doc.pdf).
```
module load Structure/2.3.4-iccifort-2019.5.281
sbatch ./STRUCTURE_K1.sh
sbatch ./STRUCTURE_K2.sh
sbatch ./STRUCTURE_K3.sh
sbatch ./STRUCTURE_K4.sh
sbatch ./STRUCTURE_K5.sh
sbatch ./STRUCTURE_K6.sh
sbatch ./STRUCTURE_K7.sh
sbatch ./STRUCTURE_K8.sh
```
Create directories and files for final steps
###### A file of individual sample names ordered as desired for plotting ([`samples_ordered.txt`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/samples_ordered.txt)) must be placed in the directory before running this step. The contents of `population_ID` must be reordered to correspond to `samples_ordered.txt` if they do not already match.
```
mkdir all_results_files
cp k1/Anolis* all_results_files/
cp k2/Anolis* all_results_files/
cp k3/Anolis* all_results_files/
cp k4/Anolis* all_results_files/
cp k5/Anolis* all_results_files/
cp k6/Anolis* all_results_files/
cp k7/Anolis* all_results_files/
cp k8/Anolis* all_results_files/
mkdir membership_plots
cp samples_ordered.txt membership_plots/
paste samples_ordered.txt population_ID > membership_plots/metadata.csv
```
Reorder results files for plotting
###### This step requires the script [`reorder_samples_STRUCTURE.sh`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/reorder_samples_STRUCTURE.sh), which reorders all results files in the `membership_plots` directory based on the ordering of individuals in `samples_ordered.txt`.
```
cd membership_plots/
cp ../k1/Anolis_k1_run7_f ./Anolis_k1
cp ../k2/Anolis_k2_run7_f ./Anolis_k2
cp ../k3/Anolis_k3_run7_f ./Anolis_k3
cp ../k4/Anolis_k4_run7_f ./Anolis_k4
cp ../k5/Anolis_k5_run7_f ./Anolis_k5
cp ../k6/Anolis_k6_run7_f ./Anolis_k6
cp ../k7/Anolis_k7_run7_f ./Anolis_k7
cp ../k8/Anolis_k8_run7_f ./Anolis_k8
../../../script/Reorder_Samples_STRUCTURE.sh
rm Anolis_k1
rm Anolis_k2
rm Anolis_k3
rm Anolis_k4
rm Anolis_k5
rm Anolis_k6
rm Anolis_k7
rm Anolis_k8
```
Plot STRUCTURE results
###### This step requires the script [`plot_STRUCTURE_results.R`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/plot_STRUCTURE_results.R), and should be run manually in the R Studio interface.
  
### [<<< Back to Page 4: DAPC](https://github.com/tylerdevos/green_anole_hybridization/blob/main/4_DAPC.md)                    [To Page 6: introgress >>>](https://github.com/tylerdevos/green_anole_hybridization/blob/main/6_introgress.md)
