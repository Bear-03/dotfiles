import Brightness from "../../services/brightness.js";

import { Audio, Network, Bluetooth, Battery, Widget } from "../../imports.js";
import repr from "../../shared/repr.js";

export const MicrophoneIcon = () => Widget.Label({
    className: "system-icon",
    setup: self => self
        .hook(Audio, self => {
            self.label = repr.microphone.icon(Audio.microphone?.isMuted ?? true)
        }, "microphone-changed"),
});

export const MicrophoneVolume = () => Widget.Label({
    className: "system-text",
    setup: self => self
        .hook(Audio, self => {
            self.label = repr.microphone.volumePercent(Audio.microphone?.volume ?? 0)
        }, "microphone-changed"),
});

export const SpeakerIcon = () => Widget.Label({
    className: "system-icon",
    setup: self => self
        .hook(Audio, self => {
            self.label = repr.speaker.icon(Audio.speaker?.isMuted ?? true, Audio.speaker?.volume);
        }, "speaker-changed"),
});

export const SpeakerVolume = () => Widget.Label({
    className: "system-text",
    setup: self => self
        .hook(Audio, self => {
            self.label = repr.speaker.volumePercent(Audio.speaker?.volume ?? 0);
        }, "speaker-changed"),
});

export const NetworkIcon = () => Widget.Label({
    className: "system-icon",
    setup: self => self
        .hook(Network, self => {
            self.label = repr.network.icon(Network.wifi?.internet, Network.wifi?.strength);
        }),
});

export const BluetoothIcon = () => Widget.Label({
    className: "system-icon",
    setup: self => self
        .hook(Bluetooth, self => {
            self.label = repr.bluetooth.icon(Bluetooth.enabled, Bluetooth.connectedDevices);
        }),
});

export const BrightnessIcon = () => Widget.Label({
    className: "system-icon",
    label: Brightness.bind("percent").transform(p => repr.brightness.icon(p)),
});

export const BrightnessPercent = () => Widget.Label({
    label: Brightness.bind("percent").transform(p => repr.brightness.percent(p)),
})

export const BatteryIcon = () => Widget.Label({
    className: "system-icon",
    setup: self => self
        .hook(Battery, self => {
            self.label = repr.battery.icon(Battery.charging || Battery.charged, Battery.percent);
        }),
});

export const BatteryPercent = () => Widget.Label({
    className: "system-text",
    label: Battery.bind("percent").transform(p => repr.battery.percent(p)),
})