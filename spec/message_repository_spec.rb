require 'message_repository'

def reset_tables
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe MessageRepository do
  before(:each) do
    reset_tables
  end

  it 'lists all messages between a host and a guest' do
    repo = MessageRepository.new

    messages = repo.all_by_host_and_user_id(1, 2)

    expect(messages.length).to eq(4)
    expect(messages.first.content).to eq('Hi, I am looking forward to the trip')
    expect(messages.first.user_id).to eq('2')
    expect(messages[1].content).to eq('You best pay me')
    expect(messages[1].host_id).to eq('1')
  end

  it 'creates a new message' do
    repo = MessageRepository.new

    new_message = Message.new
    new_message.host_id = 1
    new_message.user_id = 3
    new_message.content = 'Hiya'
    new_message.date_time = '2022-12-16 15:31:28'

    repo.create(new_message)

    messages = repo.all_by_host_and_user_id(1, 3)
    expect(messages.last.content).to eq('Hiya')
    expect(messages.last.host_id).to eq('1')
    expect(messages.last.user_id).to eq('3')
    expect(messages.last.date_time).to eq('2022-12-16 15:31:28')
  end
end
