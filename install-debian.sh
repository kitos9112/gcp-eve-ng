#!/usr/bin/env bash
#### ----------------------
# User variable definition for bootstraping a debian-like operating machine
POPULATE_SHELL_PROFILE=true
HOME_DIRECTORY=$(finger $USER | grep -Po '^Directory: \K.*(?= \s)' | tr -d ' ')
SHELL="bash"
SHELL_PROFILE_FILE="$HOME_DIRECTORY/.bashrc"
PYTHON_VERSION="3.8.1"
#### -----------------------

# 1. Install all prereqs packages for PyEnv
sudo apt-get install -y curl make build-essential libssl-dev zlib1g-dev libbz2-dev \
                        libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
                        xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

# 2 Install PyEnv itself and all associated plugins if required. Otherwise, update it!
pyenv update || (source ./common/pyenv-installer.sh; source $SHELL_PROFILE_FILE)

pyenv virtualenvs || (rm -rf $(pyenv root)/plugins/pyenv-virtualenv; 
                        git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv; 
                        echo 'eval "$(pyenv virtualenv-init -)"' >> $SHELL_PROFILE_FILE && source $SHELL_PROFILE_FILE)

# 3. Do we need to install requested Python version?
pyenv local $PYTHON_VERSION || (pyenv install $PYTHON_VERSION; pyenv local $PYTHON_VERSION)

pip install ansible
