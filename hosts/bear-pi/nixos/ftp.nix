let
    portRange = {
        from = 51000;
        to = 51999;
    };
in
{
    networking.firewall = {
        allowedTCPPorts = [ 21 ];
        allowedTCPPortRanges = [ portRange ];
    };

    services.vsftpd = {
        enable = true;
        writeEnable = true;
        localUsers = true;
        localRoot = builtins.toString /mnt/main;
        extraConfig = ''
            pasv_enable=Yes
            pasv_min_port=${builtins.toString portRange.from}
            pasv_max_port=${builtins.toString portRange.to}
        '';
    };
}