import Brightness from "./shared/services/brightness.js";
import { windows } from "./windows.js";

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
    windows,
};