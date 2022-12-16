require_relative 'booking'

class BookingRepository
  def all
    sql = 'SELECT id,name,date, booked, user_id, listing_id FROM bookings;'
    params = []
    result_set = DatabaseConnection.exec_params(sql, params)
    bookings = []
    result_set.each do |record|
      bookings << booking_to_object(record)
    end
    bookings
  end
  
  def create(booking)
    sql = "INSERT INTO bookings (name, date, booked, user_id, listing_id) VALUES ($1, $2, $3, $4, $5);"
    sql_params = [booking.name, booking.date, booking.booked, booking.user_id, booking.listing_id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end
  
  def accept(id)
    sql = "UPDATE bookings SET booked = 'yes' WHERE id = $1;"
    DatabaseConnection.exec_params(sql, [id])
    return nil
  end

  def decline(id)
    sql = "UPDATE bookings SET booked = 'no' WHERE id = $1;"
    DatabaseConnection.exec_params(sql, [id])
    return nil
  end

  def find_by_owner_id(owner_id)
    sql = 'SELECT bookings.id, bookings.name, bookings.date, bookings.booked, bookings.user_id, bookings.listing_id FROM bookings JOIN listings ON bookings.listing_id = listings.id WHERE listings.user_id = $1;'
    params = [owner_id]
    result_set = DatabaseConnection.exec_params(sql, params)
    bookings = []
    result_set.each do |record|
      bookings << booking_to_object(record)
    end
    bookings
  end

  def find(id)
    sql ="SELECT id,name,date,booked,user_id,listing_id FROM bookings WHERE id = $1;"
    result_set = DatabaseConnection.exec_params(sql,[id])
    booking = booking_to_object(result_set[0])

    return booking
  end

  def find_by_user_id(user_id)
    sql ="SELECT id, name, date, booked, user_id, listing_id FROM bookings WHERE user_id = $1;"
    params = [user_id]
    result_set = DatabaseConnection.exec_params(sql, params)
    bookings = []
    result_set.each do |record|
      bookings << booking_to_object(record)
    end
    bookings
  end

  def find_host_id_from_booking_id(booking_id)
    sql = 'SELECT listings.id, listings.user_id FROM listings JOIN bookings ON listings.id = bookings.listing_id WHERE bookings.id = $1;'
    sql_params = [booking_id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
    record = result_set[0]
    return record['user_id']
  end

  def delete(id)
    sql = 'DELETE FROM bookings WHERE id = $1;'
    sql_params = [id]
    DatabaseConnection.exec_params(sql, sql_params)
  end

  def booking_to_object(record)
    booking = Booking.new
    booking.id = record['id']
    booking.name = record['name']
    booking.date = record['date']
    booking.booked = record['booked']
    booking.user_id = record['user_id']
    booking.listing_id = record['listing_id']
    return booking
  end
end