class window.TranslateRotate
  constructor: (x, y, angle) ->
    @x = x
    @y = y
    @angle = angle
  mogrify: (x, y) ->
    new Vector(x + @x, y + @y)

class window.TurningTestPainter
  constructor: (canvas, translateRotate) ->
    @context = canvas.getContext('2d')
    @translateRotate = translateRotate
  drawLine: (x1, y1, x2, y2) ->
    start = @translateRotate.mogrify(x1, y1)
    end = @translateRotate.mogrify(x2, y2)
    @context.beginPath()
    @context.moveTo(start.x, start.y)
    @context.lineTo(end.x, end.y)
    @context.stroke()
  drawArc: (x, y, r, start, end) ->
    center = @translateRotate.mogrify(x, y)
    @context.beginPath()
    @context.arc(center.x, center.y, r, start, end, false)
    @context.stroke()
