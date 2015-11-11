SynthDef(\form, {
	arg fundf=100, formf=10, bwf=800;
	Out.ar(0, Formant.ar(fundf, formf, bwf));
}).add;

z = SynthDefAutogui(\form);

SynthDef(\wonderfunk, {
	arg fundf=100, bwfModFreq=0.3, formfModFreq=0.1, vibfreq=2;
	var signal, bwfmod, formfmod, formfvib;
	bwfmod = LFTri.kr(bwfModFreq).range(100.0, 500.0);
	formfvib = SinOsc.kr(vibfreq, 0, 30);
	formfmod = LFTri.kr(formfModFreq, 0, 450, 550+formfvib );
	signal = Formant.ar(fundf, formfmod, bwfmod);
	Out.ar(0, signal);
}).add;

z = SynthDefAutogui(\wonderfunk);
z.free

//MIDI NOTE DICTIONARY
(
var md, na, oc;
~nd = ();
md = 0;
na = [\c, \cs, \d, \eb, \e, \f, \fs, \g, \gs, \a, \bb, \b];
oc = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
oc.do{ |it ix|
	na.do{ |it2 ix2|
		~nd.put((it2 ++ it).asSymbol, 12+md);
		md = md+1;
	}
};
)




//FINAL VERSION

(
SynthDef(\wonderfunk, {
	arg pitch=60, bwfModFreq=1, formfModFreq=0.3, vibfreq=4, t=0.4, a1=0.4, a2=0.8, amp=0.85, pan=0;
	var signal, bwfmod, formfmod, formfvib, signalshift, fundf;
	fundf = pitch.midicps;
	bwfmod = LFTri.kr(bwfModFreq).range(100.0, 500.0);
	formfvib = SinOsc.kr(vibfreq, 0, 30);
	formfmod = LFTri.kr(formfModFreq, 0, 450, 550+formfvib );
	signal = Formant.ar(fundf, formfmod, bwfmod);
	signalshift = PitchShift.ar(signal, pitchRatio:t);
	signal = Mix.ar( [signal*a1, signalshift*a2] );
	signal = Pan2.ar(signal, pan);
	Out.ar(0, signal*amp);
}).add;
)

a = Synth(\wonderfunk);
b = Synth(\wonderfunk);

a.set(\pitch, ~nd[\b4]);
a.set(\pitch, ~nd[\c5]);
a.set(\pitch, ~nd[\g4]);
a.set(\pitch, ~nd[\f4]);
a.set(\pitch, ~nd[\e3]);

a.set(\pitch, ~nd[\b3]);
a.set(\pitch, ~nd[\c4]);
a.set(\pitch, ~nd[\g3]);
a.set(\pitch, ~nd[\f3]);
a.set(\pitch, ~nd[\e2]);

a.set(\pitch, ~nd[\d3]);
a.set(\pitch, ~nd[\c3]);
a.set(\pitch, ~nd[\g3]);
a.set(\pitch, ~nd[\a2]);
a.set(\pitch, ~nd[\e3]);
a.set(\pitch, ~nd[\c4]);

a.set(\formfModFreq, 0.08);
a.set(\bwfModFreq, 0.2);
a.set(\vibfreq, 3);

a.set(\formfModFreq, 0.1);
a.set(\bwfModFreq, 1.9);
a.set(\vibfreq, 8);

a.set(\formfModFreq, 0.3);
a.set(\bwfModFreq, 1);
a.set(\vibfreq, 4);


//hold me now
a.set(\pitch, ~nd[\d3]);
a.set(\pitch, ~nd[\b2]);
a.set(\pitch, ~nd[\c3]);
a.set(\pitch, ~nd[\a3]);


a.set(\pitch, ~nd[\g3]);
b.free;


(
~pitchset = [60, 67, 72, 57, 43, 60, 79];
~synths = Array.newClear(7);
~pitchset.do{ |it ix| ~synths[ix] = Synth(\wonderfunk, [\pitch, it]);};
)

//Preset 1
~formfs = [0.21, 0.17, 0.33, 0.47, 0.39, 0.269, 0.441];
~synths.do{ |it ix| it.set(\formfModFreq, ~formfs[ix]) };
~bwfs = 3!7;
~synths.do{ |it ix| it.set(\bwfModFreq, ~bwfs[ix]) };
//~pitches = [48, 55, 63, 67, 72, 75, 77];
~pitches = [48, 60, 63, 67, 72, 75, 79];

~synths.do{ |it ix| it.set(\pitch, ~pitches[ix]) };


~formfs = [0.21, 0.17, 0.33, 0.47, 0.39, 0.269, 0.441];
~formfs = [1.21, 2.17, 3.33, 4.47, 3.39, 2.269, 1.441];
~formfs = [4.21, 5.17, 6.33, 7.47, 8.39, 9.269, 11.441];
~formfs = 0.3!7;
~formfs = 0.1!7;
~formfs = 0.07!7;
~formfs = 3!7;
~synths.do{ |it ix| it.set(\formfModFreq, ~formfs[ix]) };

~bwfs = [ 0.1, 0.3, 0.5, 0.675, 0.345, 0.74, 0.25];
~bwfs = [ 2.1, 1.3, 3.5, 4.675, 2.345, 1.74, 1.25];
~bwfs = 7!7;
~bwfs = 0.1!7;
~bwfs = 0.3!7;
~bwfs = 1!7;

~bwfs = 3!7;
~synths.do{ |it ix| it.set(\bwfModFreq, ~bwfs[ix]) };



~pitches = [24, 36, 48, 60, 72, 84, 96];
~pitches = [36, 38, 40, 41, 43, 45];
~pitches = [55, 60, 63, 67, 72, 75, 79];
~pitches = [57, 58, 59, 60, 61, 62, 63];
~synths.do{ |it ix| it.set(\pitch, ~pitches[ix]) };



~vibfreqs = [1, 2, 3, 4, 3.2, 5.5, 1.7];
~vibfreqs = [11, 12, 13, 14, 13.2, 15.5, 11.7];
~vibfreqs = [0.5, 0.6, 0.7, 0.3, 0.8, 1.2, 0.1];
~vibfreqs = 20!7;
~vibfreqs = 4!7;
~synths.do{ |it ix| it.set(\vibfreq, ~vibfreqs[ix]) };



//routine for sequencing
(
~rh = [0.5, 1, 1, 0.5];
~pt = [60, 64, 67, 48, 52, 55, 72, 76, 79];
~syn = Synth(\wonderfunk, [\pitch, ~pt.choose]);
~seq = Routine {
	loop {
		~syn.set(\pitch, ~pt[round(thisThread.beats)%~pt.size]);
		~rh[round(thisThread.beats)%~rh.size].yield;
	}
}.play;
)

//change tempo
~seq.clock.tempo = 1;

//adjust duration and note score
~rh = [0.25, 0.25, 1, 1.25, 0.25, 0.25, 1.5, 0.5, 0.5, 0.25, 0.25, 1, 0.333, 0.333, 0.333, 1.5];
~pt = [ ~nd[\f2], ~nd[\a2], ~nd[\c3], ~nd[\e3], ~nd[\f3], ~nd[\g3], ~nd[\a3], ~nd[\c4], ~nd[\e4], ~nd[\f4], ~nd[\a4], ~nd[\c5], ~nd[\e5], ~nd[\g3], ~nd[\g4], ~nd[\g5], ~nd[\f5], ~nd[\a5] ];
~pt = [ ~nd[\c2], ~nd[\eb2], ~nd[\g2],~nd[\c3], ~nd[\eb3], ~nd[\g3], ~nd[\c4], ~nd[\eb4], ~nd[\g4], ~nd[\c5], ~nd[\eb5], ~nd[\g5] ];

//key of C
~pt = [ ~nd[\c4], ~nd[\e4], ~nd[\g4], ~nd[\c5] ].scramble;
~pt = [ ~nd[\f4], ~nd[\a4], ~nd[\c5], ~nd[\f5] ].scramble;
~pt = [ ~nd[\g4], ~nd[\b4], ~nd[\d5], ~nd[\g5] ].scramble;
~pt = [ ~nd[\a3], ~nd[\c4], ~nd[\e4], ~nd[\a4] ].scramble;
~pt = [ ~nd[\e4], ~nd[\g4], ~nd[\b4], ~nd[\e5] ].scramble;


~rh = [0.5, 1, 1.75, 0.25, 1.75, 0.25];

~pt = [ ~nd[\b4], ~nd[\c5], ~nd[\g4], ~nd[\f4], ~nd[\e3], ~nd[\d3], ~nd[\c3] ];

a.set(\pitch, ~nd[\b4]);
a.set(\pitch, ~nd[\c5]);
a.set(\pitch, ~nd[\g4]);
a.set(\pitch, ~nd[\f4]);
a.set(\pitch, ~nd[\e3]);
a.set(\pitch, ~nd[\d3]);
a.set(\pitch, ~nd[\c3]);

(
~seq.stop
~syn.free
)






