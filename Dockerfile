# install miniconda from https://github.com/ContinuumIO/docker-images/tree/master/miniconda3/debian/Dockerfile
# install environment.yml from Gabriele Nasello
# Activate conda environment in Dockerfile https://pythonspeed.com/articles/activate-conda-dockerfile/


# FROM debian:bullseye-slim

# LABEL maintainer="Anaconda, Inc"

# ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ARG UBUNTU_VER=latest

FROM ubuntu:${UBUNTU_VER}

# below env var required to install libglib2.0-0 non-interactively
# Avoiding user interaction with tzdata when installing ubuntu
ENV TZ America/Los_Angeles
ENV DEBIAN_FRONTEND noninteractive

# System packages 
RUN apt-get update && apt-get install -yq curl wget jq vim git unzip curl htop less nano emacs

# install graphical libraries used by qt and vispy
# From Napari Dockerfile [https://github.com/napari/napari/blob/main/dockerfile]
# python3-pyqt5.qtwebkit is required by Cytoflow
RUN \
  apt-get update && \
  apt-get install -qqy mesa-utils libgl1-mesa-glx  libglib2.0-0 && \
  apt-get install -qqy libfontconfig1 libxrender1 libdbus-1-3 libxkbcommon-x11-0 libxi6 && \
  apt-get install -qqy libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 && \
  apt-get install -qqy libxcb-xinerama0 libxcb-xinput0 libxcb-xfixes0 libxcb-shape0 && \
  apt-get install -qqy python3-pyqt5.qtwebkit

# Make RUN commands use `bash --login`:
SHELL ["/bin/bash", "--login", "-c"]

ENV PATH /opt/conda/bin:$PATH

# Leave these args here to better use the Docker build cache
ARG CONDA_VERSION=py38_4.9.2

RUN set -x && \
    UNAME_M="$(uname -m)" && \
    if [ "${UNAME_M}" = "x86_64" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh"; \
        SHA256SUM="1314b90489f154602fd794accfc90446111514a5a72fe1f71ab83e07de9504a7"; \
    elif [ "${UNAME_M}" = "s390x" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-s390x.sh"; \
        SHA256SUM="4e6ace66b732170689fd2a7d86559f674f2de0a0a0fbaefd86ef597d52b89d16"; \
    elif [ "${UNAME_M}" = "aarch64" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-aarch64.sh"; \
        SHA256SUM="b6fbba97d7cef35ebee8739536752cd8b8b414f88e237146b11ebf081c44618f"; \
    elif [ "${UNAME_M}" = "ppc64le" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-ppc64le.sh"; \
        SHA256SUM="2b111dab4b72a34c969188aa7a91eca927a034b14a87f725fa8d295955364e71"; \
    fi && \
    wget "${MINICONDA_URL}" -O miniconda.sh -q && \
    echo "${SHA256SUM} miniconda.sh" > shasum && \
    #if [ "${CONDA_VERSION}" != "latest" ]; then sha256sum --check --status shasum; fi && \
    mkdir -p /opt && \
    sh miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh shasum && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

# Initialize conda in bash config fiiles:
RUN conda init bash

ADD r_environment.yml .
ADD install_r_packages.R .
RUN conda env create -f r_environment.yml
RUN conda activate r-flowcyto && \
    Rscript install_r_packages.R && \
    conda list --explicit > ../r_spec-conda-file.txt

ADD py_environment.yml .
RUN conda env create -f py_environment.yml
RUN conda activate py-flowcyto && \
    conda list --explicit > ../py_spec-conda-file.txt

# 1. Print list of all conda environments at startup
# 2. create the jl shortcut to start jupyter lab with a specified port
RUN echo "conda env list" >> ~/.bashrc && \ 
    echo "conda activate r-flowcyto" >> ~/.bashrc && \
    echo "alias jl='export SHELL=/bin/bash; jupyter lab --allow-root --port=7777 --ip=0.0.0.0'" >> ~/.bashrc
