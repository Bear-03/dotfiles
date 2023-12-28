// Helpers
export const resource = (file) => `resource:///com/github/Aylur/ags/${file}.js`;
export const service = (file) => resource(`service/${file}`);

async function require(file, def = true) {
    const imp = await import(file);
    return def ? imp.default : imp;
}

// Required components
export const App = await require(resource("app"));
export const GLib = await require("gi://GLib");
export const Service = await require(resource("service"));
export const Utils = await require(resource("utils"), false);
export const Variable = await require(resource("variable"));
export const Widget = await require(resource("widget"));

// Services
export const Audio = await require(service("audio"));
export const Battery = await require(service("battery"));
export const Bluetooth = await require(service("bluetooth"));
export const Hyprland = await require(service("hyprland"));
export const Network = await require(service("network"));