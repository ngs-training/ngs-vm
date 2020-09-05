FROM ubuntu:18.04

MAINTAINER Jacqui Keane <drjkeane@gmail.com>

ENV PATH=/miniconda/bin:${PATH}

# System packages 
RUN apt-get update && apt-get install -y wget && apt-get clean

# Install miniconda (for python2.7) to /miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh 
RUN bash Miniconda2-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda2-latest-Linux-x86_64.sh

# Update conda
RUN conda update -y conda

# Set the conda channels
RUN conda config --add channels default
RUN conda config --add channels r
RUN conda config --add channels conda-forge
RUN conda config --add channels bioconda

# Install software using miniconda
# Core tools
RUN conda install samtools
RUN conda install bcftools            
RUN conda install bedtools    
RUN conda install igv            
# QC module
RUN conda install picard
# Read alignment module
RUN conda install bwa
# SV module
RUN conda install breakdancer
RUN conda install lumpy-sv
RUN conda install ngmlr
RUN conda install sniffles
# RNA-Seq module
RUN conda install hisat2
RUN conda install kallisto
RUN conda install r-sleuth
# CHiP-Seq module
RUN conda install bowtie2
RUN conda install macs2
RUN conda install meme
RUN conda install ucsc-bedgraphtobigwig
# Asembly module
RUN conda install assembly-stats
RUN conda install canu
RUN conda install kmer-jellyfish
RUN conda install seqtk
RUN conda install velvet
RUN conda install wtdbg
#Install genomescope.R (not available via bioconda)
RUN wget https://raw.githubusercontent.com/schatzlab/genomescope/d2aefddd32ce48aa1144d9fbd80ed6b37785cd8d/genomescope.R
RUN mv genomescope.R /miniconda/bin
RUN chmod 754 /miniconda/bin/genomescope.R

# Install git
RUN conda install git

# Install the course modules from github
# git clone <add link to git repo once finalised>

# Setup the application
EXPOSE 8080
