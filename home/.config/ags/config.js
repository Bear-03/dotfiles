import Brightness from "./shared/services/brightness.js";
import Bar from "./widgets/bar/init.js";
import ControlPanel from "./widgets/controlPanel/init.js";

const { Service } = ags;
const { exec } = ags.Utils;

// Make services available globally so they can be used in `ags run-js`
Service["Brightness"] = Brightness;

const scss = ags.App.configDir + "/style.scss";
const css = ags.App.configDir + "/style.css";

const scssResult = exec(`bash -c "sassc ${scss} ${css} 2>&1"`).trim();
if (scssResult) {
    console.warn("\n" + scssResult);
}

export default {
    style: css,
    windows: [
        Bar(),
        ControlPanel(),
    ],
};