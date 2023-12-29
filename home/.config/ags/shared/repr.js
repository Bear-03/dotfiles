import { mappedGet } from "./utils.js";

export default {
    workspace: {
        active: "",
        inactive: "",
        icon: function (selfWorkspace, activeWorkspace) {
            return selfWorkspace === activeWorkspace ? this.active : this.inactive;
        }
    },
    microphone: {
        off: "󰍭",
        on: "󰍬",
        icon: function (isMuted) {
            return isMuted ? this.off : this.on;
        },
        details: (volume) => `${Math.ceil(volume * 100)}%`
    },
    speaker: {
        off: "󰝟",
        on: ["󰕿", "󰖀", "󰕾"],
        icon: function (isMuted, volume) {
            return isMuted ? this.off : mappedGet(this.on, volume, 0, 1, Math.ceil);
        },
        details: (volume) => `${Math.ceil(volume * 100)}%`,
    },
    network: {
        off: "󰤮",
        on: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"],
        icon: function (status, strength) {
            return status != "connected" ? this.off : mappedGet(this.on, strength, 0, 80);
        }
    },
    bluetooth: {
        off: "󰂲",
        on: "󰂯",
        connected: "󰂱",
        icon: function (enabled, connectedDevices) {
            if (!enabled) {
                return this.off;
            } else if (Array.from(connectedDevices).length === 0) {
                return this.on;
            } else {
                return this.connected;
            }
        }
    },
    brightness: {
        levels: ["󰛩", "󱩎", "󱩏", "󱩐", "󱩑", "󱩒", "󱩓", "󱩔", "󱩕", "󱩖", "󰛨"],
        icon: function (percent) {
            return mappedGet(this.levels, percent, 0, 100);
        },
        details: (percent) => `${Math.round(percent)}%`,
    },
    battery: {
        connected: ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
        disconnected: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
        icon: function (connected, percent) {
            return mappedGet(connected ? this.connected : this.disconnected, percent, 0, 100, Math.floor)
        },
        details: (percent) => `${Math.floor(percent)}%`,
    },
    cpu: {
        icon: "",
        details: (usage) => `${Math.round(usage)}%`,
    },
    mem: {
        icon: "",
        details: (usage) => `${Math.round(usage)}%`,
    }
}