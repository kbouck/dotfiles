#!/bin/bash

# set script to exit if failures occur
set -eEuo pipefail
shopt -s inherit_errexit

dotfiles_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
dotfiles_log=${dotfiles_dir}/dotfiles_install.log

# log to stdout and/or file based on log level
# usage:
#     logger info  "message"
#     logger debug "message"
#     echo "message" | logger info
#     echo "message" | logger debug
#     logger debug   # dont do this, it will hang
function logger() {
    log_levels=("error" "warn" "info" "debug" "trace")
    log_level=info

    # set log-level, if a valid level was provided as first arg
    if [[ "$#" -gt 0 && " ${log_levels[@]} " =~ " $1 " ]]; then
        log_level=$1
    fi

    # if multiple args were provided, and first is a valid log level
    if [[ "$#" -gt 1 && " ${log_levels[@]} " =~ " $1 " ]]; then
        log_lines="${@:2}"     # then take log lines from args 2-n

    # if at least 1 arg was provided and it is not a valid log level
    elif  [[ "$#" -gt 0 && ! " ${log_levels[@]} " =~ " $1 " ]]; then
        log_lines="$@"       # then take log lines from all args

    # in all other cases
    else
        log_lines=$(cat)       # take log lines from stdin

    fi

    # read all log_lines and output to destination according to log level
    while IFS= read -r line; do
        # info level also goes to stdout
        if [[ "${log_level}" = "info" ]]; then
          printf '%s\n' "$line"
        fi
        # all levels go to log file, prefixed with timestamp
        printf '%s %-5s %s\n' "$(date "+%Y-%m-%dT%H:%M:%S%z")" "${log_level^^}" "$line" >> ${dotfiles_log}
    done <<< $(echo "${log_lines}")
}


function install_vim_plug() {
    if [[ ! -e "$HOME/.vim/autoload/plug.vim" ]]; then
        logger info "Installing vim-plug"
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | logger debug
        logger info "NOTE: Run \":PlugInstall\" in vim to install plugins"
    fi
}


function install_zsh_syntax_highlighting() { 
    if [[ ! -d "$HOME/.zsh-syntax-highlighting" ]]; then
        logger info "Installing zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh-syntax-highlighting | logger debug
    fi
}


# Set default shell to zsh
function set_default_shell_zsh() {
    if [[ -n "$(which zsh)" ]] && [[ ! "$SHELL" = "/bin/zsh" ]]; then
        logger info "Changing default shell from $SHELL to /bin/zsh (needs password)"
        chsh -s /bin/zsh | logger info
    #else
	#    stdout_and_log "Default shell already set to /bin/zsh"
    fi
}


function install_linux_pkgs() {

    logger debug ""
    logger info  "Installing Packages (might prompt password for sudo)"
    logger debug "==========================="
    sudo -v || { echo >&2 "No sudo privilege. Skipping package installation"; exit 1; }

    logger info "Updating apt. (this may take a while if not done recently)" 
    sudo apt update 2>&1 | logger debug

    logger debug ""
    logger debug "(APT)"
    pkg_list_apt=$(cat ${dotfiles_dir}/linux/packages_apt.txt | grep -Ev '^\s*$|^\s*\#' | tr '\n' ' ')      # get package list on single line space-delimted, removing commented lines
    echo "apt: ${pkg_list_apt}" | logger info
    sudo apt install -y ${pkg_list_apt} 2>&1    | logger debug

    logger debug ""
    logger debug "(PIP)"
    pkg_list_pip=$(cat ${dotfiles_dir}/linux/packages_pip.txt | grep -Ev '^\s*$|^\s*\#' | tr '\n' ' ')      # get package list on single line space-delimted, removing commented lines
    echo "pip: ${pkg_list_pip}" | logger info
    python3 -m pip install ${pkg_list_pip} 2>&1 | logger debug
}


# copy_files()
# ============
# recursively copy files $1 to $2 preseving any directory structure
#
function copy_files() {
    copy_from=$1
    copy_to=$2
    echo "copying from $copy_from to $copy_to" | logger debug
    if [[ -d "${copy_from}" ]]; then
        logger info "Copying files"
        cp -vR "${copy_from}/" "${copy_to}/" | logger info
    fi

    #if [[ -d "${script_dir}/copy" ]]; then
    #    echo "Copying files"
    #    cp -vR ${script_dir}/copy/ $HOME/
    #fi
}


function link_files() {
    logger debug ""
    logger info  "[Re-]creating symbolic links"
    logger debug "============================"
    ln -snfv $HOME/dotfiles/zsh/zshrc $HOME/.zshrc        | logger info
    ln -snfv $HOME/dotfiles/zsh/functions $HOME/.zsh_func | logger info
    ln -snfv $HOME/dotfiles/vim/vimrc $HOME/.vimrc        | logger info
}
    

logger debug ""
logger info  "Installing dotfiles"
logger debug "==================="
logger info  "Log: ${dotfiles_log}"

# Linux (incl. WSL on Windows)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    logger info "Platform: Linux"
    install_linux_pkgs
    set_default_shell_zsh           
    install_zsh_syntax_highlighting 
    install_vim_plug                
    link_files                      

# && [ -e "/etc/lsb-release" ]; then os='ubuntu'

# Mac
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Installing Dotfiles for Mac"
    echo "==========================="
    ${dotfiles_dir}/mac/install-mac-pkgs.sh             # install mac packages (w/ brew).
    ${dotfiles_dir}/mac/install-mac-dock.sh             # config dock settings
    ${dotfiles_dir}/mac/install-mac-prefs.sh            # confic mac defaults
    #set_default_shell_zsh                              # default for mac these days
    install_zsh_syntax_highlighting
    install_vim_plug
    link_files
    copy_files ${dotfiles_dir}/mac/copy $HOME

 
# POSIX compatibility layer and Linux environment emulation for Windows
#elif [[ "$OSTYPE" == "cygwin" ]]; then


# Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
#elif [[ "$OSTYPE" == "msys" ]]; then


# I'm not sure this can happen.
#elif [[ "$OSTYPE" == "win32" ]]; then

# TODO
# windows terminal settings
# /mnt/c/Users/kbouck/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json
# cp ./windows-terminal-settings.json "$terminalDir/LocalState/settings.json"


# ...
#elif [[ "$OSTYPE" == "freebsd"* ]]; then

# Unknown
else
  echo "Unrecognized OS: ${OSTYPE}"
  exit 1
fi

logger debug ""
logger info  "Done"


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


