require_relative './message'

class MessageRepository
  def all_by_host_and_user_id(host_id, user_id)
    all_messages = []
    sql = 'SELECT content, date_time, host_id, user_id, sender_id FROM messages WHERE host_id = $1 and user_id = $2;'
    sql_params = [host_id, user_id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
    result_set.each do |record|
      all_messages << record_to_message_object(record)
    end
    all_messages
  end

  def create(message)
    sql = 'INSERT INTO messages (content, date_time, host_id, user_id, sender_id) VALUES ($1, $2, $3, $4, $5);'
    sql_params = [message.content, message.date_time, message.host_id, message.user_id, message.sender_id]
    DatabaseConnection.exec_params(sql, sql_params)
  end

  private

  def record_to_message_object(record)
    message = Message.new
    message.id = record['id']
    message.host_id = record['host_id']
    message.user_id = record['user_id']
    message.content = record['content']
    message.date_time = record['date_time']
    message.sender_id = record['sender_id']
    message
  end
end
