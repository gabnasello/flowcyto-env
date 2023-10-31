FROM lscr.io/linuxserver/webtop:amd64-ubuntu-kde-version-0f29909a
#FROM lscr.io/linuxserver/webtop:amd64-ubuntu-kde-2e6d5ead-ls2

# Configure environment
ENV DOCKER_IMAGE_NAME='flowcyto-env'
ENV VERSION='2023-10-31' 

# title
ENV TITLE='Flow Cytometry'

# ports and volumes
EXPOSE 3000

# ports and volumes
EXPOSE 8888

VOLUME /config

# Install Bioconductor dependencies
# from [https://github.com/Bioconductor/bioconductor_docker/blob/devel/bioc_scripts/install_bioc_sysdeps.sh]
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils \
                                                gdb \
                                                libxml2-dev \
                                                python3-pip \
                                                libz-dev \
                                                liblzma-dev \
                                                libbz2-dev \
                                                libpng-dev \
                                                libgit2-dev


## sys deps from bioc_full
RUN apt-get install -y --no-install-recommends \
                                pkg-config \
                                fortran77-compiler \
                                byacc \
                                automake \
                                curl \
                                cmake

# ## This section installs libraries
RUN apt-get install -y --no-install-recommends \
                                libpcre2-dev \
                                libnetcdf-dev \
                                libhdf5-serial-dev \
                                libfftw3-dev \
                                libopenbabel-dev \
                                libopenmpi-dev \
                                libxt-dev \
                                libudunits2-dev \
                                libgeos-dev \
                                libproj-dev \
                                libcairo2-dev \
                                libtiff5-dev \
                                libreadline-dev \
                                libgsl0-dev \
                                libgslcblas0 \
                                libgtk2.0-dev \
                                libgl1-mesa-dev \
                                libglu1-mesa-dev \
                                libgmp3-dev \
                                libhdf5-dev \
                                libncurses-dev \
                                libxpm-dev \
                                liblapack-dev \
                                libmpfr-dev \
                                libmodule-build-perl \
                                libapparmor-dev \
                                libprotoc-dev \
                                librdf0-dev \
                                libmagick++-dev \
                                libsasl2-dev \
                                libpoppler-cpp-dev \
                                libprotobuf-dev \
                                libpq-dev \
                                libarchive-dev \
                                coinor-libcgl-dev \
                                coinor-libsymphony-dev \
                                coinor-libsymphony-doc \
                                libpoppler-glib-dev

## Not working because of nodejs conflict
# apt-get install -y --no-install-recommends \
# 	libv8-dev \ 

## software - perl extentions and modules
RUN apt-get install -y --no-install-recommends \
                                libperl-dev \
                                libarchive-extract-perl \
                                libfile-copy-recursive-perl \
                                libcgi-pm-perl \
                                libdbi-perl \
                                libdbd-mysql-perl \
                                libxml-simple-perl

## new libs
RUN apt-get install -y --no-install-recommends \
                                libglpk-dev \
                                libeigen3-dev \
                                liblz4-dev

## Databases and other software
RUN apt-get install -y --no-install-recommends \
                                sqlite \
                                openmpi-bin \
                                mpi-default-bin \
                                openmpi-common \
                                openmpi-doc \
                                tcl8.6-dev \
                                tk-dev \
                                default-jdk \
                                imagemagick \
                                tabix \
                                ggobi \
                                graphviz \
                                protobuf-compiler \
                                jags \
                                libhiredis-dev

## Additional resources
RUN apt-get install -y --no-install-recommends \
                                xfonts-100dpi \
                                xfonts-75dpi \
                                biber \
                                libsbml5-dev \
                                libzmq3-dev \
                                python3-dev \
                                python3-venv

## More additional resources
## libavfilter-dev - <infinityFlow, host of other packages>
## mono-runtime - <rawrr, MsBackendRawFileReader>
## libfuse-dev - <Travel>
## ocl-icd-opencl-dev - <gpuMagic> - but machine needs to be a GPU--otherwise it's useless
RUN apt-get -y --no-install-recommends install \
                                libmariadb-dev-compat \
                                libjpeg-dev \
                                libjpeg-turbo8-dev \
                                libjpeg8-dev \
                                libavfilter-dev \
                                libfuse-dev \
                                mono-runtime \
                                ocl-icd-opencl-dev

## Python installations
RUN pip3 install scikit-learn pandas pyyaml

## libgdal is needed for sf
RUN apt-get install -y --no-install-recommends \
                                libgdal-dev \
                                default-libmysqlclient-dev \
                                libmysqlclient-dev

# Install R on Ubuntu from CRAN Repository
# https://phoenixnap.com/kb/install-r-ubuntu

RUN apt-get update && \
    apt-get install -y vim git wget g++\ 
                       python-is-python3

# Install Python packages
ADD requirements.txt /
RUN pip install -r /requirements.txt

# Install cmake and libfontconfig1 (necessary for some R packages)
# RUN apt update && \
#     apt install libfontconfig1-dev -y

RUN apt update && \
    apt install software-properties-common dirmngr -y && \
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc  && \
    gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" && \
    apt install r-base r-base-dev -y

# Install RStudio

RUN wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2023.09.1-494-amd64.deb -O ./rstudio.deb && \
    apt update && \
    apt install -y ./rstudio.deb

# Install R packages
RUN Rscript -e 'install.packages("BiocManager", repos="https://cran.rstudio.com")'
RUN Rscript -e "BiocManager::install(version=3.18, update=TRUE, ask=FALSE)"
RUN Rscript -e "BiocManager::install(c('devtools'))"
## Install preprocess core manually to disable threading https://github.com/Bioconductor/bioconductor_docker/issues/22
RUN Rscript -e 'BiocManager::install("preprocessCore", configure.args = c(preprocessCore = "--disable-threading"), update=TRUE, force=TRUE, ask=FALSE, type="source")'


# Install R packages
ADD install_r_packages.R /
RUN Rscript /install_r_packages.R

RUN chmod 777 -R /config/

COPY /desktop/jupyter.desktop /config/Desktop/
RUN chmod 777 /config/Desktop/jupyter.desktop

COPY /desktop/rstudio.desktop /config/Desktop/
RUN chmod 777 /config/Desktop/rstudio.desktop