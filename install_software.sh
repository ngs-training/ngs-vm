
#!/bin/bash
#
# Script to build vm for wac ngs bioinformatics course, assumes run as user manager
# Author: Jacqui Keane <drjkeane at gmail.com>
# URL:    https://www.cambridgebioinformatics.com
#
# Usage: install_software.sh
#

set -x

export MINICONDA="$HOME/miniconda"
export MINICONDA_BIN_LOCATION="$MINICONDA/bin"
export PATH="$MINICONDA_BIN_LOCATION:$PATH"

source $MINICONDA/etc/profile.d/conda.sh

# Create a conda environment and install breakdancer 
conda create -n ngsbio breakdancer=1.4.5 

# Activate the environment
conda activate ngsbio

# Core, RNA-Seq and CHiP-Seq modules
conda install samtools=1.15.1 bcftools=1.15.1 bedtools=2.30.0 openmpi=4.1.4 r-base=4.0.5 bowtie2=2.4.5 macs2=2.2.7.1 meme=5.4.1 ucsc-bedgraphtobigwig=377 ucsc-fetchchromsizes=377 r-sleuth=0.30.0 bioconductor-rhdf5=2.34.0 bioconductor-rhdf5filters=1.2.0 bioconductor-rhdf5lib=1.12.0 hdf5=1.10.5 hisat2=2.2.1 kallisto=0.46.2

# Read alignment module
conda install bwa=0.7.17

# Assembly module
conda install assembly-stats=1.0.1 canu=2.2 kmer-jellyfish=2.3.0 seqtk=1.3 velvet=1.2.10 wtdbg=2.5 genomescope2=2.0

# Group projects
conda install freebayes=0.9.21.7

# Install java apps towards end to avoid downgrade of certain dependencies
conda install gatk4=4.2.6.1
conda install picard-slim=2.27.4

# SV module
conda install minimap2=2.24 sniffles=2.0.7
conda install pytz edlib threadpoolctl six scipy networkx joblib cython click scikit-learn python-dateutil pandas lightgbm sortedcontainers
pip install dysgu

conda deactivate

# Chipseq project
conda create -n chipseq-project r-ngsplot

# Install igv outside conda
wget https://data.broadinstitute.org/igv/projects/downloads/2.14/IGV_Linux_2.14.1_WithJava.zip
unzip IGV_Linux_2.14.1_WithJava.zip
rm IGV_Linux_2.14.1_WithJava.zip

# Create a jupyter environment to allow instructors to run, edit and convert notebooks
conda create -n jupyter jupyter=1.0.0 pandoc=2.12 texlive-core
conda activate jupyter
pip install bash_kernel
python -m bash_kernel.install
conda deactivate

# Activate ngsbio environment by default by adding to .bashrc
echo "source $MINICONDA/etc/profile.d/conda.sh" >> ~/.bashrc
echo "conda activate ngsbio" >> ~/.bashrc

# Add igv to the path
echo 'alias igv="igv.sh"' >> ~/.bashrc 
echo 'export PATH="~/IGV_Linux_2.14.1:$PATH"' >> ~/.bashrc 

set +x
