#!/bin/bash
set -x
set -eu

### Section 1 - Introduction 
cd ~/course_data/rna_seq/

### Section 2 - Introducing the tutorial dataset
ls data/*.fastq.gz
zcat data/MT1_1.fastq.gz | head
#Questions

### Section 3 - Mapping RNA-Seq reads to the genome using HISAT
hisat2-build -h
hisat2-build data/PccAS_v3_genome.fa data/PccAS_v3_hisat2.idx
ls data/PccAS_v3_hisat2.idx.*
hisat2 -h
hisat2 --max-intronlen 10000 -x data/PccAS_v3_hisat2.idx -1 data/MT1_1.fastq.gz -2 data/MT1_2.fastq.gz -S data/MT1.sam
samtools view -b -o data/MT1.bam data/MT1.sam
samtools sort -o data/MT1_sorted.bam data/MT1.bam
samtools index data/MT1_sorted.bam
#ls -al data/SBP*bam
./data/map_SBP_samples.sh
ls -al data/SBP*bam
#Questions

### Section 4 - Visualising transcriptomics with IGV
samtools faidx data/PccAS_v3_genome.fa
#Questions

### Section 5 - Transcript quantification with Kallisto
#kallisto index
#kallisto quant
kallisto index -i data/PccAS_v3_kallisto data/PccAS_v3_transcripts.fa
kallisto quant -i data/PccAS_v3_kallisto -o data/MT1 -b 100 data/MT1_1.fastq.gz data/MT1_2.fastq.gz
ls data/MT1
head data/MT1/abundance.tsv
grep PCHAS_0100100 data/MT1/abundance.tsv
awk -F"\t" '$1=="PCHAS_0100100" {print $5}' data/MT1/abundance.tsv
kallisto quant -i data/PccAS_v3_kallisto -o data/MT2 -b 100 data/MT2_1.fastq.gz data/MT2_2.fastq.gz
kallisto quant -i data/PccAS_v3_kallisto -o data/SBP1 -b 100 data/SBP1_1.fastq.gz data/SBP1_2.fastq.gz
kallisto quant -i data/PccAS_v3_kallisto -o data/SBP2 -b 100 data/SBP2_1.fastq.gz data/SBP2_2.fastq.gz
kallisto quant -i data/PccAS_v3_kallisto -o data/SBP3 -b 100 data/SBP3_1.fastq.gz data/SBP3_2.fastq.gz
#Questions

### Section 6 - Identifying differentially expressed genes with Sleuth
cat data/sleuth.R
cat data/hiseq_info.txt
Rscript data/sleuth.R &
#Questions

### Section 7 - Interpreting the results
awk -F "\t" '$4 < 0.01 && $5 > 0' data/kallisto.results | cut -f1,2,3,4,5 | head
awk -F "\t" '$4 < 0.01 && $5 < 0' data/kallisto.results | cut -f1,2,3,4,5 | head
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' data/kallisto.results | sort | uniq
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' data/kallisto.results | sort | uniq -c
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' data/kallisto.results | sort | uniq -c | sort
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' data/kallisto.results | sort | uniq -c | sort -n
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' data/kallisto.results | grep -c CIR
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' data/kallisto.results | sort | uniq -c | grep -c CIR
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' data/kallisto.results | sort | uniq -c | grep CIR
#Questions

set +eu
set +x
