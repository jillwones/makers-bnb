class Listing
  attr_accessor :id, :name, :description, :price_per_night, :user_id, :dates_available
  def initialize
    @dates_available = []
  end
end