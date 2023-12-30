import { stringEllipsis } from "../../shared/utils.js";
import { WindowNames } from "../../config.js";

import { Hyprland, Audio, Battery, Network, Bluetooth, Utils, Widget } from "../../imports.js";
import repr from "../../shared/repr.js";
import { showBatteryTime } from "../../shared/variables.js";

const WorkspacesModule = (length = 5) => Widget.Box({
    className: "module workspaces",
    children: [
        ...Array.from({ length }, (_, i) => i + 1).map(i => Widget.Button({
            onClicked: () => Hyprland.sendMessage(`dispatch workspace ${i}`),
            child: Widget.Label({
                className: "label-icon",
                label: Hyprland.active.workspace.bind("id").transform(id => repr.workspace.icon(i, id)),
            })
        })),
        Widget.Label({
            visible: Hyprland.active.workspace.bind("id").transform(id => id > length),
            label: Hyprland.active.workspace.bind("id").transform(id => id.toString()),
        })
    ]
});

const ActiveWindowModule = () => Widget.Label({
    className: "module",
    visible: Hyprland.active.client.bind("title").transform(title => Boolean(title)),
    label: Hyprland.active.client.bind("title").transform(title => stringEllipsis(title, 60)),
});

const MicrophoneModule = () => Widget.Box({
    className: "module",
    children: [
        Widget.Label({
            className: "label-icon",
            setup: self => self.hook(Audio, () => {
                self.label = repr.microphone.icon(Audio.microphone?.isMuted ?? true)
            }, "microphone-changed"),
        }),
        Widget.Label({
            setup: self => self.hook(Audio, () => {
                self.label = repr.microphone.volumePercent(Audio.microphone?.volume ?? 0)
            }, "microphone-changed"),
        }),
    ]
});

const SpeakerModule = () => Widget.Box({
    className: "module",
    children: [
        Widget.Label({
            className: "label-icon",
            setup: self => self.hook(Audio, () => {
                self.label = repr.speaker.icon(Audio.speaker?.isMuted ?? true, Audio.speaker?.volume);
            }, "speaker-changed"),
        }),

        Widget.Label({
            setup: self => self.hook(Audio, () => {
                self.label = repr.speaker.volumePercent(Audio.speaker?.volume ?? 0);
            }, "speaker-changed"),
        }),
    ]
});

const BatteryModule = () => Widget.Box({
    className: "module",
    children: [
        Widget.EventBox({
            onHover: () => showBatteryTime.value = true,
            onHoverLost: () => showBatteryTime.value = false,
            child: Widget.Box({
                children: [
                    Widget.Label({
                        className: "label-icon",
                        setup: self => self.hook(Battery, self => {
                            self.label = repr.battery.icon(Battery.charging || Battery.charged, Battery.percent);
                        }),
                    }),
                    Widget.Stack({
                        hhomogeneous: false,
                        transition: "crossfade",
                        interpolateSize: true,
                        transitionDuration: 500,
                        items: [
                            ["percent", Widget.Label({
                                label: Battery.bind("percent").transform(p => repr.battery.percent(p))
                            })],
                            ["time", Widget.Label({
                                label: Battery.bind("timeRemaining").transform(seconds => repr.battery.timeRemaining(seconds))
                            })],
                        ],
                        shown: showBatteryTime.bind().transform(v => v ? "time" : "percent"),
                    })
                ]
            }),
        })
    ]
});

const IconOnlyModule = () => Widget.Box({
    className: "module icon-only",
    children: [
        Widget.Label({
            className: "label-icon",
            label: Brightness.bind("percent").transform(p => repr.brightness.icon(p)),
        }),
        Widget.Label({
            className: "label-icon",
            setup: self => self
                .hook(Network, self => {
                    self.label = repr.network.icon(Network.wifi?.internet, Network.wifi?.strength);
                }),
        }),
        Widget.Label({
            className: "label-icon",
            setup: self => self
                .hook(Bluetooth, self => {
                    self.label = repr.bluetooth.icon(Bluetooth.enabled, Bluetooth.connectedDevices);
                }),
        }),
    ]
})

const ClockModule = () => Widget.Label({
    className: "module",
    setup: self => self
        .poll(1000, self => Utils.execAsync("date +%R").then(date => self.label = date)),
});

const Left = () => Widget.Box({
    children: [
        WorkspacesModule(),
        ActiveWindowModule(),
    ],
});

const Center = () => Widget.Box({
    children: [],
});

const Right = () => Widget.Box({
    hpack: "end",
    children: [
        MicrophoneModule(),
        SpeakerModule(),
        BatteryModule(),
        IconOnlyModule(),
        ClockModule(),
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