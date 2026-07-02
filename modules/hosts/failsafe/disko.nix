{ inputs, ... }: {
    flake.nixosModules.failsafeDisko = _: {
        imports = [
            inputs.disko.nixosModules.disko
        ];

        disko.devices = {
            disk = {
                disk1 = {
                    type = "disk";
                    device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL81T0HFLB-00BLL_S7XKNF0Y607708";
                    content = {
                        type = "gpt";
                        partitions = {
                            ESP = {
                                priority = 1;
                                name = "ESP";
                                start = "1M";
                                size = "4G";
                                type = "EF00";
                                content = {
                                    type = "filesystem";
                                    format = "vfat";
                                    mountpoint = "/boot";
                                    mountOptions = [ "umask=0077" ];
                                };
                            };
                            swap = {
                                size = "32G";
                                content = {
                                    type = "swap";
                                    discardPolicy = "both";
                                };
                            };
                            root = {
                                size = "100%";
                                content = {
                                    type = "btrfs";
                                    extraArgs = [ "-f" ];
                                    subvolumes = {
                                        "/rootfs" = {
                                            mountpoint = "/";
                                        };
                                        "/nix" = {
                                            mountOptions = [
                                                "compress=zstd"
                                                "noatime"
                                            ];
                                            mountpoint = "/nix";
                                        };
                                    };
                                    mountpoint = "/partition-root";
                                };
                            };
                        };
                    };
                };
            };
        };
    };
}
