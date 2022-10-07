#!/bin/bash
set -x
set -eu

### Section 1 - Introduction 

cd ~/course_data/structural_variation/data
breakdancer-max -h
dysgu --help
minimap2 --help
sniffles --help
bedtools --help

### Section 2 - Looking at Structural Variants in VCF
pwd
cd exercise1
head ERR1015121.vcf
#Exercises
grep -c "<DEL>" ERR1015121.vcf
grep "437148" ERR1015121.vcf
grep -c "^IV" ERR1015121.vcf

### Section 3 - Calling Structural Variants
cd ../exercise2
ls
cat breakdancer.config
breakdancer-max breakdancer.config > ERR1015121.breakdancer.out
head ERR1015121.breakdancer.out
#Exercises
grep "83065" ERR1015121.breakdancer.out
grep "258766" ERR1015121.breakdancer.out
grep DEL | awk OFS= breakdancer.dels.bed | awk '{print $1"\t"$2"\t"$5"\t"$7"\t"$9}' > breakdancer.dels.bed
#Manual inpection with IGV
cd ../exercise3
ls
dysgu run ../ref/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa temp ERR1015069.bam > ERR1015069.vcf
#Exercises
bcftools view -H -i 'FILTER="PASS"' ERR1015069.vcf | wc -l
grep 384221 ERR1015069.vcf
grep 31115 ERR1015069.vcf

### Section 4 - Calling Structural Variants from Long Reads
cd ../exercise4
ls
minimap2
minimap2 -t 2 -x map-pb -a ../ref/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa YPS128.filtered_subreads.10x.fastq.gz | samtools view -b -o YPS128.filtered_subreads.10x.bam -
samtools sort -T temp -o YPS128.filtered_subreads.10x.sorted.bam YPS128.filtered_subreads.10x.bam
samtools calmd -b YPS128.filtered_subreads.10x.sorted.bam ../ref/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa > YPS128.filtered_subreads.10x.sorted.calmd.bam
samtools index YPS128.filtered_subreads.10x.sorted.calmd.bam
sniffles
sniffles --input YPS128.filtered_subreads.10x.sorted.calmd.bam --vcf YPS128.filtered_subreads.10x.vcf
#Manual inspect in IGV
#Exercises
#Insert commands

### Section 5 - Bedtools
bedtools
cd ../exercise5
ls
bedtools intersect -a ERR1015069.dels.vcf -b Saccharomyces_cerevisiae.R64-1-1.82.genes.gff3
bedtools intersect -u -a ERR1015069.dels.vcf -b Saccharomyces_cerevisiae.R64-1-1.82.genes.gff3
bedtools intersect -u -f 0.25 -a ERR1015069.dels.vcf -b Saccharomyces_cerevisiae.R64-1-1.82.genes.gff3
bedtools intersect -h
#Exercises

bedtools closest -d -a ERR1015069.dels.vcf -b Saccharomyces_cerevisiae.R64-1-1.82.genes.gff3
bedtools closest -d -a ERR1015069.dels.vcf -b Saccharomyces_cerevisiae.R64-1-1.82.genes.gff3| grep XV | grep 43018 
bedtools closest -h
#Exercises
bedtools intersect -u -a ERR1015069.dels.vcf -b Saccharomyces_cerevisiae.R64-1-1.82.genes.gff3  | wc -l
bedtools intersect -v -a ERR1015069.dels.vcf -b Saccharomyces_cerevisiae.R64-1-1.82.genes.gff3  | wc -l
bedtools intersect -u -f 0.5 -a ERR1015069.dels.vcf -b Saccharomyces_cerevisiae.R64-1-1.82.genes.gff3  | wc -l
bedtools intersect -wb -a ERR1015069.dels.vcf -b Saccharomyces_cerevisiae.R64-1-1.82.genes.gff3 | grep 811446
bedtools intebedtools closest -d -a ERR1015069.dels.vcf -b Saccharomyces_cerevisiae.R64-1-1.82.genes.gff3| grep IV | grep 384220rsect -wb -a ERR1015069.dels.vcf -b Saccharomyces_cerevisiae.R64-1-1.82.genes.gff3 | grep 811446
bedtools intersect -u -a ERR1015069.dels.vcf -b ERR1015121.dels.vcf | wc -l
bedtools intersect -u -r -f 0.9 -a ERR1015069.dels.vcf -b ERR1015121.dels.vcf | wc -l

set +eu
set -+x
