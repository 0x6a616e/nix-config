{ ... }: {
    flake.nixosModules.failsafeHardware = { config, lib, pkgs, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        boot = {
            initrd = {
                availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
                kernelModules = [ ];
            };
            kernelModules = [ "kvm-amd" ];
            extraModulePackages = [ ];
        };

        fileSystems."/" = {
            device = "/dev/disk/by-uuid/3cc69dba-66c4-443b-81f4-1dcce3c37e48";
            fsType = "ext4";
        };

        fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/1F13-35BB";
            fsType = "vfat";
            options = [ "fmask=0077" "dmask=0077" ];
        };

        swapDevices = [ { device = "/dev/disk/by-uuid/492e8c67-b662-4a3e-933e-1a1e5d1bf05a"; } ];

        networking.useDHCP = lib.mkDefault true;

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
