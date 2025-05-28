# Exercise_bulk_RNAseq

## Docker
Dockerfile
```Dockerfile
FROM r-base:4.4.1

# Install dependencies for R
RUN apt update && apt install -y --no-install-recommends \
    software-properties-common \
    dirmngr \
    gpg \
    curl \
    build-essential \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    make \
    cmake \
    gfortran \
    libxt-dev \
    liblapack-dev \
    libblas-dev \
    sudo \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Python, Jupyter, and make R visible by jupiter
RUN apt-get update && apt-get install -y \
    python3-pip python3-dev curl libzmq3-dev \
    && pip3 install --no-cache-dir --break-system-packages jupyterlab notebook \
    && Rscript -e "install.packages('IRkernel', repos='https://cloud.r-project.org'); IRkernel::installspec(user = FALSE)"

# Install R packages
RUN R -e "install.packages(c('BiocManager', 'ggplot2', 'cowplot'))" \
    R -e "BiocManager::install('DESeq2')" 



ENV SHELL=/bin/bash
CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.allow_origin='*' --ServerApp.token=''
```

Run
```batch
@echo off
REM Ottieni il percorso corrente
set "CURRENT_DIR=%cd%"

REM Avvia Docker e monta la cartella come /sharedFolder
docker run -it --rm -p 8888:8888 -v "%CURRENT_DIR%:/sharedFolder" maiolino_bulk_rna_seq
```
