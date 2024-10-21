FROM nvidia/cuda:12.6.0-cudnn-devel-ubuntu22.04

LABEL name="point2mesh" maintainer="Causality-C"

# update package lists and install git, wget, vim, libegl1-mesa-dev, and libglib2.0-0
RUN apt-get update && apt-get install -y build-essential git wget vim libegl1-mesa-dev libglib2.0-0 unzip git tree cmake

# install conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x Miniconda3-latest-Linux-x86_64.sh && \
    ./Miniconda3-latest-Linux-x86_64.sh -b -p /workspace/miniconda3 && \
    rm Miniconda3-latest-Linux-x86_64.sh

# initialize conda
ENV PATH="/workspace/miniconda3/bin:${PATH}"
RUN conda init bash

RUN conda create -n point2mesh python=3.10 && echo "source activate point2mesh" > ~/.bashrc

# update PATH environment variable
ENV PATH="/workspace/miniconda3/envs/point2mesh/bin:$PATH"


# # change the working directory to the repository
WORKDIR /workspace/point2mesh
COPY . .