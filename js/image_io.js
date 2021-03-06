// Generated by CoffeeScript 1.11.1
var GAMMA, display, download_file, write_ppm;

GAMMA = 2.2;

write_ppm = function(w, h, Ls) {
  var L, data, x, y;
  data = 'P3\n' + w + ' ' + h + '\n255\n';
  y = 0;
  while (y < h) {
    x = 0;
    while (x < w) {
      L = Ls[y * w + x];
      data += to_byte(L.x, GAMMA) + ' ' + to_byte(L.y, GAMMA) + ' ' + to_byte(L.z, GAMMA) + ' ';
      ++x;
    }
    ++y;
  }
  download_file(data, 'coffee-image.ppm', 'text/plain');
};

download_file = function(data, fname, type) {
  var a, file, url;
  file = new Blob([data], {
    type: type
  });
  if (window.navigator.msSaveOrOpenBlob) {
    window.navigator.msSaveOrOpenBlob(file, fname);
  } else {
    url = URL.createObjectURL(file);
    a = document.createElement('a');
    a.href = url;
    a.download = fname;
    document.body.appendChild(a);
    a.click();
    setTimeout((function() {
      document.body.removeChild(a);
      window.URL.revokeObjectURL(url);
    }), 0);
  }
};

display = function(w, h, Ls) {
  var L, canvas, context, x, y;
  canvas = document.getElementById('smallpt-canvas');
  context = canvas.getContext('2d');
  y = 0;
  while (y < h) {
    x = 0;
    while (x < w) {
      L = Ls[y * w + x];
      context.fillStyle = 'rgba(' + to_byte(L.x, GAMMA) + ', ' + to_byte(L.y, GAMMA) + ', ' + to_byte(L.z, GAMMA) + ', 1.0)';
      context.fillRect(x, y, 1, 1);
      ++x;
    }
    ++y;
  }
};
