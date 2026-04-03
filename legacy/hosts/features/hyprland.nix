{ pkgs, ... }:
{
    environment.systemPackages = [
        pkgs.wl-clipboard
    ];
    programs.hyprland.enable = true;
    security.pam.services.hyprlock = {};
}
