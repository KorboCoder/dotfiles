# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
    inputs,
        lib,
        config,
        pkgs,
        ...
}: 
let
user = "danielvallesteros";
in
{
# You can import other home-manager modules here
    imports = [
# If you want to use home-manager modules from other flakes (such as nix-colors):
# inputs.nix-colors.homeManagerModule

# You can also split up your configuration and import pieces of it here:
# ./nvim.nix

# ./zsh-autocomplete.nix
# ./zsh-autosuggestions.nix
    ];

    nixpkgs = {

# You can add overlays here
        overlays = [
# If you want to use overlays exported from other flakes:
# neovim-nightly-overlay.overlays.default

# Or define it inline, for example:
# (final: prev: {
#   hi = final.hello.overrideAttrs (oldAttrs: {
#     patches = [ ./change-hello-to-hi.patch ];
#   });
# })
        ];
# Configure your nixpkgs instance
        config = {
# Disable if you don't want unfree packages
            allowUnfree = true;
# Workaround for https://github.com/nix-community/home-manager/issues/2942
            allowUnfreePredicate = _: true;
        };
    };

# TODO: Set your username
    home = {
        username = "${user}";
        homeDirectory = "/Users/${user}";
    };


    home.packages = [
        pkgs.bat
        pkgs.btop
        pkgs.cargo
        pkgs.chezmoi
        pkgs.ddrescue
        pkgs.delta
        pkgs.eza
        pkgs.fd
        pkgs.ffmpegthumbnailer
        pkgs.fnm
        pkgs.fzf
        pkgs.gnused
        pkgs.go
        pkgs.jq
        pkgs.lazydocker
        pkgs.lazygit
        pkgs.markdownlint-cli2
        pkgs.mcfly
        pkgs.neovim
        pkgs.pandoc
        pkgs.poppler
        pkgs.ranger
        pkgs.ripgrep
        pkgs.skhd
        pkgs.starship
        pkgs.thefuck
        pkgs.tldr
        pkgs.tmux
        pkgs.unar
        pkgs.virtualenv
        pkgs.watch
        pkgs.xh
        pkgs.yabai
        pkgs.yazi
        pkgs.zoxide
        pkgs.zsh-autocomplete
        pkgs.zsh-autosuggestions
        pkgs.zsh-powerlevel10k
        pkgs.zsh-syntax-highlighting
    ];
   home.file.".nix.zsh".text = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh    
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    '';

# Add stuff for your user as you see fit:
# programs.neovim.enable = true;
# home.packages = with pkgs; [ steam ];

# Enable home-manager and git
    programs.home-manager.enable = true;
    programs.git.enable = true;
    programs.zsh = {
        enable = false;
        autosuggestion = {
            enable = true;
            highlight = "fg=8,underline";
        };
        enableCompletion = true;
        # enableAutocomplete = true;
        syntaxHighlighting.enable = true;
        initExtraFirst  = (builtins.readFile ./extraFirst.sh);
        initExtra = (builtins.readFile ./extra.sh);
        # initExtraBeforeCompInit = (builtins.readFile ./extraBeforeCompInit.sh);
    };

# Nicely reload system units when changing configs
# systemd.user.startServices = "sd-switch";

# https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "23.05";
}
