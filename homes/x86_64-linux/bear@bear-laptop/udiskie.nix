{
    services.udiskie = {
        enable = true;
        automount = false;
        settings = {
            program_options = {
                terminal = "alacritty --working-directory";
            };
            notification_actions = {
                device_mounted = [ "terminal" ];
            };
        };
    };
}
