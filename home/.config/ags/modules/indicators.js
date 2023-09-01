import { mappedGet } from "../shared/utils.js";

const { Audio, Network, Bluetooth, Battery, Brightness } = ags.Service;
const { Label, Button } = ags.Widget;

export const MicrophoneIndicator = (props) => Button({
    onClicked: () => Audio.microphone.isMuted = !Audio.microphone.isMuted,
    child: Label({
        ...props,
        className: ["indicator", props?.className ?? ""],
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
})

export const SpeakerIndicator = (props) => Button({
    onClicked: () => Audio.speaker.isMuted = !Audio.speaker.isMuted,
    child: Label({
        ...props,
        className: ["indicator", props?.className ?? ""],
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

export const NetworkIndicator = (props) => Label({
    ...props,
    className: ["indicator", props?.className ?? ""],
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
    className: ["indicator", props?.className ?? ""],
    connections: [[Bluetooth, label => {
        const icons = {
            off: "󰂲",
            on: "󰂯",
            connected: "󰂱",
        }

        if (!Bluetooth.enabled) {
            label.label = icons.off;
        } else if (!Bluetooth.connectedDevices) {
            label.label = icons.on;
        } else {
            label.label = icons.connected;
        }
    }]]
});

export const BrightnessIndicator = (props) => Label({
    ...props,
    className: ["indicator", props?.className ?? ""],
    connections: [[Brightness, label => {
        const icons = ["󰛩", "󱩎", "󱩏", "󱩐", "󱩑", "󱩒", "󱩓", "󱩔", "󱩕", "󱩖", "󰛨"];

        label.label = mappedGet(icons, Brightness.percent, 0, 100);
    }]]
});

export const BatteryIndicator = (props) => Label({
    ...props,
    className: ["indicator", props?.className ?? ""],
    connections: [[Battery, label => {
        const icons = {
            charging: ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
            discharging: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
        }

        label.label = mappedGet(Battery.charging || Battery.charged ? icons.charging : icons.discharging, Battery.percent, 0, 100, Math.floor);
    }]]
});