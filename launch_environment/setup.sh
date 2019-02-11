#!/bin/bash
# Install prerequisites for the fastai course
# https://github.com/fastai/fastai

# Tools making your life easier if you choose to connect via SSH
apt-get -qq install -y screen nano


# Download environent from S3 and unpack it
aws --endpoint-url https://blob.mr3.simcloud.apple.com --cli-read-timeout 240 \
    s3 cp s3://grapaport_cudnn/bundle.tar.gz .
tar -xpf bundle.tar.gz -C /


# Verify CUDA works in PyTorch works
PATH=/task_runtime/miniconda3/bin:$PATH
export PATH=$PATH
source activate fastai
python -c 'import torch;print("torch.cuda.is_available() => {}".format(torch.cuda.is_available()))'
