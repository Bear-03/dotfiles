username: { pkgs, ... } @ inputs:
{
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = [ "gpio" "storage" "networkmanager" "wheel" ];
    packages = with pkgs; [
        neofetch
        trash-cli # Trashcan management
        zip
        unzip
    ];
}
