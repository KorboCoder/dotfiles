{
    description = "Home Manager configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        nixpkgs-unstable.url ="github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        ghostty = {
            url = "github:ghostty-org/ghostty";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
    };

    outputs = { nixpkgs, ghostty, home-manager, nixpkgs-unstable,... }:
        let
            lib = nixpkgs.lib;

            # A helper function to build a home configuration for a specific user.
            mkHome = { username, system, ... }: home-manager.lib.homeManagerConfiguration {

                # Define your different systems here.
                # You can find your system architecture by running: nix-shell -p nix-info --run "nix-info -m"
                pkgs = import nixpkgs { 
                    inherit system; 
                    overlays = [ 
                        (import ./overlays/neovim.nix) 
                    ]; 
                    config.allowUnfree = true;
                };
                # Pass the username down to home.nix and other modules
                extraSpecialArgs = { 
                    inherit username;
                    inherit ghostty;
                    pkgs-unstable = import nixpkgs-unstable {
                        inherit system; 
                        config.allowUnfree = true;
                    };
                };
                modules = [ 
                    ./home.nix 
                ];
            };

        in {

            homeConfigurations = {

                danielvallesteros = mkHome {
                    username = "danielvallesteros";
                    system = "aarch64-darwin";
                };

                vali = mkHome {
                    username = "vali";
                    system = "aarch64-darwin";
                };

                vali-nix-vm = mkHome {
                    username = "vali";
                    system = "aarch64-linux";
                };

            };


        };
}

