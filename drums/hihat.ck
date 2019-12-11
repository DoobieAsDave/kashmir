BPM tempo;

SndBuf hihat => dac;

//

.4 => float maxGain;

//

me.dir(-1) + "audio/hihat.wav" => hihat.read;
hihat.samples() => hihat.pos;
.85 => hihat.rate;
2 => hihat.interp;

//

[
    1, 0, 1, 0,
    1, 2, 1, 0,
    1, 0, 1, 0,
    1, 0, 1, 2
] @=> int sequence[];

while(true) {
    for (0 => int step; step < sequence.cap(); step++) {
        if (sequence[step]) {
            if (step % 4 == 0) maxGain => hihat.gain;
            else if (step == 2) maxGain / 3 => hihat.gain;
            else maxGain * .5 => hihat.gain;
            
            0 => hihat.pos;
        }

        tempo.note / sequence.cap() => now;
    }
}
