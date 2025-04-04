# Reference: https://rocm.blogs.amd.com/artificial-intelligence/ray/README.html#docker-files

FROM rocm/dev-ubuntu-22.04:5.7-complete
ARG PY_VERSION=3.8

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y python${PY_VERSION} python${PY_VERSION}-venv git

# Prepare python venv, add to path
ENV PATH=/ray_venv/bin:$PATH
RUN python${PY_VERSION} -m venv ray_venv && python -m pip install --upgrade pip wheel

# Install Ray
RUN pip install "ray[data,train,tune,serve] @ https://github.com/ROCm/ray/releases/download/v3.0.0-dev0%2Brocm/ray-3.0.0.dev0-cp38-cp38-manylinux2014_x86_64.whl"

# Install torch
RUN --mount=type=cache,target=/root/.cache pip3 install torch==2.0.1 torchvision==0.15.2 -f https://repo.radeon.com/rocm/manylinux/rocm-rel-5.7/

# Install additional dependencies
RUN pip3 install evaluate==0.4.1 \
    transformers==4.39.3 \
    accelerate==0.28.0 \
    scikit-learn==1.3.2 \
    requests==2.31.0 \
    diffusers==0.12.1

# Build XGBoost
RUN git clone --depth=1 --recurse-submodules https://github.com/ROCmSoftwarePlatform/xgboost xgboost \
    && cd xgboost \
    && mkdir build && cd build\
    && export GFXARCH="$(rocm_agent_enumerator | tail -1)" \
    && export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:/opt/rocm/lib/cmake:/opt/rocm/lib/cmake/AMDDeviceLibs/ \
    && cmake -DUSE_HIP=ON -DCMAKE_HIP_ARCHITECTURES=${GFXARCH} -DUSE_RCCL=1 ../ \
    && make -j \
    && pip3 install ../python-package/

WORKDIR /root