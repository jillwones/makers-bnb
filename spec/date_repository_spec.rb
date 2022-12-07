require 'date_repository'
require 'date'

def reset_tables
  seed_sql = File.read("spec/seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed_sql)
end

describe DateRepository do
  before(:each) do
    reset_tables
  end

  context "find_by_listing_id method" do
    it "finds dates by listing by id" do
      repo = DateRepository.new
      dates = repo.find_by_listing_id(1)
    
      expect(dates.first.date_available).to eq "2023-10-10"
    end
  end
end
