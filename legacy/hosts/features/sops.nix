{ config, ... }:
{
    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.age.keyFile = "${config.users.users.jan.home}/.config/sops/age/keys.txt";
    sops.secrets."tailscale/authKey" = { };
}
