##Introduction
cd /home/manager/course_data/variant_calling/data
samtools --help
bcftools --help
igv &

##Calling variants
pwd
ls -lh
samtools mpileup -f GRCm38_68.19.fa A_J.bam | head
samtools mpileup -f GRCm38_68.19.fa A_J.bam | grep 10001994
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | head
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | bcftools call -m | head
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | bcftools call -mv | head
bcftools mpileup -a ?
bcftools mpileup -a AD -f GRCm38_68.19.fa A_J.bam -Ou | bcftools call -mv -o out.vcf
grep 10001994 out.vf
grep 10003649 out.vcf

##Filtering Variants
bcftools query --format 'POS=%POS\n' out.vcf | head
bcftools query -f'%POS %REF,%ALT\n' out.vcf | head
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' out.vcf | head
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' -i'QUAL>=30' out.vcf | head
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' -i'QUAL>=30 && type="snp"' out.vcf | head
##Exercises
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' -i'QUAL>=30 && type="snp" && AD[*:1]>=25' out.vcf | head
bcftools stats out.vcf | grep TSTV | cut -f5
bcftools stats -i'QUAL>=30 && AD[*:1]>=25' out.vcf | grep TSTV | cut -f5
bcftools stats -e'QUAL>=30 && AD[*:1]>=25' out.vcf | grep TSTV | cut -f5
bcftools stats -i 'GT="het"' out.vcf | grep TSTV | cut -f5
bcftools filter -s LowQual -i'QUAL>=30 && AD[*:1]>=25' -g8 -G10 out.vcf -o out.flt.vcf
bcftools norm -f GRCm38_68.19.fa out.flt.vcf -o out.flt.norm.vcf

##Multisample calling
ls *.bam
bcftools mpileup -a AD -f GRCm38_68.19.fa *.bam -Ou | bcftools call -mv -Ob -o multi.bcf 
bcftools index multi.bcf
bcftools filter -s LowQual -i'QUAL>=30 && AD[*:1]>=25' -g8 -G10 multi.bcf -Ob -o multi.filt.bcf
bcftools index multi.filt.bcf
#Exercises
bcftools stats multi.filt.bcf | grep TSTV | cut -f5 (raw calls)
bcftools stats -i 'FILTER="PASS"' multi.filt.bcf | grep TSTV | cut -f5 (only filtered set)
bcftools stats -e 'FILTER="PASS"' multi.filt.bcf | grep TSTV | cut -f5

##Visualising variants
##Test manually
bcftools view -H -r 19:10001946 multi.filt.bcf
bcftools view -H -r 19:10072443 multi.filt.bcf

##Annotating variants
bcftools view -i 'FILTER="PASS"' multi.filt.bcf | bcftools csq -p m -f GRCm38_68.19.fa -g Mus_musculus.part.gff3.gz -Ob -o multi.filt.annot.bcf
bcftools index multi.filt.annot.bcf
bcftools query -f '%BCSQ' -r 19:10088937 multi.filt.annot.bcf
