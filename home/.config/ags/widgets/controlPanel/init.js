import {
    BluetoothIndicator,
    BrightnessIndicator,
    NetworkIndicator,
    SpeakerIndicator,
    BatteryIndicator,
    MicrophoneIndicator,
    BrightnessIndicatorDetails,
    SpeakerIndicatorDetails,
    MicrophoneIndicatorDetails,
    BatteryIndicatorDetails,
    CpuIndicator,
    CpuIndicatorDetails,
    MemIndicator,
    MemIndicatorDetails
} from "../modules/indicators.js";
import { stringEllipsis } from "../../shared/utils.js";
import { WindowNames } from "../../config.js";
import Brightness from "../../services/brightness.js";

import { Widget, Audio, Network } from "../../imports.js";
import { controlPanelVisible } from "../../shared/variables.js";

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
    ]
})

const ButtonSetting = ({ icon, onClicked, label }) => Widget.Button({
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

const ButtonSettingRow = ({ children }) => Widget.Box({
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
                icon: MicrophoneIndicator(),
                label: MicrophoneIndicatorDetails(),
                onChange: ({ value }) => Audio.microphone.volume = value / 100,
                setup: self => self
                    .hook(Audio, self => {
                        if (!Audio.microphone) {
                            return;
                        }

                        self.value = Audio.microphone.volume * 100;
                    }, "microphone-changed"),
            }),
            SliderSetting({
                icon: SpeakerIndicator(),
                label: SpeakerIndicatorDetails(),
                onChange: ({ value }) => Audio.speaker.volume = value / 100,
                setup: self => self
                    .hook(Audio, self => {
                        if (!Audio.speaker) {
                            return;
                        }

                        self.value = Audio.speaker.volume * 100;
                    }, "speaker-changed"),
            }),
            SliderSetting({
                icon: BrightnessIndicator(),
                label: BrightnessIndicatorDetails(),
                onChange: ({ value }) => Brightness.percent = value,
                value: Brightness.bind("percent"),
                min: 1,
            }),
            ButtonSettingRow({
                children: [
                    ButtonSetting({
                        icon: NetworkIndicator(),
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
                        icon: BluetoothIndicator(),
                        // TODO: Show the name of the device in the label
                    })
                ]
            }),
            ButtonSettingRow({
                children: [
                    ButtonSetting({
                        icon: CpuIndicator(),
                        label: CpuIndicatorDetails(),
                    }),
                    ButtonSetting({
                        icon: MemIndicator(),
                        label: MemIndicatorDetails(),
                    }),
                    ButtonSetting({
                        icon: BatteryIndicator(),
                        label: BatteryIndicatorDetails(),
                    })
                ]
            }),
        ]
    })
});
