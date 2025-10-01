{ pkgs, ... }:

{
    home.packages = with pkgs; [
        zsh
        eza
        dust
        zoxide
        parallel
        jq
        fd
        ripgrep
        tlrc
        wishlist
        tmux
        watch
        xh
        atuin
        yazi
        btop
        bat
        bat-extras.core
        gnused

        # migrate settings from neofetch to fastfetch
        neofetch
        fastfetch

        fzf
        zsh-fzf-tab

        zsh-autocomplete
        zsh-autosuggestions
        zsh-powerlevel10k
        zsh-completions
        zsh-syntax-highlighting
        nix-zsh-completions

        delta
        difftastic
    ];


    # home.sessionVariables = {
    #     PATH = "$HOME/.local/bin:$PATH";
    #     FZF_DEFAULT_OPTS = "--bind='ctrl-o:execute(code {})+abort'" +
    #         "--color=spinner:#f4dbd6,hl:#ed8796" +
    #         "--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6" +
    #         "--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796";
    #     ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8,underline";
    #     FPATH="$NIX_PREFIX/share/zsh-completions:$FPATH";
    #     ZSH_AUTOSUGGEST_STRATEGY="(completion history)";
    #     NIX_PREFIX= "$HOME/.nix-profile";
    #     XDG_CONFIG_HOME="$HOME/.config";
    # };
    # shell setup
    programs.zsh = {
        enable = true;
        dotDir = ".config/zsh";
        enableCompletion  = true;
        autosuggestion = {
            enable = true;
        };
        syntaxHighlighting = {
            enable = true;
            # catppuccin-machiatto
            styles = {

                ## General
                ### Diffs
                ### Markup
                ## Classes
                ## Comments
                comment="fg=#5b6078";
                ## Constants
                ## Entitites
                ## Functions/methods
                alias="fg=#a6da95";
                suffix-alias="fg=#a6da95";
                global-alias="fg=#a6da95";
                function="fg=#a6da95";
                command="fg=#a6da95";
                precommand="fg=#a6da95,italic";
                autodirectory="fg=#f5a97f,italic";
                single-hyphen-option="fg=#f5a97f";
                double-hyphen-option="fg=#f5a97f";
                back-quoted-argument="fg=#c6a0f6";
                ## Keywords
                ## Built ins
                builtin="fg=#a6da95";
                reserved-word="fg=#a6da95";
                hashed-command="fg=#a6da95";
                ## Punctuation
                commandseparator="fg=#ed8796";
                command-substitution-delimiter="fg=#cad3f5";
                command-substitution-delimiter-unquoted="fg=#cad3f5";
                process-substitution-delimiter="fg=#cad3f5";
                back-quoted-argument-delimiter="fg=#ed8796";
                back-double-quoted-argument="fg=#ed8796";
                back-dollar-quoted-argument="fg=#ed8796";
                ## Serializable / Configuration Languages
                ## Storage
                ## Strings
                command-substitution-quoted="fg=#eed49f";
                command-substitution-delimiter-quoted="fg=#eed49f";
                single-quoted-argument="fg=#eed49f";
                single-quoted-argument-unclosed="fg=#ee99a0";
                double-quoted-argument="fg=#eed49f";
                double-quoted-argument-unclosed="fg=#ee99a0";
                rc-quote="fg=#eed49f";
                ## Variables
                dollar-quoted-argument="fg=#cad3f5";
                dollar-quoted-argument-unclosed="fg=#ee99a0";
                dollar-double-quoted-argument="fg=#cad3f5";
                assign="fg=#cad3f5";
                named-fd="fg=#cad3f5";
                numeric-fd="fg=#cad3f5";
                ## No category relevant in spec
                unknown-token="fg=#ee99a0";
                path="fg=#cad3f5,underline";
                path_pathseparator="fg=#ed8796,underline";
                path_prefix="fg=#cad3f5,underline";
                path_prefix_pathseparator="fg=#ed8796,underline";
                globbing="fg=#cad3f5";
                history-expansion="fg=#c6a0f6";
                #command-substitution="fg=?"
                #command-substitution-unquoted="fg=?"
                #process-substitution="fg=?"
                #arithmetic-expansion="fg=?"
                back-quoted-argument-unclosed="fg=#ee99a0";
                redirection="fg=#cad3f5";
                arg0="fg=#cad3f5";
                default="fg=#cad3f5";
                cursor="fg=#cad3f5";
            };

        };


        shellAliases = {
            gg="lazygit";
            ll = "eza -lah";
            ls = "eza";
            sshls="wishlist --config ~/.ssh/config-custom-list";
            tmuxconfig="nvim ~/.config/tmux/tmux.conf";
            preview="fzf --preview 'bat --color \"always\" {}'";
        };

        initContent = ''

        export PATH="$HOME/.local/bin:$PATH"
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort' \
--color=spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
        export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8,underline"
        export FPATH="$NIX_PREFIX/share/zsh-completions:$FPATH"
        export ZSH_AUTOSUGGEST_STRATEGY=(completion history)
        export NIX_PREFIX="$HOME/.nix-profile"
        export XDG_CONFIG_HOME="$HOME/.config"
            [[ -f "$HOME/.zshrc" ]] && source "$HOME/.zshrc"

            source $NIX_PREFIX/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

            gcha() {
              git checkout "$(git branch --all | fzf | tr -d '[:space:]')"
            }
            gch() {
              git checkout "$(git branch | fzf | tr -d '[:space:]')"
            }
source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

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
zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

zstyle ':fzf-tab:*' popup-min-size 80 12
        '';
    };

    # zoxide setup
    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
    };


    # Atuin setup
    programs.atuin = {
        enable = true;
        # disable up arrow
        flags = ["--disable-up-arrow"];

    };

}
