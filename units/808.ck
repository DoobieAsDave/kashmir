BPM tempo;

Gain master;
SinOsc voice1 => LPF filter => master;
SinOsc voice2 => master;
master => ADSR adsr => Dyno dynamics => dac;

Envelope envelope => blackhole;

//

50 => Std.mtof => filter.freq;
2.0 => filter.Q;

1 => voice1.gain;
.025 => voice2.gain;
(1.0 / 2.0) => master.gain;

(5 :: ms, 15 :: ms, 1, tempo.quarterNote) => adsr.set;

dynamics.compress();
.75 => dynamics.thresh;

20 :: ms => envelope.duration;

//

37 => int key;
[key + 1, key - 12, key + 3, key - 14] @=> int sequence[];

//

while(true) {
    for (0 => int step; step < sequence.cap(); step++) {
        sequence[step] + 12 => Std.mtof => filter.freq;        

        sequence[step] => Std.mtof => voice1.freq;
        sequence[step] + 12 => Std.mtof => voice2.freq;

        if (step % 2 == 1) tempo.quarterNote => now;        

        1 => adsr.keyOn;
        swipeSinFreq(Std.mtof(sequence[step] + 7), Std.mtof(sequence[step]));        
        ((tempo.note * .75) - envelope.duration()) - adsr.releaseTime() => now;

        1 => adsr.keyOff;
        adsr.releaseTime() => now;

        if (step % 2 == 1) tempo.note - (tempo.quarterNote + (tempo.note * .75)) => now;
        else tempo.note - (tempo.note * .75) => now;
    }
}

function void swipeSinFreq(float startFreq, float endFreq) {
    startFreq => envelope.value;
    endFreq => envelope.target;
    
    now + envelope.duration() => time swipeEnd;

    while(now < swipeEnd) {
        envelope.value() => voice1.freq;
        samp => now;        
    }
}