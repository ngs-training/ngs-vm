#!/bin/bash

set -x
set -eu

GENOMESCOPE_DOWNLOAD_URL="https://raw.githubusercontent.com/schatzlab/genomescope/d2aefddd32ce48aa1144d9fbd80ed6b37785cd8d/genomescope.R"
MINICONDA_BIN_LOCATION="${MINICONDA}/bin"

# Set the conda channels - move to .travis.yml?
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

set +eu
set +x
