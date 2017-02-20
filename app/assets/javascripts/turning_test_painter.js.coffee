class window.TranslateRotate
  constructor: (x, y, angle) ->
    @x = x
    @y = y
    @angle = angle
  mogrify: (x, y) ->
    new Vector(x + @x, y + @y)

class window.TurningTestPainter
  constructor: (canvas, translateRotate) ->
    @canvas = canvas
    @context = canvas.getContext('2d')
    @translateRotate = translateRotate
  clear: ->
    @context.clearRect(0, 0, @canvas.width, @canvas.height)
  color: (color) ->
    @context.strokeStyle = color
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
  drawCircle: (x, y, r) ->
    @drawArc(x, y, r, 0, 2 * Math.PI)
