_: {
    flake.homeModules.firefox = { pkgs, lib, config, ... }: {
        options = {
            firefox.enable = lib.mkEnableOption "enable firefox";
        };
        config = lib.mkIf config.firefox.enable {
            programs.firefox = {
                enable = true;
                configPath = ".mozilla/firefox";
                profiles.main = {
                    bookmarks = {
                        force = true;
                        settings = [
                            { name = "NixOs Search"; url = "https://search.nixos.org/packages?channel=unstable"; keyword = "ns"; }
                        ];
                    };
                    extensions.force = true;
                };
            };
        };
    };
}
