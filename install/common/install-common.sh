#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)

current_task=""


function task_start() {
    current_task=$1
    printf "[ ] ${current_task}"
}

function task_success() {
    printf "\r[${green}✔${reset}] ${current_task}\n"
}

function task_error() {
    printf "\r[${red}✘${reset}] ${current_task}\n"
}


function install_ohmyzsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        echo "Installing oh-my-zsh"
        task_start "Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        task_success
    fi
}

function install_vim_plug() {
    if [[ ! -e "$HOME/.vim/autoload/plug.vim" ]]; then
        echo "Installing vim-plug"
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        echo "NOTE: Run \":PlugInstall\" in vim to install plugins"
    fi


}

# create symbolic links in $HOME, prefixed with '.', pointing to files in link/
#
# todo - test if file already exists, and is not a link. erase? notify? copy to backup location?
#
function link_files() {
    task_start "Linking files"
    printf "\n"
    for source_file in $(ls ${script_dir}/link); do
        printf ".${source_file}\n"
        ln -snf ${script_dir}/link/$source_file $HOME/.$source_file
    done
    task_success
}

# recursively copy files in copy/ to $HOME preseving any directory structure
# 
function copy_files() {
    task_start "Copying files"
    printf "\n"
    cp -vR ${script_dir}/copy/ $HOME/
    task_success
}


install_ohmyzsh
install_vim_plug
link_files
copy_files


