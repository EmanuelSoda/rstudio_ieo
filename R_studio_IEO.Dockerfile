FROM rocker/tidyverse:latest

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN  apt-get update && apt-get install -y --no-install-recommends \
    imagemagick \
  && rm -rf /var/lib/apt/lists/*


#########  apt-get #########
RUN apt-get update &&  apt-get install -y --no-install-recommends \
    build-essential \
    uuid-dev \
    libgpgme-dev \
    squashfs-tools \
    libseccomp-dev \
    wget \
    python3.10 \
    pkg-config \
    git \ 
    tar \
    python3-pip \
    cryptsetup-bin \
  && rm -rf /var/lib/apt/lists/*

# Install phate 
RUN python3 -m pip install --no-cache-dir  phate

# Install  scvi-tools 
RUN python3 -m pip install --no-cache-dir  scvi-tools 

# Install  PhenoGraph
RUN python3 -m pip install --no-cache-dir  PhenoGraph 

# Install  palantir
RUN python3 -m pip install --no-cache-dir  palantir 

########### Install R Packages #########
# Install Seurat 
RUN R -e "install.packages('Seurat', dependencies=TRUE, repos='http://cran.rstudio.com/')"

# Install Seurat  Object
RUN R -e "install.packages('SeuratObject', dependencies=TRUE, repos='http://cran.rstudio.com/')"

# Install tidymodels
RUN R -e "install.packages('tidymodels', dependencies=TRUE, repos='http://cran.rstudio.com/')"

# Install dyno 
RUN R -e "devtools::install_github('dynverse/dyno')"

# Install phateR1
RUN R -e "install.packages('phateR')"

# Install Harmony
RUN R -e "install.packages('harmony')"

# Install scPred
RUN devtools::install_github("powellgenomicslab/scPred")


# Install swne 
RUN R -e "if(!require(remotes)){ install.packages('remotes') # If not already installed; }"
RUN R -e "remotes::install_github('linxihui/NNLM')"
RUN R -e "remotes::install_github('yanwu2014/swne')"

RUN R -e "devtools::install_github('aertslab/RcisTarget')"
RUN R -e"devtools::install_github('aertslab/AUCell')"
RUN R -e"devtools::install_github('aertslab/cisTopic')"





########### Install R Singularity #########
ENV VERSION=1.16.3 
ENV OS=linux 
ENV ARCH=amd64

# Download Go source version 1.16.3, install them and modify the PATH
RUN wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
    tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && \
    rm go$VERSION.$OS-$ARCH.tar.gz && \
    echo 'export PATH=$PATH:/usr/local/go/bin' | tee -a /etc/profile


# Download Singularity from version 3.7.3 (security version)
ENV VERSION=3.7.3
RUN wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz && \
    tar -xzf singularity-${VERSION}.tar.gz


# Compile Singularity sources and install it
RUN export PATH=$PATH:/usr/local/go/bin && \
    cd singularity && \
    ./mconfig --without-suid && \
    make -C ./builddir && \
    make -C ./builddir install
