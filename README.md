**NOTE!** this repo is still a work in progress. Clone and execute at your own risk :-) 

# Description
These dotfiles intended to be used with GitHub codespaces, or to be manually cloned when setting up local dev environments.


# Installation
```
$ git clone https://github.com/kbouck/dotfiles.git
$ ./install.sh
```

# Behavior
- script will detect OS (Win, MacOS, Ubuntu, Raspberry Pi OS)
- and will then then link or copy the dotfiles, or other config relevant only to that environment


# Repo Layout
- install.sh                  # Detects OS and runs appropriate scripts
- install/mac/                # Mac-specific stuff
- install/linux/              # Linux-specific stuff
- install/win                 # Win-specific stuff


