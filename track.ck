.8 => float volume;
.0 => float silent;

.01 => float increment;
volume / increment => float steps;

//

BPM tempo;
tempo.setBPM(125.0);

silent => dac.gain;

//

//Machine.add(me.dir() + "record.ck");

int kickId, hihatId, sizzleId, openhatId, clapId, rimId, bassId, sampleId;

//spork ~ modVolume(1, tempo.note * 4);
.8 => dac.gain;

Machine.add(me.dir() + "units/sample.ck") => sampleId;
tempo.note * 8 => now;

Machine.add(me.dir() + "drums/hihat.ck") => hihatId;
tempo.note * 4 => now;

Machine.add(me.dir() + "drums/clap.ck") => clapId;
Machine.add(me.dir() + "drums/rim.ck") => rimId;
tempo.note * 4 => now;

Machine.add(me.dir() + "units/808.ck") => bassId;
tempo.note * 8 => now;

Machine.add(me.dir() + "drums/sizzle.ck") => sizzleId;
tempo.note * 8 => now;                                          // 32 bars

Machine.add(me.dir() + "drums/openhat.ck") => openhatId;
tempo.note * 16 => now;

spork ~ modVolume(0, tempo.note * 4);
tempo.note * 4 => now;                                          // 52 bars

Machine.remove(hihatId);
Machine.remove(sizzleId);
Machine.remove(openhatId);
Machine.remove(clapId);
Machine.remove(rimId);
Machine.remove(sampleId);
Machine.remove(bassId);
Machine.status();

//

function void modVolume(int mode, dur modTime) {
    // rise volume
    if (mode) {
        while((dac.gain() + increment) < volume) {
            dac.gain() + increment => dac.gain;
            modTime / steps => now;
        }
    }
    // lower volume
    else {
        while((dac.gain() - increment) > silent) {
            dac.gain() - increment => dac.gain;
            modTime / steps => now;            
        }
    }
}
