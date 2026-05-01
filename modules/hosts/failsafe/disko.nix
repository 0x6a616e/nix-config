{ inputs, ... }: {
    flake.nixosModules.failsafeDisko = { config, ... }: {
        imports = [
            inputs.disko.nixosModules.disko
        ];

        disko.devices = {
            disk.main = {
                type = "disk";
                device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL81T0HFLB-00BLL_S7XKNF0Y607708";
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
                            size = "8G";
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
                    options.cachefile = "none";
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
                        persistent = {
                            mountpoint = config.impermanence.path;
                            options.mountpoint = "legacy";
                            type = "zfs_fs";
                        };
                    };
                };
            };
        };
    };
}
