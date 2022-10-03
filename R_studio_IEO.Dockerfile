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


