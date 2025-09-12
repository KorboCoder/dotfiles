# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
# inputs,
lib,
# config,
pkgs,
username,
...
}: 
let

    packagesToInstall = [
        "bat"
        "bat-extras.batdiff"
        "bat-extras.batgrep"
        "bat-extras.batman"
        "bat-extras.batpipe"
        "bat-extras.batwatch"
        "bat-extras.prettybat"
        "chezmoi"
        "docker"
        "delta"
        "dust"
        "difftastic"
        "eza"
        "fastfetch"
        "fd"
        "ffmpegthumbnailer"
        "fzf"
        "gnused"
        "jq"
        "mcfly"
        "parallel"
        "ripgrep"
        "tldr"
        "wishlist"
        "tmux"
        "unar"
        "virtualenv"
        "watch"
        "xh"
        "zoxide"
        "git-lfs"
        "jdk"

        # "gemini-cli"
        # "opencode"

        "markdownlint-cli2"
        "pandoc"
        "poppler"

        "atuin"
        "btop"
        "k9s"
        "neofetch"
        "lazydocker"
        "lazygit"
        "neovim"
        "yazi"

        "cargo"
        "fnm"

        "skhd"
        "yabai"

        "nerd-fonts.mononoki"

        "zsh-autocomplete"
        "zsh-autosuggestions"
        "zsh-powerlevel10k"
        "zsh-completions"
        "zsh-syntax-highlighting"
        "nix-zsh-completions"
        "hping"
        "zsh-fzf-tab"
    ];
    callPackage = path: overrides:
        (import path) ({ inherit pkgs lib; } // overrides);

    managedPackages = lib.map (name:
        let
            # Construct the path to the potential module for the package.
            packageModulePath = ./packages + "/${name}.nix";
        in
            # The magic happens here!
            if builtins.pathExists packageModulePath then
            # IF the custom file exists, import and call it.
            (callPackage packageModulePath { })
        else
            # ELSE, just use the package directly from nixpkgs.
            let
                attrPath = lib.strings.splitString "." name;
            in
                { package = lib.getAttrFromPath attrPath pkgs; }
    ) packagesToInstall;

    # 1. Map over your packages and pull out the initScript from each.
    #    The `p.initScript or ""` handles packages that don't have a script.
    allInitScripts = lib.map (name:
        let
            # Define the path to the potential script file
            scriptPath = ./init_scripts + "/${name}.sh";
        in
            # First check if the file exists...
            if builtins.pathExists scriptPath then
            # ...only if it exists, read it.
            builtins.readFile scriptPath
        else
            # ...otherwise, return an empty string.
            ""
    ) packagesToInstall;

    nonEmptyScripts = lib.filter (script: script != "") allInitScripts;
    #
    # # 2. Join all the script snippets into one big string, separated by newlines.
    collatedScript = lib.concatStringsSep "\n" nonEmptyScripts;
in{
    # You can import other home-manager modules here
    imports = [
        # If you want to use home-manager modules from other flakes (such as nix-colors):
        # inputs.nix-colors.homeManagerModule

        # You can also split up your configuration and import pieces of it here:
        # ./nvim.nix

        # ./zsh-autocomplete.nix
        # ./zsh-autosuggestions.nix
    ];



    home = {
        inherit username;
        homeDirectory = "/Users/${username}";
    };


    home.packages = (lib.map (p: p.package) managedPackages);

    home.file.".nix.zsh".text = collatedScript;

    ##''
    #       source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    #       source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh    
    #       source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    #
    #       eval "$(batpipe)"
    # eval "$(fnm env --use-on-cd)"
    #
    #       fpath=(${pkgs.zsh-completions}/share/zsh-completions/src $fpath)
    #       source ${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh
    #       fpath=(${pkgs.nix-zsh-completions}/share/zsh/plugins/nix $fpath)
    #       fpath=($HOME/.docker/completions $fpath)
    #       autoload -U compinit && compinit
    # '';

    # Add stuff for your user as you see fit:
    # programs.neovim.enable = true;
    # home.packages = with pkgs; [ steam ];

    # Enable home-manager and git
    programs.home-manager.enable = true;


    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "25.05";
}
