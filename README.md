**NOTE!** this repo is still a work in progress. Clone and execute at your own risk :-) 

# Description
This my dotfiles intended to setup a common dotfiles. It is intended to be used with GitHub codespaces, or to be manually cloned when setting up new local dev environments.


# Installation
- clone repository
- run `install.sh`
  - this script will detect OS (Win, MacOS, Ubuntu, Raspberry Pi OS)
  - and will then then link or copy the dotfiles relevant only to that environment


# Respository Layout
- install.sh                  # Detects OS and runs appropriate scripts
- install/unix-common/        # Configures vim, zsh, prompt, etc.
- install/mac/                # Configures MacOS prefs, installs packages via brew
- install/linux/              # Installs packages via apt
- install/win


