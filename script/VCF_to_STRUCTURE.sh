#script provided by Dan Bock

module load ddocent
keepgeno='vcfkeepgeno'
names='vcfsamplenames'
sort='vcfsort'

#convert VCF files to STRUCTURE format
#the input VCF consists of 10k random filtered SNPs (at 95% call rate)

infile='10Ksubset_no_smaragdinus'
#get only genotpes from vcf
$keepgeno $infile.vcf GT | grep -v "#" | cut -f 10- > $infile.geno
#transpose genotype files
END="$(awk '{print NF;exit}' $infile.geno)"
for ((i=1;i<=$END;i++))
do
    cut -f $i $infile.geno > geno.$i
    sed -i ':a;N;$!ba;s/\n/ /g' geno.$i
done
cat $(ls geno.* | sort -V) > $infile.geno.transposed
rm geno.*
#change missing data format 
sed -i 's/\./-9 -9/g' $infile.geno.transposed
#alleles separated by single space
sed -i 's/\// /g' $infile.geno.transposed
#sample name format and add population ID column
#a file named population_ID should be created with a list of ordered integers corresponding to population IDs if using prior population information for clustering
$names $infile.vcf > sample_names
paste sample_names population_ID > sample_names.with_pop
#paste header and data files
paste -d ' ' sample_names.with_pop $infile.geno.transposed > $infile.str
rm *.transposed *.geno sample_names*
