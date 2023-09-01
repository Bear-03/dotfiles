import { activeWorkspaceId, stringEllipsis } from "../../shared/utils.js";
import { BluetoothIndicator, BrightnessIndicator, NetworkIndicator, SpeakerIndicator, BatteryIndicator, MicrophoneIndicator } from "../../modules/indicators.js";

const { App } = ags;
const { Hyprland, Audio, Battery } = ags.Service;
const { execAsync } = ags.Utils;
const {
    Box, Button, Label, CenterBox, Window,
} = ags.Widget;

const Workspaces = (length = 5) => Box({
    className: "module workspaces",
    children: [
        ...Array.from({ length }, (_, i) => i + 1).map(i => Button({
            onClicked: () => execAsync(`hyprctl dispatch workspace ${i}`),
            child: Label({
                connections: [[Hyprland, label => {
                    label.label = activeWorkspaceId() == i ? "" : "";
                }]],
            })
        })),
        Box({
            child: Label({
                connections: [[Hyprland, label => {
                    label.label = activeWorkspaceId().toString();
                }]]
            }),
            connections: [[Hyprland, box => {
                box.visible = activeWorkspaceId() > length;
            }]]
        })
    ]
});

const ActiveWindow = () => Label({
    className: "module active-window",
    connections: [[Hyprland, label => {
        const title = Hyprland.active.client.title;

        label.visible = Boolean(title);
        if (title) {
            label.label = stringEllipsis(title, 60);
        }
    }]],
});

const Clock = () => Label({
    className: "module clock",
    connections: [
        [1000, label => execAsync(["date", "+%R"])
            .then(date => label.label = date)],
    ],
});

const SettingOverview = (props) => Button({
    className: "module",
    onClicked: () => App.toggleWindow("control-panel"),
    child: Box({
        ...props,
        className: ["setting-overview", props?.className ?? ""],
    })
})

const MicrophoneOverview = () => SettingOverview({
    children: [
        MicrophoneIndicator(),
        Label({
            connections: [[Audio, label => {
                if (!Audio.microphone) {
                    return;
                }

                label.label = `${Math.ceil(Audio.microphone.volume * 100)}%`;
            }, "microphone-changed"]]
        })
    ]
})

const SpeakerOverview = () => SettingOverview({
    children: [
        SpeakerIndicator(),
        Label({
            connections: [[Audio, label => {
                if (!Audio.speaker) {
                    return;
                }

                label.label = `${Math.ceil(Audio.speaker.volume * 100)}%`;
            }, "speaker-changed"]]
        })
    ]
});

const BatteryOverview = () => SettingOverview({
    children: [
        BatteryIndicator(),
        Label({
            connections: [[Battery, label => {
                label.label = `${Battery.percent}%`;
            }]]
        })
    ]
});

const OthersOverview = () => SettingOverview({
    className: "others",
    children: [
        BrightnessIndicator(),
        NetworkIndicator(),
        BluetoothIndicator(),
    ]
})

const Left = () => Box({
    children: [
        Workspaces(),
        ActiveWindow(),
    ],
});

const Center = () => Box({
    children: [],
});

const Right = () => Box({
    halign: "end",
    children: [
        MicrophoneOverview(),
        SpeakerOverview(),
        BatteryOverview(),
        OthersOverview(),
        Clock(),
    ],
});

export default () => Window({
    name: "bar",
    anchor: ["top", "left", "right"],
    exclusive: true,
    child: CenterBox({
        className: "bar",
        startWidget: Left(),
        centerWidget: Center(),
        endWidget: Right(),
    }),
})