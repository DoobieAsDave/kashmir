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
    1, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0
] @=> int sequence[];

while(true) {
    for (0 => int step; step < sequence.cap(); step++) {
        if (sequence[step]) {
            0 => kick.pos;
        }
        

        tempo.note / sequence.cap() => now;
    } 
}
