import { mappedGet } from "../../shared/utils.js";
import Brightness from "../../services/brightness.js";
import { mem, cpu } from "../../shared/variables.js";

import { Audio, Network, Bluetooth, Battery, Widget } from "../../imports.js";

export const MicrophoneIndicator = () => Widget.Button({
    onClicked: () => Audio.microphone.isMuted = !Audio.microphone.isMuted,
    child: Widget.Label({
        className: "indicator",
        setup: self => self
            .hook(Audio, self => {
                if (!Audio.microphone) {
                    return;
                }

                const icons = {
                    off: "󰍭",
                    on: "󰍬",
                };

                self.label = Audio.microphone.isMuted ? icons.off : icons.on;
            }, "microphone-changed")
    }),
});

export const MicrophoneIndicatorDetails = () => Widget.Label({
    className: "indicator-details",
    setup: self => self
        .hook(Audio, self => {
            if (!Audio.microphone) {
                return;
            }

            self.label = `${Math.ceil(Audio.microphone.volume * 100)}%`;
        }, "microphone-changed"),
});

export const SpeakerIndicator = () => Widget.Button({
    onClicked: () => Audio.speaker.isMuted = !Audio.speaker.isMuted,
    child: Widget.Label({
        className: "indicator",
        setup: self => self
            .hook(Audio, self => {
                if (!Audio.speaker) {
                    return;
                }

                const icons = {
                    off: "󰝟",
                    on: ["󰕿", "󰖀", "󰕾"],
                };

                self.label = Audio.speaker.isMuted ? icons.off : mappedGet(icons.on, Audio.speaker.volume, 0, 1, Math.ceil);
            }, "speaker-changed"),
    }),
});

export const SpeakerIndicatorDetails = () => Widget.Label({
    className: "indicator-details",
    setup: self => self
        .hook(Audio, self => {
            if (!Audio.speaker) {
                return;
            }

            self.label = `${Math.ceil(Audio.speaker.volume * 100)}%`;
        }),
});

export const NetworkIndicator = () => Widget.Label({
    className: "indicator",
    setup: self => self
        .hook(Network, self => {
            const wifi = Network.wifi;

            if (!wifi) {
                return;
            }

            let icons = {
                off: "󰤮",
                on: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"],
            }

            self.label = wifi.internet != "connected" ? icons.off : mappedGet(icons.on, wifi.strength, 0, 80);
        }, "changed"),
});

export const BluetoothIndicator = () => Widget.Label({
    className: "indicator",
    setup: self => self
        .hook(Bluetooth, self => {
            const icons = {
                off: "󰂲",
                on: "󰂯",
                connected: "󰂱",
            }

            if (!Bluetooth.enabled) {
                self.label = icons.off;
            } else if (Array.from(Bluetooth.connectedDevices).length === 0) {
                self.label = icons.on;
            } else {
                self.label = icons.connected;
            }
        }),
});

export const BrightnessIndicator = () => Widget.Label({
    className: "indicator",
    label: Brightness.bind("percent").transform(p => mappedGet(["󰛩", "󱩎", "󱩏", "󱩐", "󱩑", "󱩒", "󱩓", "󱩔", "󱩕", "󱩖", "󰛨"], p, 0, 100)),
});

export const BrightnessIndicatorDetails = () => Widget.Label({
    className: "indicator-details",
    label: Brightness.bind("percent").transform(p => `${Math.round(Brightness.percent)}%`),
})

export const BatteryIndicator = () => Widget.Label({
    className: "indicator",
    setup: self => self
        .hook(Battery, self => {
            const icons = {
                charging: ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
                discharging: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
            }

            self.label = mappedGet(Battery.charging || Battery.charged ? icons.charging : icons.discharging, Battery.percent, 0, 100, Math.floor);
        }),
});

export const BatteryIndicatorDetails = () => Widget.Label({
    className: "indicator-details",
    label: Battery.bind("percent").transform(p => `${Math.floor(p)}%`),
})

export const CpuIndicator = () => Widget.Label({
    className: "indicator",
    label: "",
});

export const CpuIndicatorDetails = () => Widget.Label({
    className: "indicator-details",
    label: cpu.bind().transform(usage => `${Math.round(usage)}%`),
})

export const MemIndicator = () => Widget.Label({
    className: "indicator",
    label: "",
});

export const MemIndicatorDetails = () => Widget.Label({
    className: "indicator-details",
    label: mem.bind().transform(usage => `${Math.round(usage)}%`),
})