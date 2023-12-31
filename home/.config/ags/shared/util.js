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