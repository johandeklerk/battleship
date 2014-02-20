class GameController < ApplicationController

  attr_accessor :bs_api, :player_board, :opponent_board

  def register
    initialize_boards
    populate_boards
    place_player_ships_at_random

    @bs_api = Comms::BsAPI.new
    response = @bs_api.register('Johan De Klerk', 'johandk996@gmail.com')
    render :json => response
  end

  def salvo
    response = @bs_api.nuke(2843, 6, 4)
    render :json => response
  end

  def get_player_board
    render :json => @player_board
  end

  def get_opponent_board
    render :json => @opponent_board
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
        @player_board[i] = {:x => x, :y => y, :status => :open, :type => 0}
        @opponent_board[i] = {:x => x, :y => y, :status => :open, :type => 0}
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
    [5, 4, 3, 2, 2, 1, 1].each do |ship_length|
      coordinates = random_coordinates
      coordinate_hash = hash_for_coordinates(coordinates[:x], coordinates[:y], @player_board)
      place_ship(coordinate_hash, ship_length)
    end
  end

  def place_ship(coordinate_hash, ship_length)
    if coordinate_hash[:status] == :open
      # Place the ship horizontally or vertically
      placement = rand(1)

      # Place the ship horizontally
      if placement == 0
        # If the ship is too long to be placed there move it down
        if coordinate_hash[:y] < ship_length - 1
          new_y = (ship_length - coordinate_hash[:y]) + coordinate_hash[:y]
          # Get the new coordinate hash
          coordinate_hash = hash_for_coordinates(coordinate_hash[:y], new_y, @player_board)
        end
      else
        # If the ship is too long to be placed there move it backwards
        if coordinate_hash[:x] < ship_length - 1
          new_x = (ship_length - coordinate_hash[:x]) + coordinate_hash[:x]
          # Get the new coordinate hash
          coordinate_hash = hash_for_coordinates(coordinate_hash[:x], new_x, @player_board)
        end
      end

      ## If there is already a ship rince & repeat
      if coordinate_hash[:status] == :placed
        coordinates = random_coordinates
        coordinate_hash = hash_for_coordinates(coordinates[:x], coordinates[:y], @player_board)
        place_ship(coordinate_hash, ship_length)
      end

      # Now finally place the ship
      (1..ship_length).each do | |
        index = (coordinate_hash[:x].to_s + coordinate_hash[:y].to_s).to_i
        @player_board[index][:status] = :placed
        @player_board[index][:type] = ship_length
        coordinate_hash = hash_for_coordinates(coordinate_hash[:x], coordinate_hash[:y]+1, @player_board) if placement == 0
        coordinate_hash = hash_for_coordinates(coordinate_hash[:x]+1, coordinate_hash[:y], @player_board) if placement == 1
      end
    end
  end

  def random_coordinates
    {:x => rand(9), :y => rand(9)}
  end
end
