let is_remote=trim(system('[ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] && echo yes')) == "yes"

if has('nvim') && !is_remote
  lua << EOF
    require("yanky").setup({})
EOF
endif

