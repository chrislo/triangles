Engine_Triangles : CroneEngine {
  var params, synths;

  alloc {
	SynthDef(\triangle, {
	  arg out = 0,
	  note, detune_semitones, detune_cents,
	  attack, release, curve,
	  trigger_freq, trigger_delay,
	  noise, amp_lfo_freq, amp_lfo_depth,
	  cutoff, cutoff_depth,
	  vibrato_rate, vibrato_depth,
	  decimation_bits,
	  amp, pan, pan_lfo_depth, pan_lfo_freq;

	  var gate_seq = TDelay.kr(Impulse.kr(trigger_freq), trigger_delay);
	  var env = EnvGen.kr(Env.perc(attack, release, curve: curve), gate: gate_seq);

	  var f_cents = (((note+1).midicps - note.midicps)/100) * detune_cents;
	  var freq_a = note.midicps;
	  var freq_b = (note + detune_semitones).midicps + f_cents;

	  var snd = Mix.new([
		DPW3Tri.ar(Vibrato.ar(freq_a, rate: vibrato_rate, depth: vibrato_depth)),
		DPW3Tri.ar(Vibrato.ar(freq_b, rate: vibrato_rate, depth: vibrato_depth)),
		PinkNoise.ar(noise),
	  ]);

	  var amp_lfo = SinOsc.kr(amp_lfo_freq).range(1-amp_lfo_depth, 1);
	  var pan_lfo = SinOsc.kr(pan_lfo_freq, mul: pan_lfo_depth);

	  snd = Decimator.ar(snd, bits: decimation_bits);
	  snd = MoogFF.ar(snd, cutoff + env.linlin(0, 1, 0, cutoff_depth)) * env * amp * amp_lfo;
	  Out.ar(out, Pan2.ar(snd, pan + pan_lfo));
	}).add();

	params = Dictionary.newFrom([
	  \note, 60,
	  \detune_semitones, 0,
	  \detune_cents, 0,
	  \attack, 0.01,
	  \release, 1,
	  \curve, -4,
	  \trigger_freq, 0.2,
	  \trigger_delay, 0,
	  \noise, 0.1,
	  \amp_lfo_freq, 1,
	  \amp_lfo_depth, 0,
	  \cutoff, 7000,
	  \cutoff_depth, 0,
	  \vibrato_rate, 2,
	  \vibrato_depth, 0,
	  \decimation_bits, 24,
	  \amp, 0.25,
	  \pan, 0,
	  \pan_lfo_depth, 0,
	  \pan_lfo_freq, 1;
	]);

	Server.default.sync;

	synths = Array.fill(4, {arg i; Synth(\triangle, params.getPairs) });

	(0..3).do({arg synth;
	  params.keysDo({ arg key;
		this.addCommand("s" ++ synth ++ "_" ++ key, "f", { arg msg;
		  synths[synth].set(key, msg[1]);
		});
	  });
	});
  }

  free {
	(0..3).do({arg i; synths[i].free});
  }
}