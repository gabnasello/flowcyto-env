FROM dhammill/cytoexplorer:v1.1.0

# Configure environment
ENV DOCKER_IMAGE_NAME='flowcyto-env'
ENV VERSION='2023-07-16' 

RUN usermod -aG sudo rstudio && \
    echo 'rstudio ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Node.js and npm on Ubuntu
# https://computingforgeeks.com/how-to-install-nodejs-on-ubuntu-debian-linux-mint/
RUN apt update && apt -y upgrade && \
    apt install -yq nodejs npm && \
    apt -y install gcc g++ make

ADD requirements.txt /
# Set Python3 as default on ubuntu [https://dev.to/meetsohail/change-the-python3-default-version-in-ubuntu-1ekb]
RUN apt-get update && apt-get install -yq python3-pip && \
    pip3 install -r /requirements.txt
    #jupyter labextension install @jupyterlab/toc

ADD install_r_packages.R .
RUN Rscript install_r_packages.R

USER root

ADD scripts/start_jupyterlab.sh /
RUN chmod 777 /start_jupyterlab.sh

USER rstudio

WORKDIR /home/rstudio

CMD ["/start_jupyterlab.sh"]

