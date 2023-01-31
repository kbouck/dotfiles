#!/bin/bash

# todo - need to determine OS and package mgmt system (eg. apt vs rpm?)


function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    sudo apt install -y $1
  else
    echo "Already installed: ${1}"
  fi
}

echo "Installing Linux Packages (may need password for sudo)"
sudo -v || { echo >&2 "No sudo privilege. Skipping package installation"; exit 1; }

sudo apt update

# shell
install zsh
install fzf
install htop
install lolcat

# dev langs/tools
install python3-venv
install gh

# ops
install docker
install docker-compose

