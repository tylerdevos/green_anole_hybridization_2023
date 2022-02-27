## Discriminant Analysis of Principal Components
Create a metadata file with sample names and population designations
###### A file of ordered integers corresponding to population designations, named [`population_ID`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/other_files/population_ID), must be placed in the directory in which the script is run.
```
module load ddocent
vcfsamplenames 10Ksubset.vcf > sample_names.txt
paste sample_names.txt population_ID > metadata.csv
```
Perform DAPC using the R package adegenet
###### This step requires the script [`DAPC.R`](https://github.com/tylerdevos/green_anole_hybridization/blob/main/script/DAPC.R), and should be run manually in the RStudio interface.


 ### [<<< Back to Page 3: PCA](https://github.com/tylerdevos/green_anole_hybridization/blob/main/3_PCA.md)                    [To Page 5: STRUCTURE >>>](https://github.com/tylerdevos/green_anole_hybridization/blob/main/5_STRUCTURE.md)
