(
b = Buffer.read(s, "/Users/jyang/GitHub/synthesis_library/Long_Tones/shanai_1.R.aif");

SynthDef( \gh, {
	arg buf, obs=0, amp=1, atk = 0.01, decay=0, sus=1, rel=0.1, crv = -2,
	delayTime=2, damp=0, size=1, diff=0.707, feedback=0.9, modDepth=0.1, modFreq=2, gate=0;
	var source, dsp, env;
	env = EnvGen.ar( Env.adsr(atk, decay, sus, rel, curve:crv),gate );
	source = PlayBuf.ar(1, buf, loop:1);
	dsp = Greyhole.ar(source, delayTime, damp, size, diff, feedback, modDepth, modFreq);
	Out.ar(obs, dsp*amp*env);
}).add;
)

a = Synth(\gh, [\buf, b]);
a.set(\gate, 1, \atk, 13.1, \crv, 6);
a.set(\delayTime, 0.4, \damp, 0.1, \size, 0.9, \diff, 0.4, \feedback, 0.9, \modDepth, 1, \modFreq, 5 );
a.set(\gate, 0, \rel, 0.2, \crv, -4);
a.free;