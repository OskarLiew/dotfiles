# Dotfiles

These are my configuration files for non-nix configs. Check out [configuration.nix](https://github.com/OskarLiew/configuration.nix) for my full NixOS configuration, which includes these dotfiles.

## Install dotfiles

To install these dotfiles without nix, it is easiest to use symlinks

```bash
ln -s .zshenv ~/.zshenv
ln -s config/* ~/.config/
```

## Handling conflicts

If the target of the symlink already exists, backup the files and try again.
