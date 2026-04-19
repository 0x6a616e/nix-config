{ self, inputs, ... }: {
    flake.nixosModules.failsafeConfiguration = { pkgs, config, lib, ... }: {
        imports = [
            self.nixosModules.failsafeHardware

            inputs.home-manager.nixosModules.home-manager

            self.nixosModules.nh
            self.nixosModules.zsh
            self.nixosModules.tailscale
            self.nixosModules.impermanence
            self.nixosModules.sops
            self.nixosModules.gnome
        ];

        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.jan.imports = [ self.homeModules.jan ];
        };

        i18n = {
            defaultLocale = "en_US.UTF-8";
            extraLocaleSettings = {
                LC_ADDRESS = "es_MX.UTF-8";
                LC_IDENTIFICATION = "es_MX.UTF-8";
                LC_MEASUREMENT = "es_MX.UTF-8";
                LC_MONETARY = "es_MX.UTF-8";
                LC_NAME = "es_MX.UTF-8";
                LC_NUMERIC = "es_MX.UTF-8";
                LC_PAPER = "es_MX.UTF-8";
                LC_TELEPHONE = "es_MX.UTF-8";
                LC_TIME = "es_MX.UTF-8";
            };
        };

        networking = {
            hostName = "failsafe";
            hostId = "56040765";
            networkmanager.enable = true;
            useDHCP = lib.mkDefault true;
        };

        nix.settings = {
            auto-optimise-store = true;
            experimental-features = [ "nix-command" "flakes" ];
        };

        nixpkgs = {
            config.allowUnfree = true;
            hostPlatform = lib.mkDefault "x86_64-linux";
        };

        security = {
            rtkit.enable = true;
            sudo.extraConfig = ''
                Defaults pwfeedback
                Defaults lecture=always
            '';
        };

        services = {
            pipewire = {
                enable = true;
                alsa = {
                    enable = true;
                    support32Bit = true;
                };
                pulse.enable = true;
            };
            xserver.xkb = {
                layout = "us";
                variant = "";
            };
        };

        system.stateVersion = "25.05";

        time.timeZone = "America/Monterrey";

        sops.secrets."users/jan/password" = { };
        sops.secrets."users/jan/password".neededForUsers = true;

        users = {
            mutableUsers = false;
            users.jan = {
                isNormalUser = true;
                description = "Jan";
                extraGroups = [ "networkmanager" "wheel" ];
                shell = pkgs.zsh;
                initialPassword = "12345678";
                hashedPasswordFile = config.sops.secrets."users/jan/password".path;
            };
        };
    };
}
