import { mappedGet } from "../shared/utils.js";
import Brightness from "../shared/services/brightness.js";
import System from "../shared/services/system.js";

const { Audio, Network, Bluetooth, Battery } = ags.Service;
const { Label, Button } = ags.Widget;

export const MicrophoneIndicator = (props) => Button({
    onClicked: () => Audio.microphone.isMuted = !Audio.microphone.isMuted,
    child: Label({
        ...props,
        className: "indicator",
        connections: [[Audio, label => {
            if (!Audio.microphone) {
                return;
            }

            const icons = {
                off: "󰍭",
                on: "󰍬",
            };

            label.label = Audio.microphone.isMuted ? icons.off : icons.on;
        }, "microphone-changed"]]
    }),
});

export const MicrophoneIndicatorDetails = (props) => Label({
    ...props,
    className: "indicator-details",
    connections: [[Audio, label => {
        if (!Audio.microphone) {
            return;
        }

        label.label = `${Math.ceil(Audio.microphone.volume * 100)}%`;
    }, "microphone-changed"]]
});

export const SpeakerIndicator = (props) => Button({
    onClicked: () => Audio.speaker.isMuted = !Audio.speaker.isMuted,
    child: Label({
        ...props,
        className: "indicator",
        connections: [[Audio, label => {
            if (!Audio.speaker) {
                return;
            }

            const icons = {
                off: "󰝟",
                on: ["󰕿", "󰖀", "󰕾"],
            };

            if (Audio.speaker.isMuted) {
                label.label = icons.off;
                return;
            }

            label.label = mappedGet(icons.on, Audio.speaker.volume, 0, 1, Math.ceil);
        }, "speaker-changed"]]
    }),
});

export const SpeakerIndicatorDetails = (props) => Label({
    ...props,
    className: "indicator-details",
    connections: [[Audio, label => {
        if (!Audio.speaker) {
            return;
        }

        label.label = `${Math.ceil(Audio.speaker.volume * 100)}%`;
    }, "speaker-changed"]]
});

export const NetworkIndicator = (props) => Label({
    ...props,
    className: "indicator",
    connections: [[Network, label => {
        const wifi = Network.wifi;

        if (!wifi) {
            return;
        }

        let icons = {
            off: "󰤮",
            on: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"],
        }

        if (wifi.internet != "connected") {
            label.label = icons.off;
            return;
        }

        label.label = mappedGet(icons.on, wifi.strength, 0, 80);
    }]]
});

export const BluetoothIndicator = (props) => Label({
    ...props,
    className: "indicator",
    connections: [[Bluetooth, label => {
        const icons = {
            off: "󰂲",
            on: "󰂯",
            connected: "󰂱",
        }

        if (!Bluetooth.enabled) {
            label.label = icons.off;
        } else if (Array.from(Bluetooth.connectedDevices).length === 0) {
            label.label = icons.on;
        } else {
            label.label = icons.connected;
        }
    }]]
});

export const BrightnessIndicator = (props) => Label({
    ...props,
    className: "indicator",
    connections: [[Brightness, label => {
        const icons = ["󰛩", "󱩎", "󱩏", "󱩐", "󱩑", "󱩒", "󱩓", "󱩔", "󱩕", "󱩖", "󰛨"];

        label.label = mappedGet(icons, Brightness.percent, 0, 100);
    }]]
});

export const BrightnessIndicatorDetails = (props) => Label({
    ...props,
    className: "indicator-details",
    connections: [[Brightness, label => {
        label.label = `${Math.round(Brightness.percent)}%`;
    }]]
})

export const BatteryIndicator = (props) => Label({
    ...props,
    className: "indicator",
    connections: [[Battery, label => {
        const icons = {
            charging: ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
            discharging: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
        }

        label.label = mappedGet(Battery.charging || Battery.charged ? icons.charging : icons.discharging, Battery.percent, 0, 100, Math.floor);
    }]]
});

export const BatteryIndicatorDetails = (props) => Label({
    ...props,
    className: "indicator-details",
    connections: [[Battery, label => {
        label.label = `${Math.floor(Battery.percent)}%`;
    }]]
})

export const CpuIndicator = (props) => Label({
    ...props,
    className: "indicator",
    label: "",
});

export const CpuIndicatorDetails = (props) => Label({
    ...props,
    className: "indicator-details",
    connections: [[System, label => {
        label.label = `${Math.round(System.cpuUsage)}%`;
    }, "cpu-changed"]]
})

export const MemIndicator = (props) => Label({
    ...props,
    className: "indicator",
    label: "",
});

export const MemIndicatorDetails = (props) => Label({
    ...props,
    className: "indicator-details",
    connections: [[System, label => {
        label.label = `${Math.round(System.memUsage)}%`;
    }, "mem-changed"]]
})