import { stringEllipsis } from "../../shared/utils.js";

import { Hyprland, Audio, Battery, Network, Bluetooth, Utils, Widget } from "../../imports.js";
import repr from "../../shared/repr.js";
import { cpu, mem, showBatteryTime, showSystemDetails } from "../../shared/variables.js";
import consts from "../../shared/consts.js";

const WorkspacesModule = (length = 5) => Widget.Box({
    className: "module workspaces",
    children: [
        ...Array.from({ length }, (_, i) => i + 1).map(i => Widget.Button({
            className: "known",
            onClicked: () => Hyprland.sendMessage(`dispatch workspace ${i}`),
            child: Widget.Label({
                label: Hyprland.active.workspace.bind("id").transform(id => repr.workspace.icon(i, id)),
            })
        })),
        Widget.Revealer({
            revealChild: Hyprland.active.workspace.bind("id").transform(id => id > length),
            transition: "slide_right",
            transitionDuration: consts.TRANSITION_DURATIONS[1],
            child: Widget.Label({
                className: "unknown",
                label: Hyprland.active.workspace.bind("id").transform(id => id.toString()),
            }),
        })
    ]
});

const ActiveWindowModule = () => Widget.Box({
    children: [
        Widget.Revealer({
            revealChild: Hyprland.active.client.bind("title").transform(title => Boolean(title)),
            transition: "crossfade",
            transitionDuration: consts.TRANSITION_DURATIONS[0],
            child: Widget.Box({
                className: "module",
                children: [
                    Widget.Stack({
                        hhomogeneous: false,
                        interpolateSize: true,
                        transition: "crossfade",
                        transitionDuration: consts.TRANSITION_DURATIONS[0],
                        items: [
                            ["first", Widget.Label()],
                            ["second", Widget.Label()],
                        ],
                        setup: self => self.hook(Hyprland.active.client, () => {
                            const notShownIndex = self.items.findIndex((x) => x[0] != self.shown);
                            const [notShownName, notShown] = self.items[notShownIndex];

                            notShown.label = stringEllipsis(Hyprland.active.client.title, 60);
                            self.shown = notShownName;
                        })
                    })
                ]
            })
        })
    ]
});

const MicrophoneModule = () => Widget.Button({
    className: "module",
    onClicked: () => Audio.microphone.isMuted = !Audio.microphone.isMuted,
    child: Widget.Box({
        spacing: consts.MARGINS[2],
        children: [
            Widget.Label({
                className: "label-icon",
                setup: self => self.hook(Audio, () => {
                    self.label = repr.microphone.icon(Audio.microphone?.isMuted ?? true)
                }, "microphone-changed"),
            }),
            Widget.Label({
                className: "percent",
                setup: self => self.hook(Audio, () => {
                    self.label = repr.microphone.volumePercent(Audio.microphone?.volume ?? 0)
                }, "microphone-changed"),
            }),
        ]
    })
});

const SpeakerModule = () => Widget.Button({
    className: "module",
    onClicked: () => Audio.speaker.isMuted = !Audio.speaker.isMuted,
    child: Widget.Box({
        spacing: consts.MARGINS[2],
        children: [
            Widget.Label({
                className: "label-icon",
                setup: self => self.hook(Audio, () => {
                    self.label = repr.speaker.icon(Audio.speaker?.isMuted ?? true, Audio.speaker?.volume);
                }, "speaker-changed"),
            }),
            Widget.Label({
                className: "percent",
                setup: self => self.hook(Audio, () => {
                    self.label = repr.speaker.volumePercent(Audio.speaker?.volume ?? 0);
                }, "speaker-changed"),
            }),
        ]
    })
});

const BatteryModule = () => Widget.Box({
    className: "module",
    children: [
        Widget.EventBox({
            onHover: () => showBatteryTime.value = true,
            onHoverLost: () => showBatteryTime.value = false,
            child: Widget.Box({
                spacing: consts.MARGINS[2],
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
                        transitionDuration: consts.TRANSITION_DURATIONS[0],
                        items: [
                            ["percent", Widget.Label({
                                className: "percent",
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
    className: "module",
    spacing: consts.MARGINS[0],
    children: [
        Widget.Label({
            label: Brightness.bind("percent").transform(p => repr.brightness.icon(p)),
        }),
        Widget.Label({
            setup: self => self
                .hook(Network, self => {
                    self.label = repr.network.icon(Network.wifi?.internet, Network.wifi?.strength);
                }),
        }),
        Widget.Label({
            setup: self => self
                .hook(Bluetooth, self => {
                    self.label = repr.bluetooth.icon(Bluetooth.enabled, Bluetooth.connectedDevices);
                }),
        }),
    ]
})

const UsageIcon = ({ usage, icon }) => Widget.Overlay({
    child: Widget.CircularProgress({
        className: "circular-progress",
        value: usage.bind(),
        rounded: true,
        startAt: 0.75,
    }),
    overlays: [
        Widget.Label({
            className: "icon",
            label: icon,
        })
    ]
})

const UsageDetails = ({ label }) => Widget.Revealer({
    revealChild: showSystemDetails.bind(),
    transition: "slide_right",
    transitionDuration: consts.TRANSITION_DURATIONS[0],
    child: Widget.Label({
        className: "percent",
        label,
    })
});

const SystemModule = () => Widget.Box({
    className: "module system",
    children: [
        Widget.EventBox({
            onHover: () => showSystemDetails.value = true,
            onHoverLost: () => showSystemDetails.value = false,
            child: Widget.Box({
                spacing: consts.MARGINS[1],
                children: [
                    Widget.Box({
                        children: [
                            UsageIcon({
                                usage: cpu,
                                icon: repr.cpu.icon
                            }),
                            UsageDetails({
                                label: cpu.bind().transform(usage => repr.cpu.usagePercent(usage))
                            }),
                        ]
                    }),
                    Widget.Box({
                        children: [
                            UsageIcon({
                                usage: mem,
                                icon: repr.mem.icon
                            }),
                            UsageDetails({
                                label: mem.bind().transform(usage => repr.mem.usagePercent(usage))
                            }),
                        ]
                    }),
                ]
            })
        })
    ]
})

const ClockModule = () => Widget.Label({
    className: "module",
    setup: self => self
        .poll(1000, self => Utils.execAsync("date +%R").then(date => self.label = date)),
});

const Left = () => Widget.Box({
    spacing: consts.MARGINS[2],
    children: [
        WorkspacesModule(),
        ActiveWindowModule(),
    ],
});

const Center = () => Widget.Box({
    spacing: consts.MARGINS[2],
    children: [],
});

const Right = () => Widget.Box({
    spacing: consts.MARGINS[2],
    hpack: "end",
    children: [
        MicrophoneModule(),
        SpeakerModule(),
        BatteryModule(),
        IconOnlyModule(),
        SystemModule(),
        ClockModule(),
    ],
});

export default () => Widget.Window({
    name: "bar",
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
        className: "bar",
        startWidget: Left(),
        centerWidget: Center(),
        endWidget: Right(),
    }),
})