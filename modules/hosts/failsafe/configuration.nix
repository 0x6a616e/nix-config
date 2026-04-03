{ self, ... }: {
    flake.nixosModules.failsafeConfiguration = { ... }: {
        imports = [
            self.nixosModules.failsafeHardware

		self.nixosModules.git
        ];

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

        i18n.defaultLocale = "en_US.UTF-8";

        networking = {
            hostName = "failsafe";
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

        system.stateVersion = "25.05";

        time.timeZone = "America/Monterrey";

        users.users.jan = {
            description = "Jan";
            extraGroups = [ "networkmanager" "wheel" ];
            isNormalUser = true;
        };
    };
}
