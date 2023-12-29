import { stringEllipsis } from "../../shared/utils.js";
import {
    BluetoothIndicator,
    BrightnessIndicator,
    NetworkIndicator,
    SpeakerIndicator,
    BatteryIndicator,
    MicrophoneIndicator,
    MicrophoneIndicatorDetails,
    SpeakerIndicatorDetails,
} from "../modules/indicators.js";
import { WindowNames } from "../../config.js";

import { Hyprland, Battery, Utils, Widget } from "../../imports.js";
import { controlPanelVisible } from "../../shared/variables.js";

const Workspaces = (length = 5) => Widget.Box({
    className: "module workspaces",
    children: [
        ...Array.from({ length }, (_, i) => i + 1).map(i => Widget.Button({
            onClicked: () => Utils.execAsync(`hyprctl dispatch workspace ${i}`),
            child: Widget.Label({
                label: Hyprland.active.workspace.bind("id").transform(id => id == i ? "" : ""),
            })
        })),
        Widget.Label({
            visible: Hyprland.active.workspace.bind("id").transform(id => id > length),
            label: Hyprland.active.workspace.bind("id").transform(id => id.toString()),
        })
    ]
});

const ActiveWindow = () => Widget.Label({
    className: "module active-window",
    visible: Hyprland.active.client.bind("title").transform(title => Boolean(title)),
    label: Hyprland.active.client.bind("title").transform(title => stringEllipsis(title, 60)),
});

const Clock = () => Widget.Label({
    className: "module clock",
    setup: self => self
        .poll(1000, self => Utils.execAsync("date +%R").then(date => self.label = date)),
});

const SettingOverview = ({ children }) => Widget.Button({
    className: "module",
    onClicked: () => controlPanelVisible.value = !controlPanelVisible.value,
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
            label: Battery.bind("percent").transform(p => `${p}%`)
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