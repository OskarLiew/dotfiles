# Dotfiles

Storage of configuration files with a bare git repository.

## Install dotfiles

Set up the alias by adding the following command to the end of your `.bashrc` or equivalent.

```shell
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Clone the repository

```shell
git clone --bare https://github.com/OskarLiew/dotfiles $HOME/.dotfiles/
```
