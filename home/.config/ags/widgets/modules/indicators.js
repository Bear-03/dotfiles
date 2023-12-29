import { mappedGet } from "../../shared/utils.js";
import Brightness from "../../services/brightness.js";
import { mem, cpu } from "../../shared/variables.js";

import { Audio, Network, Bluetooth, Battery, Widget } from "../../imports.js";
import repr from "../../shared/repr.js";

export const MicrophoneIndicator = () => Widget.Button({
    onClicked: () => Audio.microphone.isMuted = !Audio.microphone.isMuted,
    child: Widget.Label({
        className: "indicator",
        setup: self => self
            .hook(Audio, self => {
                self.label = repr.microphone.icon(Audio.microphone?.isMuted ?? true)
            }, "microphone-changed"),
    }),
});

export const MicrophoneIndicatorDetails = () => Widget.Label({
    className: "indicator-details",
    setup: self => self
        .hook(Audio, self => {
            self.label = repr.microphone.details(Audio.microphone?.volume ?? 0)
        }, "microphone-changed"),
});

export const SpeakerIndicator = () => Widget.Button({
    onClicked: () => Audio.speaker.isMuted = !Audio.speaker.isMuted,
    child: Widget.Label({
        className: "indicator",
        setup: self => self
            .hook(Audio, self => {
                self.label = repr.speaker.icon(Audio.speaker?.isMuted ?? true, Audio.speaker?.volume);
            }, "speaker-changed"),
    }),
});

export const SpeakerIndicatorDetails = () => Widget.Label({
    className: "indicator-details",
    setup: self => self
        .hook(Audio, self => {
            self.label = repr.speaker.details(Audio.speaker?.volume ?? 0);
        }, "speaker-changed"),
});

export const NetworkIndicator = () => Widget.Label({
    className: "indicator",
    setup: self => self
        .hook(Network, self => {
            self.label = repr.network.icon(Network.wifi?.internet, Network.wifi?.strength);
        }),
});

export const BluetoothIndicator = () => Widget.Label({
    className: "indicator",
    setup: self => self
        .hook(Bluetooth, self => {
            self.label = repr.bluetooth.icon(Bluetooth.enabled, Bluetooth.connectedDevices);
        }),
});

export const BrightnessIndicator = () => Widget.Label({
    className: "indicator",
    label: Brightness.bind("percent").transform(p => repr.brightness.icon(p)),
});

export const BrightnessIndicatorDetails = () => Widget.Label({
    className: "indicator-details",
    label: Brightness.bind("percent").transform(p => repr.brightness.details(p)),
})

export const BatteryIndicator = () => Widget.Label({
    className: "indicator",
    setup: self => self
        .hook(Battery, self => {
            self.label = repr.battery.icon(Battery.charging || Battery.charged, Battery.percent);
        }),
});

export const BatteryIndicatorDetails = () => Widget.Label({
    className: "indicator-details",
    label: Battery.bind("percent").transform(p => repr.battery.details(p)),
})

export const CpuIndicator = () => Widget.Label({
    className: "indicator",
    label: repr.cpu.icon,
});

export const CpuIndicatorDetails = () => Widget.Label({
    className: "indicator-details",
    label: cpu.bind().transform(usage => repr.cpu.details(usage)),
})

export const MemIndicator = () => Widget.Label({
    className: "indicator",
    label: repr.mem.icon,
});

export const MemIndicatorDetails = () => Widget.Label({
    className: "indicator-details",
    label: mem.bind().transform(usage => repr.mem.details(usage)),
})