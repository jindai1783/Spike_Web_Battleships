require 'sinatra/base'
require_relative 'setup'

class Battleship < Sinatra::Base

  GAME = Game.new

  enable :sessions

  get '/' do
    session['game'] = GAME
    @player2 = Player.new
    @player2.name = "Computer"
    GAME.add_player(@player2)
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
      @player1 = Player.new
      @player1.name = params["user_name"]
      @board1 = Board.new(Cell)
      GAME.add_player(@player1)
      fleet1 =[
        Ship.aircraft_carrier, 
        Ship.battleship, 
        Ship.destroyer, 
        Ship.submarine, 
        Ship.patrol_boat
      ]
      GAME.player1.board = @board1
      erb :set_fleet
    end
  end

  post '/set_fleet' do
    if params["ship"].empty? || params["coord"].empty? || params["orientation"].empty?
      @error_incomplete = "Please fill in all attributes..."
      erb :set_fleet
    else
      session["coord"] = params["coordinates"]
      @coordinates = session["coord"]
      erb :game_over
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
