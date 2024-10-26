ssh() {
  clip-server start > /dev/null 2>&1
  clip_server_status="$?"

  $commands[ssh] "$@"

  if [[ "${clip_server_status}" -eq "0" ]]; then
    clip-server stop 2>&1
  fi
}
