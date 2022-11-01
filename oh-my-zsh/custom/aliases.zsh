# aliases
# =======

# ls
# --
# -h: human-readable
# -H: follow symlinks
# -G: colorize
# -l: long
# -a: all
alias ls="ls -hHG"
alias ll="ls -la"

# awk
# ---
alias awkcsv='awk -v FPAT="([^,]+)|(\"[^\"]+\")"'
