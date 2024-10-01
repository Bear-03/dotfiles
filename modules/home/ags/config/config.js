import * as setup from "./setup.js";
import { App } from "./imports.js"

import Bar from "./widgets/bar/init.js";
import { onAllMonitors } from "./shared/util.js";

const ALL_MONITOR_WINDOWS = [Bar];

setup.globals();
setup.monitorRefresh(ALL_MONITOR_WINDOWS);
const css = setup.scss();

App.config({
    style: css,
    windows: [
        ...onAllMonitors(ALL_MONITOR_WINDOWS),
    ]
});