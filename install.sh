#!/bin/bash

dotfiles_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


# link_files()
# ============
# create symbolic links in $HOME, prefixed with '.', pointing to files in link/
#
# todo - test if file already exists, and is not a link. erase? notify? copy to backup location?
#function link_files() {
#    if [[ -d "${script_dir}/link" ]]; then
#        echo "Linking files"
#        printf "\n"
#        for source_file in $(ls ${script_dir}/link); do
#            printf ".${source_file}\n"
#            ln -snf ${script_dir}/link/$source_file $HOME/.$source_file
#        done
#    fi
#}

# link_zsh_func()
# ===============
#function link_zsh_func() {
#    #ln -snf ${script_dir $HOME/.zfunc
#    ln -snf $HOME/dotfiles/zsh/func $HOME/.zsh_func
#}


# copy_files()
# ============
# recursively copy files $1 to $2 preseving any directory structure
#
function copy_files() {
    copy_from=$1
    copy_to=$2
    echo "copying from $copy_from to $copy_to"
    if [[ -d "${copy_from}" ]]; then
        echo "Copying files"
        cp -vR "${copy_from}/" "${copy_to}/"
    fi

    #if [[ -d "${script_dir}/copy" ]]; then
    #    echo "Copying files"
    #    cp -vR ${script_dir}/copy/ $HOME/
    #fi
}



function install_vim_plug() {
    if [[ ! -e "$HOME/.vim/autoload/plug.vim" ]]; then
        echo "Installing vim-plug"
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        echo "NOTE: Run \":PlugInstall\" in vim to install plugins"
    fi
}


function install_zsh_syntax_highlighting() {
    if [[ ! -d "$HOME/.zsh-syntax-highlighting" ]]; then
        echo "Installing zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh-syntax-highlighting
    fi
}


# Set default shell to zsh
function set_default_shell_zsh() {
    if [[ -n "$(which zsh)" ]] && [[ ! "$SHELL" = "/bin/zsh" ]]; then
        echo "Setting default shell from $SHELL to /bin/zsh (needs password)"
        chsh -s /bin/zsh
    else
	echo "Default shell already set to /bin/zsh"
    fi
}


function link_files() {
    echo "Creating/updating symbolic links:"
    ln -snfv $HOME/dotfiles/zsh/zshrc $HOME/.zshrc
    ln -snfv $HOME/dotfiles/zsh/functions $HOME/.zsh_func
    ln -snfv $HOME/dotfiles/vim/vimrc $HOME/.vimrc
    echo ""
}
    


# Linux (incl. WSL on Windows)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Installing Dotfiles for Linux"
    echo "============================="
    ${dotfiles_dir}/linux/install-linux-pkgs.sh          # install linux packages (w/ apt)
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


