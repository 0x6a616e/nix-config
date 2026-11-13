{
    flake.nixosModules.shared = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            devenv
            discord
            firefox
            loupe
            nautilus
            papers
            pass
            resources
            showtime
            vlc
            wl-clipboard
        ];

        programs = {
            gnupg.agent.enable = true;
            nh.enable = true;
        };
    };
}
