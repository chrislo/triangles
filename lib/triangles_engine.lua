local Triangles = {}
local Formatters = require 'formatters'

local specs = {
  ["note"] = controlspec.new(0, 127, "lin", 1, 60, ""),
  ["detune_semitones"] = controlspec.new(-24, 24, "lin", 1, 0, "st"),
  ["detune_cents"] = controlspec.new(0, 100, "lin", 1, 0, "cents"),
  ["attack"] = controlspec.new(0, 10, "lin", 0.01, 0.01, "s"),
  ["release"] = controlspec.new(0, 10, "lin", 0.01, 1, "s"),
  ["curve"] = controlspec.new(-10, 10, "lin", 1, -4, ""),
  ["trigger_freq"] = controlspec.new(0, 1, "lin", 0.01, 0.25, "Hz"),
  ["trigger_delay"] = controlspec.new(0, 10, "lin", 0.1, 0, "s"),
  ["noise"] = controlspec.new(0, 1, "lin", 0.1, 0.2, ""),
  ["amp_lfo_freq"] = controlspec.LOFREQ,
  ["amp_lfo_depth"] = controlspec.UNIPOLAR,
  ["cutoff"] = controlspec.FREQ,
  ["cutoff_depth"] = controlspec.FREQ,
  ["vibrato_rate"] = controlspec.new(0, 10, "lin", 1, 0, "Hz"),
  ["vibrato_depth"] = controlspec.UNIPOLAR,
  ["decimation_bits"] = controlspec.new(0, 24, "lin", 1, 24, "bits"),
  ["amp"] = controlspec.new(0, 1, "lin", 0.01, 0.25, ""),
  ["pan"] = controlspec.PAN,
  ["pan_lfo_depth"] = controlspec.UNIPOLAR,
  ["pan_lfo_freq"] = controlspec.LOFREQ,
}

local param_names = {
  "note", "detune_semitones", "detune_cents",
  "attack", "release", "curve",
  "trigger_freq", "trigger_delay",
  "noise", "amp_lfo_freq", "amp_lfo_depth",
  "cutoff", "cutoff_depth",
  "vibrato_rate", "vibrato_depth",
  "decimation_bits",
  "amp", "pan", "pan_lfo_depth", "pan_lfo_freq" }

function Triangles.add_params()
  params:add_group("Triangles", (4 * #param_names) + 4)

  for s = 0, 3 do
    params:add_separator("Triangle "..s)

    for i = 1, #param_names do
      local p_name = param_names[i]
      local engine_key = "s"..s.."_"..p_name

      params:add{
	type = "control",
	id = "triangles_"..engine_key,
	name = p_name,
	controlspec = specs[p_name],
	formatter = p_name == "pan" and Formatters.bipolar_as_pan_widget or nil,
	action = function(x) engine[engine_key](x) end
      }
    end
  end

  params:bang()
end

return Triangles
