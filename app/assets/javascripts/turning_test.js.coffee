class window.Vector
  constructor: (x, y) ->
    @x = x
    @y = y
  centerPoint: (other) ->
    new Vector((@x + other.x) / 2, (@y + other.y) / 2)
  angleTo: (other) ->
    if other.x > @x
      Math.atan((other.y - @y) / (other.x - @x))
    else
      Math.PI + Math.atan((other.y - @y) / (other.x - @x))

class window.LeftTurnCalculator
  constructor: (radius, baseLength) ->
    @radius = radius
    @baseLength = baseLength
    @arcLength = (2 * Math.PI * @radius / 4)
  distance: (percentage) ->
    percentage * (@arcLength + @baseLength)
  frontPosition: (percentage) ->
    dist = distance(percentage)
    if dist < @arcLength
      alpha = dist / @arcLength * (Math.PI / 2)
      x = Math.cos(alpha) * @radius
      y = Math.sin(alpha) * @radius
      new Vector(x, y)
    else
      x = -(dist - @arcLength)
      y = @radius
      new Vector(x, y)
  backPosition: (percentage) ->
    dist = distance(percentage)
    if dist < @baseLength
      x = @radius
      y = - (@baseLength - dist)
      new Vector(x, y)
    else
      alpha = (dist - @baseLength) / @arcLength * (Math.PI / 2)
      x = Math.cos(alpha) * @radius
      y = Math.sin(alpha) * @radius
      new Vector(x, y)


# https://boardgamegeek.com/article/18648138#18648138
window.smallLeftTurnCalculator1 = new LeftTurnCalculator(35, 40)
window.smallLeftTurnCalculator2 = new LeftTurnCalculator(63, 40)
window.smallLeftTurnCalculator3 = new LeftTurnCalculator(90, 40)
window.largeLeftTurnCalculator1 = new LeftTurnCalculator(35, 80)
window.largeLeftTurnCalculator2 = new LeftTurnCalculator(63, 80)
window.largeLeftTurnCalculator3 = new LeftTurnCalculator(90, 80)
