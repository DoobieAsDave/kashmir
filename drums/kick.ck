BPM tempo;

SndBuf kick => dac;

//

me.dir(-1) + "audio/kick.wav" => kick.read;
kick.samples() => kick.pos;
.75 => kick.gain;
1.25 => kick.rate;
2 => kick.interp;

//

[
    1, 1, 0, 0,
    0, 0, 0, 0,
    0, 0, 2, 0,
    0, 1, 0, 0
] @=> int sequence[];

while(true) {
    for (0 => int beat; beat < 2; beat++) {
        for (0 => int step; step < sequence.cap(); step++) {
            if (sequence[step] == 1) {
                0 => kick.pos;
            }
            else if (beat == 0 && sequence[step] == 2) {
                0 => kick.pos;
            }

            (tempo.note * 2) / sequence.cap() => now;
        }
    }    
}
