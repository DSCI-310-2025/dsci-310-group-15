# Use Miniforge as the base image
FROM condaforge/miniforge3:latest

# Set the working directory inside the container
WORKDIR /home/jovyan

# Copy the Conda environment configuration file into the container
COPY environment.yml environment.yml

# Install R 4.4.2 and update the Conda environment with dependencies
RUN mamba install -y -c conda-forge r-base=4.4.2 \
    && mamba env update --file environment.yml \
    && mamba clean --all -f -y  # Clean up cache to reduce image size

# Copy the entire project into the container
COPY . /home/jovyan/

# Activate the Conda environment
RUN echo "source activate base" >> ~/.bashrc


EXPOSE 8888

# Start JupyterLab when the container runs
CMD ["jupyter", "lab", "--port=8888", "--ip=0.0.0.0", "--no-browser", "--allow-root"]