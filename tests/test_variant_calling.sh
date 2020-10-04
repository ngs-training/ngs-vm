#!/bin/bash
set -e
set -x

# ../../variant_calling/practical/Notebooks/index.ipynb
cd ~/course_data/variant_calling
samtools --help
bcftools --help
#igv.sh


# ../../variant_calling/practical/Notebooks/answers.ipynb
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | bcftools call -mv | head
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' -i'QUAL>=30 && type="snp" && AD[*:1]>=25' out.vcf | head
bcftools stats -i'QUAL>=30 && AD[*:1]>=25' out.vcf | grep TSTV | cut -f5
bcftools stats -e'QUAL>=30 && AD[*:1]>=25' out.vcf | grep TSTV | cut -f5
bcftools stats -i 'GT="het"' out.vcf | grep TSTV | cut -f5
bcftools norm -f GRCm38_68.19.fa out.flt.vcf -o out.flt.norm.vcf
bcftools mpileup -a AD -f GRCm38_68.19.fa *.bam -Ou | bcftools call -mv -Ob -o multi.bcf
bcftools index multi.bcf
bcftools filter -s LowQual -i'QUAL>=30 && AD[*:1]>=25' -g8 -G10 multi.bcf -Ob -o multi.filt.bcf
bcftools index multi.filt.bcf
bcftools stats -e 'FILTER="PASS"' multi.filt.bcf | grep TSTV | cut -f5
bcftools view -H -r 19:10001946 multi.filt.bcf
bcftools view -H -r 19:10072443 multi.filt.bcf
bcftools query -f '%BCSQ' -r 19:10088937 multi.filt.annot.bcf


# ../../variant_calling/practical/Notebooks/variant-calling.ipynb
samtools stats -r GRCm38_68.19.fa A_J.bam > A_J.stats
samtools stats -r GRCm38_68.19.fa NZO.bam > NZO.stats
plot-bamstats -r GRCm38_68.19.fa.gc -p A_J.graphs/ A_J.stats
plot-bamstats -r GRCm38_68.19.fa.gc -p NZO.graphs/ NZO.stats
samtools mpileup -f GRCm38_68.19.fa A_J.bam | head
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | head
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | bcftools call -m | head
bcftools mpileup -a ?
bcftools mpileup -a AD -f GRCm38_68.19.fa A_J.bam -Ou | bcftools call -mv -o out.vcf
tail out.vcf


# ../../variant_calling/practical/Notebooks/filtering.ipynb
bcftools query --format 'POS=%POS\n' out.vcf | head
bcftools query -f'%POS %REF,%ALT\n' out.vcf | head
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' out.vcf | head
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' -i'QUAL>=30' out.vcf | head
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' -i'QUAL>=30 && type="snp"' out.vcf | head   
bcftools stats out.vcf | head
bcftools stats out.vcf | grep TSTV
bcftools stats out.vcf | grep TSTV | cut -f5
bcftools filter -s LowQual -i'QUAL>=30 && AD[*:1]>=25' -g8 -G10 out.vcf -o out.flt.vcf


# ../../variant_calling/practical/Notebooks/multi-sample-calling.ipynb
ls *.bam
bcftools mpileup -a AD -f GRCm38_68.19.fa *.bam -Ou | bcftools call -mv -Ob -o multi.bcf 
bcftools index multi.bcf
bcftools filter -s LowQual -i'QUAL>=30 && AD[*:1]>=25' -g8 -G10 multi.bcf -Ob -o multi.filt.bcf
bcftools index multi.filt.bcf
#Exercises
bcftools stats multi.filt.bcf | grep TSTV | cut -f5 (raw calls)
bcftools stats -i 'FILTER="PASS"' multi.filt.bcf | grep TSTV | cut -f5 (only filtered set)
bcftools stats -e 'FILTER="PASS"' multi.filt.bcf | grep TSTV | cut -f5

# ../../variant_calling/practical/Notebooks/visualisation.ipynb
bcftools view -H -r 19:10001946 multi.filt.bcf
bcftools view -H -r 19:10072443 multi.filt.bcf


# ../../variant_calling/practical/Notebooks/annotation.ipynb
bcftools view -i 'FILTER="PASS"' multi.filt.bcf | bcftools csq -p m -f GRCm38_68.19.fa -g Mus_musculus.part.gff3.gz -Ob -o multi.filt.annot.bcf
bcftools index multi.filt.annot.bcf
bcftools query -f '%BCSQ' -r 19:10088937 multi.filt.annot.bcf


# ../../variant_calling/practical/Notebooks/answers.ipynb
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | bcftools call -mv | head
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' -i'QUAL>=30 && type="snp" && AD[*:1]>=25' out.vcf | head
bcftools stats -i'QUAL>=30 && AD[*:1]>=25' out.vcf | grep TSTV | cut -f5
bcftools stats -e'QUAL>=30 && AD[*:1]>=25' out.vcf | grep TSTV | cut -f5
bcftools stats -i 'GT="het"' out.vcf | grep TSTV | cut -f5
bcftools norm -f GRCm38_68.19.fa out.flt.vcf -o out.flt.norm.vcf
bcftools mpileup -a AD -f GRCm38_68.19.fa *.bam -Ou | bcftools call -mv -Ob -o multi.bcf
bcftools index multi.bcf
bcftools filter -s LowQual -i'QUAL>=30 && AD[*:1]>=25' -g8 -G10 multi.bcf -Ob -o multi.filt.bcf
bcftools index multi.filt.bcf
bcftools stats -e 'FILTER="PASS"' multi.filt.bcf | grep TSTV | cut -f5
bcftools view -H -r 19:10001946 multi.filt.bcf
bcftools view -H -r 19:10072443 multi.filt.bcf
bcftools query -f '%BCSQ' -r 19:10088937 multi.filt.annot.bcf

