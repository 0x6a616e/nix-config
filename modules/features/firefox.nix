{ self, inputs, ... }: {
	flake.homeModules.firefox = { pkgs, ... }: {
                stylix.targets.firefox = {
                        profileNames = [ "main" ];
                        colorTheme.enable = true;
                        # colors.enable = true;
                };

		programs.firefox = {
                    enable = true;
                    profiles.main = {
                        extensions.force = true;
                        search = {
                            force = true;
                            engines = {
                                nixos-wiki = {
                                    name = "NixOS Wiki";
                                    urls = [{
                                        template = "https://wiki.nixos.org/w/index.php";
                                        params = [
                                            { name = "search"; value = "{searchTerms}"; }
                                        ];
                                    }];
                                    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                                    definedAliases = [ "@nw" ];
                                };
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
