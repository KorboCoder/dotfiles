# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
# Reference for searching options: https://home-manager-options.extranix.com
{
pkgs,
username,
...
}: 
let
    packages = with pkgs; [
        chezmoi
        unar
        virtualenv
        pandoc
        poppler

        k9s
        neovim

        cargo
        fnm
        nerd-fonts.mononoki
        android-tools
        nixd

        pyenv
    ];
in{
    # You can import other home-manager modules here
    imports = [
        # If you want to use home-manager modules from other flakes (such as nix-colors):
        # inputs.nix-colors.homeManagerModule

        # You can also split up your configuration and import pieces of it here:
        # ./nvim.nix
        ./modules/docker.nix
        ./modules/git.nix
        ./modules/jj.nix
        ./modules/macos.nix
        ./modules/shell.nix

        # ./zsh-autocomplete.nix
        # ./zsh-autosuggestions.nix
    ];



    home = {
        inherit username;
        homeDirectory = "/Users/${username}";
    };


    home.packages = packages; 

    # Add stuff for your user as you see fit:
    # programs.neovim.enable = true;
    # home.packages = with pkgs; [ steam ];

    # Enable home-manager and git
    programs.home-manager.enable = true;
    programs.java.enable = true;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "25.05";
}
