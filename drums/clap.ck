BPM tempo;

SndBuf clap => dac;
clap => Delay delay => Pan2 stereo => dac;
delay => delay;

//

me.dir(-1) + "audio/clap.wav" => clap.read;
clap.samples() => clap.pos;
.75 => clap.gain;

.3 => delay.gain;
tempo.note => delay.max;

//

[
    0, 0, 0, 0,
    0, 0, 0, 0,
    1, 0, 0, 0,
    0, 0, 0, 0
] @=> int sequence[];

while(true) {
    for (0 => int step; step < sequence.cap(); step++) {
        if (sequence[step]) {
            Math.random2f(-.1, .1) => stereo.pan;
            //tempo.note * Math.random2f(.75, .8) => delay.delay;
            tempo.note * .75 => delay.delay;
            Math.random2f(.05, .1) => delay.gain;

            0 => clap.pos;
        }

        tempo.note / sequence.cap() => now;
    }
}