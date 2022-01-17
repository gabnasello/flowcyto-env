# Create a Docker Image with a conda environment for flow cytometry data analysis

## How it works

- The ```Dockerfile``` creates a Docker Image based on dhammill/cytoexplorer:latest Image.
- It changes default port for Rstudio server to 7878 and creates an ```rs``` command to access Rstudio server
- It installs Python packages to run jupyterlab 
- It adds R packages to the dhammill/cytoexplorer:latest Image

## Create a new image

First, clone the repo:

```git clone https://github.com/gabnasello/flowcyto-env.git``` 

and run the following command to build the image (you might need sudo privileges):

```docker build --no-cache -t flowcyto-env:latest .```

Then you can follow the instructions in the [Docker repository](https://hub.docker.com/repository/docker/gnasello/flowcyto-env) to use the virtual environments.

Enjoy flow cytometry!