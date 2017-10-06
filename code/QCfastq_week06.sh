#!/bin/bash

# Alfredo H. Locht

# halocht@gmail.com ahlocht@dons.usfca.edu

# This is a QC script to extract the SRA numbers from some fastq files and then process them further

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

echo "Fastqc"
# Now run Fastqc to discard sequences less than 150 bp, set leading or trailing parameters, and cut off reads if they obtain score of less than 25

echo "Running fastqc"

fastqc data/raw_data/*.fastq --outdir=output/fastqc

echo "QC completed"

echo "#####################################################"

echo "Proceeding with Trimmomatic"

# Trimmomatic is a tool that will cut the adapter sequence of Illumina sequence reads and any other Illumina-specific additions


for file in data/raw_data
do
	TrimmomaticSE -threads 2 -phred33 data/raw_data/ERR1942280.fastq data/trimmed/$(basename -s .fastq ERR1942280.fastq).trim.fastq LEADING:5 TRAILING:5 SLIDINGWINDOW:8:25 MINLEN:150
done

echo "Trimmed the hedges"

echo "######################################################"

# Now you must convert the fastq file into a fasta file so that you can blast it against NCBI

echo "Bioawk Initiated"

for file in data/trimmed
do
	bioawk -c fastx '{print ">"$name"\n"$seq}' data/trimmed/filename.trim.fastq > output/bioawk/
done

echo "fastq --> fasta"

