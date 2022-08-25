#!/bin/bash
set -x
set -eu

### Section 1 - Introduction 
cd ~/course_data/data_formats/
samtools --help
bcftools --help
#picard -h      # returns non-zero status, commenting out

# Section 2 Data format for NGS data
# /home/manager/course_data/data_formats/practical/Notebooks/formats.ipynb
pwd
perl -e 'printf "%d\n",ord("A")-33;'
cat data/example.sam
samtools view -H data/NA20538.bam
samtools view data/NA20538.bam | head -n 1
samtools sort -o data/NA20538_sorted.bam data/NA20538.bam
samtools index data/NA20538_sorted.bam
bcftools view -h data/1kg.bcf
bcftools index data/1kg.bcf
bcftools view -H -r 20:24042765-24043073 data/1kg.bcf
#bcftools query -h      # non-zero status
bcftools query -l data/1kg.bcf
bcftools view -s HG00131 data/1kg.bcf | head -n 50
bcftools query -f'%POS\t%REF\t%ALT\n' -s HG00131 data/1kg.bcf | head
bcftools query -f'%CHROM\t%POS\n' -i 'AC[0]>2' data/1kg.bcf | head


# /home/manager/course_data/data_formats/practical/Notebooks/conversion.ipynb
samtools view -h data/NA20538.bam > data/NA20538.sam
head data/NA20538.sam
samtools view -b data/NA20538.sam > data/NA20538_2.bam
samtools view -C     -T data/Saccharomyces_cerevisiae.EF4.68.dna.toplevel.fa     -o data/yeast.cram data/yeast.bam
ls -l data
picard FastqToSam F1=data/13681_1#18_1.fastq.gz     F2=data/13681_1#18_2.fastq.gz     O=data/13681_1#18.sam SM=13681_1#18
#picard FastqToSam -h       # non-zero status
samtools collate data/yeast.cram data/yeast.collated
samtools fastq -1 data/yeast.collated_1.fastq     -2 data/yeast.collated_2.fastq data/yeast.collated.bam
bcftools view -O z -o data/1kg.vcf.gz data/1kg.bcf
ls -lrt data
bcftools view -O b -o data/1kg_2.bcf data/1kg.vcf.gz


# /home/manager/course_data/data_formats/practical/Notebooks/assessment.ipynb
samtools stats -F SECONDARY data/lane1.sorted.bam     > data/lane1.sorted.bam.bchk
head -n 47 data/lane1.sorted.bam.bchk
grep ^'#' data/lane1.sorted.bam.bchk | grep 'Use'
plot-bamstats -p data/lane1-plots/ data/lane1.sorted.bam.bchk

