cd chip_seq
cd data
ls *.fastq.gz
bowtie2 -help
ls bowtie_index
mkdir bowtie_index
bowtie2-build genome/HS19.fa.gz bowtie_index/hs19
bowtie2 -k 1 -x bowtie_index/hs19 PAX5.fastq.gz -S PAX5.sam
head -n 10 PAX5.sam 
samtools view -bSo PAX5.bam PAX5.sam
samtools sort -T PAX5.temp.bam -o PAX5.sorted.bam PAX5.bam
samtools index PAX5.sorted.bam 
genomeCoverageBed 
fetchChromSizes hg19 > genome/hg19.all.chrom.sizes
less genome/hg19.all.chrom.sizes 
awk '$1 !~ /[_.]/' genome/hg19.all.chrom.sizes > genome/hg19.chrom.sizes
less genome/hg19.chrom.sizes 
genomeCoverageBed -bg -ibam PAX5.sorted.bam -g genome/hg19.chrom.sizes > PAX5.bedgraph
less PAX5.bedgraph 
bedGraphToBigWig PAX5.bedgraph genome/hg19.chrom.sizes PAX5.bw
zless Control.fastq.gz | head
macs2 -help
macs2 callpeak -help
macs2 callpeak -t PAX5.sorted.bam -c Control.fastq.gz --format BAM --name PAX5 --gsize 138000000 --pvalue 1e-3 --call-summits
zless genome/gencode.v18.annotation.gtf | head 
bedtools
bedtools genomecov
