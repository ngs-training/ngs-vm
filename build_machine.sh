
#!/bin/bash
#
# Author: Jacqui Keane <drjkeane at gmail.com>
# URL:    https://www.cambridgebioinformatics.com
#
# Usage: install_conda_profules.sh
#

set -x
set -eu

# Script to build vm for wac ngs bioinformatics course, assumes run as user manager

export MINICONDA="$HOME/miniconda"
export MINICONDA_BIN_LOCATION="$MINICONDA/bin"
export PATH="$MINICONDA_BIN_LOCATION:$PATH"

# Update system packages
sudo apt-get update && sudo apt-get install -y git && sudo apt-get install -y wget && sudo apt-get clean

# Download and install miniconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
bash miniconda.sh -b -p $MINICONDA

# Set conda for autoinstalls and update conda
conda config --set always_yes yes --set changeps1 no
conda update -n base -c defaults conda

# Useful for debugging any issues with conda
conda info -a

# Set the conda channels
conda config --add channels defaults
conda config --add channels r
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict

# Install software using miniconda
# Core tools
conda install samtools=1.14
conda install bcftools=1.14
conda install bedtools=2.30
# Read alignment module
conda install bwa=0.7.17
# SV module
conda install breakdancer=1.4.5
conda install minimap2=2.24
conda install sniffles=2.0.6
# RNA-Seq module
conda install hisat2=2.2.1
conda install kallisto=0.48.0
conda install r-sleuth=0.30.0
# CHiP-Seq module
conda install bowtie2=2.4.5
conda install macs2=2.2.7.1
conda install meme=5.4.1
conda install ucsc-bedgraphtobigwig=377
conda install ucsc-fetchchromsizes=377
# Assembly module
conda install assembly-stats=1.0.1
conda install canu=2.2
conda install kmer-jellyfish=2.3.0
conda install seqtk=1.3
conda install velvet=1.2.10
conda install wtdbg=2.5
conda install genomescope2=2.0
# Group projects
conda install freebayes=1.3.6
conda install gatk4=4.2.6.1
# Finally install picard and IGV last to avoid downgrade of certain dependencies
conda install picard-slim=2.27.4
conda install igv=2.13
# Now install software via pip that is not available with conda
pip install dysgu

# Install genomescope.R (not available via bioconda)
#wget https://raw.githubusercontent.com/schatzlab/genomescope/d2aefddd32ce48aa1144d9fbd80ed6b37785cd8d/genomescope.R
#mv genomescope.R $MINICONDA_BIN_LOCATION
#chmod 754 $MINICONDA_BIN_LOCATION/genomescope.R

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

# Initialise conda so it persists in the .bashrc
conda init bash

set +eu
set +x
