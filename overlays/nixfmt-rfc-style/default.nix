{ inputs, ... }: self: super: {
    nixfmt-rfc-style = inputs.nixfmt-indent.packages.${self.system}.default;
}