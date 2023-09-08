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
            "close": [],
        });
    }
    static CLOSE_DELAY = 500;

    _state = State.CLOSED;

    open() {
        this._state = State.OPEN;
        App.openWindow(WindowNames.CONTROL_PANEL);
        this.emit("open");
    }

    close() {
        this._state = State.CLOSING;

        timeout(ControlPanelService.CLOSE_DELAY, () => {
            if (this._state != State.CLOSING) {
                return;
            }

            this._state = State.CLOSED;
            App.closeWindow(WindowNames.CONTROL_PANEL);
            this.emit("close");
        });
    }
}

export default class ControlPanel {
    static _instance;

    static get instance() {
        Service.ensureInstance(ControlPanel, ControlPanelService);
        return ControlPanel._instance;
    }

    static open() { ControlPanel.instance.open() }
    static close() { ControlPanel.instance.close() }
}