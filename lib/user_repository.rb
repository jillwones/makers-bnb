require_relative "./user"

class UserRepository
  def all
    users = []
    sql = "SELECT id, name, email_address, password FROM users;"
    sql_params = []
    result_set = DatabaseConnection.exec_params(sql, sql_params)
    result_set.each do |record|
      users << record_to_user_object(record)
    end
    return users
  end

  def create(new_user)
    encrypted_password = BCrypt::Password.create(new_user.password)
    sql = "INSERT INTO users (name, email_address, password) VALUES($1, $2, $3);"
    sql_params = [new_user.name, new_user.email_address, encrypted_password]
    DatabaseConnection.exec_params(sql, sql_params)
  end

  def find_by_email_address(email)
    sql = "SELECT id, name, email_address, password FROM users WHERE email_address = $1;"

    sql_params = [email]

    result_set = DatabaseConnection.exec_params(sql, sql_params)

    record = result_set[0]

    return record_to_user_object(record)
  end

  private

  def record_to_user_object(record)
    user = User.new
    user.id = record["id"]
    user.name = record["name"]
    user.email_address = record["email_address"]
    user.password = record["password"]

    return user
  end
end
