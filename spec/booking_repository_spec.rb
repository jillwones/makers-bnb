require "booking_repository"

def reset_tables
  seed_sql = File.read("spec/seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })

  connection.exec(seed_sql)
end

describe BookingRepository do
  before(:each) do
    reset_tables
  end

  context "#create" do
    it "creates a new booking request" do
      booking = Booking.new
      booking.name = "Apartment 1"
      booking.date = "2022-12-06"
      booking.booked = "pending"
      booking.user_id = 4
      booking.listing_id = 1

      repo = BookingRepository.new
      repo.create(booking)

      booking = repo.find(7)
      expect(booking.id).to eq "7"
      expect(booking.name).to eq "Apartment 1"
      expect(booking.date).to eq "2022-12-06"
      expect(booking.booked).to eq "pending"
      expect(booking.user_id).to eq "4"
      expect(booking.listing_id).to eq "1"
      end
  end

  context "#accept" do
    it "changes a booking's status to accepted" do
      repo = BookingRepository.new
      repo.accept(3)
      booking = repo.find(3)
      expect(booking.booked).to eq "yes"
    end
  end

  context "#decline" do
    it "changes a booking's status to accepted" do
      repo = BookingRepository.new
      repo.decline(6)
      booking = repo.find(6)
      expect(booking.booked).to eq "no"
    end
  end

  context "#find" do
    it "finds a booking by ID" do
      repo = BookingRepository.new
      booking = repo.find(3)
      expect(booking.id).to eq "3"
      expect(booking.name).to eq "House1"
      expect(booking.date).to eq "2023-12-12"
      expect(booking.booked).to eq "pending"
      expect(booking.user_id).to eq "4"
      expect(booking.listing_id).to eq "3"
    end
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
      expect(booking.date).to eq '2023-10-10'
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
      expect(bookings_list.date).to eq '2023-09-10'
      expect(bookings_list.booked).to eq 'no'
      expect(bookings_list.user_id).to eq '3'
      expect(bookings_list.listing_id).to eq '2'
    end 
  end 

  context 'delete method' do 
    it 'deletes a booking record' do 
      repo = BookingRepository.new 
      repo.delete(1)
      expect(repo.all.first.id).to eq('2')
    end
  end

  context 'find host id from booking id' do 
    it 'finds the correct host id from a booking id' do 
      repo = BookingRepository.new 
      expect(repo.find_host_id_from_booking_id(6)).to eq('1')
    end 
  end
end