{ inputs, ... }: {
    flake.nixosModules.mooseDisko = { config, ... }: {
        imports = [
            inputs.disko.nixosModules.disko
        ];

        disko.devices = {
            disk.main = {
                type = "disk";
                device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL21T0HCLR-00BH1_S641NF0X437278";
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            size = "4G";
                            type = "EF00";
                            content = {
                                type = "filesystem";
                                format = "vfat";
                                mountpoint = "/boot";
                                mountOptions = [ "umask=0077" ];
                            };
                        };
                        zfs = {
                            end = "-1G";
                            content = {
                                type = "zfs";
                                pool = "rpool";
                            };
                        };
                        swap = {
                            size = "32G";
                            content = {
                                type = "swap";
                                discardPolicy = "both";
                            };
                        };
                    };
                };
            };
            zpool = {
                rpool = {
                    rootFsOptions.compression = "zstd";
                    type = "zpool";
                    datasets = {
                        root = {
                            mountpoint = "/";
                            options.mountpoint = "legacy";
                            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^rpool/root@blank$' || zfs snapshot rpool/root@blank";
                            type = "zfs_fs";
                        };
                        nix = {
                            mountpoint = "/nix";
                            options.mountpoint = "legacy";
                            type = "zfs_fs";
                        };
                    };
                };
            };
        };
    };
}
