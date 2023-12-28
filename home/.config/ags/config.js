import { App, Utils } from "./imports.js"
import Brightness from "./shared/services/brightness.js";

import Bar from "./widgets/bar/init.js";
import ControlPanel from "./widgets/controlPanel/init.js";

globalThis.Brightness = Brightness;

const scss = App.configDir + "/style.scss";
const css = App.configDir + "/style.css";

const scssResult = Utils.exec(`bash -c "sassc ${scss} ${css} 2>&1"`).trim();
if (scssResult) {
    console.warn("\n" + scssResult);
}

export const WindowNames = Object.freeze({
    BAR: "bar",
    CONTROL_PANEL: "control-panel",
});

export default {
    style: css,
    windows: [
        Bar(),
        ControlPanel(),
    ]
};