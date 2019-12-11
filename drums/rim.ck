BPM tempo;

SndBuf clave => dac;

//

me.dir(-1) + "audio/rim.wav" => clave.read;
clave.samples() => clave.pos;
.5 => clave.gain;

//

[
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 1, 0,
    0, 0, 1, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0
] @=> int sequence[];

while(true) {
    for (0 => int step; step < sequence.cap(); step++) {
        if (sequence[step]) {
            0 => clave.pos;
        }

        (tempo.note * 2) / sequence.cap() => now;
    }
}