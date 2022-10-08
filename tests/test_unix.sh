#!/bin/bash
set -x
set -eu

### Section 1 - Introduction
cd ~/course_data/unix/practical/Notebooks

### Section 2 - Basic Unix
pwd
cd basic
ls ~/course_data/unix/practical/Notebooks/index.ipynb
pwd
ls
ls -l
ls -a -l
ls -alh
ls -l Pfalciparum/
ls -l
cd Styphi
pwd
ls
ls .
ls ..
ls ~
pwd
cp Styphi.gff StyphiCT18.gff
ls
cd ..
mv Styphi/StyphiCT18.gff .
ls Styphi
ls
rm StyphiCT18.gff
ls
find . -name *.gff
find . -type d
### Exercises
cd ../basic
ls
ls | wc -l
ls -alhrt
cd Pfalciparum
ls -a fasta | wc -l
cp Pfalciparum.bed annotation
mv *.fa* fasta
ls -a fasta | wc -l
find ~/course_data/unix -name "*.gff" | wc -l
find ~/course_data/unix -name "*.fa*" | wc -l

### Section 3 - Looking inside files
cd ../../files
#less Styphi.gff
head Styphi.gff
head Styphi.gff
tail Styphi.gff
tail -n 25 Styphi.gff
#man tail
head -1 Styphi.gff > first_Styphi_line.txt
cat first_Styphi_line.txt
rm first_Styphi_line.txt
cat Styphi.noseq.gff Styphi.fa > Styphi.concatenated.gff
ls
wc -l Styphi.gff
cat Styphi.gff | wc -l
ls | wc -l
ls | grep ".gff" | wc -l
sort Pfalciparum.bed
sort Pfalciparum.bed | head
sort Pfalciparum.bed | tail
sort -k 2 -n Pfalciparum.bed
sort -k 2 -n Pfalciparum.bed | head
sort -k 2 -n Pfalciparum.bed | tail
#man sort
awk '{ print $1 }' Pfalciparum.bed | sort | uniq
#awk '{ print $1 }' Pfalciparum.bed | less
#awk '{ print $1 }' Pfalciparum.bed | sort | less
#awk '{ print $1 }' Pfalciparum.bed | sort | uniq | less
### Exercises
head -n 500 Styphi.gff > Styphi.500.gff
wc -l Pfalciparum.bed
sort -k 1 -k 2 -n Pfalciparum.bed
awk '{ print $1 }' Pfalciparum.bed | sort | uniq -c

### Section 4 - Searching inside files with grep
cd ../grep
cat gene_expression.bed
grep chr2 gene_expression.bed
grep chr2 gene_expression.bed | grep +
grep chr1 gene_expression.bed
cat gene_expression_sneaky.bed
grep chr1 gene_expression_sneaky.bed | grep '-'
grep chr1 gene_expression_sneaky.bed
grep '^chr1' gene_expression_sneaky.bed
grep $'^chr1\t' gene_expression_sneaky.bed
grep $'^chr1\t' gene_expression_sneaky.bed | grep '\-$'
grep $'^chr.\t' gene_expression.bed
grep $'^chr1\t.*-$' gene_expression_sneaky.bed
grep $'^chr[12X]\t' gene_expression.bed
grep $'^chr[0-9]\+\t' gene_expression.bed
#man grep
grep -c $'^chr[0-9]\+\t' gene_expression.bed
cat sequences.fasta
grep ACGT sequences.fasta
grep -i ACGT sequences.fasta
cat list_example.1
grep '^gene1$' list_example.1 list_example.2
echo list_example.*
grep '^gene1$' list_example.*
grep '^gene42$' list_example.*
grep -v $'^chr[0-9]\+\t' gene_expression.bed
sed 's/^chr/chromosome/' gene_expression.bed
### Exercises
grep "^>" exercises.fasta
grep -c "^>" exercises.fasta
grep "^>" exercises.fasta | wc -l
grep "^>" exercises.fasta | grep " "
grep -v "^>" exercises.fasta
grep -v "^>" exercises.fasta | grep -c -i n
grep -v "^>" exercises.fasta | grep -i -v "^[acgtn].*$"
grep -v "^>" exercises.fasta | grep -i "[^ACGTN]"
grep -v "^>" exercises.fasta | grep -c "GC[AT]GC"
grep -c "^>" exercises.fasta
grep "^>" exercises.fasta | sort | uniq | wc -l

### Section 5 - File processing with AWK
cd ../awk
cat genes.gff
awk -F"\t" '{print $1}' genes.gff
awk -F"\t" '{print $1}' genes.gff | sort -u
awk -F"\t" '$1=="chr1" {print $0}' genes.gff
awk -F"\t" '$1=="chr1"' genes.gff
awk -F"\t" '{print $1}' genes.gff
awk -F"\t" '$1=="chr1" && $3=="gene"' genes.gff
awk -F"\t" '$1=="chr1" && $3=="gene" {print $2}' genes.gff | sort -u
awk -F"\t" '$2=="source2" || $3=="repeat"' genes.gff
awk -F"\t" '$1=="chr1" && $3=="gene" && $4 < 1100' genes.gff
awk -F"\t" '$1 ~ /^chr[0-9]+$/' genes.gff
awk -F"\t" '$1 !~ /^chr[0-9]+$/' genes.gff
awk '/repeat/' genes.gff
grep repeat genes.gff
awk -F"\t" '/repeat/ {print $1}' genes.gff | sort -u
awk -F"\t" '$3=="gene" && !($7 == "+" || $7 == "-")' genes.gff
awk -F"\t" '$5 < $4' genes.gff
awk -F"\t" '$3=="gene" && (NF<9 || $NF !~/name/)' genes.gff
awk -F"\t" 'NF>8 {print $NF}' genes.gff
awk 'NF>8 {print $NF}' genes.gff
awk -F"\t" 'NF<8 || NF>9' genes.gff
awk -F"\t" '{$2="new_source"; print $0}' genes.gff
awk -F"\t" 'BEGIN{OFS="\t"} {$2="new_source"; print $0}' genes.gff
awk -F"\t" '$3=="repeat" {print $5 - $4 + 1}' genes.gff | sort -n
awk -F"\t" 'BEGIN{sum=0} $3=="repeat" \
            {sum = sum + $5 - $4 + 1} \
            END{print sum}' genes.gff
awk -F"\t" 'BEGIN{sum=0} \
            $3=="repeat" {sum += $5 - $4 + 1} \
            END{print sum}' genes.gff
awk -F"\t" 'BEGIN{sum=0; count=0} \
            $3=="gene" {sum += $6; count++} \
            END{print sum/count}' genes.gff
awk -F"\t" '$3=="gene" {sum += $6; count++} \
            END{print sum/count}' genes.gff
### Exercises
awk -F"\t" '{print $1}' exercises.bed | sort -u
awk -F"\t" '{print $1}' exercises.bed | sort -u | wc -l
awk -F"\t" '$6=="+"' exercises.bed | wc -l
awk -F"\t" '$6=="-"' exercises.bed | wc -l
awk -F"\t" '$4 ~ /gene/' exercises.bed | wc -l
awk -F"\t" '$4 ~ /gene/ && $6 != "-" && $6 != "+"' exercises.bed | wc -l
awk -F"\t" '$4 ~ /gene/' exercises.bed | wc -l
awk -F"\t" '$4 ~ /gene/ {print $4}' exercises.bed | sort -u | wc -l
awk -F"\t" '$4 ~ /gene/ {print $4}' exercises.bed  | sort | uniq -c | awk '$1>1'
awk -F"\t" '$4=="repeat" {score+=$5} END {print score}' exercises.bed
awk -F"\t" '$1 == "contig-1"' exercises.bed  | wc -l
awk -F"\t" '$1 == "contig-1" && $4 == "repeat"' exercises.bed  | wc -l
awk -F"\t" '$1 == "contig-1" && $4 == "repeat" {score+=$5; count++} END{print score/count}' exercises.bed

set +eu
set +x
