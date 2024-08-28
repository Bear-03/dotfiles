username: { pkgs, ... } @ inputs:
{
    isNormalUser = true;
    # A password is always needed for SSH, so we provide a default one
    initialPassword = "pass";
    shell = pkgs.nushell;
    extraGroups = [ "gpio" "storage" "networkmanager" "wheel" ];
    packages = with pkgs; [
        neofetch
        trash-cli # Trashcan management
        zip
        unzip
        neovim
        git
    ];
}
