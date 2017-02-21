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
  drawShip: (x, y, angle, size) ->
    unitX = new Vector(Math.cos(angle), Math.sin(angle))
    unitY = new Vector(Math.cos(angle - Math.PI / 2), Math.sin(angle - Math.PI / 2))
    half = size / 2
    frontLeft = new Vector(half * (unitX.x + unitY.x) + x, half * (unitX.y + unitY.y) + y)
    backLeft = new Vector(half * (-unitX.x + unitY.x) + x, half * (-unitX.y + unitY.y) + y)
    frontRight = new Vector(half * (unitX.x + -unitY.x) + x, half * (unitX.y + -unitY.y) + y)
    backRight = new Vector(half * (-unitX.x + -unitY.x) + x, half * (-unitX.y + -unitY.y) + y)
    @drawLine(frontLeft.x, frontLeft.y, backLeft.x, backLeft.y)
    @drawLine(backLeft.x, backLeft.y, backRight.x, backRight.y)
    @drawLine(frontRight.x, frontRight.y, frontLeft.x, frontLeft.y)
    @drawLine(backRight.x, backRight.y, frontRight.x, frontRight.y)
    # well, too tired now for proper maths for the nubs
    if size == 40
      frontCenter = new Vector((frontLeft.x + frontRight.x) / 2, (frontLeft.y + frontRight.y) / 2)
      frontLeftNub = new Vector((frontLeft.x + frontCenter.x) / 2, (frontLeft.y + frontCenter.y) / 2)
      frontRightNub = new Vector((frontRight.x + frontCenter.x) / 2, (frontRight.y + frontCenter.y) / 2)
      @drawCircle(frontLeftNub.x, frontLeftNub.y, 2)
      @drawCircle(frontRightNub.x, frontRightNub.y, 2)
      backCenter = new Vector((backLeft.x + backRight.x) / 2, (backLeft.y + backRight.y) / 2)
      backLeftNub = new Vector((backLeft.x + backCenter.x) / 2, (backLeft.y + backCenter.y) / 2)
      backRightNub = new Vector((backRight.x + backCenter.x) / 2, (backRight.y + backCenter.y) / 2)
      @drawCircle(backLeftNub.x, backLeftNub.y, 2)
      @drawCircle(backRightNub.x, backRightNub.y, 2)
    if size == 80
      frontCenter = new Vector((frontLeft.x + frontRight.x) / 2, (frontLeft.y + frontRight.y) / 2)
      frontLeftCenter = new Vector((frontLeft.x + frontCenter.x) / 2, (frontLeft.y + frontCenter.y) / 2)
      frontRightCenter = new Vector((frontRight.x + frontCenter.x) / 2, (frontRight.y + frontCenter.y) / 2)
      frontLeftNub = new Vector((frontLeftCenter.x + frontCenter.x) / 2, (frontLeftCenter.y + frontCenter.y) / 2)
      frontRightNub = new Vector((frontRightCenter.x + frontCenter.x) / 2, (frontRightCenter.y + frontCenter.y) / 2)
      @drawCircle(frontLeftNub.x, frontLeftNub.y, 2)
      @drawCircle(frontRightNub.x, frontRightNub.y, 2)
      backCenter = new Vector((backLeft.x + backRight.x) / 2, (backLeft.y + backRight.y) / 2)
      backLeftCenter = new Vector((backLeft.x + backCenter.x) / 2, (backLeft.y + backCenter.y) / 2)
      backRightCenter = new Vector((backRight.x + backCenter.x) / 2, (backRight.y + backCenter.y) / 2)
      backLeftNub = new Vector((backLeftCenter.x + backCenter.x) / 2, (backLeftCenter.y + backCenter.y) / 2)
      backRightNub = new Vector((backRightCenter.x + backCenter.x) / 2, (backRightCenter.y + backCenter.y) / 2)
      @drawCircle(backLeftNub.x, backLeftNub.y, 2)
      @drawCircle(backRightNub.x, backRightNub.y, 2)
