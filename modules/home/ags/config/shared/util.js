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
export function range(length, start = 1) {
    return Array.from({ length }, (_, i) => i + start)
}

/**
 * Instantiates a window on all montitors
 * Inspired by: https://github.com/Aylur/dotfiles/blob/18b83b2d2c6ef2b9045edefe49a66959f93b358a/ags/lib/utils.ts#L52
 * @param {(number) => Gtk.Window} window Window to instantiate on monitor
 * @returns {[Gtk.Window]} All windows instantiated on each monitor
 */
export function onAllMonitors(window) {
    const monitorCount = Gdk.Display.get_default()?.get_n_monitors() || 1;
    return range(monitorCount, 0).flatMap(window);
}