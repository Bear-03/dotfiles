import { Variable } from "../imports.js";

export const oldActiveWindowTitle = Variable("");
export const controlPanelVisible = Variable(false);
export const showBatteryTime = Variable(false);
export const showSystemDetails = Variable(false);
export const cpu = Variable(0, {
    listen: [["top", "-b"], line => {
        if (!line.startsWith("%Cpu")) {
            return cpu.value;
        }

        const idle = parseFloat(line.match(/.*ni,\s?(.+)\sid/)[1]);
        return 1 - (idle / 100);
    }],
});
export const mem = Variable(0, {
    listen: [["free", "-s", "2"], line => {
        if (!line.startsWith("Mem")) {
            // Vmstat header or swap
            // don't update the value
            return mem.value;
        }

        const cols = line.trim().split(/\s+/);

        const totalMem = parseInt(cols[1]);
        const usedMem = parseInt(cols[2]);

        return (usedMem / totalMem);
    }],
})