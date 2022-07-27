cd /home/manager/course_data/unix/practical/Notebooks
cd basic
ls /home/manager/course_data/unix/Notebooks/index.ipynb
pwd
ls
ls -l
ls -a -l
ls -alh
ls -l Pfalciparum
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
#1Solutions
cd ../files
#less Styphi.gff
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
#Solutions to exercises
echo "done"
cd ../grep
