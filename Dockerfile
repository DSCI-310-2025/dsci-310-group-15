# Use Miniforge as the base image
FROM condaforge/miniforge3:latest

# Set the working directory inside the container
WORKDIR /home/jovyan

# Install R 4.4.2 and required R packages from Conda
RUN mamba install -y -c conda-forge r-base=4.4.2 \
    jupyterlab \
    r-irkernel=1.3.2 \
    r-tidyverse=2.0.0 \
    r-repr=1.1.7 \
    r-broom=1.0.7 \
    r-ggally=2.2.1 \
    r-glmnet=4.1-8 \
    r-dplyr=1.1.4 \
    r-ggplot2=3.5.1 \
    r-corrplot=0.95 \
    r-car=3.1-3 \
    r-randomforest=4.7-1.2 \
    r-testthat=3.2.3 \
    r-docopt=0.7.1 \
    && mamba clean --all -f -y  # Clean up cache to reduce image size

# Install remotes package for installing specific versions from CRAN
RUN R -e "install.packages('remotes', repos='https://cloud.r-project.org')"


# Install R packages from CRAN with fixed versions
RUN R -e "remotes::install_version('caret', version='7.0-1', repos='https://cloud.r-project.org')" && \
    R -e "remotes::install_version('pROC', version='1.18.5', repos='https://cloud.r-project.org')" &&\
    R -e "remotes::install_version('pointblank', version = '0.12.2', repos = 'https://cran.r-project.org')"

# Install Tinytex
RUN R -e "tinytex::install_tinytex()" && \
    R -e "tinytex::tlmgr_install(c('pdfcrop', 'hyperref', 'latex-bin'))"

# Install devtools and heartpredictr package
RUN R -e "install.packages('devtools', repos='https://cloud.r-project.org')" && \
    R -e "devtools::install_github('DSCI-310-2025/heartpredictr@1.0.0')"

# Install libfontconfig
RUN apt-get update && apt-get install -y \
    libfreetype6 \
    libfontconfig1 \
    && apt-get clean

# Install Quarto version 1.6.42
RUN curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.42/quarto-1.6.42-linux-amd64.deb && \
    dpkg -i quarto-linux-amd64.deb && \
    rm quarto-linux-amd64.deb

# Install IRKernel for Jupyter
RUN R -e "IRkernel::installspec(user = FALSE)"
# Copy the entire project into the container
COPY . /home/jovyan/

# Expose JupyterLab port
EXPOSE 8888

# Start JupyterLab when the container runs
CMD ["jupyter", "lab", "--port=8888", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
