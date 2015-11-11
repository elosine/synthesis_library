//For Spotlights and colors comming through, have audio going to audio busses and have a mixing synthdef that will put a percentage of each bus out to speakers
//Adjust pixel counter to reflect a percentage of number of pixels in spotlight, and have a max size so that that will translate to 1 and smaller size spotlights will be quieter, also figure out amplitude scaling



//AMP SPEC
(
b = \amp.asSpec;
w = Window.new.front;
c = NumberBox(w, Rect(20, 20, 150, 20));
a = Slider(w, Rect(20, 60, 150, 20))
    .action_({
	        c.value_(b.map(a.value))
        });
a.action.value;
)


(
SynthDef(\krunkd, {
	arg rate=0.7, res=0.3, igain=1, type=0, nl=0.0003, f1=480, f2=520, decay=1, amp=0.5, rq=0.006, atk=0.001, rel=0.5, crv = -4, pan=0;
	var filter, impulse, ftrig, filter2, output, f1b, f2b, freq, oenv;
	oenv = EnvGen.ar(Env.perc(atk, rel, crv), \t_tr.kr(0, 0.0001), doneAction:0);
	f1b = (f1.cpsmidi-1).midicps;
	f2b = (f2.cpsmidi-1).midicps;
	ftrig = Impulse.kr(rate);
	freq = TRand.kr(f1, f2, ftrig);
	impulse = K2A.ar(1);
	filter = DFM1.ar( impulse, TRand.kr(f1, f2, ftrig), res, igain, type, nl );
	filter2 = DFM1.ar( impulse, TRand.kr(f1b, f2b, ftrig), res, igain, type, nl );
	output = Mix.ar([filter, filter2]) * 0.2;
	output = Decay2.ar(output, 0.001, decay, output);
	output = output*0.06;
	output = Pan2.ar(output, pan);
	Out.ar(0, output*amp*oenv);
}).add;
)

~s1 = Synth(\krunkd, [\t_tr, 1, \decay, 3, \rel, 2]);
~s1.free

d = Synth(\krunkd, [\igain, 0.01, \res, 9.8, \f1, 200, \f2, 210, \decay, 0.9, \nl, 0.33, \t_tr, 1]);

(
 var freq; freq = rrand(30, 80); d.set(\f1, freq.midicps, \f2, (freq+1).midicps);
d.set(\t_tr, 1, \decay, 0.5, \rel, 0.3);
)




s.meter