let
    vars = import ./vars.nix;
in
{
    services.openssh = {
        enable = true;
        sftpFlags = [
            "-d ${vars.drives.main}"
        ];
    };
}
