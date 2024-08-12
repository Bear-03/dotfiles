import { Audio, Network } from "./imports.js";
import Brightness from "./services/brightness.js";
import { muteAudioStream } from "./shared/util.js";

const VOLUME_STEP = 0.05;

export function setupGlobals() {
    globalThis.Brightness = Brightness;
    globalThis.Audio = Audio;
    globalThis.Network = Network;
    globalThis.increaseSpeakerVolume = () => Audio.speaker.volume += VOLUME_STEP;
    globalThis.decreaseSpeakerVolume = () => Audio.speaker.volume -= VOLUME_STEP;
    globalThis.muteSpeaker = () => muteAudioStream("speaker");
    globalThis.muteMicrophone = () => muteAudioStream("microphone");
}