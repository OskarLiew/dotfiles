# Dotfiles

Storage of configuration files with a bare git repository. Uses an alias for git `config` that you should use instead of using git directly.

## Install dotfiles

Set up the alias by adding the following command to the end of your `.bashrc` or equivalent.

```shell
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Clone the repositoryy

```shell
git clone --bare https://github.com/OskarLiew/dotfiles $HOME/.dotfiles/
```

Optionally backup files

```shell
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```
