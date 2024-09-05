{
    virtualisation.oci-containers.containers = {
        homarr = {
            image = "ghcr.io/ajnart/homarr:latest";
            ports = [ "7575:7575" ];
            volumes = [
                "/var/run/docker.sock:/var/run/docker.sock" # Optional, only if you want docker integration
                "./homarr/configs:/app/data/configs"
                "./homarr/icons:/app/public/icons"
                "./homarr/data:/data"
            ];
        };
    };
}