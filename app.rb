require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require 'bcrypt'

DatabaseConnection.connect

class Application < Sinatra::Base
  
  enable :sessions
  
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end
end

