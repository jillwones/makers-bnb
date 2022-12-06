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
      expect(booking.date).to eq "2022-10-20"
      expect(booking.booked).to eq "pending"
      expect(booking.user_id).to eq "4"
      expect(booking.listing_id).to eq "3"
    end
  end
end