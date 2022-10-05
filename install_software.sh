
#!/bin/bash
#
# Author: Jacqui Keane <drjkeane at gmail.com>
# URL:    https://www.cambridgebioinformatics.com
#
# Usage: install_software.sh
#

set -x
#set -eu

# Script to build vm for wac ngs bioinformatics course, assumes run as user manager

export MINICONDA="$HOME/miniconda"
export MINICONDA_BIN_LOCATION="$MINICONDA/bin"
export PATH="$MINICONDA_BIN_LOCATION:$PATH"

source $MINICONDA/etc/profile.d/conda.sh

# Core, RNA-Seq and CHiP-Seq modules
conda create -n ngsbio6 breakdancer=1.4.5 

conda activate ngsbio6

conda install samtools=1.15.1 bcftools=1.15.1 bedtools=2.30.0 openmpi=4.1.4 r-base=4.0.5 bowtie2=2.4.5 macs2=2.2.7.1 meme=5.4.1 ucsc-bedgraphtobigwig=377 ucsc-fetchchromsizes=377 r-sleuth=0.30.0 bioconductor-rhdf5=2.34.0 bioconductor-rhdf5filters=1.2.0 bioconductor-rhdf5lib=1.12.0 hdf5=1.10.5 hisat2=2.2.1 kallisto=0.46.2

# Read alignment module
conda install bwa=0.7.17

# Assembly module
conda install assembly-stats=1.0.1 canu=2.2 kmer-jellyfish=2.3.0 seqtk=1.3 velvet=1.2.10 wtdbg=2.5 genomescope2=2.0

# Group projects
conda install freebayes=0.9.21.7

# Install java apps towarss end to avoid downgrade of certain dependencies
conda install gatk4=4.2.6.1
conda install igv=2.13.2
conda install picard-slim=2.27.4

conda install minimap2=2.24 sniffles=2.0.7
conda install pytz edlib threadpoolctl six scipy networkx joblib cython click scikit-learn python-dateutil pandas lightgbm sortedcontainers
pip install dysgu

conda deactivate

echo "source $MINICONDA/etc/profile.d/conda.sh" >> ~/.bashrc
echo "conda activate ngsbio6" >> ~/.bashrc

# SV module
#conda create -n sv-calling samtools=1.15.1 minimap2=2.24 sniffles=2.0.7 breakdancer=1.4.5
#conda activate sv-calling
# Now install software via pip that is not available with conda
#conda install pandas numpy scipy networkx Cython edlib
#pip install dysgu
#conda deactivate

# Install genomescope.R (not available via bioconda)
#wget https://raw.githubusercontent.com/schatzlab/genomescope/d2aefddd32ce48aa1144d9fbd80ed6b37785cd8d/genomescope.R
#mv genomescope.R $MINICONDA_BIN_LOCATION
#chmod 754 $MINICONDA_BIN_LOCATION/genomescope.R

#set +eu
set +x
