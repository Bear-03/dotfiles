import "./shared/services/system.js";
import "./shared/services/brightness.js";

import Bar from "./widgets/bar/init.js";
import ControlPanel from "./widgets/controlPanel/init.js";

const { exec } = ags.Utils;

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