{ inputs, ... }: {
    flake.nixosModules.mooseDisko = _: {
        imports = [
            inputs.disko.nixosModules.disko
        ];

        disko.devices.disk.main = {
            type = "disk";
            device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL21T0HCLR-00BH1_S641NF0X437278";
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
}
