
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs = {
    nixpkgs,
    ghostty,
    ...
  }: {
    nixosConfigurations.mysystem = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        })
      ];
    };
  };
}
