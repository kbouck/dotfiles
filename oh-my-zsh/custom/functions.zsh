# pull "down" menu of virtualenv's
# todo:
# - handle case when .venv doesn't exist yet - selection list shows empty option
# - maybe auto-upgrade pip version just after creating?
function venv() {
  [[ -d ~/.venv/ ]] || mkdir ~/.venv
  venvs=$(ls ~/.venv/)
  typeset -f "deactivate" > /dev/null && venvs=$(printf "${venvs}\n[x] deactivate\n")
  venvs=$(printf "${venvs}\n[+] new\n")
  # sed removes any [.] prefix fro the selected name
  # cut selects the chosen venv name
  selected_venv=$(echo "${venvs}" | fzf | sed 's/\[.\] *//')
  #selected_venv=$(echo ${venvs} | fzf | sed 's/\[.\] *//' | cut -f2)
  if [[ "${selected_venv}" = "deactivate" ]]; then
      echo "deactivating"
      deactivate

  elif [[ "${selected_venv}" = "new" ]]; then
      # read new venv name, zsh method
      # vared -p 'new venv: ' -c new_venv     # ZSH method
      
      # read new venv name, bash method
      printf "new venv: "
      read new_venv
      
      venv_dir="$HOME/.venv/${new_venv}"
      if [[ -e "${venv_dir}"  ]]; then
          echo "${venv_dir} already exists"
          
      else 
          echo "creating ${venv_dir}"
          python3 -m venv "${venv_dir}"
          source "$HOME/.venv/${new_venv}/bin/activate"
          echo "upgrading pip"
          pip install --upgrade pip
      fi

  elif [[ -n "${selected_venv}" ]]; then
      source "$HOME/.venv/$selected_venv/bin/activate"
  fi
}

# pull "down" menu of recent directories
function fd() {
    target_dir_idx=$(dirs -v | fzf | cut -f1)
    [[ -n "${target_dir_idx}" ]] && cd -${target_dir_idx}
}

