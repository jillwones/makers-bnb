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


  #Tests here

end