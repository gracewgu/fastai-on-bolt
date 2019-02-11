#!/bin/bash
# Activate the Jupyter Notebook

# Get URL for Jupyter Notebook
HOST_URL=`bolt task show $TASK_ID | grep "host ip" | awk 'NF{ print $NF }'`
NOTEBOOK_URL="$HOST_URL:$NOTEBOOK"
echo "Notebook to connect: $NOTEBOOK_URL"
python -c "import turibolt as bolt;bolt.set_status_message('Notebook to connect: http://$NOTEBOOK_URL')"


# Run jupyter notebook
PATH=/task_runtime/miniconda3/bin:$PATH
export PATH=$PATH
export SC_HOSTNAME=$(bolt task show $TASK_ID  | grep 'host ip' | awk '{ print $3; }')
conda deactivate
source activate fastai
cd fastai
echo "Notebook to connect:"
echo "http://${SC_HOSTNAME}:${NOTEBOOK}"
jupyter notebook --allow-root --ip="*" --no-browser --port $NOTEBOOK
