{ pkgs, ... }:
{
    environment.systemPackages = [
        pkgs.pavucontrol
    ];

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };
}
