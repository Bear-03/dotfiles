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
} from "../../modules/indicators.js";
import { stringEllipsis } from "../../shared/utils.js";
import { WindowNames } from "../../windows.js";
import Brightness from "../../shared/services/brightness.js";

const { Box, Window, Slider, Label, Button } = ags.Widget;
const { Audio, Network } = ags.Service;

const SliderSetting = ({ icon, label, onChange, connections }) => Box({
    className: "slider-setting",
    children: [
        icon,
        Slider({
            max: 100,
            hexpand: true,
            drawValue: false,
            onChange,
            connections
        }),
        label,
    ]
})

const ButtonSetting = ({ icon, onClicked, label }) => Button({
    className: "button-setting",
    onClicked,
    child: Box({
        hexpand: true,
        vertical: true,
        children: [
            icon,
            label,
        ]
    })
})

const ButtonSettingRow = ({ children }) => Box({
    className: "button-setting-row",
    homogeneous: true,
    children
})

export default () => Window({
    name: WindowNames.CONTROL_PANEL,
    anchor: ["top", "right"],
    exclusive: true,
    popup: true,
    focusable: true,
    child: Box({
        vertical: true,
        className: "control-panel",
        children: [
            SliderSetting({
                icon: MicrophoneIndicator(),
                label: MicrophoneIndicatorDetails(),
                onChange: ({ value }) => Audio.microphone.volume = value / 100,
                connections: [[Audio, slider => {
                    if (!Audio.microphone) {
                        return;
                    }

                    slider.value = Audio.microphone.volume * 100;
                }, "microphone-changed"]]
            }),
            SliderSetting({
                icon: SpeakerIndicator(),
                label: SpeakerIndicatorDetails(),
                onChange: ({ value }) => Audio.speaker.volume = value / 100,
                connections: [[Audio, slider => {
                    if (!Audio.speaker) {
                        return;
                    }
                    slider.value = Audio.speaker.volume * 100;
                }, "speaker-changed"]]
            }),
            SliderSetting({
                icon: BrightnessIndicator(),
                label: BrightnessIndicatorDetails(),
                onChange: ({ value }) => Brightness.percent = value,
                min: 1,
                connections: [[Brightness, slider => {
                    slider.value = Brightness.percent;
                }]]
            }),
            ButtonSettingRow({
                children: [
                    ButtonSetting({
                        icon: NetworkIndicator(),
                        label: Label({
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
