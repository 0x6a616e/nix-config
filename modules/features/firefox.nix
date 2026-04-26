_: {
    flake.homeModules.firefox = { pkgs, ... }: {
        programs.firefox = {
            enable = true;
            configPath = ".mozilla/firefox";
            profiles.main = {
                extensions.force = true;
                search = {
                    force = true;
                    engines = {
                        nix-packages = {
                            name = "Nix Packages";
                            urls = [{
                                template = "https://search.nixos.org/packages";
                                params = [
                                    { name = "channel"; value = "unstable"; }
                                    { name = "query"; value = "{searchTerms}"; }
                                ];
                            }];
                            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                            definedAliases = [ "@np" ];
                        };
                        nix-options = {
                            name = "Nix Options";
                            urls = [{
                                template = "https://search.nixos.org/options";
                                params = [
                                    { name = "channel"; value = "unstable"; }
                                    { name = "query"; value = "{searchTerms}"; }
                                ];
                            }];
                            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                            definedAliases = [ "@no" ];
                        };
                        home-options = {
                            name = "Home Manager Options";
                            urls = [{
                                template = "https://home-manager-options.extranix.com/";
                                params = [
                                    { name = "release"; value = "master"; }
                                    { name = "query"; value = "{searchTerms}"; }
                                ];
                            }];
                            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                            definedAliases = [ "@ho" ];
                        };
                    };
                };
            };
        };
    };
}
