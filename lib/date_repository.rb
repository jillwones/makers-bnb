require_relative './date_available'

class DateRepository
  def find_by_listing_id(listing_id)
    sql = 'SELECT id, date_available, listing_id FROM dates_available WHERE listing_id = $1;'
    params = [listing_id]
    result_set = DatabaseConnection.exec_params(sql,params)
    dates = []
    result_set.each do |record|
      dates << record_to_object(record)
    end
    dates
  end

  def delete_by_listing_id_and_date(listing_id, date)
    sql = 'DELETE FROM dates_available WHERE listing_id = $1 and date_available = $2;'
    params = [listing_id, date]
    DatabaseConnection.exec_params(sql,params)
  end

  def create(listing, date)
    sql = "INSERT INTO dates_available (date_available, listing_id) VALUES($1, $2);"
    params = [date, listing.id]
    DatabaseConnection.exec_params(sql, params)
  end

  private

  def record_to_object(record)
    date_available = DateAvailable.new
    date_available.id = record["id"]
    date_available.date_available = record["date_available"]
    date_available.listing_id = record["listing_id"]
    return date_available
  end
end