# Docker Image for flow cytometry data analysis

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/gabnasello/flowcyto-env/HEAD)

The Docker Image is based on [dhammill/cytoexplorer](https://hub.docker.com/r/dhammill/cytoexplorer)

# Build the Docker Image

From the project folder, run the command below:

```bash build.sh```

# Run Docker container

## docker-compose approach (recommended)

Be aware that the user ```rstudio``` within you Docker container won't share the same ID as the host user!

From the project folder, run the command below:

```docker-compose up```

## Alternative approach

You can run the following command:

```docker run -it --rm  -p 8888:8888 -p 7878:7878 --volume $HOME:/home/rstudio/volume --name flowcyto gnasello/flowcyto-env:latest```

docker run -it --rm  -p 8888:8888 -p 7878:7878 gnasello/flowcyto-env:2023-07-06 "jupyter lab --allow-root --port=8888 --ip=0.0.0.0"

Enjoy the analysis of flow cytometry data!