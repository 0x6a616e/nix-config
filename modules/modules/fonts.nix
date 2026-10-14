{ moduleWithSystem, ... }: {
    flake.nixosModules.fonts = moduleWithSystem({ pkgs, self', ... }: {
        fonts = {
            fontconfig = {
                enable = true;
                defaultFonts = {
                    monospace = [ "JetBrainsMono Nerd Font" ];
                    sansSerif = [ "DejaVu Sans" ];
                    serif = [ "DejaVu Serif" ];
                };
            };
            packages = [
                pkgs.dejavu_fonts
                pkgs.nerd-fonts.jetbrains-mono
                self'.packages.vcr-osd-mono
            ];
        };
    });

    perSystem = { pkgs, ... }: {
        packages.vcr-osd-mono = pkgs.stdenvNoCC.mkDerivation {
            pname = "VCR-OSD-Mono";
            version = "1.0";
            src = ../../assets/VCR_OSD_MONO_1.001.ttf;
            dontUnpack = true;
            installPhase = ''
                install -Dm644 $src $out/share/fonts/truetype/VCR-OSD-Mono.ttf
            '';
        };
    };
}
