class GameController < ApplicationController
  attr_accessor :bs_api, :player_board, :opponent_board, :placed

  def register
    initialize_boards
    populate_boards
    place_player_ships_at_random

    @bs_api = Comms::BsAPI.new
    response = @bs_api.register('Johan De Klerk', 'johandk996@gmail.com')
    response[:player_board] = @player_board
    render :json => response
  end

  def salvo
    response = @bs_api.nuke(2843, 6, 4)
    render :json => response
  end

  def test
    initialize_boards
    populate_boards
    place_player_ships_at_random
  end

  private

  # Setup the data structures for the boards
  def initialize_boards
    @player_board = Array.new(81) { Hash.new }
    @opponent_board = Array.new(81) { Hash.new }
  end

  def populate_boards
    i = 0
    (0..9).each do |x|
      (0..9).each do |y|
        @player_board[i] = {:x => x, :y => y, :status => :open, :type => 0, :placement => 0}
        @opponent_board[i] = {:x => x, :y => y, :status => :open, :type => 0, :placement => 0}
        i = i + 1
      end
    end if @player_board.is_a?(Array) && @opponent_board.is_a?(Array)
  end

  # Get the hash at the given coordinates
  def hash_for_coordinates(x, y, board)
    board[(x.to_s + y.to_s).to_i]
  end

  # Randomly place the ships on the players' board
  def place_player_ships_at_random
    # The ships lengths
    [1, 1, 2, 2, 3, 4, 5].each do |ship_length|
      random_ship_placement(ship_length)
    end
  end

  def random_ship_placement(ship_length)
    coordinates = random_coordinates
    coordinate_hash = hash_for_coordinates(coordinates[:x], coordinates[:y], @player_board)
    if coordinate_hash[:status] == :open
      # Randomly place vertical or horizontal
      placement = rand(2)
      # Determine if there are no overlapping ships
      if all_ship_coordinates_open?(coordinate_hash, placement, ship_length)
        place_ship(coordinate_hash, placement, ship_length)
      else
        random_ship_placement(ship_length)
      end
    else
      random_ship_placement(ship_length)
    end
  end

  def all_ship_coordinates_open?(coordinate_hash, placement, ship_length)
    x_or_y = get_x_or_y(coordinate_hash, placement, ship_length)
    (x_or_y..(x_or_y + ship_length)-1).each do |coord|
      next_coordinate_hash = next_coordinate_hash(coordinate_hash, placement, coord)
      unless next_coordinate_hash && next_coordinate_hash[:status] == :open
        return false
      end
    end
    true
  end

  def get_x_or_y(coordinate_hash, placement, ship_length)
    x_or_y = coordinate_hash[:x] if placement == 0
    x_or_y = coordinate_hash[:y] if placement == 1
    x_or_y < ship_length - 1 ? x_or_y = 0 : x_or_y = x_or_y
    x_or_y
  end

  def next_coordinate_hash(coordinate_hash, placement, coord)
    next_coordinate_hash = hash_for_coordinates(coord, coordinate_hash[:y], @player_board) if placement == 0
    next_coordinate_hash = hash_for_coordinates(coordinate_hash[:x], coord, @player_board) if placement == 1
    next_coordinate_hash
  end

  def place_ship(coordinate_hash, placement, ship_length)
    index = board_index(coordinate_hash[:x], coordinate_hash[:y])
    set_ship_on_player_board(index, placement, ship_length)

    x_or_y = get_x_or_y(coordinate_hash, placement, ship_length)
    (x_or_y..(x_or_y + ship_length)-1).each do |coord|
      next_coordinate_hash = next_coordinate_hash(coordinate_hash, placement, coord)
      index = board_index(next_coordinate_hash[:x], next_coordinate_hash[:y])
      set_ship_on_player_board(index, placement, ship_length)
    end
  end

  def set_ship_on_player_board(index, placement, ship_length)
    @player_board[index][:status] = :placed
    @player_board[index][:placement] = placement
    @player_board[index][:type] = ship_length
  end

  def random_coordinates
    {:x => rand(9), :y => rand(9)}
  end

  def board_index(x, y)
    (x.to_s + y.to_s).to_i
  end
end
