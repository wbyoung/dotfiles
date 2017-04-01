export N_PREFIX="/usr/local/n"
export PATH="$N_PREFIX/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"

[[ "`node --version`" != "v7.3.0" ]] && \
  echo "\033[0;33mwarning \033[1;35mnode version stale, run: \033[0;36mn 7.3.0\033[0m"

# [[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh"

npm() {
  echo "use yarn or $(/usr/bin/which npm)" >&2;
  return 1;
}
