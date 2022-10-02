FROM emanuelsoda/rstudio_seurat:latest

#RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install  scvi-tools 
RUN python3 -m pip install --no-cache-dir  scvi-tools 

# Install  PhenoGraph
RUN python3 -m pip install --no-cache-dir  PhenoGraph 

# Install  palantir
RUN python3 -m pip install --no-cache-dir  palantir 

########### Install R Packages #########

# Install dyno 
RUN R --no-echo --no-restore --no-save -e "devtools::install_github('dynverse/dyno')"

# Install swne 
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('linxihui/NNLM')"

RUN R --no-echo --no-restore --no-save -e "devtools::install_github('aertslab/RcisTarget')"

RUN R --no-echo --no-restore --no-save -e "BiocManager::install('AUCell')"

RUN R --no-echo --no-restore --no-save -e "devtools::install_github('aertslab/cisTopic')"

RUN R --no-echo --no-restore --no-save -e "remotes::install_github('yanwu2014/swne')"

# Install scPred
RUN R --no-echo --no-restore --no-save -e "devtools::install_github('powellgenomicslab/scPred')"

# Install tidymodels
RUN R --no-echo --no-restore --no-save -e "install.packages('tidymodels', dependencies=TRUE, repos='http://cran.rstudio.com/')"



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
