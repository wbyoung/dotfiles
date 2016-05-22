export N_PREFIX="/usr/local/n"
export PATH="$N_PREFIX/bin:$PATH"

[[ "`node --version`" != "v6.2.0" ]] && \
  echo "\033[0;33mwarning \033[1;35mnode version stale, run: \033[0;36mn 6.2.0\033[0m"

# [[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh"
