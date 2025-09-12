source $HOME/fzf-tab/fzf-tab.plugin.zsh

# Enable fzf-tab completion immediately
zstyle ':fzf-tab:*' switch-group ',' '.'

# Auto-trigger fzf when there are multiple completions
zstyle ':fzf-tab:*' fzf-min-height 15

# Show preview for files and directories
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cat:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath 2>/dev/null || cat $realpath'

# tmux popup (if you want to keep this)
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# Continuous completion - this makes it appear more readily
zstyle ':fzf-tab:*' continuous-trigger 'tab'

# Set fzf flags for better experience
zstyle ':fzf-tab:*' fzf-flags '--height=50%' '--layout=reverse'

# Make tab completion more aggressive
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':fzf-tab:*' popup-min-size 80 12
