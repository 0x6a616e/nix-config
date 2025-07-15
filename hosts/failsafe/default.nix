{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ./sddm.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  networking = {
    hostName = "failsafe";
    networkmanager.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  services.xserver = {
    videoDrivers = ["nvidia"];
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  system.stateVersion = "25.05";

  time.timeZone = "America/Monterrey";

  users.users.jan = {
    isNormalUser = true;
    description = "Jan";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
