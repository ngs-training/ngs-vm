cd rna_seq/data
ls *.fastq.gz
hisat2-build -h
hisat2-build PccAS_v3_genome.fa PccAS_v3_hisat2.idx
ls PccAS_v3_hisat2.idx.*
hisat2 -h
hisat2 --max-intronlen 10000 -x PccAS_v3_hisat2.idx -1 MT1_1.fastq.gz -2 MT1_2.fastq.gz -S MT1.sam
samtools view -b -o MT1.bam MT1.sam
samtools sort -o MT1_sorted.bam MT1.bam 
samtools index MT1_sorted.bam 
ls SBP*bam*
./map_SBP_samples.sh
ls *.bam
cat sleuth.R 
cat hiseq_info.txt 
Rscript sleuth.R 
awk -F "\t" '$4 < 0.01 && $5 > 0' kallisto.results | cut -f1,2,3,4,5 | head
awk -F "\t" '$4 < 0.01 && $5 < 0' kallisto.results | cut -f1,2,3,4,5 | head
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' kallisto.results | sort | uniq
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' kallisto.results | sort | uniq -c
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' kallisto.results | sort | uniq -c | sort
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' kallisto.results | sort | uniq -c | sort -n
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' kallisto.results | grep -c CIR
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' kallisto.results | sort | uniq -c | grep -c CIR
awk -F "\t" '$4 < 0.01 && $5 < 0 {print $2}' kallisto.results | sort | uniq -c | grep CIR
