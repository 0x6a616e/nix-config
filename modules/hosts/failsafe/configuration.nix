{ self, inputs, ... }: {
    flake.nixosModules.failsafeConfiguration = { pkgs, config, ... }: {
        imports = [
            self.nixosModules.failsafeHardware

            inputs.home-manager.nixosModules.home-manager

            self.nixosModules.nh
            self.nixosModules.zsh
            self.nixosModules.tailscale
            self.nixosModules.fonts
            self.nixosModules.hyprland
            self.nixosModules.impermanence
            self.nixosModules.sops
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
        };

        nix.settings = {
            auto-optimise-store = true;
            experimental-features = [ "nix-command" "flakes" ];
        };

        nixpkgs.config.allowUnfree = true;

	security.rtkit.enable = true;

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

        users.users.jan = {
            isNormalUser = true;
            description = "Jan";
            extraGroups = [ "networkmanager" "wheel" ];
		shell = pkgs.zsh;
        hashedPasswordFile = config.sops.secrets."users/jan/password".path;
        };
    };
}
