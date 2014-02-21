# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  # Draws a row of rectangles
  drawRow = (svg, y, xoffsets) ->
    for offset in xoffsets
      rectangle = svg.append("rect")
      .attr("x", offset)
      .attr("y", y)
      .attr("class", "rectangle")
      .attr("width", 50)
      .attr("height", 50)

  # Draws the entire board
  drawBoard = (element, y, xoffsets) ->
    svg = d3.select element
    .append("svg")
    .attr("width", 511)
    .attr("height", 511)
    for [1..10]
      drawRow(svg, y, xoffsets)
      y = y + 50

  drawCarrier = (element) ->
    svg = d3.select(element).select("svg")
    svg.append("ellipse")
    .attr("cx", 135)
    .attr("cy", 35)
    .attr("rx", 125)
    .attr("ry", 20)

  drawBattleship = (element) ->
    svg = d3.select(element).select("svg")
    svg.append("ellipse")
    .attr("cx", 110)
    .attr("cy", 85)
    .attr("rx", 100)
    .attr("ry", 18)

  drawDestroyer = (element) ->
    svg = d3.select(element).select("svg")
    svg.append("ellipse")
    .attr("cx", 85)
    .attr("cy", 135)
    .attr("rx", 75)
    .attr("ry", 16)

  drawSubmarines = (element) ->
    svg = d3.select(element).select("svg")
    [svg.append("ellipse")
     .attr("cx", 60)
     .attr("cy", 185)
     .attr("rx", 50)
     .attr("ry", 12),
     svg.append("ellipse")
     .attr("cx", 60)
     .attr("cy", 235)
     .attr("rx", 50)
     .attr("ry", 12)]

  drawPatrolBoats = (element) ->
    svg = d3.select(element).select("svg")
    [svg.append("ellipse")
     .attr("cx", 35)
     .attr("cy", 285)
     .attr("rx", 25)
     .attr("ry", 10),
     svg.append("ellipse")
     .attr("cx", 35)
     .attr("cy", 335)
     .attr("rx", 25)
     .attr("ry", 10)]

  postMessage = (message) ->
    $("#messages_container").html(message)

  appendMessage = (message) ->
    html = $("#messages_container").html()
    $("#messages_container").html(html + '<br/>' + message)

  initialPlacementSequence = (ship) ->
    ship.transition().attr('fill', 'red').duration(1000)
    ship.transition().attr('fill', 'blue').duration(1000).delay(1000)
    ship.transition().attr('fill', 'black').duration(1000).delay(2000)

  $("#start_button").click ->
    postMessage("Starting the Game!")
    name = $("#name").val()
    email = $("#email").val()

    $.get '/register', (data) ->
      console.log(data)
      appendMessage("Welcome " + name)
      appendMessage("Game No: " + data.id)
      appendMessage("Placing the ships...")
      initialPlacementSequence(carrier)
      initialPlacementSequence(battleship)
      initialPlacementSequence(destroyer)
      for submarine in submarines
        initialPlacementSequence(submarine)
      for patrol_boat in patrol_boats
        initialPlacementSequence(patrol_boat)

  y = 10
  xoffsets = [10, 60, 110, 160, 210, 260, 310, 360, 410, 460]

  drawBoard('#player_board', y, xoffsets)
  drawBoard('#opponent_board', y, xoffsets)

  carrier = drawCarrier('#player_board')
  battleship = drawBattleship('#player_board')
  destroyer = drawDestroyer('#player_board')
  submarines = drawSubmarines('#player_board')
  patrol_boats = drawPatrolBoats('#player_board')









