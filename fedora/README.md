# Fedora

## Initial Setup

Some issues that needed to be addressed after first installing Fedora 42:

- The machine I have required disabling secure boot in the BIOS settings in order to start from the flash drive.
- Package update was not working in the UI (which could have been network issues), so `dnf` was used to actually update software.
- I couldn't get VIM local and/or remote copy to work exactly how I wanted via focus events and [ended up with a compromise](https://github.com/wbyoung/dotfiles/commit/69bf7f0da4c1eb59b7cc19936dc6b75a22d02462).

## Flatpak

As of Fedora 42, I experienced a few issues with some tools that needed more permissions than were extended via a `flatpak` install.

- mDNS resolution did not work. This resulted in not being able to access other devices on the network that use a `*.local` DNS name. This affected both _Brave_ and _Visual Studio Code_ when accessing local devices. It is possible to workaround by just using IP addresses, i.e. using an IP address for the `HostName` in `~/.ssh/config`, but inconvenient and a source of repeated confusion.
- Accessing the local filesystem was limited which affected the ability to open a HTML file in _Brave_ that would be able to access linked resources via relative paths.
- If `flatpak-spawn` is used for spawning shells inside of other tools (i.e. _Visual Studio Code_), it doesn't seem to allow `^C` to make it through to the running process, so it's not possible to run long running processes like watched tests, servers, etc. inside of such an application.

## Visual Studio Code

Visual Studio Code doesn't work well via Flatpak for two reasons (see the discussion in the main [Flatpak section](#flatpak)):

- mDNS resolution
- Use of `flatpak-spawn` to run a shell in the terminal

Until these are resolved, following the [standard Fedora install instructions](https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions) works far better. This is now part of the dotfiles setup.

If it ever works better, the config I used with Flatpak until the issues were too obnoxious included:

```json
{
    "keyboard.dispatch": "keyCode",
    "terminal.integrated.defaultProfile.linux": "zsh",
    "terminal.integrated.profiles.linux": {
        "bash": {
            "path": "/usr/bin/flatpak-spawn",
            "args": ["--host", "--env=TERM=xterm-256color", "bash"],
            "icon": "terminal-bash",
            "overrideName": true
        },
        "zsh": {
            "path": "/usr/bin/flatpak-spawn",
            "args": ["--host", "--env=TERM=xterm-256color", "zsh"],
            "icon": "terminal-bash",
            "overrideName": true
        },
        "fish": {
            "path": "fish"
        },
        "tmux": {
            "path": "tmux",
            "icon": "terminal-tmux"
        },
        "pwsh": {
            "path": "pwsh",
            "icon": "terminal-powershell"
        }
    }
}
```

## Other Changes

I have enabled [Night Theme Switcher](https://gitlab.com/rmnvgr/nightthemeswitcher-gnome-shell-extension) and while it's possible to script the install have skipped that for now.


## Android Studio

To get the emulator working, follow the [instructions here](https://stackoverflow.com/a/78085883/98069) which should result in just executing the following:

```bash
sudo ausearch -c 'RenderThread' --raw | audit2allow -M my-RenderThread
sudo semodule -X 300 -i my-RenderThread.pp
rm my-RenderThread.pp
```


To later deactivate:

```bash
sudo semodule -X 300 -r my-RenderThread
```
