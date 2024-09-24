lib: rec {
    mapFilesToAttrs = {
        dir,
        keyFn ? lib.trivial.id,
        valueFn ? lib.trivial.id
    }: let
        files = builtins.attrNames (builtins.readDir dir);
    in
    builtins.listToAttrs (
        builtins.filter (x: x.name != null && x.value != null) (
            map
            (filename: {
                name = keyFn filename;
                value = valueFn filename;
            })
            files
        )
    );

    # Inspired by: https://github.com/ngi-nix/ngipkgs/blob/faf6738d6462798dea6c2cc2dde84b3834b5427a/lib.nix#L25C3-L43C18
    # Takes an attrset of arbitrary nesting (attrset containing attrset)
    # and flattens it into an attrset that is *not* nested, i.e., does
    # *not* contain attrsets.
    # This is done by concatenating the names of nested values using a
    # separator.
    #
    # Type: flattenAttrs :: string -> AttrSet -> AttrSet
    #
    # Example:
    #   flattenAttrs {
    #       sep = "@";
    #       attrs = { a = { b = "x"; }; c = { d = { e = "y"; }; }; f = "z"; };
    #   };
    #   => { "a@b" = "x"; "c@d@e" = "y"; "f" = "z"; }
    #
    #   flattenAttrs {
    #       sep = "@";
    #       attrs = { a = { b = "x"; }; c = { d = { e = "y"; }; }; f = "z"; };
    #       reverse = true;
    #   };
    #   => { "b@a" = "x"; "e@d@c" = "y"; "f" = "z"; }
    flattenAttrs = { sep, attrs, reverse ? false }: let
        concat = last: path: name:
            if last
            then if reverse
                then name + path
                else path + name
            else if reverse
                then sep + name + path
                else path + name + sep;
        inner = path: attrs: lib.concatMapAttrs (name: value:
            if builtins.isAttrs value
            then inner (concat false path name) value
            else {${concat true path name} = value;}
        ) attrs;
    in
    inner "" attrs;
}