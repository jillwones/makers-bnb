require "listing_repository"
require "listing"

def reset_tables
  seed_sql = File.read("spec/seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed_sql)
end

describe ListingRepository do
  before(:each) do
    reset_tables
  end

  context "all method" do
    it "returns all listings" do
      repo = ListingRepository.new
      listings = repo.all

      expect(listings.length).to eq 6
      expect(listings.first.id).to eq "1"
      expect(listings.first.name).to eq "Apartment1"
      expect(listings.first.description).to eq "Two bedrooms in north London"
      expect(listings.first.price_per_night).to eq "100"
      expect(listings.first.user_id).to eq "1"
      expect(listings.last.id).to eq "6"
      expect(listings.last.name).to eq "Apartment3"
      expect(listings.last.description).to eq "Studio flat in central London"
      expect(listings.last.price_per_night).to eq "85.75"
      expect(listings.last.user_id).to eq "1"
    end
  end

  context "create method" do
    it "creates a new listing which gets added to the database" do
      repo = ListingRepository.new
      listing = Listing.new
      listing.name = "test listing"
      listing.description = "test description"
      listing.price_per_night = 123.45
      listing.user_id = 1
      repo.create(listing)
      newest_listing = repo.all.last
      expect(newest_listing.name).to eq "test listing"
      expect(newest_listing.description).to eq "test description"
      expect(newest_listing.price_per_night).to eq "123.45"
      expect(newest_listing.user_id).to eq "1"
    end
  end


  context "delete method" do
    it "deletes a listing" do
      repo = ListingRepository.new
      repo.delete(1)
      listings = repo.all

      expect(listings.length).to eq(5)
      expect(listings.first.id).to eq("2")
    end

    it "deletes all bookings and dates_available associated with that listing" do 
      repo = ListingRepository.new
      repo.delete(1)

      booking_repository = BookingRepository.new 
      expect(booking_repository.all.map(&:listing_id)).not_to include('1')

      dates_available_repo = DateRepository.new 
      expect(dates_available_repo.find_by_listing_id(1)).to eq([])
    end
  end

  context "find_by_id method" do
    it "finds a single listing by id" do
      repo = ListingRepository.new
      listing = repo.find_by_id(1)
      expect(listing.id).to eq '1'
      expect(listing.name).to eq 'Apartment1'
      expect(listing.description).to eq 'Two bedrooms in north London'
      expect(listing.price_per_night).to eq '100'
    end  
  end  
end
