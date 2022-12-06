require_relative 'booking'

class BookingRepository
  def all
    sql = 'SELECT id,name,date, booked,user_id, listing_id FROM bookings;'
    params = []
    result_set = DatabaseConnection.exec_params(sql, params)
    bookings = []
    result_set.each do |record|
      bookings << booking_to_object(record)
    end
    bookings
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

