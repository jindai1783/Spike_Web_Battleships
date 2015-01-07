require 'sinatra/base'

class Battleship < Sinatra::Base

  enable :sessions

  get '/' do
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
      session["user_name"] = params["user_name"]
      @user_name = session["user_name"]
      erb :set_fleet
    end
  end

  post '/set_fleet' do
    
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
