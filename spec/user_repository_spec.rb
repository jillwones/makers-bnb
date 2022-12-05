require 'user_repository'

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_tables
  end

  it 'lists all users' do 
    repo = UserRepository.new 

    users = repo.all 

    expect(users.length).to eq(5)
    expect(users.first.name).to eq('Jude')
    expect(users.last.name).to eq('Will')
  end

  it 'creates a new user' do 
    repo = UserRepository.new 

    new_user = User.new 

    new_user.name = 'Billy'
    new_user.email_address = 'billy@billy.com'
    new_user.password = '123'

    repo.create(new_user)

    users = repo.all

    expect(users.last.name).to eq('Billy')
    expect(users.last.email_address).to eq('billy@billy.com')
  end
end