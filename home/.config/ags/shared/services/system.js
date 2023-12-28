import { Service, Utils } from "../../imports.js";

class System extends Service {
    static {
        Service.register(
            this,
            {
                "cpu-changed": ["float"],
                "mem-changed": ["float"],
            },
            {},
        );
    }

    #cpuUsage = 0.0;
    #memUsage = 0.0;

    constructor() {
        super();

        Utils.subprocess("top -b", (line) => {
            if (!line.startsWith("%Cpu")) {
                return;
            }

            const idle = parseFloat(line.match(/.*ni,\s?(.+)\sid/)[1]);
            this.#cpuUsage = 100 - idle;

            this.emit("changed");
            this.emit("cpu-changed", this.#cpuUsage)
        });

        Utils.subprocess("free -s 2", (line) => {
            if (!line.startsWith("Mem")) {
                // Vmstat header
                return;
            }

            const cols = line.trim().split(/\s+/);

            const totalMem = parseInt(cols[1]);
            const usedMem = parseInt(cols[2]);

            this.#memUsage = (usedMem / totalMem) * 100;

            this.emit("changed");
            this.emit("mem-changed", this.#memUsage)
        });
    }

    get cpuUsage() {
        return this.#cpuUsage;
    }

    get memUsage() {
        return this.#memUsage;
    }
}

export default new System();