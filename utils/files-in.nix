namesOnly: path: let
    names = builtins.attrNames (builtins.readDir path);
in
if namesOnly
then names
else map (name: path + /${name}) names