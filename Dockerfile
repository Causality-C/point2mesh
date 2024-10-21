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

# Populate this with your architecture from: https://github.com/facebookresearch/pytorch3d/issues/1565
ENV TORCH_CUDA_ARCH_LIST="Turing Ampere Ada Hopper" 

# change the working directory to the repository
WORKDIR /workspace/point2mesh
COPY requirements.txt requirements.txt

RUN pip install torch==2.4.0 torchvision==0.19.0 numpy==1.24.0

RUN pip install git+https://github.com/facebookresearch/pytorch3d.git@stable

COPY . . 