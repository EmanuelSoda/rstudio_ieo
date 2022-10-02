FROM rocker/tidyverse:latest

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN echo "options(repos = 'https://cloud.r-project.org')" > $(R --no-echo --no-save -e "cat(Sys.getenv('R_HOME'))")/etc/Rprofile.site

#########  apt-get #########
RUN apt-get update &&  apt-get install -y --no-install-recommends \
    build-essential \
    imagemagick \
    libhdf5-dev \
    uuid-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \ 
    liblzma-dev \
    libfribidi-dev \
    libbz2-dev \
    libgeos-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libgpgme-dev \
    libglpk-dev \ 
    squashfs-tools \
    libseccomp-dev \
    wget \
    python3.10 \
    pkg-config \
    git \ 
    tar \
    libcurl4-openssl-dev \
    libssl-dev \
    libpng-dev \
    libboost-all-dev \
    libxml2-dev \
    openjdk-8-jdk \
    python3-dev \
    libfftw3-dev \
    libgsl-dev \
    libudunits2-dev \
    python3-pip \
    cryptsetup-bin \
    curl 

RUN apt-get update && apt-get install -y --no-install-recommends \
  llvm-10  

# Install UMAP
RUN LLVM_CONFIG=/usr/lib/llvm-10/bin/llvm-config pip3 install llvmlite
RUN pip3 install numpy
RUN pip3 install umap-learn

# Install FIt-SNE
RUN git clone --branch v1.2.1 https://github.com/KlugerLab/FIt-SNE.git
RUN g++ -std=c++11 -O3 FIt-SNE/src/sptree.cpp FIt-SNE/src/tsne.cpp FIt-SNE/src/nbodyfft.cpp  -o bin/fast_tsne -pthread -lfftw3 -lm

# Install bioconductor dependencies & suggests
RUN R --no-echo --no-restore --no-save -e "install.packages('BiocManager')"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install(c('multtest', 'S4Vectors', 'SummarizedExperiment', 'SingleCellExperiment', 'MAST', 'DESeq2', 'BiocGenerics', 'GenomicRanges', 'IRanges', 'rtracklayer', 'monocle', 'Biobase', 'limma', 'glmGamPoi'))"

# Install CRAN suggests
RUN R --no-echo --no-restore --no-save -e "install.packages(c('VGAM', 'R.utils', 'metap', 'Rfast2', 'ape', 'enrichR', 'mixtools'))"

# Install hdf5r
RUN R --no-echo --no-restore --no-save -e "install.packages('hdf5r')"

# Install Seurat
RUN R --no-echo --no-restore --no-save -e "install.packages('remotes')"
RUN R --no-echo --no-restore --no-save -e "install.packages('Seurat')"

# Install SeuratDisk
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('mojaveazure/seurat-disk')"

# Install phateR1
RUN R -e "install.packages('phateR')"

# Install Harmony
RUN R -e "install.packages('harmony')"

# Install Signac
RUN R --no-echo --no-restore --no-save -e "install.packages('Signac')"

# Install phate 
RUN python3 -m pip install --no-cache-dir  phate