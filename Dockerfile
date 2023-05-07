# rocker/r-ver:4.0.5 [https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/rstudio_4.0.5.Dockerfile]

FROM dhammill/cytoexplorer:v1.1.0

# Change default port for Rstudio server to 7878
# Give the rstudio user sudo priviledges without asking for a password (only sudo commando from rstudio terminal)
EXPOSE 7878
# https://s3.amazonaws.com/rstudio-server/rstudio-server-pro-0.98.507-admin-guide.pdf
RUN echo "www-port=7878" > /etc/rstudio/rserver.conf && \
    usermod -aG sudo rstudio && \
    echo 'rstudio ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Manually install nodejs (requirement for Jupyter Notebook)
# https://nodejs.org/en/download/
# https://github.com/nodejs/node/blob/master/BUILDING.md#building-nodejs-on-supported-platforms
#RUN wget https://nodejs.org/dist/v16.13.1/node-v16.13.1.tar.gz && \
#    tar -xvf node-v16.13.1.tar.gz && \
#    cd node-v16.13.1 && \
#    ./configure && \
#    make -j4 && \
#    make install && \
#    make test-only && \
#    cd .. && \
#    rm node-v16.13.1.tar.gz 

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

USER rstudio

ADD scripts/launch_rstudio_server.sh /
RUN echo "alias rs='bash /launch_rstudio_server.sh'" >> ~/.bashrc

# Set the jl command to create a JupytetLab shortcut
ADD scripts/launch_jupyterlab.sh /
RUN echo "alias jl='bash /launch_jupyterlab.sh'" >> ~/.bashrc

ADD scripts/entrypoint.sh /
ADD scripts/message.sh /
RUN echo "bash /message.sh" >> ~/.bashrc

CMD ["/launch_jupyterlab.sh"]