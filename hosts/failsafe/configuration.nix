{ pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.jan = import ./home.nix;
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

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  system.stateVersion = "25.05";

  time.timeZone = "America/Monterrey";

  users.users.jan = {
    isNormalUser = true;
    description = "Jan";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
