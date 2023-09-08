import { WindowNames } from "../../windows.js";

const { Service, App } = ags;
const { timeout } = ags.Utils;

const State = Object.freeze({
    CLOSING: "closing",
    CLOSED: "closed",
    OPEN: "open",
})

class ControlPanelService extends Service {
    static {
        Service.register(this, {
            "open": [],
            "closing": [],
            "close": [],
        });
    }
    static CLOSE_DELAY = 500;

    // TODO: Fix panel not disappearing if it is never hovered for a first time
    _state = State.CLOSED;

    open() {
        this._state = State.OPEN;
        App.openWindow(WindowNames.CONTROL_PANEL);
        this.emit("open");
        this.emit("changed");
    }

    close(delay = ControlPanelService.CLOSE_DELAY) {
        this._state = State.CLOSING;
        this.emit("closing");
        this.emit("changed");

        timeout(delay, () => {
            if (this._state != State.CLOSING) {
                return;
            }

            this._state = State.CLOSED;
            App.closeWindow(WindowNames.CONTROL_PANEL);
            this.emit("close");
            this.emit("changed");
        });
    }

    toggle() {
        if (this._state == State.OPEN) {
            this.close(0);
        } else {
            this.open();
        }
    }
}

export default class ControlPanel {
    static _instance;

    static get instance() {
        Service.ensureInstance(ControlPanel, ControlPanelService);
        return ControlPanel._instance;
    }

    static open(...params) { ControlPanel.instance.open(...params) }
    static close(...params) { ControlPanel.instance.close(...params) }
    static toggle(...params) { ControlPanel.instance.toggle(...params) }
}