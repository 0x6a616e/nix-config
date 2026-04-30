{ self, inputs, ... }: {
    flake.nixosModules.chappieDisko = { pkgs, config, ... }: {
        imports = [
            inputs.disko.nixosModules.disko
        ];

        disko.devices = {
            disk.root = {
                type = "disk";
                device = "/dev/disk/by-id/nvme-KINGSTON_SNV3S1000G_50026B7687129744";
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
                            end = "-17G";
                            content = {
                                type = "zfs";
                                pool = "rpool";
                            };
                        };
                        swap = {
                            size = "16G";
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
                        persistent = {
                            mountpoint = config.impermanence.path;
                            options = {
                                encryption = "aes-256-gcm";
                                keyformat = "passphrase";
                                keylocation = "prompt";
                                mountpoint = "legacy";
                            };
                            type = "zfs_fs";
                        };
                    };
                };
            };
        };
    };
}
