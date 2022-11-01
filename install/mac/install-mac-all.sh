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
    current_task
    current_task=$1
    printf "[ ] ${current_task}}\r"
}

function task_success() {
    printf "[${green}✔${reset}] ${current_task}\n"
}

function task_error() {
    printf "[${red}✘${reset}] ${current_task}\n"
}


# NOTE: install pkgs needs to go first as later steps require the 'dock-util' package to be installed
task_start "Installing software packages"
${script_dir}/install-mac-pkgs.sh
task_success 

task_start "Setting mac preferences"
${script_dir}/install-mac-prefs.sh
task_success

task_start "Copying config files"
cp -vR ${script_dir}/copy/ ${HOME}/
task_success

#task_start "Configuring Dock"
#${script_dir}/install-mac-dock.sh
#task_success

#task_start "Linking dotfiles"
#${script_dir}/install-mac-dotfiles.sh
#task_success



