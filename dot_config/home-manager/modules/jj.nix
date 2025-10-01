

{ pkgs-unstable, ... }:

{

    home.packages = with pkgs-unstable; [
        jira-cli-go
        jjui
        jujutsu
    ];
}
