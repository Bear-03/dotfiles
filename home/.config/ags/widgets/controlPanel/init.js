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
import ControlPanel from "../../shared/services/controlPanel.js";

const { App } = ags;
const { Box, EventBox, Window, Slider, Label, Button } = ags.Widget;
const { Audio, Network } = ags.Service;
const { timeout } = ags.Utils;

const SliderSetting = ({ icon, label, ...props }) => Box({
    className: "slider-setting",
    children: [
        icon,
        Slider({
            ...props,
            max: 100,
            hexpand: true,
            drawValue: false,
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

const ButtonSettingRow = (props) => Box({
    ...props,
    className: "button-setting-row",
    homogeneous: true,
})

export default () => Window({
    name: WindowNames.CONTROL_PANEL,
    anchor: ["top", "right"],
    exclusive: true,
    popup: true,
    child: EventBox({
        aboveChild: true,
        onHover: () => ControlPanel.open(),
        // For some reason this event fires twice when aboveChild == true
        // TODO: Reduce disappearing speed (maybe use revealer)
        // TODO: Maybe make it also toggle in SettingOverview with just hover
        // TODO: Make it reopen if it is in the middle of the closing animation (or waiting for timeout) and it regains hover
        onHoverLost: () => ControlPanel.close(),
        child: Box({
            className: "control-panel",
            vertical: true,
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
                                    label.label = stringEllipsis(Network.wifi.ssid, 10);
                                }]]
                            }),
                        }),
                        ButtonSetting({
                            icon: BluetoothIndicator(),
                            // TODO: Show the name of the device in the label
                        })
                    ]
                }),
                // TODO: Add CPU and RAM, their usage percentage will be the label
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
                })
            ]
        }),
    })
});