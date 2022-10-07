#!/bin/bash
set -x
set -eu

### Section 1 - Introduction
pwd
ls -l
echo cd $PWD
cd ~/course_data/chip_seq

### Section 2 - Introducing the tutorial dataset
cd data
ls *.fastq.gz
zcat PAX5.fastq.gz | head

### Section 3 - Aligning the PAX5 sample to the genome
bowtie2 --help
cd data
ls bowtie_index
mkdir bowtie_index
bowtie2-build genome/HS19.fa.gz bowtie_index/hs19
ls -l bowtie_index
bowtie2 -k 1 -x bowtie_index/hs19 PAX5.fastq.gz -S PAX5.sam
head -n 10 PAX5.sam

#Questions

### Section 4 - Manipulating SAM output
samtools view -bSo PAX5.bam PAX5.sam

### Section 5 - Visualising alignments in IGV
samtools sort -T PAX5.temp.bam -o PAX5.sorted.bam PAX5.bam
samtools index PAX5.sorted.bam
# Remove genomeCoverageBed command from tests as the command (even with --help options) retuns exit code 1 
#genomeCoverageBed
fetchChromSizes hg19 > genome/hg19.all.chrom.sizes
awk '$1 !~ /[_.]/' genome/hg19.all.chrom.sizes > genome/hg19.chrom.sizes
genomeCoverageBed -bg -ibam PAX5.sorted.bam -g genome/hg19.chrom.sizes > PAX5.bedgraph
bedGraphToBigWig PAX5.bedgraph genome/hg19.chrom.sizes PAX5.bw

#Manually view in IGV
#Questions

### Section 6 Aligning the control sample to the genome
zcat Control.fastq.gz | head

### Section 7 Finding enriched areas using MACS
macs2 --help
macs2 callpeak --help
macs2 callpeak -t PAX5.sorted.bam -c Control.sorted.bam --format BAM --name PAX5 --gsize 138000000 --pvalue 1e-3 --call-summits

### Section 8 File Formats
#Questions
head -10 PAX5_peaks.narrowPeak
#Questions
zcat genome/gencode.v18.annotation.gtf.gz | head -n 10 
zcat -S genome/gencodev18.annotation.gtf | head -n 10
#Questions

### Section 9 Inspecting genomic regions using bedtools
bedtools
# Again remove command below from test as returns exit code 1
#bedtools genomecov
bedtools genomecov -i PAX5_peaks.narrowPeak -g genome/hg19.chrom.sizes
zcat genome/gencode.v18.annotation.gtf.gz | awk '$3=="gene"' > genome/gencode.v18.annotation.genes.gtf
head -10 genome/gencode.v18.annotation.genes.gtf
wc -l PAX5_peaks.narrowPeak
bedtools intersect -a PAX5_peaks.narrowPeak -b genome/gencode.v18.annotation.genes.gtf | wc -l
bedtools closest -a PAX5_peaks.narrowPeak -b genome/gencode.v18.annotation.genes.gtf | head
awk 'BEGIN {FS=OFS="\t"} { if($7=="+"){tss=$4-1} else { tss = $5 } print $1,tss, tss+1, ".", ".", $7, $9}' genome/gencode.v18.annotation.genes.gtf > genome/gencode.tss.bed
sortBed -i genome/gencode.tss.bed > genome/gencode.tss.sorted.bed
bedtools closest -a PAX5_peaks.narrowPeak -b genome/gencode.tss.sorted.bed > PAX5_closestTSS.txt
head PAX5_closestTSS.txt
#Questions

### Section 10 Motif analysis
sort -k5 -nr PAX5_summits.bed > PAX5_summits.sorted.bed
awk 'BEGIN{FS=OFS="\t"}; NR < 301 { print $1, $2-30, $3+29 }' PAX5_summits.sorted.bed > PAX5_top300_summits.bed
#Fasta file must be unzipped
gunzip genome/HS19.fa.gz
samtools faidx genome/HS19.fa
bedtools getfasta -fi genome/HS19.fa -bed PAX5_top300_summits.bed -fo PAX5_top300_summits.fa
#meme
meme PAX5_top300_summits.fa -o meme_out -dna -nmotifs 1 -minw 6 -maxw 20
firefox meme_out/meme.html &
tomtom -o tomtom_out meme_out/meme.html motif_databases/JASPAR/JASPAR_CORE_2016_vertebrates.meme motif_databases/MOUSE/uniprobe_mouse.meme
firefox tomtom_out/tomtom.html &
#Questions

set +x
set +eu
