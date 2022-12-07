require "spec_helper"
require "rack/test"
require_relative "../../app"

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
      response = get("/homepage")
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

  context "get /listings" do
    it "returns 200 OK with all listings" do
      response = get("/listings")

      expect(response.status).to eq(200)
      expect(response.body).to include("<p>Listing id: 1</p>")
      expect(response.body).to include("<p>Apartment1</p>")
      expect(response.body).to include("<p>Two bedrooms in north London</p>")
      expect(response.body).to include("View listing</a>")
    end
  end

  context "get /listings/:id" do
    it "returns 200 OK with specified listing" do
      response = get("/listings/1")

      expect(response.status).to eq 200
      expect(response.body).to include("<p>Listing id: 1</p>")
      expect(response.body).to include("<p>Apartment1</p>")
      expect(response.body).to include("<p>Two bedrooms in north London</p>")
    end

    it "returns 200 OK with a different listing" do
      response = get("/listings/2")

      expect(response.status).to eq 200
      expect(response.body).to include("<p>Listing id: 2</p>")
      expect(response.body).to include("<p>Apartment2</p>")
      expect(response.body).to include("<p>Three bedrooms in central London</p>")
      expect(response.body).to include("<p>170.50</p>")
    end
  end

  context "get /new_listing_form" do 
    it "returns 200 OK and a form to create new listing" do
      response = get("/new_listing_form")
      expect(response.status).to eq 200
      expect(response.body).to include('<form action="/new_listing_form" method="post">')
      expect(response.body).to include('<label for="name">Name:</label><br>')
    end 
  end

  context "post /new_listing_form" do
    xit "returns 200 OK and adds listing to database" do
      response = post('/',
        email_address: 'aimee@aimee.com',
        password: 'aimee')

      response = post(
        "/new_listing_form",
        name: "Loft",
        description: "Loft conversion in South London",
        price_per_night:"150",
        user_id: "2",
        start_date: "2022-12-25",
        end_date: "2022-12-29"
      )
      
      response = get("/listings/7")
      
      expect(response.status).to eq 200
      expect(response.body).to include('<p>Listing id: 7</p>')
      expect(response.body).to include('<p>Loft</p>')
      expect(response.body).to include('<p>Loft conversion in South London</p>')
      expect(response.body).to include('<p>150</p>')
      expect(response.body).to include('<p>User id: 2</p>')


      response = get("/listings")
      
      expect(response.status).to eq 200
      expect(response.body).to include('<p>Listing id: 7</p>')
      expect(response.body).to include('<p>Loft</p>')
      expect(response.body).to include('<p>Loft conversion in South London</p>')
      expect(response.body).to include('<p>150</p>')
      expect(response.body).to include('<p>User id: 2</p>')
    end 
  end

  context 'get /my-requests' do
    it 'returns a page with all requests that a logged in user has made' do
      response = post('/',
        email_address: 'aimee@aimee.com',
        password: 'aimee')

      expect(response.status).to eq(302)
      
      response = get('/my-requests')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h2>Pending:</h2>')
      expect(response.body).to include('<p>Name: Apartment3</p>')
      expect(response.body).to include('<p>Date Requested: 2022-10-15</p>')
      expect(response.body).to include('<p><b>Status: Pending</b></p>')
      expect(response.body).to include('<h2>Accepted:</h2>')
      expect(response.body).to include('<p>Name: Apartment1</p>')
      expect(response.body).to include('<p>Date Requested: 2022-10-10</p>')
      expect(response.body).to include('<p><b>Status: Accepted</b></p>')
      expect(response.body).to include('<h2>Rejected:</h2>')
      expect(response.body).to include('<p>No rejected bookings</p>')
    end
  end

  context 'get /requests-for-approval' do
    it "returns a page with all requests on a user's listings" do
      response = post('/',
        email_address: 'jude@jude.com',
        password: 'jude')

      expect(response.status).to eq(302)
      
      response = get('/requests-for-approval')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Requests for Approval</h1>')
      expect(response.body).to include('<h2>Pending:</h2>')
      expect(response.body).to include('<p>Date Requested: 2022-10-10</p>')
      expect(response.body).to include('<p><b>Status: Accepted</b></p>')
      expect(response.body).to include('<p>Name of requester: Aimee</p>')
      expect(response.body).to include('<p>Email of requester: aimee@aimee.com</p>')
      expect(response.body).to include('<p>Name: Apartment3</p>')
      expect(response.body).to include('<h2>Accepted:</h2>')
      expect(response.body).to include('<p>Date Requested: 2022-10-15</p>')
      expect(response.body).to include('<p><b>Status: Accepted</b></p>')
      expect(response.body).to include('<p>Name of requester: Aimee</p>')
      expect(response.body).to include('<p>Email of requester: aimee@aimee.com</p>')
      expect(response.body).to include('<p>Name: Apartment1</p>')
      expect(response.body).to include('<h2>Rejected:</h2>')
      expect(response.body).to include('<p>No rejected bookings</p>')
    end
  end

  # context '/accept/:id' do
  #   it "changes a pending request to accepted" do
  #     response = post()
  #   end
  # end

  # context '/reject/:id' do
  # end
end