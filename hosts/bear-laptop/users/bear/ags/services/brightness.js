import { clamp } from "../shared/util.js";
import { Service, Utils } from "../imports.js";

const STEP = 10;

class Brightness extends Service {
    static {
        Service.register(
            this,
            {},
            {
                "percent": ["float", "rw"],
            }
        );
    }

    #percent = 0;

    constructor() {
        super();

        this.#percent = parseInt(Utils.exec("brightnessctl -m i").split(",")[3].slice(0, -1));
    }

    get percent() {
        return this.#percent;
    }

    set percent(value) {
        value = clamp(value, 1, 100);

        Utils.execAsync(`brightnessctl -q s ${value}%`)
            .then(() => {
                this.#percent = value;
                this.changed("percent");
            });
    }

    increase() {
        if (this.percent < STEP) {
            this.percent += 1;
        } else {
            this.percent += STEP;
        }
    }

    decrease() {
        if (this.percent > STEP) {
            this.percent -= STEP;
        } else {
            this.percent -= 1;
        }
    }
}

export default new Brightness()