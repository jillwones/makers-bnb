require "spec_helper"
require "rack/test"
require_relative "../../app"

# Add reset_tables method here

RSpec.describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  def reset_tables
    seed_sql = File.read("spec/seeds.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_tables
  end

  context "GET /" do
    it "returns the login page" do
      response = get("/")

      expect(response.status).to eq(200)
      expect(response.body).to include("Log In")
      expect(response.body).to include("Sign Up")
    end
  end

  context "POST /" do
    it "returns a logged in page with valid details" do
      post("/", email_address: "jude@jude.com", password: "jude")
      response = get("/listings")
      expect(response.status).to eq(200)
      expect(response.body).to include("Welcome, Jude")
    end
  end

  context "POST /logout" do
    it "returns the login page" do
      post("/logout")
      response = get("/")
      expect(response.status).to eq(200)
      expect(response.body).to include("Log In")
      expect(response.body).to include("Sign Up")
    end
  end

  context 'GET /signup' do 
    it 'returns the signup page' do 
      response = get('/signup')

      expect(response.status).to eq(200)
      expect(response.body).to include('Enter your details below')
    end
  end

  context 'POST /signup' do 
    it 'returns the login page with success message' do 
      post('/signup', name: 'Freddy', email_address: 'freddy@freddy.com', password: 'freddy')
      response = get('/')

      expect(response.status).to eq(200)
      expect(response.body).to include('Account Successfully Created - Please Log In')
    end
  end
end
