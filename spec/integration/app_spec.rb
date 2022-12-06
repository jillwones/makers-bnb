require "spec_helper"
require "rack/test"
require_relative "../../app"

# Add reset_tables method here

RSpec.describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  before(:each) do
    reset_tables
  end

  context "get /listings" do
    it "returns 200 OK with all listings" do
      response = get("/listings")

      expect(response.status).to eq(200)
      expect(response.body).to include("<p>Listing id: 1</p>")
      expect(response.body).to include("<p>Apartment1</p>")
      expect(response.body).to include("<p>Two bedrooms in north London</p>")
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
    it "returns 200 OK and adds listing to database" do
      response = post(
        "/new_listing_form",
        name: "Loft",
        description: "Loft conversion in South London",
        price_per_night:"150",
        user_id: "2"  
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
end
