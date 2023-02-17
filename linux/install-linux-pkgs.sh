#!/bin/bash

# todo - need to determine OS and package mgmt system (eg. apt vs rpm?)
# - apt: Ubuntu/Pop
# - yum: RHEL
# - pip: need way to list pip packages to install
# - merge install functions


function apt_install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "(APT) Installing: ${1}..."
    sudo apt install -y $1
  else
    echo "Already installed: ${1}"
  fi
}

function pip_install {
  which $1 &> /dev/null
  if [ $? -ne 0 ]; then
    echo "(PIP) Installing: ${1}..."
    python3 -m pip install $1
  else
    echo "Already installed: ${1}"
  fi
}

echo "Installing Linux Packages (may need password for sudo)"
sudo -v || { echo >&2 "No sudo privilege. Skipping package installation"; exit 1; }

sudo apt update

# essential
apt_install python3-pip
apt_install python3-venv

# shell
apt_install zsh
apt_install fzf
apt_install htop
apt_install lolcat

# network
apt_install net-tools

# dev langs/tools
apt_install gh

# data-fu
apt_install jq
apt_install miller
apt_install sqlite3
pip_install visidata
#apt_install yq

# ops
apt_install docker
apt_install docker-compose


