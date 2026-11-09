# claude-sandboxed: run Claude Code (or any command) in a bubblewrap sandbox.
#
#   claude-sandboxed [options] [dir...] [-- command [args...]]
#
# Directories are bound read-write (default: the current directory). The
# command defaults to `claude`, which also gets the sandbox-only settings.
#
# Options:
#   --ro DIR          also bind DIR read-only (repeatable)
#   --chdir DIR       start in DIR (default: the first directory)
#   --podman=DIR      share a dedicated user's podman socket from DIR
#                     (default: /run/agent-podman; see setup-agent-podman)
#   --no-podman       don't share a podman socket
#   --no-kube         don't bind ~/.kube/config (bound read-only by default
#                     when it exists; only safe when the cluster runs as that
#                     dedicated user)
#   --init SCRIPT     shell snippet to run inside before the command
#   --env NAME[=VAL]  pass an environment variable in: NAME forwards its
#                     current value (if set). the sandbox otherwise starts
#                     with a clean environment & only basics (HOME, PATH,
#                     LANG, TERM, EDITOR, …) are kept (repeatable)
#   --port N          also reach host localhost:N (TCP; repeatable). the
#                     sandbox has its own network namespace (via pasta):
#                     internet & DNS work, but not the host's abstract unix
#                     sockets (i.e. X11) or services on its localhost, except
#                     the kubeconfig's API server port & these
#   --host-net        share the host's network namespace instead
#
# Environment:
#   CLAUDE_SANDBOXED_SETTINGS   settings passed to claude with --settings
#                               (default: ~/.dotfiles/claude/sandbox-settings.json)
#   CLAUDE_SANDBOXED_GH_CONFIG  the sandbox's own gh login
#                               (default: ~/.config/gh-claude)
#
# Sandboxed sessions get CLAUDE_BWRAP_SANDBOX=1 so hooks can tell them apart.
#
# Wrap it for a project in ~/.zshrc.local, i.e.:
#
#   claude-myproject() { claude-sandboxed ~/src/myproject -- "$@"; }
#
# A command starting with an option is passed to claude, so
# `claude-myproject --resume` runs `claude --resume`.

claude-sandboxed() {
  local runtime_dir="/run/user/$(id -u)"
  local settings="${CLAUDE_SANDBOXED_SETTINGS:-$HOME/.dotfiles/claude/sandbox-settings.json}"
  local gh_config="${CLAUDE_SANDBOXED_GH_CONFIG:-$HOME/.config/gh-claude}"
  local podman_dir=/run/agent-podman kube="$HOME/.kube/config"
  local chdir="" init="" signkey="" isolate_net=1 dir tmp rc
  local -a rw_dirs=() ro_dirs=() args=() host_ports=() runner=() env_vars=()

  # --- options ------------------------------------------------------------

  while (( $# )); do
    case "$1" in
      --ro) ro_dirs+=("${2:?--ro needs a directory}"); shift 2 ;;
      --ro=*) ro_dirs+=("${1#*=}"); shift ;;
      --chdir) chdir="${2:?--chdir needs a directory}"; shift 2 ;;
      --chdir=*) chdir="${1#*=}"; shift ;;
      --podman=*) podman_dir="${1#*=}"; shift ;;
      --no-podman) podman_dir=""; shift ;;
      --no-kube) kube=""; shift ;;
      --init) init="${2?--init needs a script}"; shift 2 ;;
      --init=*) init="${1#*=}"; shift ;;
      --isolate-net) isolate_net=1; shift ;;  # the default; kept for scripts
      --host-net) isolate_net=""; shift ;;
      --port) host_ports+=("${2:?--port needs a port}"); shift 2 ;;
      --port=*) host_ports+=("${1#*=}"); shift ;;
      --env) env_vars+=("${2:?--env needs a variable}"); shift 2 ;;
      --env=*) env_vars+=("${1#*=}"); shift ;;
      --) shift; break ;;
      -*) echo "claude-sandboxed: unknown option: $1" >&2; return 2 ;;
      *) rw_dirs+=("$1"); shift ;;
    esac
  done
  (( ${#rw_dirs} )) || rw_dirs=("$PWD")
  chdir="${chdir:-${rw_dirs[1]}}"
  if (( ! $# )) || [[ "$1" == -* ]]; then
    set -- claude "$@"
  fi

  # --- host prerequisites ---------------------------------------------------

  for dir in "${rw_dirs[@]}" "${ro_dirs[@]}"; do
    if [[ ! -d "$dir" ]]; then
      echo "claude-sandboxed: not a directory: $dir" >&2
      return 1
    fi
  done

  # ~/.claude is writable inside the sandbox, so a session could replace the
  # settings symlink into your dotfiles & change what unsandboxed sessions allow
  if [[ -e "$HOME/.dotfiles/claude/settings.json" &&
    "$(readlink "$HOME/.claude/settings.json")" != *".dotfiles/claude/settings.json" ]]; then
    echo "claude-sandboxed: ~/.claude/settings.json no longer links to your dotfiles; check it first" >&2
    return 1
  fi

  # the sandbox gets its own gh login, stored as a plain token in hosts.yml
  # since it can't reach your keyring
  if [[ ! -s "$gh_config/hosts.yml" ]]; then
    cat >&2 <<EOF
claude-sandboxed: no gh login for the sandbox at $gh_config

create one (this doesn't touch your own gh login):

  GH_CONFIG_DIR="$gh_config" gh auth login --insecure-storage

--insecure-storage keeps the token in $gh_config/hosts.yml instead of
your keyring, which the sandbox can't reach. to limit what the sandbox can
do, use a fine-grained token scoped to the repositories it needs instead:

  GH_CONFIG_DIR="$gh_config" gh auth login --insecure-storage --with-token < token.txt
EOF
    return 1
  fi

  # the key git signs commits with: user.signingkey, or else the key for
  # user.email (git's fallback). empty when commits aren't signed.
  if [[ "$(git config --global --bool --get commit.gpgsign)" == true ]]; then
    signkey="$(git config --global --get user.signingkey ||
      git config --global --get user.email)"
  fi
  if [[ -n "$signkey" ]]; then
    # start the host gpg agent & keyboxd so the sandbox never autostarts its own
    gpg-connect-agent /bye >/dev/null 2>&1
    gpg-connect-agent --keyboxd /bye >/dev/null 2>&1
    # cache the passphrase now (prompts once on the host if not already cached)
    if ! echo | gpg --batch --pinentry-mode ask -u "$signkey" --clearsign >/dev/null; then
      echo "claude-sandboxed: gpg unlock failed for $signkey" >&2
      return 1
    fi
  fi

  # bwrap refuses to start when a bind source is missing; say why instead
  if [[ -n "$podman_dir" && ! -S "$podman_dir/podman.sock" ]]; then
    echo "claude-sandboxed: no podman socket at $podman_dir; run setup-agent-podman" >&2
    return 1
  fi

  if [[ -n "$isolate_net" ]] && ! command -v pasta >/dev/null; then
    echo "claude-sandboxed: needs pasta (dnf install passt), or use --host-net" >&2
    return 1
  fi

  # generated files bound into the sandbox (removed when it exits). files
  # rather than --ro-bind-data fds, which pasta may not pass through.
  tmp="$(mktemp -d)" || return 1
  print no-autostart > "$tmp/gpg.conf"

  # a clean environment (i.e. no tokens or desktop sockets); what's needed is
  # set below. must come before any --setenv.
  args+=(--clearenv)

  # --- network ---------------------------------------------------------------

  if [[ -n "$isolate_net" ]]; then
    # the cluster's API server, when it's on the host's localhost
    if [[ -n "$kube" && -e "$kube" ]] &&
      [[ "$(kubectl --kubeconfig "$kube" config view --minify \
        -o jsonpath='{.clusters[0].cluster.server}' 2>/dev/null)" =~ \
        '^https?://(127\.0\.0\.1|localhost):([0-9]+)' ]]; then
      host_ports+=("$match[2]")
    fi
    host_ports=(${(u)host_ports})
    # pasta's DNS forwarder; the host's resolver (i.e. systemd-resolved on
    # 127.0.0.53) doesn't exist inside the new namespace
    print "nameserver 169.254.1.1" > "$tmp/resolv.conf"
    args+=(--ro-bind "$tmp/resolv.conf" /etc/resolv.conf)
    runner=(
      pasta --config-net --quiet
      --dns-forward 169.254.1.1
      # no route to the host's localhost, except these TCP ports
      --no-map-gw
      -T "${(j:,:)host_ports:-none}"
      # nothing forwarded into the sandbox
      -t none -u none -U none
      --
    )
  else
    args+=(--ro-bind /etc/resolv.conf /etc/resolv.conf)
  fi

  # --- namespaces & pseudo filesystems ---------------------------------------

  args+=(
    # run as you: pasta's user namespace makes you root (uid 0), which breaks
    # tools that key off the uid (i.e. gpg looks for /run/user/0/gnupg)
    --unshare-user --uid "$(id -u)" --gid "$(id -g)"
    --unshare-pid
    --die-with-parent
    # pasta's namespace, or with --host-net the host's, which also shares its
    # abstract unix sockets (i.e. X11) & localhost services
    --share-net
    --proc /proc
    --dev /dev
    --dev-bind /dev/tty /dev/tty
    --tmpfs /tmp
  )

  # --- system (read-only) -----------------------------------------------------

  args+=(
    --ro-bind /usr /usr
    --ro-bind /lib /lib
    --ro-bind /lib64 /lib64
    --ro-bind /bin /bin
    --ro-bind /etc/hosts /etc/hosts
    --ro-bind /etc/passwd /etc/passwd
    --ro-bind /etc/group /etc/group
    --ro-bind /etc/ssl /etc/ssl
    --ro-bind /etc/pki /etc/pki
    # openssl config; node won't start without it
    --ro-bind /etc/crypto-policies /etc/crypto-policies
  )
  # claude code managed settings (i.e. deny rules), so they apply here too
  if [[ -d /etc/claude-code ]]; then
    args+=(--ro-bind /etc/claude-code /etc/claude-code)
  fi

  # --- claude & tool config ---------------------------------------------------

  args+=(
    --ro-bind "$HOME/.local/bin/claude" "$HOME/.local/bin/claude"
    --bind "$HOME/.claude" "$HOME/.claude"
    --bind "$HOME/.claude.json" "$HOME/.claude.json"
    # a sandbox-only gh login, not your own
    --bind "$gh_config" "$HOME/.config/gh"
  )
  for dir in .dotfiles/claude .gitconfig .gitignore_global; do
    [[ -e "$HOME/$dir" ]] && args+=(--ro-bind "$HOME/$dir" "$HOME/$dir")
  done

  # --- gpg: commit signing through the host agent -----------------------------

  if [[ -n "$signkey" ]]; then
    local gpg_sockets="$(gpgconf --list-dirs socketdir)"
    args+=(
      # an empty gnupg home: no secret keys or revocation certificates
      --tmpfs "$HOME/.gnupg"
      # fail instead of starting an agent/keyboxd inside the sandbox
      --ro-bind "$tmp/gpg.conf" "$HOME/.gnupg/gpg.conf"
      # the restricted agent socket (signing yes; key export etc. no) & keyboxd
      # started above; not the ssh or browser sockets
      --bind "$gpg_sockets/S.gpg-agent.extra" "$gpg_sockets/S.gpg-agent"
      --bind "$gpg_sockets/S.keyboxd" "$gpg_sockets/S.keyboxd"
    )
    for dir in common.conf trustdb.gpg; do
      [[ -e "$HOME/.gnupg/$dir" ]] && args+=(--ro-bind "$HOME/.gnupg/$dir" "$HOME/.gnupg/$dir")
    done
  fi

  # --- display: clipboard via wayland -----------------------------------------

  # only the wayland socket; when unset this would bind all of $runtime_dir
  if [[ -n "$WAYLAND_DISPLAY" ]]; then
    args+=(--bind "$runtime_dir/$WAYLAND_DISPLAY" "$runtime_dir/$WAYLAND_DISPLAY")
  fi

  # --- containers & kubernetes ---------------------------------------------------

  if [[ -n "$podman_dir" ]]; then
    args+=(
      --bind "$podman_dir" "$podman_dir"
      --setenv CONTAINER_HOST "unix://$podman_dir/podman.sock"
      --setenv DOCKER_HOST "unix://$podman_dir/podman.sock"
    )
  fi
  if [[ -n "$kube" && -e "$kube" ]]; then
    args+=(--ro-bind "$kube" "$kube")
  fi

  # --- projects -----------------------------------------------------------------

  for dir in "${rw_dirs[@]}"; do
    args+=(--bind "$dir" "$dir")
  done
  for dir in "${ro_dirs[@]}"; do
    args+=(--ro-bind "$dir" "$dir")
  done
  args+=(--chdir "$chdir")

  # --- environment --------------------------------------------------------------

  # basics from your environment (locale, terminal, editor, …); nothing that
  # points at credentials or things the sandbox can't reach (i.e. DISPLAY,
  # DBUS_SESSION_BUS_ADDRESS, SSH_AUTH_SOCK)
  local -a keep=(
    HOME USER LOGNAME SHELL PATH LANG TZ ${(k)parameters[(I)LC_*]}
    TERM COLORTERM EDITOR VISUAL GIT_EDITOR PAGER LESS GPG_TTY
    KIND_EXPERIMENTAL_PROVIDER XDG_SESSION_TYPE
  )
  [[ -n "$WAYLAND_DISPLAY" ]] && keep+=(WAYLAND_DISPLAY)
  local var
  for var in "${keep[@]}" "${env_vars[@]}"; do
    if [[ "$var" == *=* ]]; then
      args+=(--setenv "${var%%=*}" "${var#*=}")
    elif [[ -n "${(P)var}" ]]; then
      args+=(--setenv "$var" "${(P)var}")
    fi
  done

  args+=(
    --setenv XDG_RUNTIME_DIR "$runtime_dir"
    # marks sandboxed sessions, i.e. for an outside-the-sandbox hook
    --setenv CLAUDE_BWRAP_SANDBOX 1
  )

  # --- run ------------------------------------------------------------------------

  # claude gets the sandbox-only permissions (i.e. gh with the limited token)
  if [[ "$1" == claude && -f "$settings" ]]; then
    args+=(--ro-bind "$settings" "$settings")
    set -- claude --settings "$settings" "${@:2}"
  fi

  # an absolute path: pasta runs confined (pasta_t) & would otherwise search
  # $PATH, which SELinux denies for directories like ~/.local/bin
  "${runner[@]}" "${commands[bwrap]:-bwrap}" "${args[@]}" \
    /bin/sh -c "${init}"$'\nexec "$@"' sh "$@"
  rc=$?
  rm -rf "$tmp"
  _claude_sandboxed_prune_spares "$settings"
  return $rc
}

# claude's background-session supervisor starts inside each sandbox (it can't
# reach one outside) & pre-starts a spare session. the sandbox's exit kills
# it, leaving a failed, never-prompted "bg" entry in the sessions list every
# launch. remove those (only ones launched with the sandbox settings) with
# `claude rm`. note: ~/.claude/jobs isn't a stable interface, so if it
# changes this just stops matching.
_claude_sandboxed_prune_spares() {
  local settings="$1" state
  command -v jq >/dev/null || return 0
  for state in "$HOME"/.claude/jobs/*/state.json(N); do
    jq -e --arg settings "$settings" '
      .state == "failed" and .template == "bg"
        and (.detail // "" | startswith("(idle"))
        and ((.respawnFlags // []) | index($settings) != null)
    ' "$state" >/dev/null 2>&1 || continue
    claude rm "${${state:h}:t}" >/dev/null 2>&1
  done
  return 0
}
