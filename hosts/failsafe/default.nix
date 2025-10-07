{ pkgs, inputs, ... }:
{
    imports = [
        ./hardware-configuration.nix

        ./cursors.nix
        ./fonts.nix
        ./hyprland.nix
        ./zsh.nix
    ];

    boot = {
        loader = {
            efi.canTouchEfiVariables = true;
            systemd-boot.enable = true;
        };
        supportedFilesystems = [ "ntfs" ];
    };

    environment.systemPackages = [
        pkgs.pavucontrol
    ];

    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.jan.imports = [
            inputs.nixvim.homeModules.nixvim
            ../../home/jan/failsafe.nix
        ];
    };

    i18n.defaultLocale = "en_US.UTF-8";

    networking = {
        hostName = "failsafe";
        networkmanager.enable = true;
    };

    nix = {
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
        settings = {
            auto-optimise-store = true;
            experimental-features = [ "nix-command" "flakes" ];
        };
    };

    nixpkgs.config.allowUnfree = true;

    security.rtkit.enable = true;

    services = {
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
        xserver.xkb = {
            layout = "us";
            variant = "";
        };
    };

    system.stateVersion = "25.05";

    time.timeZone = "America/Monterrey";

    users.users.jan = {
        description = "Jan";
        extraGroups = [ "networkmanager" "wheel" ];
        isNormalUser = true;
        shell = pkgs.zsh;
    };
}
