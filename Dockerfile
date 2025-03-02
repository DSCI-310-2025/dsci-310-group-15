# Use Miniforge as the base image
FROM condaforge/miniforge3:latest

# Set the working directory inside the container
WORKDIR /home/jovyan

# Install R 4.4.2 and required R packages from Conda
RUN mamba install -y -c conda-forge r-base=4.4.2 \
    jupyterlab \
    r-irkernel \
    r-tidyverse=2.0.0 \
    r-repr=1.1.7 \
    r-broom=1.0.7 \
    r-glmnet=4.1-8 \
    r-dplyr=1.1.4 \
    r-ggplot2=3.5.1 \
    r-corrplot=0.95 \
    r-car=3.1-3 \
    r-readr \
    r-e1071 \
    && mamba clean --all -f -y  # Clean up cache to reduce image size

# Install remotes package for installing specific versions from CRAN
RUN R -e "install.packages('remotes', repos='https://cloud.r-project.org')"

# Install R packages from CRAN with fixed versions
RUN RUN mamba install -y -c conda-forge r-ggally=2.1.1; \
    R -e "remotes::install_version('randomForest', version='4.7-1.2', repos='https://cloud.r-project.org')"; \
    R -e "remotes::install_version('caret', version='7.0-1', repos='https://cloud.r-project.org')"; \
    R -e "remotes::install_version('pROC', version='1.18.5', repos='https://cloud.r-project.org')"

RUN R -e "IRkernel::installspec(user = FALSE)"
# Copy the entire project into the container
COPY . /home/jovyan/

# Expose JupyterLab port
EXPOSE 8888

# Start JupyterLab when the container runs
CMD ["jupyter", "lab", "--port=8888", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--NotebookApp.token=''"]