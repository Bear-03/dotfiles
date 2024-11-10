args: self: super: {
    dbeaver-bin = super.dbeaver-bin.overrideAttrs (old: {
        # Fix UI flickering when using dark theme
        postInstall = (old.postInstall or "") + ''
            wrapProgram $out/bin/dbeaver --set GDK_BACKEND x11
        '';
    });
}