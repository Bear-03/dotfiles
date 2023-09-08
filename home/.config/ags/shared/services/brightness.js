import { clamp } from "../utils.js";

const { Service } = ags;
const { execAsync, exec } = ags.Utils;

class BrightnessService extends Service {
    static { Service.register(this); }
    static STEP = 10;

    _percent = 0;

    constructor() {
        super();

        this._percent = parseInt(exec("brightnessctl -m i").split(",")[3].slice(0, -1));
    }

    get percent() {
        return this._percent;
    }

    set percent(value) {
        value = clamp(value, 1, 100);

        execAsync(`brightnessctl -q s ${value}%`)
            .then(() => {
                this._percent = value;
                this.emit("changed");
            });
    }

    increase() {
        if (this.percent < BrightnessService.STEP) {
            this.percent += 1;
        } else {
            this.percent += BrightnessService.STEP;
        }
    }

    decrease() {
        if (this.percent > BrightnessService.STEP) {
            this.percent -= BrightnessService.STEP;
        } else {
            this.percent -= 1;
        }
    }
}

export default class Brightness {
    static _instance;

    static get instance() {
        Service.ensureInstance(Brightness, BrightnessService);
        return Brightness._instance;
    }

    static get percent() { return Brightness.instance.percent; }
    static set percent(value) { Brightness.instance.percent = value; }
    static increase() { Brightness.instance.increase() }
    static decrease() { Brightness.instance.decrease() }
}