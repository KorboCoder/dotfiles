{ pkgs, ... }:

{
    home.packages = with pkgs; [
        skhd
        yabai
        utm
    ];
}
