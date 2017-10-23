#!/bin/bash

# Alfredo H. Locht

# halocht@gmail.com ahlocht@dons.usfca.edu

# This is a  script that will run a pipeline all the way from downloading files from NCBI to turning them into fasta files which are in the correct format for BLASTing

# Script's name: QCfastq_week06.sh

echo "Checking the value of BLASTDB variable"

if [ -z ${BLASTDB} ]; then source /home/.bashrc; export PATH; export BLASTDB; fi

echo "BLASTDB checked"

echo "##################################################"



echo "Downloading fastq files into data/raw_data"

# The pipe and tail -n +2 is a handy way to exclude the first line
for SRA_number in $(cut -f 6 data/metadata/fierer_forensic_hand_mouse_SraRunTable.txt | tail -n +2)
do
    fastq-dump -v $SRA_number -O data/raw_data
done

echo "Done downloading fastq files into data/raw_data"

echo "#####################################################"

echo "Fastqc is a program which will give a quality control check on raw sequence data coming from high throughput sequencing pipelines"
echo "Running fastqc"

fastqc data/raw_data/*.fastq --outdir=output/fastqc

echo "QC completed"

echo "#####################################################"

echo "Proceeding with Trimmomatic"

# Trimmomatic is a tool that will trim sequences based off their quality scores. In this case, we are trimming sequences with a sequence of less than 150 base pairs, trim leading and trailing N values, and  to cut off reads when their base score falls below 25


for file in data/raw_data/*.fastq
do

	TrimmomaticSE -threads 2 -phred33 $file data/trimmed/$(basename -s .fastq $file).trim.fastq LEADING:5 TRAILING:5 SLIDINGWINDOW:8:25 MINLEN:150

done

echo "Trimmed the fastq sequences"

echo "######################################################"

# Now you must convert the fastq file into a fasta file so that you can blast it against NCBI

echo "Bioawk Initiated"

for file in data/trimmed
do
	bioawk -c fastx '{print ">"$name"\n"$seq}' data/trimmed/filename.trim.fastq > output/bioawk/
done

echo "fastq --> fasta"

