import {
    BluetoothIcon,
    BrightnessIcon,
    NetworkIcon,
    SpeakerIcon,
    BatteryIcon,
    MicrophoneIcon,
    BrightnessPercent,
    SpeakerVolume,
    MicrophoneVolume,
    BatteryPercent,
} from "../modules/system.js";
import { stringEllipsis } from "../../shared/utils.js";
import { WindowNames } from "../../config.js";
import Brightness from "../../services/brightness.js";

import { Widget, Audio, Network } from "../../imports.js";
import { cpu, mem, controlPanelVisible } from "../../shared/variables.js";
import repr from "../../shared/repr.js";

const SliderSetting = ({ icon, label, onChange, setup, value }) => Widget.Box({
    className: "slider-setting",
    children: [
        icon,
        Widget.Slider({
            max: 100,
            hexpand: true,
            drawValue: false,
            onChange,
            setup,
            value,
        }),
        label,
    ],
})

const ButtonSetting = ({ onClicked, icon, label }) => Widget.Button({
    className: "button-setting",
    onClicked: onClicked || (() => { }),
    child: Widget.Box({
        hexpand: true,
        vertical: true,
        children: [
            icon,
            label,
        ]
    })
})

const ButtonSettingRow = (children) => Widget.Box({
    className: "button-setting-row",
    homogeneous: true,
    children
})

export default () => Widget.Window({
    name: WindowNames.CONTROL_PANEL,
    anchor: ["top", "right"],
    popup: true,
    visible: controlPanelVisible.bind(),
    focusable: true,
    child: Widget.Box({
        vertical: true,
        className: "control-panel",
        children: [
            SliderSetting({
                icon: MicrophoneIcon(),
                label: MicrophoneVolume(),
                onChange: ({ value }) => Audio.microphone.volume = value / 100,
                setup: self => self
                    .hook(Audio, self => {
                        self.value = (Audio.microphone?.volume ?? 0) * 100;
                    }, "microphone-changed"),
            }),
            SliderSetting({
                icon: SpeakerIcon(),
                label: SpeakerVolume(),
                onChange: ({ value }) => Audio.speaker.volume = value / 100,
                setup: self => self
                    .hook(Audio, self => {
                        self.value = (Audio.speaker?.volume ?? 0) * 100;
                    }, "speaker-changed"),
            }),
            SliderSetting({
                icon: BrightnessIcon(),
                label: BrightnessPercent(),
                onChange: ({ value }) => Brightness.percent = value,
                value: Brightness.bind("percent"),
                min: 1,
            }),
            ButtonSettingRow([
                ButtonSetting({
                    icon: NetworkIcon(),
                    label: Widget.Label({
                        connections: [[Network, label => {
                            if (!Network.wifi) {
                                return;
                            }

                            // TODO: Make text go from right to left to be able to read everything
                            label.label = stringEllipsis(Network.wifi.ssid, 20);
                        }]]
                    }),
                }),
                ButtonSetting({
                    icon: BluetoothIcon(),
                    // TODO: Show the name of the device in the label
                })
            ]),
            ButtonSettingRow([
                ButtonSetting({
                    icon: Widget.Label(repr.cpu.icon),
                    label: Widget.Label({
                        label: cpu.bind().transform(usage => repr.cpu.usagePercent(usage))
                    }),
                }),
                ButtonSetting({
                    icon: Widget.Label(repr.mem.icon),
                    label: Widget.Label({
                        label: mem.bind().transform(usage => repr.mem.usagePercent(usage))
                    })
                }),
                ButtonSetting({
                    icon: BatteryIcon(),
                    label: BatteryPercent(),
                })
            ]),
        ]
    })
});