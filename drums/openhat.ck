BPM tempo;

SndBuf openhat => Pan2 stereo => dac;

//

me.dir(-1) + "audio/openhat.wav" => openhat.read;
openhat.samples() => openhat.pos;
.025 => openhat.gain;

//

while(true) {
    tempo.quarterNote => now;
    
    Math.random2f(-.1, .1) => stereo.pan;
    Math.random2(0, Std.ftoi(openhat.samples() * (10 / 100))) => openhat.pos;
    
    tempo.quarterNote => now;
}