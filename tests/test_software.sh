#!/bin/bash

set -x
#set -eu

echo $PATH

samtools
bcftools --version
bedtools --version
bwa
igv &

picard -h

breakdancer-max
bam2cfg.pl -h
sniffles --version
minimap2 --version

hisat2 --version
kallisto version
#sleuth.R

bowtie2 --version
macs2 --version
meme -version
tomtom -version
bedGraphToBigWig
fetchChromSizes

assembly-stats -v
canu -version
jellyfish --version
seqtk
velveth
velvetg
wtdbg2 -V
genomescope2 --version

#set +eu
set +x
