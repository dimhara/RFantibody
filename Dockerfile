FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
ARG DEBIAN_FRONTEND=noninteractive

# 1. Install System Dependencies
# Added 'git' and 'sudo' as they are often required by the setup scripts
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get install --no-install-recommends -y \
    python3.10 python3-pip pipx vim make wget git sudo \
    && rm -rf /var/lib/apt/lists/*

# 2. Fix Python Symlinks
# Ensures 'python' points to python3.10
RUN ln -sf /usr/bin/python3.10 /usr/bin/python

# 3. Install Poetry globally
# This is required before running the setup.sh script
RUN pip install --no-cache-dir poetry

# 4. Set Workdir and Copy Source Code ("Baking it in")
WORKDIR /home
COPY . .

# 5. Run RFantibody Setup Scripts
# This step does the heavy lifting: 
# - Downloads the weights (~Gigabytes of data)
# - Installs DGL and python dependencies via poetry
# - Compiles USalign
# Note: This increases build time significantly, but startup time will be instant.
#RUN bash include/download_weights.sh && \
#    bash include/setup.sh

# 6. Keep the container running on RunPod
CMD ["sleep", "infinity"]
