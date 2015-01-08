require 'sinatra/base'
require_relative 'setup'

class Battleship < Sinatra::Base

  GAME = Game.new

  enable :sessions

  get '/' do
    session['game'] = GAME
    erb :home
  end

  get '/new_game' do
    erb :new_game
  end

  post '/new_game' do
    if params["user_name"].empty?
      @error_no_name = "You didn't enter your name."
      erb :new_game
    else
      player1 = Player.new
      player1.name = params["user_name"]
      board1 = Board.new(Cell)
      GAME.add_player(player1)
      GAME.player1.board = board1
      erb :set_fleet
    end
  end

  post '/set_fleet' do
    if params["coord"].empty? || params["orientation"].empty?
      @error_incomplete = "Please fill in all attributes..."
      erb :set_fleet
    else

      case params["ship"]
      when "A"
        type = Ship.aircraft_carrier
      when "B"
        type = Ship.battleship
      when "D"
        type = Ship.destroyer
      when "S"
        type = Ship.submarine
      else
        type = Ship.patrol_boat
      end

      coord = params["coord"].to_sym

      case params["orientation"]
      when "h"
        orien = :horizontally
      else
        orien = :vertically
      end

      GAME.player1.board.place(type, coord, orien)

      erb :set_fleet
    end
  end

  get '/board_two' do

    player2 = Player.new
    player2.name = "Computer"
    GAME.add_player(player2)
    board2 = Board.new(Cell)
    GAME.player2.board = board2

    fleet2 = [
      Ship.aircraft_carrier, 
      Ship.battleship, 
      Ship.destroyer, 
      Ship.submarine, 
      Ship.patrol_boat]

    fleet2.each_with_index do |ship, index| 
      coord = ("A" + (index + 1).to_s).to_sym
      GAME.player2.board.place(ship, coord, :vertically)
    end

    erb :board_two
  end

  get '/redirect_to_set_fleet' do
    erb :set_fleet
  end

  get '/fight' do
    erb :fight
  end

  post '/fight' do
    if params["coord"].empty?
      @error_incomplete = "Please fill in the coordinate..."
      erb :set_fleet
    else
      coord = params["coord"].to_sym
      GAME.shoots(coord)
      erb :fight
    end
  end

  get '/game_over' do
    erb :game_over
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
