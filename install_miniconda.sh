
#!/bin/bash
#
# Author: Jacqui Keane <drjkeane at gmail.com>
# URL:    https://www.cambridgebioinformatics.com
#
# Usage: install_miniconda.sh
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
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
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

# Install the course modules from github
cd $HOME
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
