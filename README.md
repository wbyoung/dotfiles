# wbyoung's dotfiles

## Install

```bash
sh -c "`curl -fsSL https://raw.githubusercontent.com/wbyoung/dotfiles/master/bootstrap`" -s --prompt
```

If sharing a machine, some commands may not work. For instance, Homebrew may
need to have [group permissions][homebrew-permissions] added/changed to various
directories.

### Extra Setup

To use the clipboard features over SSH, add the following to whichever host in
`.ssh/config`:

```
Host whateverhostname
  RemoteForward 2224 127.0.0.1:2224
  PermitLocalCommand yes
  LocalCommand zsh -c 'clip-server &> /dev/null &'
```

# Thanks

Inspiration taken from:

- [holman/dotfiles](https://github.com/holman/dotfiles)
- [skwp/dotfiles](https://github.com/skwp/dotfiles)
- [atomantic/dotfiles](https://github.com/atomantic/dotfiles)

[homebrew-permissions]: https://medium.com/@leifhanack/homebrew-multi-user-setup-e10cb5849d59
