require_relative 'listing'

class ListingRepository
  def all
    sql = "SELECT id, name, description, price_per_night, user_id FROM listings;"
    params = []
    result_set = DatabaseConnection.exec_params(sql, params)
    listings = []
    result_set.each do |record|
      listings << record_to_object(record)
    end
    return listings
  end

  def create(listing)
    sql = "INSERT INTO listings (name, description, price_per_night, user_id) VALUES ($1, $2, $3, $4);"
    params = [listing.name, listing.description, listing.price_per_night, listing.user_id]
    DatabaseConnection.exec_params(sql, params)
    return listing
  end

  def find_by_id(id)
    sql = "SELECT id, name, description, price_per_night, user_id FROM listings WHERE id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [id])
    record = result_set[0]
    record_to_object(record)
  end

  def delete(listing_id)
    sql = 'DELETE FROM bookings WHERE listing_id = $1;'
    sql_params = [listing_id]
    DatabaseConnection.exec_params(sql, sql_params)
    sql = 'DELETE FROM dates_available WHERE listing_id = $1;'
    sql_params = [listing_id]
    DatabaseConnection.exec_params(sql, sql_params)
    sql = 'DELETE FROM listings WHERE id = $1;'
    sql_params = [listing_id]
    DatabaseConnection.exec_params(sql, sql_params)
  end

  def record_to_object(record)
    listing = Listing.new
    listing.id = record["id"]
    listing.name = record["name"]
    listing.description = record["description"]
    listing.price_per_night = record["price_per_night"]
    listing.user_id = record["user_id"]

    return listing
  end
end
