SynthDef(\form, {
	arg fundf=100, formf=10, bwf=800;
	Out.ar(0, Formant.ar(fundf, formf, bwf));
}).add;

z = SynthDefAutogui(\form);

SynthDef(\wonderfunk, {
	arg fundf=100, formf=10, bwfModFreq=0.3;
	var signal, bwfmod;
	bwfmod = LFTri.kr(bwfModFreq).range(100.0, 500.0);
	signal = Formant.ar(fundf, formf, bwfmod);
	Out.ar(0, signal);
}).add;

z = SynthDefAutogui(\wonderfunk);
z.free