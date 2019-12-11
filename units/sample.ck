BPM tempo;

SndBuf sample => ADSR adsr => LPF filter => dac;
filter => Delay rev1 => dac;
filter => Delay rev2 => dac.left;
filter => Delay rev3 => Pan2 stereo => dac;
rev1 => rev1;
rev2 => rev2;
rev3 => rev3;

//

loadSample("audio/sample_a.wav");
sample.samples() => sample.pos;
.5 => sample.gain;
2 => sample.interp;

(tempo.quarterNote, tempo.eighthNote, sample.gain(), tempo.halfNote) => adsr.set;

2.0 => filter.Q;

tempo.note * 2 => rev1.max => rev2.max => rev3.max;
.3 => rev1.gain;
.1 => rev2.gain;
.15 => rev3.gain;

//

float filterFreq;
float stereoPan;

function void modFilterFreq(FilterBasic filter, dur modTime, float min, float max, float amount) {
    amount => float step;
    max - min => float range;
    (range / amount) * 2 => float steps;

    min => filterFreq;

    while(true) {
        filterFreq => filter.freq;

        if (filterFreq >= max) {
            amount * -1 => step;
        }
        else if (filterFreq <= min) {
            amount => step;
        }

        step +=> filterFreq;

        modTime / steps => now;
    }
}
function void modStereoPan(Pan2 stereo, dur modTime, float min, float max, float amount) {
    amount => float step;
    max - min => float range;
    (range / amount) * 2 => float steps;

    min => stereoPan;

    while(true) {
        stereoPan => stereo.pan;

        if (stereoPan >= max) {
            amount * -1 => step;
        }
        else if (stereoPan <= min) {
            amount => step;
        }

        step +=> stereoPan;

        modTime / steps => now;
    }
}

//

spork ~ modFilterFreq(filter, (tempo.note * 4) / 3, Std.mtof(75), Std.mtof(110), .5);
spork ~ modStereoPan(stereo, tempo.note * Math.random2f(.5, 1.5), -1, 1, .01);

while(true) {
    tempo.halfNote * Math.random2f(.5, 1.5) => rev1.delay;
    tempo.quarterNote * Math.random2f(.5, 2.0) => rev2.delay;
    tempo.note * Math.random2f(.5, 2.0) => rev2.delay;

    .85 => sample.rate;

    for (0 => int step; step < 4; step++) {
        tempo.quarterNote => now;    

        1 => adsr.keyOn;
        if (step != 3) {
            18000 => sample.pos;
        }
        else {
            sample.rate() * -1 => sample.rate;
            sample.samples() - 1 => sample.pos;
        }
        (tempo.note * 2 - tempo.quarterNote) - adsr.releaseTime() => now;

        1 => adsr.keyOff;
        adsr.releaseTime() => now;
    }
}

function void loadSample(string filename) {
    me.dir(-1) + filename => sample.read;
    sample.samples() => sample.pos;
}

function int getRandomPos(int start, int end) {
    Math.random2(
        Std.ftoi(sample.samples() * start / 100),
        Std.ftoi(sample.samples() * end / 100)
    ) => int randomPos;

    <<<randomPos>>>;
    return randomPos;
}