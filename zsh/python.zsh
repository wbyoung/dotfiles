source-local "zsh/plugins.zsh"

# add autoenv functionality (compatible with rvm & avn)
_in_autoenv_cd=false

function __autoenv_chpwd() {
  if [[ "$_in_autoenv_cd" = "false" ]]; then
    _in_autoenv_cd=true
    autoenv_init
    _in_autoenv_cd=false
  fi
}

[[ " ${chpwd_functions[*]} " == *" __autoenv_chpwd "* ]] || type autoenv_init &>/dev/null &&
  chpwd_functions+=(__autoenv_chpwd)

unset -f cd
