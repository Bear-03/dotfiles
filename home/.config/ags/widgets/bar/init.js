import { stringEllipsis } from "../../shared/utils.js";
import {
    BluetoothIcon,
    BrightnessIcon,
    NetworkIcon,
    SpeakerIcon,
    BatteryIcon,
    BatteryPercent,
    MicrophoneIcon,
    MicrophoneVolume,
    SpeakerVolume,
} from "../modules/system.js";
import { WindowNames } from "../../config.js";

import { Hyprland, Utils, Widget } from "../../imports.js";
import repr from "../../shared/repr.js";

const Workspaces = (length = 5) => Widget.Box({
    className: "module workspaces",
    children: [
        ...Array.from({ length }, (_, i) => i + 1).map(i => Widget.Button({
            onClicked: () => Utils.execAsync(`hyprctl dispatch workspace ${i}`),
            child: Widget.Label({
                label: Hyprland.active.workspace.bind("id").transform(id => repr.workspace.icon(i, id)),
            })
        })),
        Widget.Label({
            visible: Hyprland.active.workspace.bind("id").transform(id => id > length),
            label: Hyprland.active.workspace.bind("id").transform(id => id.toString()),
        })
    ]
});

const ActiveWindow = () => Widget.Label({
    className: "module",
    visible: Hyprland.active.client.bind("title").transform(title => Boolean(title)),
    label: Hyprland.active.client.bind("title").transform(title => stringEllipsis(title, 60)),
});

const Clock = () => Widget.Label({
    className: "module",
    setup: self => self
        .poll(1000, self => Utils.execAsync("date +%R").then(date => self.label = date)),
});

const IconModule = (children, iconOnly = false) => Widget.Box({
    classNames: ["module", iconOnly ? "icon-only" : ""],
    children
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
        IconModule([
            MicrophoneIcon(),
            MicrophoneVolume(),
        ]),
        IconModule([
            SpeakerIcon(),
            SpeakerVolume(),
        ]),
        IconModule([
            BatteryIcon(),
            BatteryPercent(),
        ]),
        IconModule([
            BrightnessIcon(),
            NetworkIcon(),
            BluetoothIcon(),
        ], true),
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