#!/bin/bash


output() {
  printf "$1"
}


all_done() {
  if [[ "$1" ]]; then
    printf "$1"
  else
    printf "✅\n"
  fi
}


# install dependencies from Brewfile
brew() {
    # install brew if necessary
    which -s brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew update
    brew upgrade
    output "Brew bundling...\n"
    brew bundle
    all_done "\n\n"
}


install_xcode_select() {
  output "Conditionally installing xcode-select..."

  (type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
    test -d "${xpath}" && test -x "${xpath}") || xcode-select --install

  all_done
}


install_dotfiles() {
  output "Installing dotfiles..."

  dotfiles=(
    aliases.zsh
    config
    gitconfig
    gnupg
    irbrc
    tmux.conf
    tmux.overmind.conf
    zprofile
    zshrc
  )

  for val in "${dotfiles[@]}"; do
    ln -snf $(pwd)/$val $HOME/.$val
  done

  all_done
}


install_npm_packages() {
  output "Conditionally installing npm packages..."

  npm_packages_needed=(
    bash-language-server
    eslint
    neovim
    pyright
    typescript-language-server
    vscode-langservers-extracted
    write-good
  )
  npm_packages_not_installed=()

  for pkg in "${npm_packages_needed[@]}"; do
    npm list --depth 1 --global $pkg >/dev/null 2>&1 || npm_packages_not_installed+=($pkg)
  done

  [ ${#npm_packages_not_installed[@]} -eq 0 ] || /opt/homebrew/bin/npm install -g "${npm_packages_not_installed[@]}"

  all_done
}


initialize_neovim() {
  output "Initializing neovim..."

  HEADLESS_NEOVIM=1 /opt/homebrew/bin/nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

  all_done
}


initialize_tmux() {
  output "Initializing tmux..."

  tmux new -d '~/.tmux/plugins/tpm/scripts/install_plugins.sh'

  all_done
}


install_fzf() {
  output "Conditionally installing fzf..."

  command -v fzf >/dev/null 2>&1 || $(brew --prefix)/opt/fzf/install --all

  all_done
}


teardown() {
  output "Cleaning up..."

  IFS=$' \t\n'

  all_done
}


system_defaults() {
    # see https://github.com/mihaliak/dotfiles/blob/master/macos/defaults.sh


}

dock() {
    dockutil --no-restart --remove all
    dockutil --no-restart --add "/Applications/Google Chrome.app"
    dockutil --no-restart --add "/Applications/Hyper.app"
    dockutil --no-restart --add "/Applications/Sourcetree.app"
    dockutil --no-restart --add "/Applications/PhpStorm.app"
    dockutil --no-restart --add "/Applications/Sublime Text.app"
    dockutil --no-restart --add "/Applications/TablePlus.app"
    dockutil --no-restart --add "/Applications/Postman.app"
    dockutil --no-restart --add "/Applications/FileZilla.app"
    dockutil --no-restart --add "/Applications/Spotify.app"
    dockutil --no-restart --add "/Applications/Bear.app"
    dockutil --no-restart --add "/Applications/Skype.app"
    dockutil --no-restart --add "/Applications/FaceTime.app"
    dockutil --no-restart --add "/Applications/Messages.app"
    dockutil --no-restart --add "/Applications/LastPass.app"
    killall Dock
}


# main
brew_bundle
install_dotfiles
install_xcode_select
install_npm_packages
install_fzf
#initialize_neovim
#initialize_tmux
teardown
