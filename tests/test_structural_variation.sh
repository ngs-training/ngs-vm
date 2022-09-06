cd /home/manager/course_data/structural_variation
cd data
cd exercise1
pwd
head ERR1015121.vcf
cd ../exercise2
cat breakdancer.config
breakdancer-max breakdancer.config > ERR1015121.breakdancer.out
cat ERR1015121.breakdancer.out
grep dels ERR1015121.breakdancer.out > ERR1015121.breakdancer.dels.out
awk '{print $1"\t"$2"\t"$5"\t"$7"\t"$9}' ERR1015121.breakdancer.dels.out > ERR1015121.breakdancer.dels.bed
#Test IGV
cd ../exercise3
ls -l ERR1015069.bam
ls -l ERR1015069.bam.bai
samtools view -bh -F 1294 ERR1015069.bam | samtools sort -O bam -T ERR1015069.temp -o ERR1015069.discordants.bam
samtools index ERR1015069.discordants.bam
samtools view -h ERR1015069.bam | extractSplitReads_BwaMem -i stdin | samtools view -b - | samtools sort -O bam -T ERR1015069.temp -o ERR1015069.splitters.bam
samtools index ERR1015069.splitters.bam
lumpyexpress -B ERR1015069.bam -S ERR1015069.splitters.bam -D ERR1015069.discordants.bam -o ERR1015069.vcf
cd ../exercise4
ngmlr -t 2 -r Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa -q YPS128.filtered_subreads.10x.fastq.gz -o ERR1015069.sam
samtools view -b -o ERR1015069.bam ERR1015069.sam
samtools sort -o ERR1015069.sorted.bam ERR1015069.bam 
samtools index ERR1015069.sorted.bam 
sniffles -m ERR1015069.sorted.bam -v ERR1015069.vcf
#Look in IGV
cd ../exercise5
bedtools
#bedtools intersect...
#bedtools intersect..
#bedtools closest...
#bedtools intersect...
