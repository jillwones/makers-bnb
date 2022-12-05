require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/database_connection"
require_relative "lib/user_repository"
require "bcrypt"

DatabaseConnection.connect

class Application < Sinatra::Base
  enable :sessions

  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get "/" do
    @message = session.delete(:message)
    return erb(:login)
  end

  post "/" do
    @user_repository = UserRepository.new
    all_users = @user_repository.all
    @valid_details = all_users.any? { |user| (user.email_address == params[:email_address]) and (BCrypt::Password.new(user.password) == params[:password]) }

    if @valid_details
      user = @user_repository.find_by_email_address(params[:email_address])

      session[:user] = user

      redirect "/listings"
    else
      session[:message] = "Incorrect details"
      redirect "/"
    end
  end

  get "/listings" do
    return erb(:listings)
  end

  post "/logout" do
    session.clear
    session[:message] = "Successfully logged out."
    redirect "/"
  end
end
