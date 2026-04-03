{ self, ... }: {
    flake.nixosModules.failsafeConfiguration = { pkgs, ... }: {
        imports = [
            self.nixosModules.failsafeHardware

		self.nixosModules.git
		self.nixosModules.nh
		self.nixosModules.zsh
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
            isNormalUser = true;
            description = "Jan";
            extraGroups = [ "networkmanager" "wheel" ];
        };
    };
}
