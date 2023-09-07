const { Service } = ags;
const { subprocess } = ags.Utils;

class SystemService extends Service {
    static {
        Service.register(this, {
            "cpu-usage": ["float"],
            "mem-usage": ["float"],
        });
    }

    _cpuUsage = 0.0;
    _memUsage = 0.0;

    constructor() {
        super();

        subprocess("top -b", (line) => {
            if (!line.startsWith("%Cpu")) {
                return;
            }

            const idle = parseFloat(line.match(/.*ni,\s?(.+)\sid/)[1]);
            this._cpuUsage = 100 - idle;

            this.emit("changed");
            this.emit("cpu-usage", this._cpuUsage)
        });

        subprocess("free -s 2", (line) => {
            if (!line.startsWith("Mem")) {
                // Vmstat header
                return;
            }

            const cols = line.trim().split(/\s+/);

            const totalMem = parseInt(cols[1]);
            const usedMem = parseInt(cols[2]);

            this._memUsage = (usedMem / totalMem) * 100;

            this.emit("changed");
            this.emit("mem-usage", this._memUsage)
        });
    }

    get cpuUsage() {
        return this._cpuUsage;
    }
}

export default class System {
    static _instance;

    static get instance() {
        Service.ensureInstance(System, SystemService);
        return System._instance;
    }

    static get cpuUsage() {
        return System.instance.cpuUsage;
    }
}