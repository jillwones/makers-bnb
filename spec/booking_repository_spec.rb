require_relative '../lib/booking_repository'
require_relative '../lib/booking'
require_relative '../lib/user'
require_relative '../lib/user_repository'
require_relative '../lib/listing'
require_relative '../lib/listing_repository'

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe BookingRepository do
  before(:each) do
    reset_tables
  end

  context 'all method' do
    it 'returns all bookings' do
      repo = BookingRepository.new
      bookings = repo.all
      expect(bookings.length).to eq 6
    end
  end

  context 'find_by_owner_id method' do
    it 'returns all booking bookings by the owners user id' do
      repo = BookingRepository.new
      bookings = repo.find_by_owner_id(1)
      first_booking = bookings.first
      last_booking = bookings.last
      expect(bookings.length).to eq 2
      expect(first_booking.name).to eq 'Apartment1'
      expect(last_booking.name).to eq 'Apartment3'
      expect(first_booking.user_id).to eq '2'
      expect(last_booking.user_id).to eq '2'
    end
  end

  context 'find method' do
    it 'finds a booking' do
      repo = BookingRepository.new

      booking = repo.find(1)

      expect(booking.name).to eq 'Apartment1'
      expect(booking.date).to eq '2022-10-10'
      expect(booking.booked).to eq 'yes'
      expect(booking.user_id).to eq '2'
      expect(booking.listing_id).to eq '1'
    end
  end

  context "find_by_user_id method" do 
    it "finds a user by ID(2)" do
      repo = BookingRepository.new 
      bookings_list = repo.find(2)
      expect(bookings_list.name).to eq 'Apartment2'
      expect(bookings_list.date).to eq '2022-09-09'
      expect(bookings_list.booked).to eq 'no'
      expect(bookings_list.user_id).to eq '3'
      expect(bookings_list.listing_id).to eq '2'
    end 
  end 
end
