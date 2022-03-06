Engine_Triangles : CroneEngine {
  var params, synths;

  alloc {
	SynthDef(\triangle, {
	  arg out = 0,
	  note, transpose, detune_semitones, detune_cents,
	  attack, release, curve,
	  bellow, trigger_freq, trigger_delay,
	  noise_mix, osc_mix, amp_lfo_freq, amp_lfo_depth,
	  cutoff, cutoff_depth,
	  vibrato_rate, vibrato_depth,
	  decimation_bits,
	  amp, pan, pan_lfo_depth, pan_lfo_freq;

	  var gate_seq = TDelay.kr(Impulse.kr(trigger_freq), trigger_delay);
	  var env = EnvGen.kr(Env.perc(attack, release, curve: curve), gate: gate_seq);
	  var bellow_env = EnvGen.kr(Env.step([bellow, 1-bellow], [attack, release]), gate: Trig.kr(gate_seq, attack));

	  var f_cents = (((note+1).midicps - note.midicps)/100) * detune_cents;
	  var freq_a = (note + transpose).midicps;
	  var freq_b = (note + detune_semitones + transpose).midicps + f_cents;

	  var osc1_mul = osc_mix * (1 - noise_mix);
	  var osc2_mul = (1 - osc_mix) * (1 - noise_mix);
	  var noise_mul = noise_mix;

	  var snd = Mix.new([
		SelectX.ar(bellow_env, [
		  DPW3Tri.ar(Vibrato.ar(freq_a.lag2, rate: vibrato_rate, depth: vibrato_depth), mul: osc1_mul),
		  DPW3Tri.ar(Vibrato.ar(freq_b.lag2, rate: vibrato_rate, depth: vibrato_depth), mul: osc2_mul),
		]),
		PinkNoise.ar(noise_mul),
	  ]);

	  var amp_lfo = SinOsc.kr(amp_lfo_freq).range(1-amp_lfo_depth, 1);
	  var pan_lfo = SinOsc.kr(pan_lfo_freq, mul: pan_lfo_depth);

	  snd = Decimator.ar(snd, bits: decimation_bits);
	  snd = MoogFF.ar(snd, cutoff + env.linlin(0, 1, 0, cutoff_depth)) * env * amp * amp_lfo;
	  Out.ar(out, Pan2.ar(snd, pan + pan_lfo));
	}).add();

	params = Dictionary.newFrom([
	  \note, 60,
	  \transpose, 0,
	  \detune_semitones, 0,
	  \detune_cents, 0,
	  \attack, 0.01,
	  \release, 1,
	  \curve, -4,
	  \bellow, 0.5,
	  \trigger_freq, 0.2,
	  \trigger_delay, 0,
	  \noise_mix, 0.1,
	  \osc_mix, 0.5,
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
		if ([\decimation_bits, \note, \transpose, \detune_semitones].includes(key), {
		  this.addCommand("s" ++ synth ++ "_" ++ key, "i", { arg msg;
			synths[synth].set(key, msg[1]);
		  });
		}, {
		  this.addCommand("s" ++ synth ++ "_" ++ key, "f", { arg msg;
			synths[synth].set(key, msg[1]);
		  });
		});
	  });
	});
  }

  free {
	(0..3).do({arg i; synths[i].free});
  }
}