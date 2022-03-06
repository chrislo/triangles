-- triangles v0.1.0
-- endless triangles
--
--
--
--
--
--    ▼ instructions below ▼
--
-- K2 randomises parameters

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
  local chords = {"Minor 7", "Minor 9", "Major 7", "Major 9", "Sus4"}
  local chord = MusicUtil.generate_chord(48, chords[math.random(1, #chords)])

  for voice = 0, 3 do
    Triangles.note(voice, chord[math.random(1, #chord)])
    Triangles.level(voice, 0.2)
    Triangles.noise_mix(voice, 0.05)
    Triangles.osc_mix(voice, 0.5)

    Triangles.attack(voice, math.random(1, 3))
    Triangles.release(voice, math.random(1, 5))
    Triangles.trigger_freq(voice, math.random(1, 8) + 8)
    Triangles.bit_depth(voice, math.random(10, 24))
    Triangles.cutoff(voice, math.random(1000, 7000))
    Triangles.pan(voice, math.random(-30, 30) / 100.0)
  end

  Triangles.vibrato_depth(3, 0.002)
end

function rotate(p, deg)
  local rad = math.rad(deg)
  local x_p = (p.x * math.cos(rad)) - (p.y * math.sin(rad))
  local y_p = (p.x * math.sin(rad)) + (p.y * math.cos(rad))

  return { x = x_p, y = y_p }
end

function draw_triangle(x, y, size, deg)
  local h = (math.sqrt(3) * size) / 2
  local v1 = { x = 0, y = h/2}
  local v2 = { x = size/2, y = -h/2}
  local v3 = { x = -size/2, y = -h/2}

  v1 = rotate(v1, deg)
  v2 = rotate(v2, deg)
  v3 = rotate(v3, deg)

  screen.line_width(1)
  screen.move(v1.x + x, v1.y + y)
  screen.line(v2.x + x, v2.y + y)
  screen.line(v3.x + x, v3.y + y)
  screen.close()
  screen.stroke()
end

function redraw()
  screen.clear()
  screen.aa(1)
  draw_triangle(30, 32, 30, 0)
  draw_triangle(50, 32, 32, 10)
  draw_triangle(70, 32, 34, 20)
  draw_triangle(90, 32, 36, 30)
  screen.update()
end
