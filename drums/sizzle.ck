.175 => float volume;
.0 => float silent;

.01 => float increment;
volume / increment => float steps;

//

BPM tempo;

SndBuf sizzle => Pan2 stereo => dac;

//

me.dir(-1) + "audio/sizzle.wav" => sizzle.read;
sizzle.samples() => sizzle.pos;
.175 => sizzle.gain;
2 => sizzle.interp;

//

function void modSizzleVolume(int mode, dur modTime) {
    if (mode) {
        while((sizzle.gain() + increment) < volume) {
            sizzle.gain() + increment => sizzle.gain;
            modTime / steps => now;
        }
    }
    else {
        while((sizzle.gain() - increment) > silent) {
            sizzle.gain() - increment => sizzle.gain;
            modTime / steps => now;
        }
    }    
}

//

Shred sizzleVolumeShred;

while(true) {
    spork ~ modSizzleVolume(1, tempo.eighthNote * 4) @=> sizzleVolumeShred;

    repeat(4) {
        0 => stereo.pan;
        0 => sizzle.pos;
        tempo.eighthNote => now;
    }

    spork ~ modSizzleVolume(0, tempo.eighthNote * 4) @=> sizzleVolumeShred;
    Math.random2(1, 2) => int rep;
    repeat(rep) {
        sizzle.rate() -.075 => sizzle.rate;
        Math.random2(0, (sizzle.samples() * .1) => Std.ftoi) => sizzle.pos;
        tempo.eighthNote / rep => now;
    }
    repeat(3) {
        1 => sizzle.rate;
        Math.random2f(-.3, .3) => stereo.pan;
        0 => sizzle.pos;
        tempo.eighthNote => now;
    }
}