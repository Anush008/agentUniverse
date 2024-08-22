#!/bin/sh

# Ignore broken pipe errors
trap '' PIPE
# 判断conda 命令是否存在,如果不存在，则判断$HOME/miniconda3/bin是否存在，如果存在则export 一下conda
if ! command -v conda &> /dev/null; then
    # Check if $HOME/miniconda3/bin exists
    if [ -d "$HOME/miniconda3/bin" ]; then
        # Add $HOME/miniconda3/bin to PATH
        export PATH="$HOME/miniconda3/bin:$PATH"
      fi
fi

# Check if Python is installed, if not, install it ，或者python的版本小于3.10
if ! command -v python &> /dev/null; then
    echo "Python is not installed. Installing Python..."
    # Check if conda is installed
    if ! command -v conda &> /dev/null; then
        echo "conda is not installed. Installing conda..."
        mkdir -p ~/miniconda3
        # If on macOS
        # 根据cpu类型与系统类型mac,linux，x86_64,arm，下载
        if [[ "$(uname)" == "Darwin" ]]; then
            if [[ "$(uname -m)" == "x86_64" ]]; then
                curl -o ~/miniconda3/miniconda.sh https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py39_24.3.0-0-MacOSX-x86_64.sh
            elif [[ "$(uname -m)" == "arm64" ]];then
                curl -o ~/miniconda3/miniconda.sh https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py39_24.3.0-0-MacOSX-arm64.sh
            fi
        # If on Linux
        elif [[ "$(uname)" == "Linux" ]]; then
            if [[ "$(uname -m)" == "x86_64" ]]; then
                curl -o ~/miniconda3/miniconda.sh https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py39_24.3.0-0-Linux-x86_64.sh
              fi
            if [[ "$(uname -m)" == "aarch64" ]];then
                    curl -o ~/miniconda3/miniconda.sh https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py39_24.3.0-0-Linux-aarch64.sh
              fi
        fi
        bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
        $HOME/miniconda3/bin/conda init bash
        $HOME/miniconda3/bin/conda init sh
        # 配置conda环境变量
        echo 'export PATH="$HOME/miniconda3/bin:$PATH"' >> ~/.bashrc
        source ~/.bashrc
        export PATH="$HOME/miniconda3/bin:$PATH"
        rm -rf ~/miniconda3/miniconda.sh
        # Configure Tsinghua mirrors
        conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
        conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
        conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
        conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
    fi
    # Create and activate Python 3.10 environment
    conda create -n python_au3.10 python=3.10 -y
    conda config --set default_env python_au3.10
    export PATH="$HOME/miniconda3/envs/python_au3.10/bin:$PATH"
    echo "Python 3.10 environment created and activated."
    python --version
fi

if ! python --version | grep -q "3.10"; then
    # 判断是否存在conda 命令
    if ! command -v conda &> /dev/null; then
        echo "conda is not installed. Please install conda and try again."
        exit 1
    fi
    # 判断conda中是否存在python_au3.10 环境
    if ! conda env list | grep -q "python_au3.10"; then
        echo "Python 3.10 environment is not installed. Installing Python 3.10 environment..."
        conda create -n python_au3.10 python=3.10 -y
        conda config --set default_env python_au3.10
        # 根据which conda的所在的目录，获取python_au3.10所在的目录，并设置环境变量
    fi
    export PATH="$HOME/miniconda3/envs/python_au3.10/bin:$PATH"
fi

# 判断 pip list 是否已安装 agentUniverse
if ! pip list | grep -q "agentUniverse"; then
   pip install agentUniverse -i https://pypi.tuna.tsinghua.edu.cn/simple
fi

# Check if custom_key file exists, if not, copy from sample
if [ ! -f "config/custom_key" ]; then
    cp config/custom_key.toml.sample config/custom_key.toml
fi

# Set PYTHONPATH to the parent directory of the current working directory
export PYTHONPATH=$PWD/../..

# Start the service
cd app/bootstrap
python -u server_application.py

