#!/bin/bash
pip list | grep -i turibolt

if [ $? -eq 0 ]; then
    echo "turibolt is installed"
else
    echo "turibolt is not installed: installing it according to"
    echo "https://bolt.apple.com/docs/get-started.html#installation"
    pip install --upgrade pip
    pip install --upgrade turibolt --index https://pypi.apple.com/simple
    bolt  # to configure bolt
    echo "turibolt is now installed"
fi

cd launch_environment && bolt task submit --tar . && cd -
