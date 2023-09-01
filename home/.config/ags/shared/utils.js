const { Hyprland } = ags.Service;

export function dbg(value) {
    console.log(value);
    return value;
}

export function activeWorkspaceId() {
    return Hyprland.active.workspace.id;
}

export function stringEllipsis(string, maxLength, ellipsis = "...") {
    if (string.length <= maxLength) {
        return string;
    }

    return string.substring(0, maxLength - ellipsis.length).trim() + ellipsis;
}

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