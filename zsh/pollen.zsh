# pollen.zsh
#
# a zsh plugin manager inspired by antigen, but far simpler & faster

POLLEN="${POLLEN-${DOTFILES-$HOME/.pollen}/repos}"
POLLENATED=()

typeset -A -g _pollen

pollinate() {
  POLLENATED+=("$@")

  -pollen-parse "$@"
  -pollen-install
  -pollen-source
}

pollen-update() {
  -pollen-update-all
}

-pollen-update-all() {
  for resource in ${POLLENATED[@]}; do
    -pollen-parse ${(z)resource}
    -pollen-update
  done
}

-pollen-update() {
  if [[ -d "${_pollen[location]}" ]]; then
    echo "\033[0;36mupdating \033[1;35m${_pollen[repo]}\033[0m"
    $(cd "${_pollen[location]}" && git pull -q origin master --ff-only)
  fi
}

-pollen-install() {
  if ! [[ -d "${_pollen[location]}" ]]; then
    mkdir -p "$POLLEN"
    echo "\033[0;36mcloning \033[1;35m${_pollen[repo]}\033[0m"
    git clone -q "${_pollen[repo_url]}" "${_pollen[location]}"
  fi
}

-pollen-source() {
  local paths

  if (( ! ${fpath[(I)${_pollen[sources]}]} )); then
      fpath=(${_pollen[sources]} $fpath)
  fi

  paths=$(
    -pollen-locate-file ${_pollen[sources]} ||
    -pollen-locate-plugin ${_pollen[sources]} ||
    -pollen-locate-all-zsh ${_pollen[sources]} ||
    -pollen-locate-all-sh ${_pollen[sources]}
  )

  for script in ${(f)paths}; do
    source $script
  done
}

-pollen-locate-file() {
  [[ -f "$1" ]] && echo "$1"
}

-pollen-locate-plugin() {
  plugin=("$1/"*.plugin.zsh([1])(N))

  [[ -n "$plugin" ]] && echo "$plugin"
}

-pollen-locate-all-zsh() {
  files=("$1/"*.zsh(N))

  [[ -n "$files" ]] && echo "${(F)files}"
}

-pollen-locate-all-sh() {
  files=("$1/"*.sh(N))

  [[ -n "$files" ]] && echo "${(F)files}"
}

-pollen-parse() {
  # check for custom destination
  local destination=${1##*\#}

  # but if the customization wasn't present, just use the name
  if [[ "$destination" = "$1" ]]; then
    destination=${1:t}
  fi

  _pollen[name]=${destination:t}
  _pollen[repo]=${1%\#*}
  _pollen[repo_name]=${_pollen[repo]:t}
  _pollen[repo_url]=https://github.com/${_pollen[repo]}.git
  _pollen[location]=$POLLEN/${destination}
  _pollen[sources]=${_pollen[location]}

  if [[ "$2" = "--no-source" ]]; then
    _pollen[sources]=/dev/null
  elif [[ -n "$2" ]]; then
    _pollen[sources]="${_pollen[sources]}/$2"
  fi
}

export POLLEN
