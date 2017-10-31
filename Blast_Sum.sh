#!/bin/bash

# "Alfredo H. Locht"

# halocht@gmail.com ahlocht@dons.usfca.edu

# 27Oct2017

# This is a script to summarize BLAST results

# Name: Blast_Sum.sh

for file in $@
do

	cut -d "," -f1 $file.csv | uniq -c | sort -nr | head -10 > output/csv_output/$(basename -s .csv $file)_summary.txt

done
