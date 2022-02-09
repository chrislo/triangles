local Triangles = {}
local Formatters = require 'formatters'
local MusicUtil = require "musicutil"

function Triangles.add_params()
  local number_of_parameters_per_synth = 21
  params:add_group("TRIANGLES", (4 * number_of_parameters_per_synth) + 4 + 2)

  params:add_separator("GLOBAL")
  params:add_number("t_global_transpose", "transpose (semitones)", -24, 24, 0)
  params:set_action("t_global_transpose", function(n) Triangles.global_transpose(n) end)

  for s = 0, 3 do
    local prefix = "s"..s.."_"

    params:add_separator("VOICE "..s+1)

    params:add_number(prefix.."note", "note", 0, 127, 60,
      function(n)
	return MusicUtil.note_num_to_name(n.value, true)
      end
    )
    params:set_action(prefix.."note", function(n) engine[prefix.."note"](n) end)

    params:add_number(prefix.."detune_semitones", "detune (semitones)", -24, 24, 0)
    params:set_action(prefix.."detune_semitones", function(n) engine[prefix.."detune_semitones"](n) end)

    params:add_number(prefix.."detune_cents", "detune (cents)", 0, 100, 0)
    params:set_action(prefix.."detune_cents", function(n) engine[prefix.."detune_cents"](n) end)

    params:add_control(prefix.."bellow", "bellow", controlspec.UNIPOLAR, nil)
    params:set_action(prefix.."bellow", function(n) engine[prefix.."bellow"](n) end)
    params:set(prefix.."bellow", 0.5)

    params:add_taper(prefix.."attack", "attack", 0, 10, 1.0, 0.001, "s")
    params:set_action(prefix.."attack", function(n) engine[prefix.."attack"](n) end)

    params:add_taper(prefix.."release", "release", 0, 10, 1.0, 0.001, "s")
    params:set_action(prefix.."release", function(n) engine[prefix.."release"](n) end)

    params:add_number(prefix.."curve", "curve", -10, 10, -4)
    params:set_action(prefix.."curve", function(n) engine[prefix.."curve"](n) end)

    params:add_number(prefix.."trigger_freq", "trigger frequency", 1, 32, 4)
    params:set_action(prefix.."trigger_freq", function(n)
	local current_tempo = params:get('clock_tempo')
	local one_beat_in_seconds = 60.0/current_tempo
	engine[prefix.."trigger_freq"](1/(n * one_beat_in_seconds))
    end)

    params:add_number(prefix.."trigger_delay", "trigger delay", 0, 32, 0)
    params:set_action(prefix.."trigger_delay", function(n)
	local current_tempo = params:get('clock_tempo')
	local one_beat_in_seconds = 60.0/current_tempo
	engine[prefix.."trigger_delay"](n * one_beat_in_seconds)
    end)

    params:add_control(prefix.."noise", "noise level", controlspec.UNIPOLAR, nil)
    params:set_action(prefix.."noise", function(n) engine[prefix.."noise"](n) end)

    params:add_control(prefix.."amp_lfo_freq", "amp LFO rate", controlspec.LOFREQ, nil)
    params:set_action(prefix.."amp_lfo_freq", function(n) engine[prefix.."amp_lfo_freq"](n) end)

    params:add_control(prefix.."amp_lfo_depth", "amp LFO depth", controlspec.UNIPOLAR, nil)
    params:set_action(prefix.."amp_lfo_depth", function(n) engine[prefix.."amp_lfo_depth"](n) end)

    params:add_control(prefix.."cutoff", "filter cutoff", controlspec.WIDEFREQ, nil)
    params:set_action(prefix.."cutoff", function(n) engine[prefix.."cutoff"](n) end)
    params:set(prefix.."cutoff", 2000)

    params:add_control(prefix.."cutoff_depth", "filter env depth", controlspec.FREQ, nil)
    params:set_action(prefix.."cutoff_depth", function(n) engine[prefix.."cutoff_depth"](n) end)

    params:add_control(prefix.."vibrato_rate", "vibrato rate", controlspec.LOFREQ)
    params:set_action(prefix.."vibrato_rate", function(n) engine[prefix.."vibrato_rate"](n) end)

    params:add_taper(prefix.."vibrato_depth", "vibrato depth", 0, 1, 0, 0.001, "")
    params:set_action(prefix.."vibrato_depth", function(n) engine[prefix.."vibrato_depth"](n) end)

    params:add_number(prefix.."decimation_bits", "bit depth", 4, 24, 24)
    params:set_action(prefix.."decimation_bits", function(n) engine[prefix.."decimation_bits"](n) end)

    params:add_control(prefix.."amp", "level", controlspec.UNIPOLAR, nil)
    params:set_action(prefix.."amp", function(n) engine[prefix.."amp"](n) end)

    params:add_control(prefix.."pan", "pan", controlspec.PAN, Formatters.bipolar_as_pan_widget)
    params:set_action(prefix.."pan", function(n) engine[prefix.."pan"](n) end)

    params:add_control(prefix.."pan_lfo_freq", "Pan LFO rate", controlspec.LOFREQ)
    params:set_action(prefix.."pan_lfo_freq", function(n) engine[prefix.."pan_lfo_freq"](n) end)

    params:add_control(prefix.."pan_lfo_depth", "Pan LFO depth", controlspec.UNIPOLAR)
    params:set_action(prefix.."pan_lfo_depth", function(n) engine[prefix.."pan_lfo_depth"](n) end)
  end

  params:bang()
end


function parameter_name(voice, key)
  return "s"..voice.."_"..key
end

function Triangles.global_transpose(x)
  for s = 0, 3 do
    engine["s"..s.."_".."transpose"](x)
  end
end

function Triangles.note(voice, x)
  params:set(parameter_name(voice, 'note'), x)
end

function Triangles.level(voice, x)
  params:set(parameter_name(voice, 'amp'), x)
end

function Triangles.attack(voice, x)
  params:set(parameter_name(voice, 'attack'), x)
end

function Triangles.release(voice, x)
  params:set(parameter_name(voice, 'release'), x)
end

function Triangles.trigger_freq(voice, x)
  params:set(parameter_name(voice, 'trigger_freq'), x)
end

function Triangles.trigger_delay(voice, x)
  params:set(parameter_name(voice, 'trigger_delay'), x)
end

function Triangles.noise_level(voice, x)
  params:set(parameter_name(voice, 'noise'), x)
end

function Triangles.bit_depth(voice, x)
  params:set(parameter_name(voice, 'decimation_bits'), x)
end

function Triangles.vibrato_depth(voice, x)
  params:set(parameter_name(voice, 'vibrato_depth'), x)
end

function Triangles.cutoff(voice, x)
  params:set(parameter_name(voice, 'cutoff'), x)
end

function Triangles.pan(voice, x)
  params:set(parameter_name(voice, 'pan'), x)
end

function Triangles.bellow(voice, x)
  params:set(parameter_name(voice, 'bellow'), x)
end

return Triangles
