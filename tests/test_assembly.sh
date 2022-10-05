set -x
set -eu

cd ~/course_data/assembly/data/

#Start PacBio assembly 
canu -p PB -d Pacbio -s file.specs -pacbio-raw PBReads.fastq.gz &> canu_log.txt &

#Make an illumina assembly
##velveth k.assembly.41 41 -shortPaired -fastq IT.Chr5_1.fastq IT.Chr5_2.fastq
##velvetg k.assembly.41 -exp_cov auto -ins_length 350

##velveth k.assembly.49 49 -shortPaired -fastq IT.Chr5_1.fastq IT.Chr5_2.fastq
##velvetg k.assembly.49 -exp_cov auto -ins_length 350 -min_contig_lgth  200 -cov_cutoff 5

##velveth k.assembly.55 55 -shortPaired -fastq IT.Chr5_1.fastq IT.Chr5_2.fastq
##velvetg k.assembly.55 -exp_cov auto -ins_length 350 -min_contig_lgth  200 -cov_cutoff 5

##assembly-stats k.assembly*/*.fa
##seqtk cutN -n1 k.assembly.49/contigs.fa > tmp.contigs.fasta
##assembly-stats tmp.contigs.fasta

#What to expect from a genome assembly
##jellyfish count -C -m21 -s1G -t4 -o IT.jf <(cat IT.Chr5_1.fastq IT.Chr5_2.fastq)
##jellyfish histo IT.jf > IT.histo
#Rscript genomescope.R IT.histo 21 76 IT.jf21

#Rscript genomescope.R fAnaTest.jf21.histo 21 76 fAnaTest.jf21
#Rscript genomescope.R fDreSAT1.jf21.histo 21 76 fDreSAT1.jf21
#Rscript genomescope.R fMasArm1.jf21.histo 21 76 fMasArm1.jf21
#Rscript genomescope.R fSalTru1.jf21.histo 21 76 fSalTru1.jf21

#Back to PacBio assembly
wtdbg2 -t4 -i PBReads.fastq.gz -o wtdbg
wtpoa-cns -t4 -i wtdbg.ctg.lay.gz -fo wtdbg.ctg.lay.fasta
assembly-stats wtdbg.ctg.lay.fasta

bwa index wtdbg.ctg.lay.fasta 
samtools faidx wtdbg.ctg.lay.fasta
bwa mem -t 4 wtdbg.ctg.lay.fasta IT.Chr5_1.fastq IT.Chr5_2.fastq | samtools sort -@4 - | samtools mpileup -f wtdbg.ctg.lay.fasta -ug - | bcftools call -m > wtdbg.vcf

sleep 3600
assembly-stats Pacbio/PB.contigs.fasta
bwa index Pacbio/PB.contigs.fasta
samtools faidx Pacbio/PB.contigs.fasta
bwa mem -t4 Pacbio/PB.contigs.fasta IT.Chr5_1.fastq IT.Chr5_2.fastq | samtools sort -@4 - | samtools mpileup -f Pacbio/PB.contigs.fasta -ug - | bcftools call -mv > PB.vcf
bcftools stats PB.vcf | grep ^SN

bcftools stats wtdbg.vcf | grep ^SN

#Polishing
bgzip -c PB.vcf > PB.vcf.gz
tabix PB.vcf.gz
bcftools consensus -i'QUAL>1 && (GT="AA" || GT="Aa")' -Hla -f Pacbio/PB.contigs.fasta PB.vcf.gz > PB.contigs.polished.fasta
assembly-stats PB.contigs.polished.fasta 
assembly-stats Pacbio/PB.contigs.fasta
bwa index PB.contigs.polished.fasta
bwa mem -t4 PB.contigs.polished.fasta IT.Chr5_1.fastq IT.Chr5_2.fastq | samtools sort -@4 - | samtools mpileup -f PB.contigs.polished.fasta -ug - | bcftools call -mv > PB.polished.vcf
bcftools stats PB.polished.vcf | grep ^SN
bcftools stats PB.vcf | grep ^SN

bgzip -c wtdbg.vcf > wtdbg.vcf.gz
tabix wtdbg.vcf.gz 
bcftools consensus -i'QUAL>1 && (GT="AA" || GT="Aa")' -Hla -f wtdbg.ctg.lay.fasta wtdbg.vcf.gz > wtdbg.contigs.polished.fasta
assembly-stats wtdbg.contigs.polished.fasta 
bwa index wtdbg.contigs.polished.fasta 
bwa mem -t4 wtdbg.contigs.polished.fasta IT.Chr5_1.fastq IT.Chr5_2.fastq | samtools sort -@4 - | samtools mpileup -f wtdbg.contigs.polished.fasta -ug - | bcftools call -mv > wtbg.polished.vcf
bcftools stats wtbg.polished.vcf | grep ^SN
bcftools stats wtdbg.vcf | grep ^SN

set +eu
set +x
