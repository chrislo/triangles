-- triangles v0.1.0
-- four endlessly triggering voices
--
--
--
--
--
--    ▼ instructions below ▼
--
-- E2 randomises parameters

engine.name = 'Triangles'
Triangles = include('triangles/lib/triangles_engine')
MusicUtil = require "musicutil"

function init()
  Triangles.add_params()
  randomise_params()
end

function key(n,z)
  if n == 2 and z == 1 then
    randomise_params()
  end
end

function randomise_params()
  local chord = MusicUtil.generate_chord(48, "Minor 9")

  for voice = 0, 3 do
    Triangles.note(voice, chord[math.random(1, #chord)])
    Triangles.level(voice, 0.2)
    Triangles.noise_level(voice, math.random(2, 6) / 10.0)

    Triangles.attack(voice, math.random(1, 3))
    Triangles.release(voice, math.random(1, 5))
    Triangles.trigger_freq(voice, math.random(1, 8) + 8)
    Triangles.trigger_delay(voice, math.random(1, 4))
    Triangles.bit_depth(voice, math.random(10, 24))
    Triangles.cutoff(voice, math.random(1000, 7000))
    Triangles.pan(voice, math.random(-30, 30) / 100.0)
  end

  Triangles.vibrato_depth(3, 0.002)
end

function redraw()
  screen.clear()
  screen.move(64,32)
  screen.text("triangles")
  screen.update()
end
