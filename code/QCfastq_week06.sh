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

# the pipe and tail -n +2 is a handy way to exclude the first line
for SRA_number in $(cut -f 6 data/metadata/fierer_forensic_hand_mouse_SraRunTable.txt | tail -n +2)
do
    fastq-dump -v $SRA_number -O data/raw_data
done

echo "Done downloading fastq files into /data/raw_data"

echo "#####################################################"

echo "Fastqc"
# Now run Fastqc to discard sequences less than 150 bp, set leading or trailing parameters, and cut off reads if they obtain score of less than 25

echo "Running fastqc"

fastqc data/raw_data/*.fastq --outdir=output/fastqc

