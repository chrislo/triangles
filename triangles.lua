engine.name = 'Triangles'
triangles = include('triangles/lib/triangles_engine')

function init()
  triangles.add_params()

  playing = true
end

function key(n,z)
  if n == 3 and z == 1 then
    playing = not playing

    if playing then
      engine.amp(0.25)
    else
      engine.amp(0)
    end

    redraw()
  end
end

function redraw()
  screen.clear()
  screen.move(64,32)
  screen.text(playing and "K3: turn off" or "K3: turn on")
  screen.update()
end
