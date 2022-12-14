#!/bin/bash

##===========================================##===========================================##
# Set image version
##===========================================##===========================================##
IMAGE_VERSION=$(date "+%m%d%y")


##===========================================##===========================================##
# Build the image and push it to docker hub
##===========================================##===========================================##
docker build --platform linux/amd64 --no-cache -t emanuelsoda/rstudio_seurat:${IMAGE_VERSION}  -t emanuelsoda/rstudio_seurat:latest . -f Rstudio_Seurat.dockerfile 2>&1 | tee stdout.log && \
docker push emanuelsoda/rstudio_seurat:${IMAGE_VERSION}
docker push emanuelsoda/rstudio_seurat:latest

# USE THESE LINES ONLY WHEN EVERYTHING WORKS. Below is for testing.


##===========================================##===========================================##
# Bulding/testing components of the image
##===========================================##===========================================##
# docker build --progress=plain -t emanuelsoda/rstudio_seurat:${IMAGE_VERSION} . 2>&1 | tee stdout.log && \


# I think --no-cache arguments it's usefull when building the final image of when there are problmes withe dependencies,
# otherwise it slows down everything. Last part redirects STDOUT/ERR both to STDOUT and a file that it's usefull to check
# whether packgaes have been installed since the output is super verbose. Sometimes packages don't get installed but it doens't
# throw and error. In this way i can double check what happened.