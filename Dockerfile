# rocker/r-ver:4.0.5 [https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/rstudio_4.0.5.Dockerfile]

FROM dhammill/cytoexplorer:v1.1.0

# Configure environment
ENV DOCKER_IMAGE_NAME='flowcyto-env'
ENV VERSION='2023-06-02' 

# Change default port for Rstudio server to 7878
# Give the rstudio user sudo priviledges without asking for a password (only sudo commando from rstudio terminal)
EXPOSE 7878
# https://s3.amazonaws.com/rstudio-server/rstudio-server-pro-0.98.507-admin-guide.pdf
RUN echo "www-port=7878" > /etc/rstudio/rserver.conf && \
    usermod -aG sudo rstudio && \
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

ADD scripts/launch_rstudio_server.sh /
RUN echo "alias rs='bash /launch_rstudio_server.sh'" >> /etc/bash.bashrc

# Set the jl command to create a JupytetLab shortcut
ADD scripts/launch_jupyterlab.sh /
RUN echo "alias jl='bash /launch_jupyterlab.sh'" >> /etc/bash.bashrc

ADD scripts/entrypoint.sh /
ADD scripts/message.sh /
RUN echo "bash /message.sh" >> /etc/bash.bashrc

USER rstudio

CMD ["/launch_jupyterlab.sh -p 8888"]