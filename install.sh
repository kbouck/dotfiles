#!/bin/bash

dotfiles_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# delegate installation to os-specific scripts

# Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux"
    alias linux_test='echo linux_test'
    # ${dotfiles_dir}/install/common/install-common.sh
    # ${dotfiles_dir}/install/linux/install-linux.sh
    # ${dotfiles_dir}/install/linux/install-pkgs.sh

# Mac
# && [ -e "/etc/lsb-release" ]; then os='ubuntu'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Mac"
    # ${dotfiles_dir}/install/common/install-common.sh
    # ${dotfiles_dir}/install/mac/install-mac.sh
    # ${dotfiles_dir}/install/mac/install-mac-pkgs.sh
    # ${dotfiles_dir}/install/mac/install-mac-dock.sh
    # ${dotfiles_dir}/install/mac/install-mac-defaults.sh

 
# POSIX compatibility layer and Linux environment emulation for Windows
#elif [[ "$OSTYPE" == "cygwin" ]]; then


# Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
#elif [[ "$OSTYPE" == "msys" ]]; then


# I'm not sure this can happen.
#elif [[ "$OSTYPE" == "win32" ]]; then


# ...
#elif [[ "$OSTYPE" == "freebsd"* ]]; then

# Unknown
else
  echo "Unrecognized OS: ${OSTYPE}"
  exit 1
fi


# .bash_profile
# =============
#bash_profile="${bash_profile} ${script_dir}/bash_profile/path"
#bash_profile="${bash_profile} ${script_dir}/bash_profile/aliases"
#bash_profile="${bash_profile} ${script_dir}/bash_profile/prompt"
#bash_profile="${bash_profile} ${script_dir}/bash_profile/python_miniconda"
#bash_profile="${bash_profile} ${script_dir}/bash_profile/python_venv"
#bash_profile="${bash_profile} ${script_dir}/bash_profile/groovy"
#cat ${bash_profile} > /tmp/bash_profile.txt

# .vimrc
# ======


