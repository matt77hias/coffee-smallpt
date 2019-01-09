GAMMA = 2.2

write_ppm = (w, h, Ls) ->
  data = 'P3\n' + w + ' ' + h + '\n255\n'
  y = 0
  while y < h
    x = 0
    while x < w
      L = Ls[y * w + x]
      data += to_byte(L.x, GAMMA) + ' ' + to_byte(L.y, GAMMA) + ' ' + to_byte(L.z, GAMMA) + ' '
      ++x
    ++y
  download_file data, 'coffee-image.ppm', 'text/plain'
  return

download_file = (data, fname, type) ->
  file = new Blob([ data ], type: type)
  if window.navigator.msSaveOrOpenBlob
    # IE10+
    window.navigator.msSaveOrOpenBlob file, fname
  else
    # Others
    url = URL.createObjectURL(file)
    a = document.createElement('a')
    a.href = url
    a.download = fname
    document.body.appendChild a
    a.click()
    setTimeout (->
      document.body.removeChild a
      window.URL.revokeObjectURL url
      return
    ), 0
  return

display = (w, h, Ls) ->
  canvas = document.getElementById('smallpt-canvas')
  context = canvas.getContext('2d')
  y = 0
  while y < h
    x = 0
    while x < w
      L = Ls[y * w + x]
      context.fillStyle = 'rgba(' + to_byte(L.x, GAMMA) + ', ' + to_byte(L.y, GAMMA) + ', ' + to_byte(L.z, GAMMA) + ', 1.0)'
      context.fillRect x, y, 1, 1
      ++x
    ++y
  return
