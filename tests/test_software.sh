#!/bin/bash

echo $MINICONDA
echo $PATH

samtools
bcftools --help
bedtools --help
bwa
igv &

picard
PicardCommandLine -h

breakdancer-max
bam2cfg.pl -h
sniffles --help
#lumpy --help
#lumpyexpress -h
minimap2

hisat2 -h
kallisto 
sleuth.R

bowtie2
macs2 -h
meme
tomtom
bedGraphToBigWig
fetchChromSizes

assembly-stats
canu
jellyfish --help
seqtk
velveth
velvetg
wtdbg2 --help
genomescope.R

du -h $HOME/miniconda
