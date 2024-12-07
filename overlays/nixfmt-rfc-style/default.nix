{ inputs, ... }: self: super: {
    nixfmt-rfc-style = super.writeShellApplication {
        name = "format";
        runtimeInputs = [
            inputs.nixfmt-indent.packages.${super.system}.default
        ];
        text = ''
            nixfmt --indent=4 "''${@}"
        '';
    };
}