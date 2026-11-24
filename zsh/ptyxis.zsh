
# add an explicit cd into the current working directory to allow autoenv based
# files to get processed when a new tab/window is opened.
if [[ -n "$PTYXIS_VERSION" ]]; then
  cd "$PWD"
fi
