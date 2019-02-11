#!/bin/bash
# Install prerequisites for the fastai course
# https://github.com/fastai/fastai

# Tools making your life easier if you choose to connect via SSH
apt-get -qq install -y screen nano
alias mr3='aws --endpoint-url https://blob.mr3.simcloud.apple.com --cli-read-timeout 240'


# Install cudnn, per the instructions at bolt’s docs:
# https://bolt.apple.com/docs/applications.html#cudnn
mkdir -p /task_runtime/cudnn
cd /task_runtime/cudnn
mr3 s3 cp s3://grapaport_cudnn/cudnn-8.0-linux-x64-v6.0.tar . # permissions to pa-seattle
tar -xvf cudnn-8.0-linux-x64-v6.0.tar
cp -P ./cuda/include/cudnn.h ${CUDA_HOME}/include/cudnn.h
cp -rP ./cuda/lib64/* ${CUDA_HOME}/lib64/
cd -


# Install Miniconda 3
wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod u+x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b -f -p /task_runtime/miniconda3/ # batch mode, force install, where it's installed
rm Miniconda3-latest-Linux-x86_64.sh
PATH=/task_runtime/miniconda3/bin:$PATH
export PATH=$PATH


# Install and activate the fastai course materials
git clone https://github.com/fastai/fastai.git
cd fastai
conda env update -q
source activate fastai


# Install torch for CUDA8 that works
# https://pytorch.org/previous-versions/
conda uninstall -y -q torch torchvision
pip install http://download.pytorch.org/whl/cu80/torch-0.3.1-cp36-cp36m-linux_x86_64.whl
python -c 'import torch;print("torch.cuda.is_available() => {}".format(torch.cuda.is_available()))'
pip install torchvision==0.2.0


# Clean
rm -rf /task_runtime/miniconda3/pkgs/*


# Verify CUDA works in PyTorch works
python -c 'import torch;print("torch.cuda.is_available() => {}".format(torch.cuda.is_available()))'


# Download data for lesson #1 (you can also do it via the notebook)
mkdir -p /task_runtime/fastai/courses/dl1/data
cd /task_runtime/fastai/courses/dl1/data
wget -q http://files.fast.ai/data/dogscats.zip
unzip -qq dogscats.zip
rm -f dogscats.zip


# Simplify connecting to notebook by disabling security
# http://jupyter-notebook.readthedocs.io/en/stable/security.html#alternatives-to-token-authentication
jupyter notebook -y --generate-config
echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py
