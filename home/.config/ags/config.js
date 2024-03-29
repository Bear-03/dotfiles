import { setupGlobals } from "./globals.js";
import { App, Utils } from "./imports.js"

import Bar from "./widgets/bar/init.js";

setupGlobals();

const scss = App.configDir + "/style.scss";
const css = App.configDir + "/style.css";

const scssResult = Utils.exec(`bash -c "sassc ${scss} ${css} 2>&1"`).trim();
if (scssResult) {
    console.warn("\n" + scssResult);
}

export default {
    style: css,
    windows: [
        Bar(),
    ]
};