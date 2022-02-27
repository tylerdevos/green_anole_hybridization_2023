#!/usr/bin/env python

import sys
import argparse
import vcf

__author__ = 'Pim Bongaerts'
__copyright__ = 'Copyright (C) 2016 Pim Bongaerts'
__license__ = 'GPL'

ADMIX_LABEL = "ADMIX"
COL_INDIV = 0
COL_POP = 1
COL_ASSIGN = 2
ERROR_FLAG = "ERROR"


def read_assignment_file(
        assignment_filename, assign_cut_off, include_parentals):
    """ Assess assignment of each individual and store in dict/list """
    assignment_file = open(assignment_filename, 'r')
    par1_indivs = []
    par2_indivs = []
    admixed_indivs = []
    indiv_pops = {}
    for line in assignment_file:
        cols = line.split(',')
        indiv_pops[cols[COL_INDIV]] = cols[COL_POP]
        if float(cols[COL_ASSIGN]) > float(assign_cut_off):
            # Parental individuals 1
            par1_indivs.append(cols[COL_INDIV])
        elif float(cols[COL_ASSIGN]) < (1 - float(assign_cut_off)):
            # Parental individuals 2
            par2_indivs.append(cols[COL_INDIV])
        else:
            # Admixed individuals
            admixed_indivs.append(cols[COL_INDIV])

    # Include parentals to admixed individuals if include flag is set
    if include_parentals:
        final_admixed_indivs = par1_indivs + admixed_indivs + par2_indivs
    else:
        final_admixed_indivs = admixed_indivs

    return par1_indivs, par2_indivs, final_admixed_indivs, indiv_pops


def output_individuals(record, list_of_indivs, output_file):
    """ Outputs genotypes of all indivs for current SNP to output_file """
    genotypes_for_snp = []
    for indiv in list_of_indivs:
        genotype = record.genotype(indiv).gt_bases
        if genotype:
            introgress_genotype = '{0}/{1}'.format(genotype[0], genotype[2])
        else:
            introgress_genotype = 'NA/NA'
        genotypes_for_snp.append(introgress_genotype)
    concat_genotypes_for_snp = ','.join(genotypes_for_snp)
    output_file.write('{}\n'.format(concat_genotypes_for_snp))


def main(vcf_filename, assignment_filename, assign_cut_off, freq_diff_cut_off,
         output_prefix, include_parentals):
    # Assess assignment of individuals in dataset and store in lists
    (par1_indivs, par2_indivs, admixed_indivs,
     indiv_pops) = read_assignment_file(assignment_filename, assign_cut_off,
                                        include_parentals)

    # Open output files
    parental1_file = open('{}_par1'.format(output_prefix), 'w')
    parental2_file = open('{}_par2'.format(output_prefix), 'w')
    admixed_file = open('{}_admix'.format(output_prefix), 'w')
    loci_file = open('{}_loci'.format(output_prefix), 'w')

    # Write output file headers
    loci_file.write('locus,type,lg,marker pos.\n')
    admixed_file.write(
        '{}\n'.format(
            ','.join(
                ['ADMIX'] *
                len(admixed_indivs))))
    admixed_file.write('{}\n'.format(','.join(admixed_indivs)))

    # Iterate over loci in VCF file and output to files
    output_count = 0
    vcf_reader = vcf.Reader(open(vcf_filename, 'r'))
    for record in vcf_reader:
            # Output locus information (CHROM as lg and POS as marker pos.)
            marker = '{0}_{1}'.format(record.CHROM, record.POS)
            loci_file.write('{0},C,{1},{1}.{2}\n'.format(marker, record.CHROM,
                                                         record.POS))
            # Output genotypes of individuals to different files
            output_individuals(record, par1_indivs, parental1_file)
            output_individuals(record, par2_indivs, parental2_file)
            output_individuals(record, admixed_indivs, admixed_file)
            output_count += 1


    # Close output files
    parental1_file.close()
    parental2_file.close()
    admixed_file.close()
    loci_file.close()

    # Summary message
    print('Outputted {0} loci'.format(output_count))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('vcf_filename', metavar='vcf_file',
                        help='input file with SNP data (`.vcf`)')
    parser.add_argument('assignment_filename', metavar='assignment_file',
                        help='text file (tsv or csv) with assignment \
                        values for each individual (max. 2 clusters); e.g. a \
                        reformatted STRUCTURE output file')
    parser.add_argument('assign_cut_off', metavar='assign_cut_off', type=float,
                        help='min. assignment value for an individual to be \
                        included in the allele frequency calculation (i.e. \
                        putative purebred)')
    parser.add_argument('freq_cut_off', metavar='freq_cut_off', type=float,
                        help='min. allele frequency difference between the 2 \
                        clusters for a locus to be included in the output')
    parser.add_argument('output_prefix', metavar='output_prefix',
                        help='prefix for output files')
    parser.add_argument('--include', '-i', action='store_true',
                        help='set this flag if parental pops need to be \
                        included in output')
    args = parser.parse_args()
    main(args.vcf_filename, args.assignment_filename, args.assign_cut_off,
         args.freq_cut_off, args.output_prefix, args.include)
