require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/listing_repository'
require_relative 'lib/user_repository'
require_relative 'lib/booking_repository'
require_relative 'lib/date_repository'
require_relative 'lib/message_repository'
require_relative 'lib/twilio'
require 'bcrypt'
require 'date'

DatabaseConnection.connect

class Application < Sinatra::Base
  enable :sessions

  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @message = session.delete(:message)
    return erb(:login)
  end

  post '/' do
    @user_repository = UserRepository.new
    all_users = @user_repository.all
    @valid_details = all_users.any? do |user|
      (user.email_address == params[:email_address]) and (BCrypt::Password.new(user.password) == params[:password])
    end

    if @valid_details
      user = @user_repository.find_by_email_address(params[:email_address])

      session[:user] = user

      redirect '/homepage'
    else
      session[:message] = 'Incorrect details'
      redirect '/'
    end
  end

  get '/homepage' do
    return erb(:homepage)
  end

  post '/logout' do
    session.clear
    session[:message] = 'Successfully logged out.'
    redirect '/'
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
    @message = session.delete(:message)
    listing_repository = ListingRepository.new
    date_repository = DateRepository.new

    @listing = listing_repository.find_by_id(params[:id])
    @dates = date_repository.find_by_listing_id(params[:id])
    return erb(:listings_id)
  end

  post '/listings/:id' do
    listing_repository = ListingRepository.new
    date_repository = DateRepository.new

    @listing = listing_repository.find_by_id(params[:id])
    @dates = date_repository.find_by_listing_id(params[:id])

    if @dates.map(&:date_available).include?(params[:date])
      booking = Booking.new
      booking_repository = BookingRepository.new

      booking.name = @listing.name
      booking.date = params[:date]
      booking.booked = 'pending'
      booking.user_id = session[:user].id
      booking.listing_id = params[:id]
      booking_repository.create(booking)

      user_repository = UserRepository.new
      owner_of_listing = user_repository.find_by_id(@listing.user_id)
      text = Text.new
      text.send_text_requested(owner_of_listing.phone_number)
      return redirect '/my-requests'
    else
      session[:message] = 'Date unavailable, choose a different date.'
      return redirect "/listings/#{params[:id]}"
    end
  end

  get '/new_listing_form' do
    @todays_date = Date.today.to_s
    return erb(:new_listing_form)
  end

  post '/new_listing_form' do
    new_listing = Listing.new
    new_listing.name = params[:name]
    new_listing.description = params[:description]
    new_listing.price_per_night = params[:price_per_night]
    new_listing.user_id = session[:user].id
    method_to_make_multiple_dates(new_listing, params[:start_date], params[:end_date])
    listing_repository = ListingRepository.new
    listing_repository.create(new_listing)
    id = listing_repository.all.last.id
    new_listing.id = id
    dates_available_repo = DateRepository.new
    new_listing.dates_available.each do |date|
      dates_available_repo.create(new_listing, date)
    end
    return redirect "/listings/#{id}"
  end

  get '/my-requests' do
    @booking_repository = BookingRepository.new
    return erb(:my_requests)
  end

  get '/requests-for-approval' do
    @booking_repository = BookingRepository.new
    @user_repository = UserRepository.new
    return erb(:requests_for_approval)
  end

  post '/accept/:request_id/:listing_id/:request_date/:user_id' do
    @booking_repository = BookingRepository.new
    @booking_repository.accept(params[:request_id])
    dates_available_repo = DateRepository.new
    dates_available_repo.delete_by_listing_id_and_date(params[:listing_id], params[:request_date])
    user_repository = UserRepository.new
    user = user_repository.find_by_id(params[:user_id])
    text = Text.new
    text.send_text_approved(user.phone_number)
    return redirect '/requests-for-approval'
  end

  post '/reject/:id/:user_id' do
    @booking_repository = BookingRepository.new
    @booking_repository.decline(params[:id])
    user_repository = UserRepository.new
    user = user_repository.find_by_id(params[:user_id])
    text = Text.new
    text.send_text_rejected(user.phone_number)
    return redirect '/requests-for-approval'
  end

  post '/reject/:id' do
    @booking_repository = BookingRepository.new
    @booking_repository.decline(params[:id])
    return redirect '/requests-for-approval'
  end

  get '/my-listings' do
    @listing_repository = ListingRepository.new
    return erb(:my_listings)
  end

  post '/delete_listing/:listing_id' do
    @listing_repository = ListingRepository.new
    @listing_repository.delete(params[:listing_id])
    return redirect '/my-listings'
  end

  post '/delete_request/:request_id' do
    booking_repository = BookingRepository.new
    booking_repository.delete(params[:request_id])
    return redirect '/my-requests'
  end

  get '/messages' do 
    @message_repository = MessageRepository.new
    @booking_repository = BookingRepository.new
    @user_repository = UserRepository.new
    @valid_bookings = @booking_repository.all.select do |booking| 
      (booking.booked == 'yes') and (session[:user].id == booking.user_id or session[:user].id == (@booking_repository.find_host_id_from_booking_id(booking.id)))
    end
    return erb(:messages)
  end 

  get '/messages/:host_id/:user_id' do 
    message_repo = MessageRepository.new
    @user_repo = UserRepository.new
    @messages = message_repo.all_by_host_and_user_id(params[:host_id], params[:user_id])
    return erb(:messages_user_host)
  end

  post '/messages/new/:host_id/:user_id' do 
    message = Message.new
    message_repository = MessageRepository.new
    message.content = params[:content]
    message.date_time = Time.new.strftime('%Y-%m-%d %H:%M:%S')
    message.host_id = params[:host_id]
    message.user_id = params[:user_id]
    message.sender_id = session[:user].id
    message_repository.create(message)
    redirect "/messages/#{params[:host_id]}/#{params[:user_id]}"
  end

  def method_to_make_multiple_dates(listing, start_date, end_date)
    start_date = Date.parse start_date
    end_date = Date.parse end_date
    while start_date <= end_date
      listing.dates_available << start_date
      start_date += 1
    end
  end
end
