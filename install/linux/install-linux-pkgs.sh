#!/bin/bash

# todo - need to determine OS and package mgmt system (eg. apt vs rpm?)

# todo - is 'which $1' sufficient to check? package name won't always match executable
function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    sudo apt install -y $1
  else
    echo "Already installed: ${1}"
  fi
}

sudo -v

sudo apt update

install htop
install lolcat

install docker
install docker-compose


