#!/bin/bash
#usage: ./trim_IBS_one_column.sh
#print the second column of the file (which contains the IBS values), exclude non-fractional values (which are the diagonals of the IBS matrix) and sort the IBS values
awk '{print $2}' IBS_one_column.temp | sort | grep "0." > one_col.temp
#print every other line of the sorted IBS values (the omitted lines are the repeated IBS values from a given pairwise comparison, from above the diagonal of the square matrix)
sed -n 'p;n' one_col.temp > IBS_one_column.txt
rm *.temp
