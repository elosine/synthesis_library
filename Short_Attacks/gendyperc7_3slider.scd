//// MAKE A 2D SLIDER AS ACCELEROMETER AND AN ADDITIONAL 1D SLIDER FOR bowing position

(
SynthDef(\stochsynth, {
	arg ampdist = 4.5, durdist = 1.5, adparam = 1, ddparam = 1, minfreq = 50, maxfreq = 6580, ampscale = 1.0, durscale = 0.5, initCPs = 12, knum, mul = 0.5, add = 0, envdur = 2, envdens = 7, atk=0.001, amp = 4.1, rel = 0.5;
	//'one-slider' variables
	var dur = \dur.kr(0.0).linexp(0.0, 1.0, 0.02, 3.02);
	var dens = \dens.kr(0.0).linlin(0.0, 1.0, 37.0, 9.02);
	var crv = \crv.kr(0.0).linexp(0.0, 1.0, 6.0, 4.0);
	var res = \res.kr(0.0).linlin(0.0, 1.0, 0.0, 0.6);

	var env = Env.perc(0.0001, dur, 0.25, -32);
	var gate = Dust.kr(dens);
	var env_gen = EnvGen.kr(env, gate, doneAction: 0);
	var envgate = Dust.kr(envdens);
	//var ampenv = EnvGen.kr(Env.perc(0.001, envdur, curve: crv), envgate);
	//var ampenv = EnvGen.kr(Env.perc(atk, TRand.kr(0.08, 1.2, Dust.kr(1)), curve: crv), envgate);
	var ampenv = EnvGen.kr(Env.perc(atk, rel, curve: crv), \t_trig.kr(1));
	var gd = Gendy1.ar( ampdist, durdist, adparam, ddparam, minfreq, maxfreq, ampscale, durscale, initCPs, knum, env_gen, add );
	var moog = MoogLadder.ar(gd, TIRand.kr(200, 10000, envgate),res);
	var ring = Ringz.ar(gd, TRand.kr(80, 1500, Dust.kr(1.4)), TRand.kr(0.2, 3, Dust.kr(1.4)));
	var mix = Mix.ar([gd, ring*0.01]);
	var rmod = SinOsc.ar(SinOsc.kr(0.03, 0, 400, 600));
	var pan = Pan2.ar([moog, DelayC.ar(moog, delaytime:0.008)], SinOsc.kr(TIRand.kr(0.5, 2.5,Dust.kr(1.0) )));//spatialize
	Out.ar(0, pan*ampenv*amp);
}).add;
)

(
~kbus01 = Bus.control(s);

~nb = NumberBox()
.font_( Font(\Monaco, 14) )
.stringColor_( Color.green )
.normalColor_( Color.green )
.background_( Color.black );

~sl = Slider()
.knobColor_( Color.new255(0) )
.background_( Color.new255(30, 247, 82) )
.focusColor_( Color.black )
.thumbSize_(30)
.action_({|val|
	~nb.value_(val.value);
	~kbus01.set(val.value);
});

~win = Window()
.layout_( HLayout( VLayout(~nb,~sl) ) )
.bounds_(80@350) //.bounds_(Rect(100, 1000, 900, 500))
.background_( Color.new255(0, 0, 0, 130) )
.front;


~syn1 = Synth(\stochsynth);
~syn1.map(\dur, ~kbus01, \dens, ~kbus01, \crv, ~kbus01, \res, ~kbus01);
//~syn1.map(\res, ~kbus01);
)

(
r = Routine {
	    inf.do({
		~syn1.set(\t_trig, 1);
		//[0.5, 0.8, 1.2, 1.1, 1.5, 0.77].choose.wait;
		0.8.wait;
	});

}.play;
)


r.stop;
r.reset

~syn1.set(\t_trig, 1);
~syn.set(\rel, 0.1, \atk, 0.01);
(
var inc = 0.0, dir=1;

r = Routine {
	    inf.do({
		if(inc>=1.0, {dir = -1});
		if(inc<=0.0, {dir = 1});
		~sl.valueAction_(inc);

		inc = inc + (0.01*dir);
		0.1.wait;
	}.defer)

}.play(AppClock);

)
~sl.valueAction_(0.5);



