engine.name = 'Triangles'
triangles = include('triangles/lib/triangles_engine')

function init()
  triangles.add_params()
end

function redraw()
  screen.clear()
  screen.move(64,32)
  screen.text("triangles")
  screen.update()
end
