# Set overall config path
export XDG_CONFIG_HOME="$HOME/.config"

# Set ZSH config path
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Set default editors
export EDITOR="nano"
export VISUAL="code"

# Set ZSH environment variables
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file
export HISTDUP="erase"


# Color output
# export LESS='-R --use-color -Dd+r$Du+b$'
export BAT_THEME="TwoDark"
export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="--preview 'batcat -n --color=always {}'"

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 10'"
export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree ls"
