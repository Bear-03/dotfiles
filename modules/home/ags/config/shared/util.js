import Gdk from "gi://Gdk"
import { Audio } from "../imports.js";

export function clamp(value, min, max) {
    return Math.min(Math.max(value, min), max);
}

export function map(value, fromLow, fromHigh, toLow, toHigh) {
    const conversionRate = (toHigh - toLow) / (fromHigh - fromLow);
    return toLow + conversionRate * (clamp(value, fromLow, fromHigh) - fromLow);
}

export function mappedGet(array, index, indexLow, indexHigh, roundingFn = Math.round) {
    return array[roundingFn(map(index, indexLow, indexHigh, 0, array.length - 1))];
}

export function muteAudioStream(type) {
    Audio[type].stream.change_is_muted(!Audio[type].stream.isMuted);
}

export function capitalize(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

/**
 * Taken from: https://github.com/Aylur/dotfiles/blob/18b83b2d2c6ef2b9045edefe49a66959f93b358a/ags/lib/utils.ts#L60
 * @returns {[number]} [start...length]
 */
export function range(length, start = 0) {
    return Array.from({ length }, (_, i) => i + start)
}

export function cartesian(a, b) {
    const res = [];

    for (const i of a) {
        for (const j of b) {
            res.push([i, j]);
        }
    }

    return res;
}

let monitorDiscriminator = 0;
export function nextMonitorDiscriminator() {
    return monitorDiscriminator++;
}

/**
 * Instantiates a window on all montitors
 * Inspired by: https://github.com/Aylur/dotfiles/blob/18b83b2d2c6ef2b9045edefe49a66959f93b358a/ags/lib/utils.ts#L52
 * @param {[(Gdk.Monitor) => Gtk.Window]} windows Windows to instantiate on each monitor
 * @returns {[Gtk.Window]} All windows instantiated for all monitors
 */
export function onAllMonitors(windows) {
    const display = Gdk.Display.get_default();
    const monitorCount = display.get_n_monitors();
    const gdkmonitors = range(monitorCount).map((i) => display.get_monitor(i))

    return cartesian(windows, gdkmonitors).map(([window, gdkmonitor]) => window(gdkmonitor));
}