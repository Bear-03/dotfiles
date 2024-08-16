import { Hyprland, Audio, Battery, Network, Bluetooth, Utils, Widget, SystemTray, Variable } from "../../imports.js";
import Brightness from "../../services/brightness.js";
import repr from "../../shared/repr.js";
import { cpu, mem, showBatteryTime, showMiscDetails, showSystemDetails } from "../../shared/variables.js";
import consts from "../../shared/consts.js";
import { muteAudioStream, capitalize } from "../../shared/util.js";

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

const ACTIVE_WINDOW_TRUNCATE = 60;
const ActiveWindowLabel = () => Widget.Label({
    truncate: "end",
    max_width_chars: ACTIVE_WINDOW_TRUNCATE,
    setup: self => self.hook(self, () => {
        self.tooltipText = self.label.length >= ACTIVE_WINDOW_TRUNCATE ? self.label : "";
    }, "notify::label"),
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
                        children: {
                            first: ActiveWindowLabel(),
                            second: ActiveWindowLabel(),
                        },
                        setup: self => self.hook(Hyprland.active.client, () => {
                            const notShownName = Object.keys(self.children).filter(c => c != self.shown)[0];
                            self.children[notShownName].label = Hyprland.active.client.title;
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
    onClicked: () => muteAudioStream("microphone"),
    child: Widget.Box({
        spacing: consts.MARGINS[2],
        children: [
            Widget.Label({
                setup: self => self.hook(Audio, () => {
                    self.label = repr.microphone.icon(Audio.microphone?.stream?.isMuted ?? true)
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
    onClicked: () => muteAudioStream("speaker"),
    child: Widget.Box({
        spacing: consts.MARGINS[2],
        children: [
            Widget.Label({
                setup: self => self.hook(Audio, () => {
                    self.label = repr.speaker.icon(Audio.speaker?.stream?.isMuted ?? true, Audio.speaker?.volume);
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
                        setup: self => self.hook(Battery, self => {
                            self.label = repr.battery.icon(Battery.charging || Battery.charged, Battery.percent);
                        }),
                    }),
                    Widget.Stack({
                        hhomogeneous: false,
                        transition: "crossfade",
                        interpolateSize: true,
                        transitionDuration: consts.TRANSITION_DURATIONS[0],
                        children: {
                            percent: Widget.Label({
                                className: "percent",
                                label: Battery.bind("percent").transform(p => repr.battery.percent(p))
                            }),
                            time: Widget.Label({
                                label: Battery.bind("timeRemaining").transform(seconds => repr.battery.timeRemaining(seconds))
                            }),
                        },
                        shown: showBatteryTime.bind().transform(v => v ? "time" : "percent"),
                    })
                ]
            }),
        })
    ]
});

const IconWithDetails = ({ revealDetails, icon, details }) => Widget.Box({
    children: [
        icon,
        Widget.Revealer({
            revealChild: revealDetails,
            transition: "slide_left",
            transitionDuration: consts.TRANSITION_DURATIONS[0],
            child: details,
        }),
    ]
})

// TODO: Make wifi and bluetooth not reveal if not connected to anything
// TODO: Add tooltip to wifi and bluetooth
const MiscModule = () => Widget.Box({
    className: "module misc",
    children: [
        Widget.EventBox({
            onHover: () => showMiscDetails.value = true,
            onHoverLost: () => showMiscDetails.value = false,
            child: Widget.Box({
                spacing: consts.MARGINS[1],
                children: [
                    IconWithDetails({
                        revealDetails: showMiscDetails.bind(),
                        icon: Widget.Label({
                            label: Brightness.bind("percent").transform(p => repr.brightness.icon(p)),
                        }),
                        details: Widget.Label({
                            className: "icon-details",
                            label: Brightness.bind("percent").transform(p => repr.brightness.percent(p)),
                        })
                    }),
                    IconWithDetails({
                        revealDetails: showMiscDetails.bind(),
                        icon: Widget.Label({
                            setup: self => self
                                .hook(Network, self => {
                                    self.label = repr.network.icon(Network.wifi?.internet, Network.wifi?.strength);
                                }),
                        }),
                        details: Widget.Label({
                            className: "icon-details",
                            truncate: "end",
                            max_width_chars: 10,
                            label: Network.wifi.bind("ssid"),
                        })
                    }),
                    IconWithDetails({
                        revealDetails: showMiscDetails.bind(),
                        icon: Widget.Label({
                            setup: self => self.hook(Bluetooth, self => {
                                self.label = repr.bluetooth.icon(Bluetooth.enabled, Bluetooth.connectedDevices);
                            }),
                        }),
                        details: Widget.Label({
                            className: "icon-details",
                            truncate: "end",
                            max_width_chars: 10,
                            label: Bluetooth.bind("connectedDevices").transform(d => d[0]?.name ?? ""),
                        }),
                    }),
                ]
            })
        })
    ]
})

const UsageIcon = ({ usage, icon }) => Widget.Overlay({
    child: Widget.CircularProgress({
        className: "circular-progress",
        value: usage,
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

const SystemModule = () => Widget.Box({
    className: "module system",
    children: [
        Widget.EventBox({
            onHover: () => showSystemDetails.value = true,
            onHoverLost: () => showSystemDetails.value = false,
            child: Widget.Box({
                spacing: consts.MARGINS[1],
                children: [
                    IconWithDetails({
                        revealDetails: showSystemDetails.bind(),
                        icon: UsageIcon({
                            usage: cpu.bind(),
                            icon: repr.cpu.icon,
                        }),
                        details: Widget.Label({
                            className: "icon-details",
                            label: cpu.bind().transform(usage => repr.cpu.usagePercent(usage))
                        })
                    }),
                    IconWithDetails({
                        revealDetails: showSystemDetails.bind(),
                        icon: UsageIcon({
                            usage: mem.bind(),
                            icon: repr.mem.icon,
                        }),
                        details: Widget.Label({
                            className: "icon-details",
                            label: mem.bind().transform(usage => repr.cpu.usagePercent(usage))
                        })
                    }),
                ]
            })
        })
    ]
});

const activeTrayItems = Variable(0);

const SysTrayItem = (item) => Widget.Revealer({
    transition: "slide_left",
    transitionDuration: consts.TRANSITION_DURATIONS[0],
    child: Widget.Button({
        onPrimaryClick: (_, event) => item.activate(event),
        onSecondaryClick: (_, event) => item.openMenu(event),
        child: Widget.Icon({
            icon: item.bind("icon"),
        }),
    }),
    setup: (self) => self.hook(item, () => {
        self.child.tooltipMarkup = item.tooltipMarkup || (item.title ? capitalize(item.title) : "");

        // Hook is called twice on changes, so everything has to be recomputed
        activeTrayItems.setValue(SystemTray.items.filter(item => item.status != "Passive").length);

        if (item.status == "Passive") {
            self.revealChild = false;
            self.className = "";
        } else if (item.status) {
            self.revealChild = true;
            self.className = "shown";
        }
    }),
});

const SysTrayModule = () => Widget.Revealer({
    revealChild: activeTrayItems.bind().as(value => value != 0),
    transition: "slide_left",
    transitionDuration: consts.TRANSITION_DURATIONS[0],
    child: Widget.Box({
        className: "module tray",
        children: SystemTray.bind("items").transform(items => items.map(SysTrayItem)),
    }),
});

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
        MiscModule(),
        SystemModule(),
        SysTrayModule(),
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