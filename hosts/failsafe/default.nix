{ pkgs, config, inputs, ... }:
{
	imports = [
		./hardware-configuration.nix

		./cursors.nix
		./fonts.nix
		./hyprland.nix
		./sddm.nix
		./tailscale.nix
		./zsh.nix
	];

	boot = {
		loader = {
			efi.canTouchEfiVariables = true;
			systemd-boot.enable = true;
		};
	};

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
		users.jan = {
			imports = [
				inputs.catppuccin.homeModules.catppuccin
				../../home/jan/failsafe.nix
			];
		};
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
			options = "--delete-older-than 1w";
		};
		settings = {
			auto-optimise-store = true;
			experimental-features = [ "nix-command" "flakes" ];
		};
	};

	nixpkgs.config.allowUnfree = true;

	services = {
		openssh = {
			enable = true;
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
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkjK160oBMA9G4A/MrlQUezZdBNOB03WLXrMApBR5tv"
		];
		shell = pkgs.zsh;
	};
}
