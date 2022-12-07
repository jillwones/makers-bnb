require "user_repository"

def reset_tables
  seed_sql = File.read("spec/seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do
    reset_tables
  end

  it "lists all users" do
    repo = UserRepository.new

    users = repo.all

    expect(users.length).to eq(5)
    expect(users.first.name).to eq("Jude")
    expect(users.last.name).to eq("Will")
  end

  it "creates a new user" do
    repo = UserRepository.new

    new_user = User.new

    new_user.name = "Billy"
    new_user.email_address = "billy@billy.com"
    new_user.password = "123"

    repo.create(new_user)

    users = repo.all

    expect(users.last.name).to eq("Billy")
    expect(users.last.email_address).to eq("billy@billy.com")
  end

  it "finds a user by email" do
    repo = UserRepository.new

    user = repo.find_by_email_address("jude@jude.com")

    expect(user.name).to eq("Jude")
    expect(user.id).to eq("1")
  end

  it 'returns true when email is taken' do 
    repo = UserRepository.new 
    expect(repo.check_if_email_taken('jude@jude.com')).to eq(true)
  end

  it 'returns false when the email is not taken' do 
    repo = UserRepository.new 
    expect(repo.check_if_email_taken('newemail@jude.com')).to eq(false)
  end

  it 'finds a user by id' do
    repo = UserRepository.new
    user = repo.find_by_id(1)

    expect(user.id).to eq('1')
    expect(user.name).to eq('Jude')
    expect(user.email_address).to eq('jude@jude.com')
    expect(user.phone_number).to eq('+447877916281')
  end
end
