{ inputs, pkgs, ... }:
{
    environment.systemPackages = [
        inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    ];
}
