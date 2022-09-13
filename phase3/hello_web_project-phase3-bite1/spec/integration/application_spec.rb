require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }
  
    context "GET /names" do
      it 'returns 200 OK' do
        response = get('/names', name1: "Leo", name2: "Leroy", name3: "Jovi")
  
        expect(response.status).to eq(200)
        expect(response.body).to eq "Hello Leo, Leroy, Jovi"
      end
  
      it 'returns 404 Not Found' do
        response = get('/qwerty123456') # deliberate wrong path
  
        expect(response.status).to eq(404)
      end
    end

    context "POST /sort-names" do
      it 'returns 200 OK' do
        response = post('/sort-names', name1: "Joe", name2: "Alice", name3: "Zoe", name4: "Julia", name5: "Kieran")
  
        expect(response.status).to eq(200)
        expect(response.body).to eq "Alice,Joe,Julia,Kieran,Zoe"
      end
  
      it 'returns 404 Not Found' do
        response = get('/qwerty123456') # deliberate wrong path
  
        expect(response.status).to eq(404)
      end
    end
    
    context "GET /hello" do
      it "returns 200 OK and greeting message" do
        response = get("/hello")

        expect(response.status).to eq(200)
        expect(response.body).to include("<h1>Hello!</h1>")
      end
    end
    
end