set -x
set -eu

#Introduction
cd ~/course_data/read_alignment/data
samtools --help
#bwa
#picard -h
#igv &


#Performing Read Alignment
pwd
cd ref
zless GRCm38.68.dna.toplevel.chr7.fa.gz | head
cd ../Exercise1/fastq/
bwa index ../../ref/GRCm38.68.dna.toplevel.chr7.fa.gz
bwa mem ../../ref/GRCm38.68.dna.toplevel.chr7.fa.gz md5638a_7_87000000_R1.fastq.gz md5638a_7_87000000_R2.fastq.gz > md5638.sam 
samtools view -O BAM -o md5638.bam md5638.sam
ls -lh md5638.sam md5638.bam
samtools sort -T temp -O bam -o md5638.sorted.bam md5638.bam
samtools index md5638.sorted.bam
bwa mem ../../ref/GRCm38.68.dna.toplevel.chr7.fa.gz md5638a_7_87000000_R1.fastq.gz md5638a_7_87000000_R2.fastq.gz | samtools view -O BAM - | samtools sort -T temp -O bam -o md5638_2.sorted.bam -
samtools index md5638_2.sorted.bam
#picard MarkDuplicates
picard MarkDuplicates I=md5638.sorted.bam O=md5638.markdup.bam M=md5638.metrics.txt
head -10 md5638.metrics.txt
samtools index md5638.markdup.bam
samtools stats md5638.markdup.bam > md5638.markdup.stats
plot-bamstats -p md5638_plot/ md5638.markdup.stats

#Alignment Visualisation
#Tests need to be performed manually

#Alignment Workflows
cd ~/course_data/read_alignment/data/Exercise2/60A_Sc_DBVPG6044/library1
cd lane1
bwa index ../../../../ref/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz
bwa mem -M -R '@RG\tID:lane1\tSM:60A_Sc_DBVPG6044' ../../../../ref/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz s_7_1.fastq.gz s_7_2.fastq.gz | samtools view -bS - | samtools sort -T temp -O bam -o lane1.sorted.bam -
samtools index lane1.sorted.bam
samtools stats lane1.sorted.bam > lane1.stats.txt
plot-bamstats -p plot/ lane1.stats.txt
cd ../lane2
bwa mem -M -R '@RG\tID:lane2\tSM:60A_Sc_DBVPG6044' ../../../../ref/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz s_7_1.fastq.gz s_7_2.fastq.gz | samtools view -bS - | samtools sort -T temp -O bam -o lane2.sorted.bam -
samtools index lane2.sorted.bam
samtools stats lane2.sorted.bam > lane2.stats.txt
plot-bamstats -p plot2/ lane2.stats.txt
cd ..
pwd
ls
#picard MergeSamFiles
picard MergeSamFiles I=lane1/lane1.sorted.bam I=lane2/lane2.sorted.bam O=library1.bam
picard MarkDuplicates I=library1.bam O=library1.markdup.bam M=library1.metrics.txt
#Visualise with IGV needs manually testing
gunzip ../../../ref/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz

samtools view -C -T ../../../ref/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa -o library1.markdup.cram library1.markdup.bam

set +eu
set +x
