#!/bin/bash

set -x
set -eu

export MINICONDA="$HOME/miniconda"
export MINICONDA_BIN_LOCATION="$MINICONDA/bin"
export PATH="$MINICONDA_BIN_LOCATION:$PATH"

# Update system packages 
sudo apt-get update && sudo apt-get install -y git && sudo apt-get install -y wget && sudo apt-get clean

#Install python
sudo apt install python2.7

#if [[ "$PYTHON_VERSION" == "2.7" ]]; then
wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh;
#else
#wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
#fi
bash miniconda.sh -b -p $MINICONDA

#Set conda for autoinstalls and update conda
conda config --set always_yes yes --set changeps1 no
conda update -n base -c defaults conda

# Useful for debugging any issues with conda
conda info -a

# Set the conda channels
conda config --add channels default
conda config --add channels r
conda config --add channels conda-forge
conda config --add channels bioconda

# Install software using miniconda
# Core tools
#conda install samtools=1.10
conda install bcftools
conda install bedtools
conda install igv
# QC module
conda install picard
# Read alignment module
conda install bwa
# SV module
conda install breakdancer
conda install lumpy-sv
conda install minimap2
conda install sniffles
# RNA-Seq module
conda install hisat2
conda install kallisto
conda install r-sleuth
# CHiP-Seq module
conda install bowtie2
conda install macs2
conda install meme
conda install ucsc-bedgraphtobigwig
conda install ucsc-fetchchromsizes
# Assembly module
conda install assembly-stats
conda install canu
conda install kmer-jellyfish
conda install seqtk
conda install velvet
conda install wtdbg
# Group projects
conda install freebayes
conda install gatk4

#Install genomescope.R (not available via bioconda)
wget https://raw.githubusercontent.com/schatzlab/genomescope/d2aefddd32ce48aa1144d9fbd80ed6b37785cd8d/genomescope.R
mv genomescope.R $MINICONDA_BIN_LOCATION
chmod 754 $MINICONDA_BIN_LOCATION/genomescope.R

#Install last to see if resolves issue with latest version
conda install samtools=1.10

# Install the course modules from github
cd /home/manager
mkdir course_data
cd course_data
git clone http://www.github.com/WTAC-NGS/unix
git clone http://www.github.com/WTAC-NGS/data_formats
git clone http://www.github.com/WTAC-NGS/read_alignment
git clone http://www.github.com/WTAC-NGS/variant_calling
git clone http://www.github.com/WTAC-NGS/structural_variation
git clone http://www.github.com/WTAC-NGS/rna_seq
git clone http://www.github.com/WTAC-NGS/chip_seq
git clone http://www.github.com/WTAC-NGS/assembly
git clone http://www.github.com/WTAC-NGS/igv

#Set path
export set PATH=$MINICONDA_BIN_LOCATION:$PATH
echo $PATH

set +eu
set +x
