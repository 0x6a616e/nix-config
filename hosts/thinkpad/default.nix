{ pkgs, inputs, ... }:
{
    imports = [
        ./hardware-configuration.nix

        ../features/zsh.nix
    ];
#     imports = [
#         ./hardware-configuration.nix
#
#         ./features/fonts.nix
#         ./features/cursors.nix
#         ./features/zsh.nix
#         ./features/hyprland.nix
#         ./features/nh.nix
#         ./features/sops.nix
#         ./features/tailscale.nix
#     ];

    boot = {
        loader = {
            efi.canTouchEfiVariables = true;
            systemd-boot.enable = true;
        };
        supportedFilesystems = [ "ntfs" ];
    };

    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.jan.imports = [
            inputs.nixvim.homeModules.nixvim
            ../../home/jan/thinkpad.nix
        ];
    };

    i18n.defaultLocale = "en_US.UTF-8";

    networking = {
        hostName = "thinkpad";
        networkmanager.enable = true;
    };

    nix.settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
    };

    nixpkgs.config.allowUnfree = true;

    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    system.stateVersion = "25.11";

    time.timeZone = "America/Monterrey";

    users.users.jan = {
        isNormalUser = true;
        description = "jan";
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.zsh;
    };
}
