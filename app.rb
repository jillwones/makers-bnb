require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require 'bcrypt'
require_relative 'lib/listing_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  
  enable :sessions
  
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
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
