cd /home/manager/course_data/rna_seq/data
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
kallisto index
kallisto quant
kallisto index -i PccAS_v3_kallisto PccAS_v3_transcripts.fa
kallisto quant -i PccAS_v3_kallisto -o MT1 -b 100 MT1_1.fastq.gz MT1_2.fastq.gz
head MT1/abundance.tsv
grep PCHAS_0100100 MT1/abundance.tsv
awk -F"\t" '$1=="PCHAS_0100100" {print $5}' MT1/abundance.tsv
kallisto quant -i PccAS_v3_kallisto -o MT2 -b 100 MT2_1.fastq.gz MT2_2.fastq.gz
kallisto quant -i PccAS_v3_kallisto -o SBP1 -b 100 SBP1_1.fastq.gz SBP1_2.fastq.gz
kallisto quant -i PccAS_v3_kallisto -o SBP2 -b 100 SBP2_1.fastq.gz SBP2_2.fastq.gz
kallisto quant -i PccAS_v3_kallisto -o SBP3 -b 100 SBP3_1.fastq.gz SBP3_2.fastq.gz
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
