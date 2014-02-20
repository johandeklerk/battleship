# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  # Draws a row of rectangles
  drawRow = (svgContainer, y, offsets) ->
    for offset in offsets
      rectangle = svgContainer.append("rect")
      .attr("x", offset)
      .attr("y", y)
      .attr("class", "rectangle")
      .attr("width", 50)
      .attr("height", 50)

  # Draws the entire board
  drawBoard = (element, y, xoffsets) ->
    svgContainer = d3.select element
    .append("svg")
    .attr("width", 511)
    .attr("height", 511)
    for [1..10]
      drawRow(svgContainer, y, xoffsets)
      y = y + 50

  drawCarrier = (element) ->
    return d3.select element
    .select "svg"
      .append("ellipse")
      .attr("cx", 135)
      .attr("cy", 35)
      .attr("rx", 125)
      .attr("ry", 20)

  drawBattleship = (element) ->
    return d3.select element
    .select "svg"
      .append("ellipse")
      .attr("cx", 110)
      .attr("cy", 85)
      .attr("rx", 100)
      .attr("ry", 18)

  drawDestroyer = (element) ->
    return d3.select element
    .select "svg"
      .append("ellipse")
      .attr("cx", 85)
      .attr("cy", 135)
      .attr("rx", 75)
      .attr("ry", 16)

  drawSubmarine = (element) ->
    d3.select element
    .select "svg"
      .append("ellipse")
      .attr("cx", 60)
      .attr("cy", 185)
      .attr("rx", 50)
      .attr("ry", 12)
    d3.select element
    .select "svg"
      .append("ellipse")
      .attr("cx", 60)
      .attr("cy", 235)
      .attr("rx", 50)
      .attr("ry", 12)

  drawPatrolBoat = (element) ->
    d3.select element
    .select "svg"
      .append("ellipse")
      .attr("cx", 35)
      .attr("cy", 285)
      .attr("rx", 25)
      .attr("ry", 10)
    d3.select element
    .select "svg"
      .append("ellipse")
      .attr("cx", 35)
      .attr("cy", 335)
      .attr("rx", 25)
      .attr("ry", 10)

  y = 10
  xoffsets = [10, 60, 110, 160, 210, 260, 310, 360, 410, 460]

  drawBoard('#player_board', y, xoffsets)
  drawBoard('#opponent_board', y, xoffsets)

  carrier = drawCarrier('#player_board')
  battleship = drawBattleship('#player_board')
  destroyer = drawDestroyer('#player_board')
  submarine1 = drawSubmarine('#player_board')
  submarine2 = drawSubmarine('#player_board')
  patrol_boat1 = drawPatrolBoat('#player_board')
  patrol_boat2 = drawPatrolBoat('#player_board')

  console.log(carrier)


