import { activeWorkspaceId, stringEllipsis } from "../../shared/utils.js";
import {
    BluetoothIndicator,
    BrightnessIndicator,
    NetworkIndicator,
    SpeakerIndicator,
    BatteryIndicator,
    MicrophoneIndicator,
    MicrophoneIndicatorDetails,
    SpeakerIndicatorDetails,
} from "../../modules/indicators.js";
import { WindowNames } from "../../config.js";
import ControlPanel from "../../shared/services/controlPanel.js";

import { Hyprland, Battery, Utils, Widget } from "../../imports.js";

const Workspaces = (length = 5) => Widget.Box({
    className: "module workspaces",
    children: [
        ...Array.from({ length }, (_, i) => i + 1).map(i => Widget.Button({
            onClicked: () => Utils.execAsync(`hyprctl dispatch workspace ${i}`),
            child: Widget.Label({
                connections: [[Hyprland, label => {
                    label.label = activeWorkspaceId() == i ? "" : "";
                }]],
            })
        })),
        Widget.Box({
            child: Widget.Label({
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

const ActiveWindow = () => Widget.Label({
    className: "module active-window",
    connections: [[Hyprland, label => {
        const title = Hyprland.active.client.title;

        label.visible = Boolean(title);
        if (title) {
            label.label = stringEllipsis(title, 60);
        }
    }]],
});

const Clock = () => Widget.Label({
    className: "module clock",
    connections: [
        [1000, label => Utils.execAsync(["date", "+%R"])
            .then(date => label.label = date)],
    ],
});

const SettingOverview = ({ children }) => Widget.Button({
    className: "module",
    onClicked: () => ControlPanel.toggle(),
    child: Widget.Box({
        className: "setting-overview",
        children
    })
})

const MicrophoneOverview = () => SettingOverview({
    children: [
        MicrophoneIndicator(),
        MicrophoneIndicatorDetails(),
    ]
})

const SpeakerOverview = () => SettingOverview({
    children: [
        SpeakerIndicator(),
        SpeakerIndicatorDetails(),
    ]
});

const BatteryOverview = () => SettingOverview({
    children: [
        BatteryIndicator(),
        Widget.Label({
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

const Left = () => Widget.Box({
    children: [
        Workspaces(),
        ActiveWindow(),
    ],
});

const Center = () => Widget.Box({
    children: [],
});

const Right = () => Widget.Box({
    hpack: "end",
    children: [
        MicrophoneOverview(),
        SpeakerOverview(),
        BatteryOverview(),
        OthersOverview(),
        Clock(),
    ],
});

export default () => Widget.Window({
    name: WindowNames.BAR,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
        className: "bar",
        startWidget: Left(),
        centerWidget: Center(),
        endWidget: Right(),
    }),
})