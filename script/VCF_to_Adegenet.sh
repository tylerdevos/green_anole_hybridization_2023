#!/bin/bash
#SBATCH -t 900:00:00
#SBATCH --exclusive --nodes=1 --ntasks-per-node=20

#script provided by Dan Bock and modified by Tyler DeVos

module load ddocent

input='10Ksubset_no_smaragdinus'
#break up multiple nucleotide polymorphisms
vcfallelicprimitives $input.vcf | vcfuniq > snp.$input.vcf
sed -i 's/|/\//g' snp.$input.vcf

#make position vector (using line numbers)
    grep -v "#" snp.$input.vcf > snp.$input.txt
    awk '{print NR}' snp.$input.txt > position.temp
    sed -i ':a;N;$!ba;s/\n/ /g' position.temp
    echo ">> position" > position_header
    cat position_header position.temp > position
    rm position_header position.temp

#make allele vector
    awk '{print $4,$5}' snp.$input.txt > allele.temp
    sed  -i 's/\s/\//g' allele.temp
    sed -i 's/A/a/g' allele.temp
    sed -i 's/T/t/g' allele.temp
    sed -i 's/C/c/g' allele.temp
    sed -i 's/G/g/g' allele.temp
    sed -i ':a;N;$!ba;s/\n/ /g' allele.temp
    echo ">> allele" > allele_header
    cat allele_header allele.temp > allele
    rm allele_header allele.temp


#make population vector (this step requires a file named `population.temp`, which should contain an ordered, one-word population designation for each individual)
    vcfsamplenames snp.$input.vcf > $input.sample_names.txt
    sed -i ':a;N;$!ba;s/ /\n/g' $input.sample_names.txt
    sed -i ':a;N;$!ba;s/\n/ /g' population.temp
    echo ">> population" > population_header
    cat population_header population.temp > population  
    rm population_header

#make genotypes vector
    vcfkeepgeno snp.$input.vcf GT | grep -v "#" | cut -f 10- > $input.geno
    sed -i 's/0\/0/0/g' $input.geno
    sed -i 's/0\/1/1/g' $input.geno
    sed -i 's/1\/0/1/g' $input.geno
    sed -i 's/1\/1/2/g' $input.geno
    sed -i 's/\./-/g' $input.geno
    END="$(awk '{print NF;exit}' $input.geno)"
    for ((i=1;i<=END;i++)); do
    cut -f $i $input.geno > geno.$i
    sed -i ':a;N;$!ba;s/\n/ /g' geno.$i
    done
    cat $(ls geno.* | sort -V) >  $input.transposed.txt
    rm geno.* *.geno
    vcfsamplenames snp.$input.vcf > $input.sample_names.temp
    awk '{print ">",$0}' $input.sample_names.temp > $input.sample_names.txt
    paste -d '\n' $input.sample_names.txt $input.transposed.txt > genotypes
    sed -i 's/\s//g' genotypes
    sed -i 's/>/> /g' genotypes
    rm $input.sample_names.temp

#make the header specific to the adegenet format
printf ">>>> begin comments - do not remove this line <<<<\n\n>>>> end comments - do not remove this line <<<<\n" > header

#make final adegenet input file
cat header position allele population genotypes > $input.snp
rm header snp.$input.vcf *.txt position allele population genotypes
