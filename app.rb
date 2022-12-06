require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/database_connection"
require_relative "lib/listing_repository"
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

      redirect "/homepage"
    else
      session[:message] = "Incorrect details"
      redirect "/"
    end
  end

  get "/homepage" do
    return erb(:homepage)
  end

  post "/logout" do
    session.clear
    session[:message] = "Successfully logged out."
    redirect "/"
  end

  get '/signup' do 
    @message = session.delete(:message)
    return erb(:signup)
  end

  post '/signup' do 
    @user_repository = UserRepository.new 
    new_user = User.new 
    new_user.name = params[:name]
    new_user.email_address = params[:email_address] 
    new_user.password = params[:password]
    taken = @user_repository.check_if_email_taken(params[:email_address])
    if taken 
      session[:message] = 'Email taken - use another'
      return redirect '/signup'
    end
    session[:message] = 'Account Successfully Created - Please Log In'
    @user_repository.create(new_user)
    return redirect '/'
  end

  get '/listings' do
    @listing_repository = ListingRepository.new
    return erb(:listings)
  end

  get '/listings/:id' do
    listing_repository = ListingRepository.new
    @listing = listing_repository.find_by_id(params[:id])
    return erb(:listings_id)
  end

  get '/new_listing_form' do
    return erb(:new_listing_form)
  end

  post '/new_listing_form' do
    new_listing = Listing.new
    new_listing.name = params[:name]
    new_listing.description = params[:description]
    new_listing.price_per_night = params[:price_per_night]
    # change below to 'new_listing.user_id = session[:user].id' once sessions added
    new_listing.user_id = params[:user_id]
    
    listing_repository = ListingRepository.new
    listing_repository.create(new_listing)
    id = listing_repository.all.last.id

    return redirect "/listings/#{id}"
  end
end