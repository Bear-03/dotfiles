import Bar from "./widgets/bar/init.js";
import ControlPanel from "./widgets/controlPanel/init.js";

export const WindowNames = Object.freeze({
    BAR: "bar",
    CONTROL_PANEL: "control-panel",
});

export const windows = [
    Bar(),
    ControlPanel(),
];