{ ... }: {
    flake.nixosModules.failsafeHardware = { config, lib, pkgs, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        boot = {
            initrd = {
                availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
                kernelModules = [ ];
		postResumeCommands = lib.mkAfter ''
			zfs rollback -r rpool/root@blank
		'';
            };
            kernelModules = [ "kvm-amd" ];
            extraModulePackages = [ ];
        };

	fileSystems."/" = {
		device = "rpool/root";
		fsType = "zfs";
	};

	fileSystems."/nix" = {
		device = "rpool/nix";
		fsType = "zfs";
	};

	fileSystems."/persistent" = {
		device = "rpool/persistent";
		fsType = "zfs";
	};

	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/9D53-5CC6";
		fsType = "vfat";
		options = [ "fmask=0077" "dmask=0077" ];
	};

	swapDevices = [ { device = "/dev/disk/by-uuid/3e7c6bc9-200b-48da-b250-2497017930f9"; } ];

        networking.useDHCP = lib.mkDefault true;

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
