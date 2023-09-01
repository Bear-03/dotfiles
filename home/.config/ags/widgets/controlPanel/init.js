import {
    BluetoothIndicator,
    BrightnessIndicator,
    NetworkIndicator,
    SpeakerIndicator,
    BatteryIndicator,
    MicrophoneIndicator
} from "../../modules/indicators.js";

const { Box, Window, Slider } = ags.Widget;
const { Audio, Brightness } = ags.Service;

const Setting = ({ icon, onSliderChange, ...props }) => Box({
    className: "setting",
    valign: "center",
    children: [
        icon,
        Slider({
            ...props,
            max: 100,
            hexpand: true,
            drawValue: false,
            onChange: onSliderChange,
        })
    ]
})

export default () => Window({
    name: "control-panel",
    anchor: ["top", "right"],
    exclusive: true,
    popup: true,
    focusable: true,
    child: Box({
        className: "control-panel",
        vertical: true,
        children: [
            Setting({
                icon: MicrophoneIndicator(),
                onSliderChange: ({ value }) => Audio.microphone.volume = value / 100,
                connections: [[Audio, slider => {
                    if (!Audio.microphone) {
                        return;
                    }

                    slider.value = Audio.microphone.volume * 100;
                }, "microphone-changed"]]
            }),
            Setting({
                icon: SpeakerIndicator(),
                onSliderChange: ({ value }) => Audio.speaker.volume = value / 100,
                connections: [[Audio, slider => {
                    if (!Audio.speaker) {
                        return;
                    }

                    slider.value = Audio.speaker.volume * 100;
                }, "speaker-changed"]]
            }),
            Setting({
                icon: BrightnessIndicator(),
                onSliderChange: ({ value }) => Brightness.percent = value,
                min: 1,
                connections: [[Audio, slider => {
                    slider.value = Brightness.percent;
                }, "speaker-changed"]]
            }),
        ]
    }),
});