cd read_alignment
cd ref
zless GRCm38.68.dna.toplevel.chr7.fa.gz | head
cd ../Exercise1/fastq/
bwa index ../../ref/index GRCm38.68.dna.toplevel.chr7.fa.gz
bwa mem ../../ref/GRCm38.68.dna.toplevel.chr7.fa.gz md5638a_7_87000000_R1.fastq.gz md5638a_7_87000000_R2.fastq.gz > md5638.sam
samtools view -O BAM -o md5638.bam md5638.sam 
samtools sort -T temp -O bam -o md5638.sorted.bam md5638.bam 
samtools index md5638.sorted.bam 
bwa mem ../../ref/GRCm38.68.dna.toplevel.chr7.fa.gz md5638a_7_87000000_R1.fastq.gz md5638a_7_87000000_R2.fastq.gz | samtools view -O BAM - | samtools sort -T temp -O bam -o md5638_2.sorted.bam -
samtools index md5638_2.sorted.bam 
picard MarkDuplicates I=md5638.sorted.bam O=md5638.markdup.bam M=md5638.metrics.txt
less md5638.metrics.txt 
samtools index md5638.markdup.bam 
samtools stats md5638.markdup.bam > md5638.markdup.stats
plot-bamstats -p md5638_plot/ md5638.markdup.stats 
history > ~/repo/alignment.sh
