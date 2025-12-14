FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
ARG DEBIAN_FRONTEND=noninteractive

# 1. Install System Dependencies
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get install --no-install-recommends -y \
    python3.10 python3-pip pipx vim make wget git sudo g++ \
    && rm -rf /var/lib/apt/lists/*

# 2. Fix Python Symlinks
RUN ln -sf /usr/bin/python3.10 /usr/bin/python

# 3. Install Poetry globally
RUN pip install --no-cache-dir poetry

# 4. Set Workdir and Copy Source Code
WORKDIR /home
COPY . .

# 5. Run RFantibody Setup Scripts
RUN bash include/download_weights.sh

##  !!!! RUN THIS MANUALY: installs nvidia (again) and runs out of github free space)    bash include/setup.sh

# 6. Fix for missing Biotite
RUN poetry run pip install biotite

# 7. FIXES:
# A. Set PYTHONPATH so Python finds the source code
# B. Symlink the config folder so the script finds the configs
ENV PYTHONPATH="/home/src/rfantibody/rfdiffusion:/home/include/SE3Transformer:/home/scripts:$PYTHONPATH"
RUN ln -s /home/src/rfantibody/rfdiffusion/config /home/scripts/config

# 8. Keep the container running
CMD ["sleep", "infinity"]
