#!/bin/bash
# Activate the Jupyter Notebook

# Get URL for Jupyter Notebook
HOST_URL=`bolt task show $TASK_ID | grep "host ip" | awk 'NF{ print $NF }'`
NOTEBOOK_URL="$HOST_URL:$NOTEBOOK"
echo "Notebook to connect: $NOTEBOOK_URL"
python -c "import turibolt as bolt;bolt.set_status_message('Notebook to connect: http://$NOTEBOOK_URL')"


# Make preparations to run jupyter notebook
PATH=/task_runtime/miniconda3/bin:$PATH
export PATH=$PATH
export SC_HOSTNAME=$(bolt task show $TASK_ID  | grep 'host ip' | awk '{ print $3; }')
conda deactivate
source activate fastai
cd fastai
echo "Notebook to connect:"
echo "http://${SC_HOSTNAME}:${NOTEBOOK}"
echo 'jupyter notebook --allow-root --ip="*" --no-browser --port $NOTEBOOK' > /task_runtime/run_jupyter.sh


# Create an 'environment bundle' from everything installed.
tar -cPf bundle.tar.gz --gzip \
    /task_runtime/miniconda3 \
    /task_runtime/fastai \
    /root/.jupyter/jupyter_notebook_config.py \
    ${CUDA_HOME}/include/cudnn.h \
    ${CUDA_HOME}/lib64/

# Upload bundle to s3
# (You won't have permissions to write to this bucket unless you are me.)
alias mr3='aws --endpoint-url https://blob.mr3.simcloud.apple.com --cli-read-timeout 240'
mr3 s3 cp bundle.tar.gz s3://grapaport_cudnn/bundle.tar.gz
