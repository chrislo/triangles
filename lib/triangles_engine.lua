local Triangles = {}
local Formatters = require 'formatters'
local MusicUtil = require "musicutil"

function Triangles.add_params()
  local number_of_parameters_per_synth = 20
  params:add_group("Triangles", (4 * number_of_parameters_per_synth) + 4)

  for s = 0, 3 do
    local prefix = "s"..s.."_"

    params:add_separator("Triangle "..s)

    params:add_number(prefix.."note", "note", 0, 127, 60,
      function(n)
	return MusicUtil.note_num_to_name(n.value, true)
      end
    )
    params:set_action(prefix.."note", function(n) engine[prefix.."note"](n) end)

    params:add_number(prefix.."detune_semitones", "detune (semitones)", -24, 24, 0)
    params:set_action(prefix.."detune_semitones", function(n) engine[prefix.."detune_semitones"](n) end)

    params:add_number(prefix.."detune_cents", "detune (cents)" 0, 100, 0)
    params:set_action(prefix.."detune_cents", function(n) engine[prefix.."detune_cents"](n) end)

    params:add_taper(prefix.."attack", "attack", 0, 10, 1.0, 0.001, "s")
    params:set_action(prefix.."attack", function(n) engine[prefix.."attack"](n) end)

    params:add_taper(prefix.."release", "release", 0, 10, 1.0, 0.001, "s")
    params:set_action(prefix.."release", function(n) engine[prefix.."release"](n) end)

    params:add_number(prefix.."curve", "curve" -10, 10, -4)
    params:set_action(prefix.."curve", function(n) engine[prefix.."curve"](n) end)

    params:add_number(prefix.."trigger_frequency", "trigger frequency", 1, 32, 4)
    params:set_action(prefix.."trigger_frequency", function(n)
	local current_tempo = params:get('clock_tempo')
	local one_beat_in_seconds = 60.0/current_tempo
	engine[prefix.."trigger_frequency"] = n * one_beat_in_seconds
    end)

    params:add_number(prefix.."trigger_delay", "trigger delay", 1, 32, 4)
    params:set_action(prefix.."trigger_delay", function(n)
	local current_tempo = params:get('clock_tempo')
	local one_beat_in_seconds = 60.0/current_tempo
	engine[prefix.."trigger_delay"] = n * one_beat_in_seconds
    end)

    params:add_control(prefix.."noise", "noise level", controlspec.UNIPOLAR, nil)
    params:set_action(prefix.."noise", function(n) engine[prefix.."noise"](n) end)

    params:add_control(prefix.."amp_lfo_freq", "Amp LFO rate", controlspec.LOFREQ, nil)
    params:set_action(prefix.."amp_lfo_freq", function(n) engine[prefix.."amp_lfo_freq"](n) end)

    params:add_control(prefix.."amp_lfo_depth", "Amp LFO depth", controlspec.UNIPOLAR, nil)
    params:set_action(prefix.."amp_lfo_depth", function(n) engine[prefix.."amp_lfo_depth"](n) end)

    params:add_control(prefix.."cutoff", "Filter cutoff", controlspec.WIDEFREQ, nil)
    params:set_action(prefix.."cutoff", function(n) engine[prefix.."cutoff"](n) end)

    params:add_control(prefix.."cutoff_depth", "Filter env depth", controlspec.FREQ, nil)
    params:set_action(prefix.."cutoff_depth", function(n) engine[prefix.."cutoff_depth"](n) end)

    params:add_control(prefix.."vibrato_rate", "Vibrato rate", controlspec.LOFREQ)
    params:set_action(prefix.."vibrato_rate", function(n) engine[prefix.."vibrato_rate"](n) end)

    params:add_control(prefix.."vibrato_depth", "Vibrato depth", controlspec.UNIPOLAR)
    params:set_action(prefix.."vibrato_depth", function(n) engine[prefix.."vibrato_depth"](n) end)

    params:add_number(prefix.."decimation_bits", "Bit depth", 4, 24, 24)
    params:set_action(prefix.."decimation_bits", function(n) engine[prefix.."decimation_bits"](n) end)

    params:add_control(prefix.."amp", "Level", controlspec.UNIPOLAR, nil)
    params:set_action(prefix.."amp", function(n) engine[prefix.."amp"](n) end)

    params:add_control(prefix.."pan", "Level", controlspec.PAN, Formatters.bipolar_as_pan_widget)
    params:set_action(prefix.."pan", function(n) engine[prefix.."pan"](n) end)

    params:add_control(prefix.."pan_lfo_freq", "Pan LFO rate", controlspec.LOFREQ)
    params:set_action(prefix.."pan_lfo_freq", function(n) engine[prefix.."pan_lfo_freq"](n) end)

    params:add_control(prefix.."pan_lfo_depth", "Pan LFO depth", controlspec.UNIPOLAR)
    params:set_action(prefix.."pan_lfo_depth", function(n) engine[prefix.."pan_lfo_depth"](n) end)
  end

  params:bang()
end

return Triangles
