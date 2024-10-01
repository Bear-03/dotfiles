import Gdk from "gi://Gdk"
import { Audio, Utils } from "./imports.js";
import Brightness from "./services/brightness.js";
import { muteAudioStream } from "./shared/util.js";

const VOLUME_STEP = 0.05;

export function globals() {
    globalThis.Brightness = Brightness;

    globalThis.increaseSpeakerVolume = () => Audio.speaker.volume += VOLUME_STEP;
    globalThis.decreaseSpeakerVolume = () => Audio.speaker.volume -= VOLUME_STEP;
    globalThis.muteSpeaker = () => muteAudioStream("speaker");
    globalThis.muteMicrophone = () => muteAudioStream("microphone");
}

export function scss() {
    const scss = App.configDir + "/style.scss";
    const css = "/tmp/ags-style.css";

    const scssResult = Utils.exec(`bash -c "sassc ${scss} ${css} 2>&1"`).trim();
    if (scssResult) {
        console.warn("\n" + scssResult);
    }

    return css;
}

export function monitorRefresh(allMonitorWindows) {
    const display = Gdk.Display.get_default();

    display.connect("monitor-added", (_disp, gdkmonitor) => {
        for (const window of allMonitorWindows) {
            App.addWindow(window(gdkmonitor));
        }
    });

    display.connect("monitor-removed", (_disp, gdkmonitor) => {
        App.windows.forEach((window) => {
            if (window.gdkmonitor === gdkmonitor) {
                App.removeWindow(window);
            }
        });
    });
}