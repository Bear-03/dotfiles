username: { pkgs, ... } @ inputs:
{
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = [ "audio" "networkmanager" "wheel" ];
    packages = with pkgs; [
        lxqt.lxqt-policykit # Polkit support
        git-lfs
        adw-gtk3 # Adwaita theme for gtk
        adwaita-icon-theme # Cursor theme
        neofetch
        swaybg # Background image
        discord
        xorg.xlsclients # List all windows using XWayland
        brightnessctl # Brightness control, to be used primarily by AGS
        sassc # SCSS compiler for AGS
        pavucontrol # Audio controller
        noisetorch
        hyprshot # Screenshots in wayland
        bluetuith # Bluetooth TUI
    ];
}