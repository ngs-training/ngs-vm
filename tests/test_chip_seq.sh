cd /home/manager/course_data/chip_seq
cd data
ls *.fastq.gz
head PAX5.fastq
bowtie2 --help
ls bowtie_index
mkdir bowtie_index
bowtie2-build genome/HS19.fa.gz bowtie_index/hs19
ls -l bowtie_index
bowtie2 -k 1 -x bowtie_index/hs19 PAX5.fastq.gz -S PAX5.sam
head -n 10 PAX5.sam 
samtools view -bSo PAX5.bam PAX5.sam
samtools sort -T PAX5.temp.bam -o PAX5.sorted.bam PAX5.bam
samtools index PAX5.sorted.bam 
genomeCoverageBed 
fetchChromSizes hg19 > genome/hg19.all.chrom.sizes
cat genome/hg19.all.chrom.sizes 
awk '$1 !~ /[_.]/' genome/hg19.all.chrom.sizes > genome/hg19.chrom.sizes
cat genome/hg19.chrom.sizes 
genomeCoverageBed -bg -ibam PAX5.sorted.bam -g genome/hg19.chrom.sizes > PAX5.bedgraph
cat PAX5.bedgraph 
bedGraphToBigWig PAX5.bedgraph genome/hg19.chrom.sizes PAX5.bw
#Manually view in IGV

zcat Control.fastq.gz
bowtie2 -k 1 -x bowtie_index/hs19 Control.fastq.gz -S Control.sam
head -n 10 Control.sam 
samtools view -bSo Control.bam Control.sam
samtools sort -T Control.temp.bam -o Control.sorted.bam Control.bam
samtools index Control.sorted.bam 

macs2 -help
macs2 callpeak --help
macs2 callpeak -t PAX5.sorted.bam -c Control.sorted.bam --format BAM --name PAX5 --gsize 138000000 --pvalue 1e-3 --call-summits
head -10 PAX5_peaks.narrowPeak
zcat genome/gencode.v18.annotation.gtf.gz | head -n 10 
bedtools
bedtools genomecov
bedtools genomecov -i PAX5_peaks.narrowPeak -g genome/hg19.chrom.sizes
awk '$3=="gene"' genome/gencode.v18.annotation.gtf > genome/gencode.v18.annotation.genes.gtf
wc -l PAX5_peaks.narrowPeak
bedtools intersect -a PAX5_peaks.narrowPeak -b genome/gencode.v18.annotation.genes.gtf | wc -l
bedtools closest -a PAX5_peaks.narrowPeak -b genome/gencode.v18.annotation.genes.gtf | head
awk 'BEGIN {FS=OFS="\t"} { if($7=="+"){tss=$4-1} else { tss = $5 } print $1,tss, tss+1, ".", ".", $7, $9}' genome/gencode.v18.annotation.genes.gtf > genome/gencode.tss.bed
sortBed -i genome/gencode.tss.bed > genome/gencode.tss.sorted.bed
bedtools closest -a PAX5_peaks.narrowPeak -b genome/gencode.tss.sorted.bed > PAX5_closestTSS.txt
head PAX5_closestTSS.txt
sort -k5 -nr PAX5_summits.bed > PAX5_summits.sorted.bed
awk 'BEGIN{FS=OFS="\t"}; NR < 301 { print $1, $2-30, $3+29 }' PAX5_summits.sorted.bed > PAX5_top300_summits.bed
bedtools getfasta -fi genome/HS19.fa -bed PAX5_top300_summits.bed -fo PAX5_top300_summits.fa
meme
meme PAX5_top300_summits.fa -o meme_out -dna -nmotifs 1 -minw 6 -maxw 20
firefox meme_out/meme.html &
tomtom -o tomtom_out meme_out/meme.html motif_databases/JASPAR/JASPAR_CORE_2016_vertebrates.meme motif_databases/MOUSE/uniprobe_mouse.meme
firefox tomtom_out/tomtom.html &
