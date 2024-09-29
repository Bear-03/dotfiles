{ pkgs, ... } @ args:
let
    username = "bear";
in
{
    users.users.${username} = {
        isNormalUser = true;
        shell = pkgs.nushell;
        extraGroups = [ "audio" "storage" "networkmanager" ];
    };
}