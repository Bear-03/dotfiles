args: self: super:
let
    package = super.nixfmt-rfc-style;
in
{
    nixfmt-rfc-style = super.symlinkJoin {
        inherit (package) name;
        paths = [ package ];
        buildInputs = with super; [ makeWrapper ];
        postBuild = ''
            wrapProgram $out/bin/nixfmt-rfc-style \
                --add-flags "--indent=4" \
        '';
    };
}
