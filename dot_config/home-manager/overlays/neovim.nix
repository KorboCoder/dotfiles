self: super: 
let
  # First override the unwrapped neovim
  neovim-unwrapped-custom = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "0.11.4";
    src = super.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v0.11.4";
      # get new hash via `nix-shell -p nix-prefetch-github --run "nix-prefetch-github neovim neovim --rev v0.11.4"`
      hash = "sha256-IpMHxIDpldg4FXiXPEY2E51DfO/Z5XieKdtesLna9Xw=";
    };
  });
in
{
  # Override both the unwrapped and wrapped versions
  neovim-unwrapped = neovim-unwrapped-custom;
  
  # Override the wrapped neovim to use our custom unwrapped version
  neovim = super.wrapNeovim neovim-unwrapped-custom { };
}
