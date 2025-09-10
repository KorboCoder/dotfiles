{
    description = "Home Manager configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, home-manager, ... }:
        let
            lib = nixpkgs.lib;
            # Define your different systems here.
            # You can find your system architecture by running: nix-shell -p nix-info --run "nix-info -m"
            system = "aarch64-darwin";
            pkgs = import nixpkgs { inherit system; };

            # A helper function to build a home configuration for a specific user.
            mkHome = { username, ... }: home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                # Pass the username down to home.nix and other modules
                extraSpecialArgs = { inherit username; };
                modules = [ ./home.nix ];
            };

        in {
            homeConfigurations = {

                danielvallesteros = mkHome {
                    username = "danielvallesteros";
                };

                vali = mkHome {
                    username = "vali";
                };

            };

        };
}
