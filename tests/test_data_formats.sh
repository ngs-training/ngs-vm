cd /home/manager/course_data/data_formats/data

#samtools view -H NA20538.bam | less -S
#samtools view -H NA20538.bam
samtools view -H NA20538.bam | grep -c ^@RG
samtools view -H NA20538.bam | grep ^@PG | less -S
samtools view -H NA20538.bam | cut -f1,4

samtools view NA20538.bam | head -1 | cut -f1
samtools view NA20538.bam | head -1 | cut -f3,4
samtools view NA20538.bam | head -1 | cut -f5
samtools view -C -T Saccaromyces_cerevisiae.EF4.68.dna.toplevel.fa -o yeast.cram yeast.bam
ls -lh yeast.bam yeast.cram
bcftools
bcftools view
bcftools view -h 1kg.bcf | less
bcftools view -O z -o 1kg.vcf.gz 1kg.bcf
bcftools index 1kg.bcf
bcftools view -H -r 20:24042765-24043073 1kg.bcf | less -S
bcftools query -l 1kg.bcf | wc -l
bcftools query -r 20:24019472 -s HG00107,HG00108 -f '%POS [ %GT]\n' 1kg.bcf
bcftools query -i 'AC>10' -f '%POS\n' 1kg | wc -l
bcftools query -s HG00107 -i 'FORMAT/DP>10 & FORMAT/GT="alt"' -f '%POS [%GT %DP]\n' 1kg.bcf | head
head 60A_Sc_DBVPG6044/lane1/s_7_1.fastq | grep ^@
head 60A_Sc_DBVPG6044/lane1/s_7_2.fastq | grep ^@
wc -l 60A_Sc_DBVPG6044/lane1/*.fastq
./align.sh
grep ^SN lane*.sorted.bam.bchk | awk -F'\t' '$2=="raw rotal sequences:"'
grep ^SN lane*.sorted.bam.bchk | awk -F'\t' '$2=="reads mapped:"'
grep ^SN lane*.sorted.bam.bchk | awk -F'\t' '$2=="pairs on different cromosomes:"'
samtools stats -F SECONDARY lane1.sorted.bam > lane1.sorted.bam.bchk
plot-bamstats -p lane1-plots/ lane1.sorted.bam.bchk
firefox lane1-plots/*.html &
