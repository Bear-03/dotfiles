let
    vars = import ./vars.nix;
    domains = vars.domains;
    secrets = import ./secrets.nix;
in
{
    virtualisation.oci-containers.containers = {
        wg-easy = {
            hostname = "wg-easy";
            autoStart = true;
            # Prometheus metrics are only available on nightly for now
            image = "ghcr.io/wg-easy/wg-easy:nightly";
            environment = {
                # Wireguard will be available at "external-base:51820
                # No need to open port in firewall on nixos
                # The container setup does it automatically
                WG_HOST = domains.base;
                WG_DEFAULT_DNS = vars.local-ip; # Use this machine as DNS
                PASSWORD_HASH = secrets.wireguard-password-hash;
                ENABLE_PROMETHEUS_METRICS = "true";
            };
            volumes = [
                "etc_wireguard:/etc/wireguard"
            ];
            ports = [
                "51820:51820/udp"
                "51821:51821/tcp"
            ];
            extraOptions = [
                "--cap-add=NET_ADMIN"
                "--cap-add=SYS_MODULE"
                # Enabled as per:
                # https://github.com/wg-easy/wg-easy/blob/067b7bcf8451022d2607a3ee8b90e3da1265732f/docker-compose.yml#L47C11-L47C18
                # NixOS' OCI containers run on podman
                "--cap-add=NET_RAW"
                "--sysctl=\"net.ipv4.conf.all.src_valid_mark=1\""
                "--sysctl=\"net.ipv4.ip_forward=1\""
            ];
        };
    };
}