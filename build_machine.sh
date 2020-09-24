#!/bin/bash

set -x
set -eu

GENOMESCOPE_DOWNLOAD_URL="https://raw.githubusercontent.com/schatzlab/genomescope/d2aefddd32ce48aa1144d9fbd80ed6b37785cd8d/genomescope.R"
MINICONDA="{$HOME}/miniconda"
MINICONDA_BIN_LOCATION="${MINICONDA}/bin"

# Update system packages 
sudo apt-get update && sudo apt-get install -y git && sudo apt-get install -y wget && sudo apt-get clean

#Install python
sudo apt install python2.7

if [[ "$PYTHON_VERSION" == "2.7" ]]; then
   wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh;
else
   wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
fi
bash miniconda.sh -b -p $MINICONDA

#Set conda for autoinstalls and update conda
conda config --set always_yes yes --set changeps1 no
conda update -q conda

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
#conda install lumpy-sv
conda install ngmlr
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
# Asembly module
conda install assembly-stats
conda install canu
conda install kmer-jellyfish
conda install seqtk
conda install velvet
conda install wtdbg
#Install genomescope.R (not available via bioconda)
wget ${GENOMESCOPE_DOWNLOAD_URL}
mv genomescope.R ${MINICONDA_BIN_LOCATION}
chmod 754 ${MINICONDA_BIN_LOCATION}/genomescope.R

#Install last to see if resolves issue with latest version
conda install samtools=1.10

# Install git
conda install git

# Install the course modules from github
# git clone <add link to git repo once finalised>

#Set path
export PATH=$MINICONDA_BIN_LOCATION:$PATH
echo $PATH

set +eu
set +x
