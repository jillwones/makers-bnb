require 'date_repository'

def reset_tables
  seed_sql = File.read("spec/seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed_sql)
end

describe DateRepository do
  before(:each) do
    reset_tables
  end

  context 'find_by_listing_id method' do
    it 'finds dates available for a given listing id' do
      repo = DateRepository.new
      dates = repo.find_by_listing_id(1)
      first_date = dates.first
      last_date = dates.last
      expect(dates.length).to eq 3
      expect(first_date.date_available).to eq '2023-10-10'
      expect(first_date.id).to eq '1'
      expect(last_date.date_available).to eq '2023-10-12'
    end
  end

  context 'create method' do
    it 'creates a new date available for a given listing id' do
      repo = DateRepository.new
      listing = Listing.new
      listing.id = 1
      repo.create(listing,'2024-11-30')
      new_date = repo.find_by_listing_id(1).last
      expect(new_date.date_available).to eq '2024-11-30'
    end
  end
  
  context 'delete_by_listing_id_and_date' do
    it 'deletes a date available entry for a given listing id' do
      repo = DateRepository.new
      repo.delete_by_listing_id_and_date(6,'2023-12-14')
      dates = repo.find_by_listing_id(6)
      expect(dates.length).to eq 3
    end
  end
end

