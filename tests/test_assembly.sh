#!/bin/bash
set -x
set -eu


### Section 1 - Introduction
cd ~/course_data/assembly/data/
canu
jellyfish
velvetg
velveth
assembly-stats
wtdbg2

### Section 2 - PacBio Genome Assembly
pwd
ls
zless -S PBReads.fastq.gz | head
canu -p PB -d Pacbio -s file.specs -pacbio-raw PBReads.fastq.gz &> canu_log.txt &
head canu_log.txt

### Section 3 - Assembly algorithms

### Section 4 - Illumina genome assembly
velveth k.assembly.49 49 -shortPaired -fastq IT.Chr5_1.fastq IT.Chr5_2.fastq
velveth
velvetg k.assembly.49 -exp_cov auto -ins_length 350
velvetg

velvetg k.assembly.49 -exp_cov auto -ins_length 350 -min_contig_lgth 200 -cov_cutoff 5

velveth k.assembly.55 55 -shortPaired -fastq IT.Chr5_1.fastq IT.Chr5_2.fastq
velvetg k.assembly.55 -exp_cov auto -ins_length 350 -min_contig_lgth 200 -cov_cutoff 5

velveth k.assembly.41 41 -shortPaired -fastq IT.Chr5_1.fastq IT.Chr5_2.fastq
velvetg k.assembly.41 -exp_cov auto -ins_length 350 -min_contig_lgth 200 -cov_cutoff 5

ls ~/course_data/assembly/data/assembly_backup
assembly-stats k.assembly*/*.fa

seqtk cutN -n1 k.assembly.41/contigs.fa > assembly.41.contigs.fasta
assembly-stats assembly.41.contigs.fasta
seqtk cutN -n1 k.assembly.49/contigs.fa > assembly.49.contigs.fasta
assembly-stats assembly.49.contigs.fasta
seqtk cutN -n1 k.assembly.55/contigs.fa > assembly.55.contigs.fasta
assembly-stats assembly.55.contigs.fasta


### Section 5 - Assembly estimation
jellyfish count -C -m 21 -s 1G -t 2 -o IT.jf <(cat IT.Chr5_1.fastq IT.Chr5_2.fastq)
jellyfish histo IT.jf > IT.histo
less IT.histo
Rscript genomescope.R IT.histo 21 76 IT.jf21
head IT.jf21/summary.txt
firefox IT.jf21/plot.png &

ls *.histo
Rscript genomescope.R fAnaTes1.jf21.histo 21 150 fAnaTes1.jf21
Rscript genomescope.R fDreSAT1.jf21.histo 21 150 fDreSAT1.jf21
Rscript genomescope.R fMasArm1.jf21.histo 21 150 fMasArm1.jf21
Rscript genomescope.R fSalTru1.jf21.histo 21 150 fSalTru1.jf21

### Section 6 - PacBio Genome Assembly contd.
ls ~/course_data/assembly/data/backup/pacbio_assemblies

wtdbg2 -t2 -i PBReads.fastq.gz -o wtdbg
wtpoa-cns -t2 -i wtdbg.ctg.lay.gz -fo wtdbg.ctg.lay.fasta
assembly-stats wtdbg.ctg.lay.fasta

assembly-stats canu-assembly/PB.contigs.fasta

bwa index canu-assembly/PB.contigs.fasta
samtools faidx canu-assembly/PB.contigs.fasta
bwa mem -t2 canu-assembly/PB.contigs.fasta IT.Chr5_1.fastq IT.Chr5_2.fastq | samtools sort -@2 - | samtools mpileup -f canu-assembly/PB.contigs.fasta -ug - | bcftools call -mv > canu.vcf

bwa index wtdbg.ctg.lay.fasta
samtools faidx wtdbg.ctg.lay.fasta
bwa mem -t2 wtdbg.ctg.lay.fasta IT.Chr5_1.fastq IT.Chr5_2.fastq | samtools sort -@2 - | samtools mpileup -f wtdbg.ctg.lay.fasta -ug - | bcftools call -mv > wtdbg.vcf

bcftools stats canu.vcf | grep ^SN
bcftools stats wtdbg.vcf | grep ^SN

bgzip -c canu.vcf > canu.vcf.gz
tabix canu.vcf.gz
bcftools consensus -i'QUAL>1 && (GT="AA" || GT="Aa")' -Hla -f canu-assembly/PB.contigs.fasta canu.vcf.gz > canu-assembly/PB.contigs.polished.fasta

bgzip -c wtdbg.vcf > wtdbg.vcf.gz
tabix wtdbg.vcf.gz
bcftools consensus -i'QUAL>1 && (GT="AA" || GT="Aa")' -Hla -f wtdbg.ctg.lay.fasta wtdbg.vcf.gz > wtdbg.contigs.polished.fasta

#Insert commands to polish again
bwa index canu-assembly/PB.contigs.polished.fasta
samtools faidx canu-assembly/PB.contigs.polished.fasta
bwa mem -t2 canu-assembly/PB.contigs.polished.fasta IT.Chr5_1.fastq IT.Chr5_2.fastq | samtools sort -@2 - | samtools mpileup -f canu-assembly/PB.contigs.polished.fasta -ug - | bcftools call -mv > canu.polished.vcf

bwa index wtdbg.contigs.polished.fasta
samtools faidx wtdbg.contigs.polished.fasta
bwa mem -t2 wtdbg.contigs.polished.fasta IT.Chr5_1.fastq IT.Chr5_2.fastq | samtools sort -@2 - | samtools mpileup -f wtdbg.contigs.polished.fasta -ug - | bcftools call -mv > wtdbg.poilshed.vcf

bcftools stats canu.polished.vcf | grep ^SN
bcftools stats wtdbg.polished.vcf | grep ^SN

set +eu
set +x
